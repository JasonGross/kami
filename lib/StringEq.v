Require Import Bool Ascii String List.

Set Implicit Arguments.

Definition ascii_eq (a1 a2: Ascii.ascii): bool :=
  match a1, a2 with
  | Ascii.Ascii b1 b2 b3 b4 b5 b6 b7 b8,
    Ascii.Ascii c1 c2 c3 c4 c5 c6 c7 c8 =>
    (eqb b1 c1) && (eqb b2 c2) && (eqb b3 c3) && (eqb b4 c4) &&
                (eqb b5 c5) && (eqb b6 c6) && (eqb b7 c7) && (eqb b8 c8)
  end.

Fixpoint string_eq (s1 s2: string): bool :=
  match s1, s2 with
  | EmptyString, EmptyString => true
  | String a1 s1', String a2 s2' =>
    (ascii_eq a1 a2) && (string_eq s1' s2')
  | _, _ => false
  end.

Definition string_in (a: string) (l: list string) :=
  existsb (fun e => string_eq e a) l.

Lemma ascii_eq_dec_eq: forall a1 a2, true = ascii_eq a1 a2 -> a1 = a2.
Proof.
  intros; destruct a1, a2.
  unfold ascii_eq in H.
  apply eq_sym in H.
  repeat
    match goal with
    | [H: _ && _ = true |- _] => apply andb_true_iff in H; destruct H
    | [H: eqb _ _ = true |- _] => apply eqb_prop in H; subst
    end.
  reflexivity.
Qed.

Lemma ascii_eq_dec_neq: forall a1 a2, false = ascii_eq a1 a2 -> a1 <> a2.
Proof.
  intros; destruct a1, a2.
  unfold ascii_eq in H.
  apply eq_sym in H.
  repeat
    match goal with
    | [H: _ && _ = false |- _] => apply andb_false_iff in H; destruct H
    end;
    intro Hx; inversion Hx; subst; clear Hx;
      apply eqb_false_iff in H; elim H; reflexivity.
Qed.

Lemma string_eq_dec_eq: forall s1 s2, true = string_eq s1 s2 -> s1 = s2.
Proof.
  induction s1; simpl; intros.
  - destruct s2; [auto|inversion H].
  - destruct s2; [inversion H|].
    apply eq_sym, andb_true_iff in H; destruct H.
    apply eq_sym, ascii_eq_dec_eq in H; subst.
    rewrite (IHs1 s2); auto.
Qed.

Lemma string_eq_dec_neq: forall s1 s2, false = string_eq s1 s2 -> s1 <> s2.
Proof.
  induction s1; simpl; intros.
  - destruct s2; [inversion H|discriminate].
  - destruct s2; [discriminate|].
    apply eq_sym, andb_false_iff in H; destruct H.
    + apply eq_sym, ascii_eq_dec_neq in H.
      intro Hx; elim H; inversion Hx; auto.
    + intro Hx; elim (IHs1 s2 (eq_sym H)).
      inversion Hx; auto.
Qed.

Lemma string_in_dec_in: forall s l, true = string_in s l -> In s l.
Proof.
  induction l; simpl; intros; [inversion H|].
  apply eq_sym, orb_true_iff in H; destruct H.
  - left; apply string_eq_dec_eq; auto.
  - right; auto.
Qed.

Lemma string_in_dec_not_in: forall s l, false = string_in s l -> ~ In s l.
Proof.
  induction l; simpl; intros; [auto|].
  apply eq_sym, orb_false_iff in H; destruct H.
  intro Hx; destruct Hx.
  - apply eq_sym, string_eq_dec_neq in H; auto.
  - elim (IHl (eq_sym H0)); auto.
Qed.

