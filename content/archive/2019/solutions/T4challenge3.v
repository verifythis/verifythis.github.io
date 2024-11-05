From iris.base_logic.lib Require Export invariants.
From iris.proofmode Require Import tactics.
From lrust.lang Require Export notation.
From lrust.lang Require Import heap proofmode.
From lrust.lang.lib Require Import spawn.

Definition N := nroot .@ "matmul".

Section S.
  Context `{!lrustG Σ, spawnG Σ}.

  Parameter mul : val.
  Hypothesis mul_spec : ∀ u v : Z,
    {{{ True }}} mul [ #u;#v] {{{ RET #(u*v); True }}}.

  Definition faa : val :=
    rec: "faa" ["l"; "x"] :=
      let: "v" := !ˢᶜ"l" in
      if: CAS "l" "v" ("v" + "x") then #☠
      else "faa" ["l"; "x"].

  Definition iteration : val :=
    rec: <> ["r"; "c"; "v"; "x"; "y"] :=
      faa ["y" +ₗ "r"; mul [!("x" +ₗ "c"); "v"]].

  Definition mat_mult : val :=
    rec: "mat_mult" ["x"; "y"; "m"; "len"] :=
      if: "len" = #0 then #☠
      else
        let: "join" :=
            spawn [λ: ["finisher"],
                   let: "cell" := !"m" in
                   iteration [!"cell"; !("cell" +ₗ #1); !("cell" +ₗ #2); "x"; "y"];;
                             finish ["finisher"; #☠]]
        in
        "mat_mult" ["x"; "y"; "m" +ₗ #1; "len" - #1];;
        join ["join"].

  Lemma iteration_spec (r c : nat) (v : Z) (lx ly : loc) (x : list Z) qx leny :
    (c < length x)%nat → (r < leny)%nat →
    {{{ lx ↦∗{qx} map (λ z:Z, #z) x ∗
        inv N (∃ y:list Z, ⌜length y = leny⌝ ∗ ly ↦∗ map (λ z:Z, #z) y) }}}
      iteration [ #r; #c; #v; #lx; #ly]
    {{{ RET #☠; lx ↦∗{qx} map (λ z:Z, #z) x }}}.
  Proof.
    iIntros (Hc Hr Φ) "[Hx #INV] HΦ".
    iAssert (□ |={⊤, ⊤∖↑N}=> ∃ yr : Z, (ly +ₗ r) ↦ #yr ∗
             ∀ yr': Z, (ly +ₗ r) ↦ #yr' ={⊤∖↑N, ⊤}=∗ True)%I as "#ACC".
    { iModIntro. iInv N as (y) ">Hinv" "Hclose".
      iDestruct "Hinv" as (Hleny) "Hinv".
      assert (Hr' := Hr). rewrite -Hleny in Hr.
      apply lookup_lt_is_Some in Hr. destruct Hr as [yr ?].
      rewrite -(take_drop_middle y r yr) // map_app /= heap_mapsto_vec_app
              heap_mapsto_vec_cons map_length take_length Min.min_l; last lia.
      iDestruct "Hinv" as "(Hy1 & Hy2 & Hy3)". iModIntro. iExists _. iFrame.
      iIntros (yr') "Hy2". iApply ("Hclose" with "[Hy1 Hy2 Hy3]").
      iExists _. iSplit; last first.
      - iCombine "Hy1 Hy2 Hy3" as "Hy".
        rewrite -(heap_mapsto_vec_cons _ _ #yr')
                 (_ : ly +ₗ r = ly +ₗ length (map (λ z : Z, #z) (take r y))).
        { rewrite -heap_mapsto_vec_app -(map_app _ _ (_ :: _)). iFrame. }
        rewrite map_length take_length Min.min_l //. lia.
      - rewrite app_length take_length Min.min_l /=; last lia.
        rewrite drop_length. iPureIntro. lia. }
    wp_rec. wp_op. assert (Hc' := Hc).
    apply lookup_lt_is_Some in Hc. destruct Hc as [xc ?].
    rewrite -(take_drop_middle x c xc) // map_app /= heap_mapsto_vec_app
            heap_mapsto_vec_cons map_length take_length Min.min_l; last lia.
    iDestruct "Hx" as "(? & ? & ?)". wp_op. wp_read.
    wp_apply mul_spec; [done|]. iIntros "_". wp_lam. iSpecialize ("HΦ" with "[$]").
    iLöb as "IH". wp_bind (!ˢᶜ _)%E. iAssert (□ |={_}=> _)%I as "#ACC'"; [iExact "ACC"|].
    iMod "ACC'" as (yr) "[Hyr Hclose]". wp_read.
    iMod ("Hclose" with "Hyr") as "_". iModIntro. wp_let. wp_op.
    wp_bind (CAS _ _ _ ). iMod "ACC" as (yr') "[Hyr Hclose]".
    destruct (decide (yr = yr')) as [<-|].
    - iApply (wp_cas_int_suc with "Hyr"). iIntros "!> Hyr".
      iMod ("Hclose" with "Hyr") as "_". iModIntro. by wp_case.
    - iApply (wp_cas_int_fail with "Hyr")=>//. iIntros "!> Hyr".
      iMod ("Hclose" with "Hyr") as "_". iModIntro. wp_case. wp_rec. by iApply "IH".
  Qed.

  Definition sparse_matrix (lm : loc) (m : list (nat * nat * Z)) : iProp Σ :=
    (∃ locs : list loc,
       ⌜length locs = length m⌝ ∗
       lm ↦∗ map (λ l:loc, #l) locs ∗
       [∗ list] ld ∈ zip locs m,
          let '(l, (r, c, v)) := ld : loc * (nat * nat * Z) in
          l ↦∗ [ #r; #c; #v ])%I.

  Lemma mat_mul_spec (m : list (nat * nat * Z)) (lm : loc) (lx ly : loc) (x : list Z)
    (lenx leny : nat) :
    length x = lenx →
    Forall (λ '(r, c, v), (r < leny)%nat ∧ (c < lenx)%nat) m →
    {{{ lx ↦∗ map (λ (z:Z), #z) x ∗ ly ↦∗ repeat (#0) leny ∗
        sparse_matrix lm m }}}
      mat_mult [ #lx; #ly; #lm; #(length m) ]
    {{{ RET #☠; True }}}.
  Proof.
    iIntros (Hlenx Hm Φ) "(Hx & Hy & Hm) HΦ".
    iDestruct "Hm" as (mlocs Hmlocs) "[Hlm Hm]".
    iMod (inv_alloc N _ (∃ y:list Z, ⌜length y = leny⌝ ∗ ly ↦∗ map (λ z:Z, #z) y)%I
            with "[Hy]") as "#INV".
    { iExists (repeat 0 leny). iSplit.
      - by rewrite repeat_length.
      - rewrite (_ : map _ (repeat 0 leny) = repeat #0 leny) //.
        clear. induction leny=>//=. by f_equal. }
    generalize 1%Qp at 2=>qx.
    iInduction Hm as [|[[r c] v] m [Hr Hc] ?] "IH" forall (mlocs Hmlocs qx lm Φ).
    - wp_rec. wp_op. wp_case. by iApply "HΦ".
    - wp_rec. wp_op. wp_case. destruct mlocs as [|l mlocs]=>//=.
      iDestruct "Hm" as "[Hm0 Hm]". rewrite heap_mapsto_vec_cons.
      iDestruct "Hlm" as "[Hlm0 Hlm]". iDestruct "Hx" as "[Hx0 Hx]".
      wp_apply (spawn_spec N (λ r, ⌜r = #☠⌝%I) with "[Hm0 Hlm0 Hx0]")=>/=.
      { iIntros (h) "{IH} Hh". wp_let. wp_read. wp_let.
        rewrite !heap_mapsto_vec_cons !shift_loc_assoc.
        iDestruct "Hm0" as "(Hr & Hc & Hv & _)". wp_read. wp_op. wp_read.
        wp_op. wp_read. wp_apply (iteration_spec with "[$INV $Hx0]").
        { by subst lenx. } { done. }
        iIntros "Hx0". wp_seq.
        iApply (finish_spec _ _ _ #☠ with "[$Hh //]"); by auto. }
      iIntros (h) "Hh". wp_let. wp_op. wp_op.
      rewrite (_ : S (length m) - 1 = length m); [|lia].
      wp_apply ("IH" with "[] Hx Hlm Hm"); [by auto|]. iIntros "_". wp_seq.
      iApply (join_spec with "Hh"). iIntros "!> % ->". by iApply "HΦ".
  Qed.

End S.
