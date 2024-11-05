From stdpp Require Import list sets.
From Coq Require Import ssreflect.

Section S.

Context `{TotalOrder T R}.
Context `{RelDecision T T R}.

Definition stack := list (nat * T).

Fixpoint pop_larger (stk : stack) (x : T) : stack * option nat :=
  match stk with
  | [] => ([], None)
  | (idx, v) :: stk =>
    if bool_decide (R x v) then pop_larger stk x
    else (stk, Some idx)
  end.

Fixpoint nearest_aux (l : list T) (cur_pos : nat) (stk : stack)
  : list (option nat) :=
  match l with
  | [] => []
  | x :: l =>
    let '(stk, idx) := pop_larger stk x in
    idx :: nearest_aux l (S cur_pos) ((cur_pos, x) :: stk)
  end.

Definition nearest (l : list T) :=
  nearest_aux l 0 [].

Lemma nearest_aux_same_length l cur_pos stk :
  length (nearest_aux l cur_pos stk) = length l.
Proof.
  revert cur_pos stk. induction l as [|t l IH]=>//= cur_pos stk.
  destruct pop_larger=>/=. by rewrite IH.
Qed.

Lemma nearest_same_length l :
  length (nearest l) = length l.
Proof. apply nearest_aux_same_length. Qed.

Fixpoint list_counter (cnt : nat) (len : nat) : list nat :=
  match len with
  | 0 => []
  | S len => cnt :: list_counter (S cnt) len
  end.

Lemma nearest_aux_indices_lt l cur_pos stk :
  Forall (λ '(idx, _), idx < cur_pos) stk →
  Forall2 (λ i lefti,
             match lefti with
             | None => True
             | Some lefti => lefti < i
             end)
          (list_counter cur_pos (length l)) (nearest_aux l cur_pos stk).
Proof.
  revert cur_pos stk. induction l as [|x l IH]=>/= cur_pos stk FA.
  - constructor.
  - destruct pop_larger as [stk' idx] eqn:EQ. constructor.
    + revert EQ. clear -FA. induction FA as [|[idx' v] stk ?? IH]=>/=.
      * move=>[= ? <-] //.
      * case_bool_decide. by apply IH. move=>[= ? <-] //.
    + eapply IH. constructor; [lia|]. revert EQ. clear -FA.
      induction FA as [|[idx' v] stk ?? IH]=>/=.
      * move =>[= <- ?] //.
      * case_bool_decide; [by auto|]. move=>[= <- ?].
        eapply Forall_impl; [apply FA|]. intros []. lia.
Qed.

Lemma nearest_indices_lt l :
  Forall2 (λ i lefti,
             match lefti with
             | None => True
             | Some lefti => lefti < i
             end)
          (list_counter 0 (length l)) (nearest l).
Proof. by apply nearest_aux_indices_lt. Qed.

Lemma nearest_indices_lt_alt l :
  ∀ i lefti, (nearest l) !! i = Some (Some lefti) → lefti < i.
Proof.
  intros i lefti Hi.
  assert (Hfa2 := nearest_indices_lt).
  eapply Forall2_lookup_lr in Hfa2; [..|by apply Hi]; [by apply Hfa2|].
  apply lookup_lt_Some in Hi. rewrite nearest_same_length in Hi.
  clear -Hi. change i with (0 + i) at 2. generalize 0. revert i Hi.
  induction (length l) as [|len IH]; [auto with lia|].
  move => /= i Hi n. destruct i=>/=; [by auto|]. rewrite IH; auto with lia.
Qed.

Lemma nearest_aux_content_lt l cur_pos stk :
  Forall2 (λ x lefti,
             (∃ lefti' y, lefti = Some (cur_pos + lefti') /\
                          l !! lefti' = Some y /\
                          ~R x y) \/
             match lefti with
             | None => True
             | Some lefti => ∃ z, (lefti, z) ∈ stk /\ ~R x z
             end)
          l (nearest_aux l cur_pos stk).
Proof.
  revert cur_pos stk. induction l as [|x l IH]=>/= cur_pos stk.
  - constructor.
  - destruct pop_larger as [stk' idx] eqn:EQ. constructor.
    + right. revert EQ. clear. induction stk as [|[] stk IH]=>/=.
      * move=>[= _ <-] //.
      * case_bool_decide.
        -- destruct idx=>// EQ. destruct IH as (z & ? & ?)=>//.
           exists z. set_solver.
        -- move => [? <-]. exists t. set_solver.
    + specialize (IH (S cur_pos) ((cur_pos, x) :: stk')).
      eapply Forall2_impl; [apply IH|] => /= x' lefti [[lefti' [y [-> [??]]]] | Hlefti].
      * left. exists (S lefti'). eauto.
      * destruct lefti; [|by auto].
        destruct Hlefti as (z & [[= -> ->]|Hstk']%elem_of_cons & HR); [left; by eauto 10|].
        right. exists z. split; [|done]. revert EQ. clear -Hstk'.
        induction stk as [|[idx' x'] stk IH]=>/=; [naive_solver|].
        case_bool_decide; set_solver.
Qed.

Lemma nearest_content_lt l :
  Forall2 (λ x lefti,
             match lefti with
             | None => True
             | Some lefti =>
               ∃ y, l !! lefti = Some y /\ ~R x y
             end)
          l (nearest l).
Proof.
  unfold nearest. assert (Hnearest := nearest_aux_content_lt l 0 []).
  eapply Forall2_impl; [by apply Hnearest|].
  move=> /= x lefti [[?[?[??]]]|].
  - naive_solver.
  - destruct lefti; set_solver.
Qed.

End S.
