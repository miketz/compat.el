.POSIX:
.PHONY: all compile test clean
.SUFFIXES: .el .elc

EMACS = emacs
MAKEINFO = makeinfo
BYTEC = compat-25.elc \
	compat-26.elc \
	compat-27.elc \
	compat-28.elc \
	compat-29.elc \
	compat.elc \
	compat-macs.elc \
	compat-tests.elc

all: compile

compile: $(BYTEC)

test:
	$(EMACS) --version
	$(EMACS) -Q --batch -L . -l compat-tests.el -f ert-run-tests-batch-and-exit

clean:
	$(RM) $(BYTEC) compat.info

$(BYTEC): compat-macs.el

.el.elc:
	@echo "Compiling $<"
	@$(EMACS) -Q --batch -L . \
		--eval '(setq compat-strict t byte-compile-error-on-warn (< emacs-major-version 30))' \
		-f batch-byte-compile $<

compat.info: compat.texi
	$(MAKEINFO) $<
