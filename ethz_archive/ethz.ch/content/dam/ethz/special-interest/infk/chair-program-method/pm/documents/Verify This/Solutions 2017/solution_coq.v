Require Import List. Import ListNotations.
Require Import Arith.

(* B and B2 are the naive and the second implementations respectively.
   Predicate is_eq relates buffers in the first implementation (B)
   and in the second one (B2).
*)

Module Type Buf.
  Parameter buf : Type -> Type.
  Parameter empty : forall {A}, nat -> buf A.
  Parameter add : forall {A}, A -> buf A -> buf A.
  Parameter get : forall {A}, buf A -> list A.
End Buf.

Module B <: Buf.
  Record buf_aux A := {
    h : nat;
    xs : list A
  }.
  Arguments h {_}.
  Arguments xs {_}.
  Definition buf A := buf_aux A.
  Definition empty {A} h : buf A :=
    {|h:=h; xs:=[]|}.
  Definition add {A} (x:A) (b:buf A) : buf A :=
    {|h:=h b; xs:=x::xs b|}.
  Fixpoint take {A} n (xs:list A) :=
    match n, xs with
    | 0, _ | _, [] => []
    | S n, x::xs => x::take n xs
    end.
  Definition get {A} (b:buf A) :=
    take (h b) (xs b).
End B.

Module B2 <: Buf.
  Record buf_aux A := {
    h : nat;
    xs : list A;
    xs_len : nat;
    ys : list A
  }.
  Arguments h {_}.
  Arguments xs {_}.
  Arguments xs_len {_}.
  Arguments ys {_}.
  Definition buf := buf_aux.
  Definition empty {A} h : buf A :=
    {|h:=h; xs:=[]; xs_len:=0; ys:=[]|}.
  Definition add {A} x (b:buf A) :=
    match b with
    {| h := h; xs := xs; xs_len := xs_len; ys := ys|} => 
    if Nat.eqb xs_len (h - 1) then {|h:=h; xs:=[]; xs_len:=0; ys:=x::xs|}
                          else {|h:=h; xs:=x::xs; xs_len:=xs_len+1; ys:=ys|}
    end.
  Fixpoint take {A} n (xs:list A) :=
    match n, xs with
    | 0, _ | _, [] => []
    | S n, x::xs => x::take n xs
    end.
  Definition get {A} (b:buf A) :=
    match b with
    {| h := h; xs := xs; xs_len := xs_len; ys := ys|} =>
    take h (xs++ys)
    end.
End B2.

Definition is_well_formed {A} (b2:B2.buf A) :=
  B2.xs_len b2 = List.length (B2.xs b2).

Definition is_eq {A} (b:B.buf A) (b2:B2.buf A) :=
  is_well_formed b2 /\ B.h b = B2.h b2 /\ B.get b = B2.get b2.

Lemma empty_eq : forall A n,
  is_eq (@B.empty A n) (B2.empty n).
Proof.
  intros; repeat split; reflexivity.
Qed.

Lemma add_eq : forall A x (b:B.buf A) b2,
  is_eq b b2 ->
  is_eq (B.add x b) (B2.add x b2).
Proof.
  intros. destruct H as (H & H0 & H1). repeat split.
  - unfold is_well_formed.
    destruct b2. simpl. destruct (Nat.eqb xs_len (h-1)) eqn:Heq.
    + reflexivity.
    + simpl. unfold is_well_formed in H. simpl in H. rewrite H.
      rewrite Nat.add_1_r. reflexivity.
  - simpl. destruct b2; simpl in *.
    destruct (Nat.eqb _ _); assumption.
  - destruct b, b2. simpl in *. unfold B.get in H0. simpl in H0.
    unfold B.add, B2.add; simpl.
    destruct (Nat.eqb xs_len (h0-1)) eqn:HH.
    + unfold B.get, B2.get; simpl.
Abort.