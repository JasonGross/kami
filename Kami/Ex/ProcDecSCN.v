Require Import Bool String List.
Require Import Lib.CommonTactics Lib.ilist Lib.Word.
Require Import Lib.Struct Lib.FMap Lib.StringEq.
Require Import Kami.Syntax Kami.ParametricSyntax Kami.Semantics Kami.SemFacts.
Require Import Kami.RefinementFacts Kami.Renaming Kami.Wf.
Require Import Kami.Renaming Kami.Specialize Kami.Tactics Kami.Duplicate.
Require Import Kami.ModuleBound Kami.ModuleBoundEx.
Require Import Ex.SC Ex.Fifo Ex.MemAtomic.
Require Import Ex.ProcDec Ex.ProcDecInl Ex.ProcDecInv Ex.ProcDecSC.

Set Implicit Arguments.

Section ProcDecSCN.
  Variables addrSize iaddrSize fifoSize instBytes dataBytes rfIdx: nat.

  (* External abstract ISA: decoding and execution *)
  Variables (getOptype: OptypeT instBytes)
            (getLdDst: LdDstT instBytes rfIdx)
            (getLdAddr: LdAddrT addrSize instBytes)
            (getLdSrc: LdSrcT instBytes rfIdx)
            (calcLdAddr: LdAddrCalcT addrSize dataBytes)
            (getStAddr: StAddrT addrSize instBytes)
            (getStSrc: StSrcT instBytes rfIdx)
            (calcStAddr: StAddrCalcT addrSize dataBytes)
            (getStVSrc: StVSrcT instBytes rfIdx)
            (getSrc1: Src1T instBytes rfIdx)
            (getSrc2: Src2T instBytes rfIdx)
            (getDst: DstT instBytes rfIdx)
            (exec: ExecT addrSize instBytes dataBytes)
            (getNextPc: NextPcT addrSize instBytes dataBytes rfIdx)
            (alignPc: AlignPcT addrSize iaddrSize)
            (alignAddr: AlignAddrT addrSize)
            (isMMIO: IsMMIOT addrSize).

  Variable (init: ProcInit addrSize dataBytes rfIdx).
  
  Definition scmm := scmm getOptype getLdDst getLdAddr getLdSrc calcLdAddr
                          getStAddr getStSrc calcStAddr getStVSrc
                          getSrc1 getSrc2 getDst exec getNextPc alignPc alignAddr
                          isMMIO init.

  Definition procDec0 := pdec fifoSize getOptype
                              getLdDst getLdAddr getLdSrc calcLdAddr
                              getStAddr getStSrc calcStAddr getStVSrc
                              getSrc1 getSrc2 getDst exec
                              getNextPc alignPc alignAddr init.
  
  Definition memAtomic0 := memAtomic addrSize fifoSize dataBytes 0.
  Definition pdec0 := (procDec0 ++ memAtomic0)%kami.

  Lemma pdec0_memAtomic_refines_scmm: pdec0 <<== scmm.
  Proof. (* SKIP_PROOF_ON
    krewrite assoc left.
    kmodulari n.
    - krewrite <- dup_dist left.
      kduplicated.
      apply pdec_refines_pinst; auto.
    - krefl.
      END_SKIP_PROOF_ON *) apply cheat.
  Qed.
  
End ProcDecSCN.

