From stdpp Require Import list sets.
From Coq Require Import ssreflect.

Section S.

Context `{TotalOrder T R}.
Context `{RelDecision T T R}.

Fixpoint get_cuts_aux (prev : T) (inc : bool)
                      (l : list T) (cur_pos : nat) {struct l}: list nat :=
  match l with
  | [] => [cur_pos]
  | t :: l' =>
    if bool_decide (inc = bool_decide (R t prev)) then
      get_cuts_aux t inc l' (S cur_pos)
    else
      cur_pos :: get_cuts t l' (S cur_pos)
  end
with get_cuts (t : T) (l : list T) (cur_pos : nat) {struct l}: list nat :=
  match l with
  | [] => [cur_pos]
  | t' :: l' =>
    get_cuts_aux t' (bool_decide (R t' t)) l' (S cur_pos)
  end.

Definition cuts (l : list T) : list nat :=
  0 ::
    match l with
    | [] => []
    | t :: l => get_cuts t l 1
    end.

Lemma cuts_nonempty l:
  length (cuts l) > 0.
Proof. simpl. lia. Qed.

Lemma get_cuts_aux_end prev inc l cur_pos:
  let c := get_cuts_aux prev inc l cur_pos in
  last c = Some (cur_pos + List.length l)
with get_cuts_end t l cur_pos:
  let c := get_cuts t l cur_pos in
  last c = Some (cur_pos + List.length l).
Proof.
  - destruct l; simpl.
    + f_equal. lia.
    + case_bool_decide.
      * rewrite get_cuts_aux_end. f_equal. lia.
      * specialize (get_cuts_end t l (S cur_pos)).
        destruct get_cuts=>//.
        simpl in *. rewrite get_cuts_end. f_equal. lia.
  - destruct l; simpl.
    + f_equal. lia.
    + rewrite get_cuts_aux_end. f_equal. lia.
Qed.

Lemma cuts_begin_end l:
  let c := cuts l in
  last c = Some (List.length l) ∧ head c = Some 0.
Proof.
  split=>//.
  destruct l=>//=. pose proof (get_cuts_end t l 1). destruct get_cuts=>//.
Qed.

Lemma get_cuts_aux_bounds prev inc l cur_pos:
  let c := get_cuts_aux prev inc l cur_pos in
  Forall (λ ck, 0 ≤ ck ≤ cur_pos + List.length l) c
with get_cuts_bounds t l cur_pos:
  let c := get_cuts t l cur_pos in
  Forall (λ ck, 0 ≤ ck ≤ cur_pos + List.length l) c.
Proof.
  - destruct l; simpl.
    + repeat constructor; lia.
    + case_bool_decide.
      * eapply Forall_impl; [apply get_cuts_aux_bounds|]. auto with lia.
      * constructor; [split; lia|].
        eapply Forall_impl; [apply get_cuts_bounds|]. auto with lia.
  - destruct l; simpl.
    + repeat constructor; lia.
    + eapply Forall_impl; [apply get_cuts_aux_bounds|]. auto with lia.
Qed.

Lemma cuts_bounds l:
  let c := cuts l in
  Forall (λ ck, 0 ≤ ck ≤ List.length l) c.
Proof.
  destruct l; simpl.
  - repeat constructor.
  - constructor; [lia|].
    eapply Forall_impl; [apply get_cuts_bounds|]. auto with lia.
Qed.

(* A list is monotonic between indices start and stop *)
Definition list_mono_fact (l : list T) (inc : bool) (start stop : nat):=
  ∀ i xi xip1,
    start ≤ i →
    S i < stop →
    l !! i = Some xi →
    l !! (S i) = Some xip1 →
    inc = bool_decide (R xip1 xi).

Lemma list_mono_fact_cons_O t1 t2 l stop :
  list_mono_fact (t2::l) (bool_decide (R t2 t1)) 0 stop ->
  list_mono_fact (t1::t2::l) (bool_decide (R t2 t1)) 0 (S stop).
Proof.
  intros Hmono [|i] xi xip1 ?? Hxi Hxip1.
  - by inversion Hxi; inversion Hxip1; subst.
  - eapply Hmono, Hxip1=>//; lia.
Qed.

