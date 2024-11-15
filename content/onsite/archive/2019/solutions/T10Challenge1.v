(*
Version: Coq master bae97b8d592dd1a5a92236959264c57ef9c57f53 (about 8.9)
Author: Jasper Hugunin (Team name: Coinductive Sorcery)

Challenge 1: Monotonic Segments and GHC Sort

Part A:
Proved non-empty, end.

Part B:
no work
*)

Set Universe Polymorphism.
Set Primitive Projections.

From Coq Require Import Sorted.
From Coq Require Import List.
From Coq Require Import CRelationClasses.
Import ListNotations.

Arguments app {A} l1 l2.

Section total_order.

Universe i.

Context
  {A : Type@{i}}
  (cmp : A -> A -> comparison) (* Decidable order on A *)
.
Definition leP (x y : A) : Prop :=
  match cmp x y with Gt => False | _ => True end.
Definition geP (x y : A) : Prop :=
  match cmp x y with Lt => False | _ => True end.

(* Part A: Monotonic Segments *)

(*
Definition of monotonic modified to allow segments of equal values
to be either increasing or decreasing.
*)

Definition monotonic (s : list A) : Type :=
  Sorted leP s + Sorted (flip leP) s.

Inductive direction := Inc | Dec | Unk.

(* Commentary: list nat was a poor choice for representing cut *)
Fixpoint monotonic_segments_helper (s : list A)
    (d : direction) (cur : nat) (last : A) (cut : list nat)
  : list nat
  := match s with
     | [] => cur :: cut
     | si :: s =>
       match cmp last si with
       | Lt =>
         match d with
         | Dec => monotonic_segments_helper s Unk (S cur) si (cur :: cut)
         | _ => monotonic_segments_helper s Inc (S cur) si cut
         end
       | Gt =>
         match d with
         | Inc => monotonic_segments_helper s Unk (S cur) si (cur :: cut)
         | _ => monotonic_segments_helper s Dec (S cur) si cut
         end
       | Eq =>
         monotonic_segments_helper s d (S cur) si cut
       end
     end.

Theorem monotonic_segments_helper_non_empty
  : forall s d cur last cut,
    length (monotonic_segments_helper s d cur last cut) > 0.
refine (
  fix non_empty_helper s d cur last cut
   := match s with [] => _ | _ :: _ => _ end
).
* apply Gt.gt_Sn_O.
* unfold monotonic_segments_helper;
  case (cmp last a); [apply non_empty_helper | | ];
  case d; apply non_empty_helper.
Qed.

Theorem monotonic_segments_helper_end
  : forall s d cur last cut,
    head (monotonic_segments_helper s d cur last cut) = Some (length s + cur).
refine (
  fix end_helper s d cur last cut
   := match s with [] => _ | _ :: _ => _ end
).
* reflexivity.
* unfold monotonic_segments_helper;
  case (cmp last a) ;
    [rewrite end_helper; f_equal; symmetry; apply plus_n_Sm | | ];
  case d; rewrite end_helper; f_equal; symmetry; apply plus_n_Sm.
Qed.

Theorem monotonic_segments_helper_begin
  : forall s d cur last cut,
    head (rev cur) = Some 0 ->
    head (rev (monotonic_segments_helper s d cur last cut)) = Some 0.

Definition monotonic_segments (s : list A) : list nat
  := match s with
     | [] => [0]
     | si :: s => rev (monotonic_segments_helper s Unk 1 si [O])
     end.

Theorem monotonic_segments_non_empty
  : forall s, length (monotonic_segments s) > 0.
intro s; case s.
* apply Gt.gt_Sn_O.
* intros si s'; unfold monotonic_segments;
  rewrite rev_length; apply monotonic_segments_helper_non_empty.
Qed.

Theorem monotonic_segments_end
  : forall s, head (rev (monotonic_segments s)) = Some (length s).
intro s; case s.
* reflexivity.
* intros si s'; unfold monotonic_segments.
  rewrite rev_involutive.
  rewrite monotonic_segments_helper_end.
  f_equal; symmetry. change (S (length s') = length s' + 1).
  rewrite <- plus_n_Sm. f_equal; apply plus_n_O.
Qed.

(* Incomplete *)

(* Part B *)

(* Definition GHCSort_after_split (sigma : list {l : list A & monotonic l})
  : {l : list A | Sorted leP l}
  := _. *)
