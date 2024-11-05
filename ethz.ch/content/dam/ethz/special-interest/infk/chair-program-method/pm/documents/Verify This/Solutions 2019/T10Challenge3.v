(*
Version: Coq master bae97b8d592dd1a5a92236959264c57ef9c57f53 (about 8.9)
Author: Jasper Hugunin (Team name: Coinductive Sorcery)

Challenge 3: Sparse Matrix Multiplication

Parallel and sequential versions given
(operating on sequences given as balanced binary trees).

Parallelism is exploiting the natural parallelizability of pure total code.
Coq itself has no support for parallelism, but can be extracted to haskell or
ml, which have parallel compilers. In particular, since everything is pure,
for the pair let marked with (* parallel *), both components can be computed
in simultaneously.

No possibility for deadlock or data races since this is a pure total language.

The verification is just missing proofs of associativity and idempotency for
vector addition.
*)

Set Universe Polymorphism.
Set Primitive Projections.

From Coq Require List.
From Coq Require Fin Vector.
Import List.ListNotations.

Section generic_algorithm.

Universe i.
Context
  {seq : Type@{i} -> Type@{i}}
  (map : forall (A B : Type@{i}), (A -> B) -> seq A -> seq B)
  (reduce : forall (A : Type@{i}) (op : A -> A -> A), A -> seq A -> A)
.
Arguments map {A B} f.
Arguments reduce {A} op zero.
Context (* Instantiate with integers, for example *)
  (A : Type@{i})
  (prod : A -> A -> A)
  (sum : A -> A -> A)
  (zero : A)
.
Context (rows cols : nat).

Definition zerovec := Vector.const zero rows.

Definition generic_sparse_matrix_multiply
  (m : seq (Fin.t rows * Fin.t cols * A))
  (x : Vector.t A cols)
  : Vector.t A rows
  := reduce (Vector.map2 sum) zerovec
     (map (fun '(r, c, v) => Vector.replace zerovec r
                             (prod (Vector.nth x c) v))
      m).

End generic_algorithm.

Definition sequential_sparse_matrix_multiply'
  : forall {A} prod sum zero (rows cols : nat),
    list (Fin.t rows * Fin.t cols * A) ->
    Vector.t A cols ->
    Vector.t A rows
  := generic_sparse_matrix_multiply
     (seq := list)
     List.map
     (fun A op zero l => List.fold_left op l zero)
.

(*
Sequences represented as (presumably balanced) binary trees.
With implementations of operations that keep the trees balanced,
gives an efficient parallel type of sequences.
*)
Inductive tree@{i} (A : Type@{i}) :=
  | Node (left : tree A) (a : A) (right : tree A)
  | Emp
.
Arguments Node {A}.
Arguments Emp {A}.

Fixpoint tree_map@{i j} {A : Type@{i}} {B : Type@{j}} (f : A -> B) (t : tree A)
  : tree B
  := match t with
     | Node l a r => Node (tree_map f l) (f a) (tree_map f r)
     | Emp => Emp
     end.
Fixpoint tree_reduce@{i} {A : Type@{i}} (op : A -> A -> A) (zero : A)
  (t : tree A) : A
  := match t with
     | Node l a r =>
       let (* parallel *) '(la, ra) :=
         (tree_reduce op zero l, tree_reduce op zero r) in
       op (op la a) ra
     | Emp => zero
     end.

Definition parallel_sparse_matrix_multiply
  : forall {A} prod sum zero (rows cols : nat),
    tree (Fin.t rows * Fin.t cols * A) ->
    Vector.t A cols ->
    Vector.t A rows
  := generic_sparse_matrix_multiply
     (seq := tree)
     (@tree_map)
     (@tree_reduce).

Fixpoint tree_to_list@{i} {A : Type@{i}} (t : tree A) :=
  match t with
  | Node l a r => app (app (tree_to_list l) [a]) (tree_to_list r)
  | Emp => nil
  end.