Lemma list_mono_fact_cons_S t l inc start stop :
  list_mono_fact l inc start stop ->
  list_mono_fact (t::l) inc (S start) (S stop).
Proof. intros Hmono [|i] ????; [lia|]. eapply (Hmono i)=>//; lia. Qed.

Lemma get_cuts_aux_mono_first prev inc l cur_pos:
  let c := get_cuts_aux prev inc l cur_pos in
  match c with
  | [] => False
  | ck :: _ =>
    ∃ ck', ck = ck' + cur_pos /\
           list_mono_fact (prev :: l) inc 0 (S ck')
  end.
Proof.
  revert prev cur_pos. induction l as [|t l IH]; simpl.
  - exists 0. split. lia. intros k xk xkp1 ??. lia.
  - intros. case_bool_decide; subst.
    + specialize (IH t (S cur_pos)). destruct get_cuts_aux as [|ck c]=>//.
      destruct IH as [ck' [-> Hmono]]. exists (S ck'). split; [lia|].
      by eapply list_mono_fact_cons_O.
    + exists 0. split=>// ?????. lia.
Qed.

Lemma get_cuts_aux_mono prev inc l cur_pos:
  let c := get_cuts_aux prev inc l cur_pos in
  ∀ k ck ckp1,
    c !! k = Some ck →
    c !! (S k) = Some ckp1 →
    ∃ ck' ckp1' inc,
      ck = ck' + cur_pos /\
      ckp1 = ckp1' + cur_pos /\
      list_mono_fact (prev::l) inc (S ck') (S ckp1')
with get_cuts_mono prev l cur_pos:
  let c := cur_pos :: get_cuts prev l (S cur_pos) in
  ∀ k ck ckp1,
    c !! k = Some ck →
    c !! (S k) = Some ckp1 →
    ∃ ck' ckp1' inc,
      ck = ck' + cur_pos /\
      ckp1 = ckp1' + cur_pos /\
      list_mono_fact (prev::l) inc ck' ckp1'.
Proof.
  - destruct l; simpl.
    + move=> [|?] //.
    + intros k ck ckp1 Hck Hckp1. case_bool_decide.
      * destruct (get_cuts_aux_mono _ _ _ _ _ _ _ Hck Hckp1)
          as (ck' & ckp1' & inc' & -> & -> & Hmono).
        exists (S ck'), (S ckp1'). eauto 10 using list_mono_fact_cons_S with lia.
      * destruct (get_cuts_mono _ _ _ _ _ _ Hck Hckp1)
          as (ck' & ckp1' & inc' & -> & -> & Hmono).
        eauto 10 using list_mono_fact_cons_S.
  - destruct l; simpl.
    + move=> [|[|]] // ?? [= <-] [= <-]. exists 0, 1, true. do 2 split=>//.
    + intros [|k] ?? Hck Hckp1.
      * assert (Hmono:=get_cuts_aux_mono_first t (bool_decide (R t prev)) l
                                               (S (S cur_pos))).
        destruct get_cuts_aux=>//.
        destruct Hmono as (ck' & -> & ?). move: Hck Hckp1 => [= <-] [= <-].
        eexists 0, (S (S ck')). eauto using list_mono_fact_cons_O with lia.
      * destruct (get_cuts_aux_mono _ _ _ _ _ _ _ Hck Hckp1)
          as (ck' & ckp1' & inc & -> & -> & ?).
        exists (S (S ck')), (S (S ckp1')). eauto using list_mono_fact_cons_S with lia.
Qed.

Lemma cuts_mono l:
  let c := cuts l in
  ∀ k ck ckp1,
    c !! k = Some ck →
    c !! (S k) = Some ckp1 →
    ∃ inc, list_mono_fact l inc ck ckp1.
Proof.
  intros ? k ck ckp1 Hck Hckp1. destruct l as [|t l].
  - exists true. move=>[] //.
  - destruct (get_cuts_mono t l 0 _ _ _ Hck Hckp1) as (? & ? & ? & -> & -> & ?).
    rewrite -!plus_n_O. eauto.
Qed.

End S.

Eval compute in (cuts (R:=le) [1;2;3;4;5;7]).
Eval compute in (cuts (R:=le) [1;4;7;3;3;5;9]).
Eval compute in (cuts (R:=le) [6;3;4;2;5;3;7]).
