IGNORE:=

LIBVS:=$(wildcard Kami/Lib/*.v)
LIBVS:=$(filter-out $(IGNORE:%=%.v),$(LIBVS))

EXSVS:=$(wildcard Kami/Ex/IsaRv32/*.v)
EXSVS:=$(filter-out $(IGNORE:%=%.v),$(EXSVS))

EXVS:=$(wildcard Kami/Ex/*.v)
EXVS:=$(filter-out $(EXSVS) $(IGNORE:%=%.v),$(EXVS))

EXTVS:=$(wildcard Kami/Ext/*.v)
EXTVS:=$(filter-out $(IGNORE:%=%.v),$(EXTVS))

VS:=$(wildcard Kami/*.v)
VS:=$(filter-out $(LIBVS) $(EXSVS) $(EXVS) $(EXTVS) $(IGNORE:%=%.v),$(VS))

.PHONY: coq clean

ARGS := -R Kami Kami

coq: Makefile.coq.all
	$(MAKE) -f Makefile.coq.all

Makefile.coq.all: Makefile $(LIBVS) $(VS) $(EXVS) $(EXSVS) $(EXTVS)
	$(COQBIN)coq_makefile $(ARGS) $(LIBVS) $(VS) $(EXVS) $(EXSVS) $(EXTVS) -o Makefile.coq.all

src: Makefile.coq.src
	$(MAKE) -f Makefile.coq.src

Makefile.coq.src: Makefile $(LIBVS) $(VS)
	$(COQBIN)coq_makefile $(ARGS) $(LIBVS) $(VS) -o Makefile.coq.src

clean:: Makefile.coq.all Makefile.coq.src
	$(MAKE) -f Makefile.coq.all clean || $(MAKE) -f Makefile.coq.src clean
	rm -f */*.v.d */*.glob */*.vo */*~ *~
	rm -f Makefile.coq.all
	rm -f Makefile.coq.src
