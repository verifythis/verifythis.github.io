(*
Version: Coq master bae97b8d592dd1a5a92236959264c57ef9c57f53 (about 8.9)
Author: Jasper Hugunin (Team name: Coinductive Sorcery)

Challenge 2: Cartesian Trees

Part A:
No proofs, only simplified specifications for verification conditions 2 and 3.

Part B:
no work
*)

Set Universe Polymorphism.
Set Primitive Projections.

From Coq Require Import List.
From Coq Require Import CRelationClasses.
From Coq Require Import ZArith.
From Coq Require FMapAVL FMapFacts.
From Coq Require Fin Vector.

Record prod@{i} {A : Type@{i}} {B : A -> Type@{i}}
  := pair { p1 : A ; p2 : B p1 }.
Arguments prod A B : clear implicits.
Arguments pair {A B}.
Definition prod'@{i} A B := prod@{i} A (fun _ => B).

Import ListNotations.

Fixpoint removeWhile {A : Type} (cond : A -> bool) (l : list A)
  : option (prod' A (list A))
  := match l with
     | [] => None
     | a :: l => if cond a then removeWhile cond l else Some (pair a l)
     end.

Fixpoint get {A : Type} (l : list A) (i : nat) : i < length l -> A :=
  match l return i < length l -> A with
  | [] => fun H => match Nat.nlt_0_r i H with end
  | a :: l => match i return i < S (length l) -> A with
              | O => fun H => a
              | S i' => fun H => get l i' (lt_S_n _ _ H)
              end
  end.

Section total_order.

Universe i.

Context
  {A : Type@{i}}
  (le : A -> A -> bool) (* Decidable non-strict order on A *)
  (le_total : forall x y, is_true (le x y) \/ is_true (le y x))
.
Definition eqA (x y : A) : Prop := is_true (le x y) /\ is_true (le y x).

(* Part A *)

Fixpoint nearestLeftSmaller' (l : list A) (i : nat) (stack : list (prod' nat A))
  : list (option (prod' nat A))
  := match l with
     | [] => []
     | a :: l =>
       match removeWhile (fun '(pair n a') => le a a') stack with
       | None => None :: nearestLeftSmaller' l (S i) []
       | Some (pair na stack') =>
         Some na :: nearestLeftSmaller' l (S i) ((pair i a) :: na :: stack')
       end
     end.

Let mapper : option (prod' nat A) -> nat
  := option_rect (fun _ => nat) (fun '(pair n a) => S n) O.

Definition nearestLeftSmaller (l : list A) : list nat :=
  map mapper (nearestLeftSmaller' l O []).

Lemma nearestLeftSmaller'_sameLength
  : forall l i stack, length l = length (nearestLeftSmaller' l i stack).
refine (
  let fix helper l i stack
    : length l = length (nearestLeftSmaller' l i stack)
   := match l with [] => eq_refl | _ :: l' => _ end in
  helper).
unfold nearestLeftSmaller'.
refine (
  match removeWhile (fun '(pair n a') => le a a') stack as s'
    return length _ = length match s' with None => _ | _ => _ end
  with
  | Some _ => _
  | None => _
  end);
exact (f_equal S (helper l' _ _)).
Qed.

Lemma nearestLeftSmaller_sameLength
  : forall l, length l = length (nearestLeftSmaller l).
refine (
  let fix helper l i stack
    : length l = length (map mapper (nearestLeftSmaller' l i stack))
   := match l with [] => eq_refl | _ :: l' => _ end in
  fun l => helper l _ _).
unfold nearestLeftSmaller'.
refine (
  match removeWhile (fun '(pair n a') => le a a') stack as s'
    return length _ = length (map mapper match s' with None => _ | _ => _ end)
  with
  | Some _ => _
  | None => _
  end);
exact (f_equal S (helper l' _ _)).
Qed.

Definition getLeft' (l : list A) (i_ : nat) stack (i : nat)
  : i < length l -> option (prod' nat A) :=
  fun H => get (nearestLeftSmaller' l i_ stack) i
    match nearestLeftSmaller'_sameLength l i_ stack in _ = ll return i < ll
    with eq_refl => H end.

Definition getLeft (l : list A) (i : nat) : i < length l -> nat :=
  fun H => get (nearestLeftSmaller l) i
    match nearestLeftSmaller_sameLength l in _ = ll return i < ll
    with eq_refl => H end.

Theorem neighborsToLeft (* Verification condition 1 *)
  : forall l (i : nat) (H : i < length l),
    getLeft l i H < i.
Admitted.

Theorem neighbors'Smaller (* Verification condition 2, simplified *)
  : forall l i_ stack (i : nat) (H : i < length l),
    match getLeft' l i_ stack i H with
    | None => True
    | Some (pair n a) => is_true (negb (le (get l i H) a))
    end.
Admitted.

Theorem neighbors'Nearest (* Verification condition 3, simplified *)
  : forall l i_ stack (i : nat) (H : i < length l),
    match getLeft' l i_ stack i H with
    | None => True
    | Some (pair n a) => forall j, n < j -> forall (H2 : j < i),
             is_true (le (get l i H) (get l j (lt_trans _ _ _ H2 H)))
    end.
Admitted.

(* Theorem neighborsSmaller (* Verification condition 2 *)
  : forall l (i : nat) (H : i < length l),
    match getLeft l i H with
    | O => True
    | S li => is_true (negb (le (get l i H) (get l li _)))
    end. *)