Definition sequential_sparse_matrix_multiply
  : forall {A} prod sum zero (rows cols : nat),
    tree (Fin.t rows * Fin.t cols * A) ->
    Vector.t A cols ->
    Vector.t A rows
  := fun A prod sum zero rows cols t =>
     sequential_sparse_matrix_multiply' prod sum zero rows cols
     (tree_to_list t).

Lemma seq_par_folds_equal' :
  forall {A} (sum : A -> A -> A) zero
  (assoc : forall x y z, sum x (sum y z) = sum (sum x y) z)
  (idemr : forall x, x = sum x zero)
  (t : tree A),
  forall x, List.fold_left sum (tree_to_list t) x =
            sum x (tree_reduce sum zero t).
intros A sum zero assoc idem.
induction t.
* intro x.
  change (
    List.fold_left sum (app (app (tree_to_list t1) [a]) (tree_to_list t2)) x
    = sum x (sum (sum (tree_reduce sum zero t1) a) (tree_reduce sum zero t2))).
  do 2 rewrite List.fold_left_app.
  rewrite IHt1.
  rewrite IHt2.
  change (
    sum (sum (sum x (tree_reduce sum zero t1)) a) (tree_reduce sum zero t2) =
    sum x (sum (sum (tree_reduce sum zero t1) a) (tree_reduce sum zero t2))).
  rewrite assoc.
  rewrite assoc.
  reflexivity.
* intro x.
  simpl.
  apply idem.
Qed.

Lemma seq_par_folds_equal :
  forall {A} (sum : A -> A -> A) zero
  (assoc : forall x y z, sum x (sum y z) = sum (sum x y) z)
  (idemr : forall x, x = sum x zero)
  (ideml : forall x, x = sum zero x)
  (t : tree A),
  List.fold_left sum (tree_to_list t) zero =
  tree_reduce sum zero t.
intros; rewrite ideml; apply (seq_par_folds_equal' sum zero assoc idemr).
Qed.

Lemma seq_par_maps_equal :
  forall {A B} (f : A -> B) (t : tree A),
  List.map f (tree_to_list t) = tree_to_list (tree_map f t).
intros A B f; induction t.
* simpl.
  repeat rewrite List.map_app.
  rewrite IHt1; rewrite IHt2.
  reflexivity.
* reflexivity.
Qed.

(* Proof that sum of vectors is associative *)
Lemma sum_assoc :
  forall {A} (sum : A -> A -> A),
  (forall x y z, sum x (sum y z) = sum (sum x y) z) ->
  forall n (x y z : Vector.t A n),
    Vector.map2 sum x (Vector.map2 sum y z) =
    Vector.map2 sum (Vector.map2 sum x y) z.
Admitted.

(* Sum with zero vector is idempotent ... *)

Theorem sequential_equals_parallel :
  forall {A} prod sum zero (rows cols : nat)
    (m : tree (Fin.t rows * Fin.t cols * A))
    (x : Vector.t A cols),
  (forall x y z, sum x (sum y z) = sum (sum x y) z) ->
  (forall x, x = sum x zero) ->
  (forall x, x = sum zero x) ->
  sequential_sparse_matrix_multiply (A := A) prod sum zero rows cols m x =
    parallel_sparse_matrix_multiply (A := A) prod sum zero rows cols m x.
intros A prod sum zero rows cols m x assoc idemr ideml.
unfold sequential_sparse_matrix_multiply.
unfold sequential_sparse_matrix_multiply'.
unfold parallel_sparse_matrix_multiply.
unfold generic_sparse_matrix_multiply.
rewrite seq_par_maps_equal.
apply (seq_par_folds_equal (Vector.map2 sum) (zerovec A zero rows)).
* (* associativity *)
  apply (sum_assoc sum assoc).
* (* right idempotency *)
  admit.
* (* left idempotency *)
  admit.
Admitted.
(* Just missing proofs of associativity, idempotency for vector addition. *)
