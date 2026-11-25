# Top-level flow entry points (CLAUDE.md §7).
# Phase 0: no flow is implemented yet. Every target fails loudly so that
# nothing can be mistaken for a passing run.

TARGETS := lint sim regress formal syn pnr sta

.PHONY: $(TARGETS) clean help

help:
	@echo "Targets: $(TARGETS) clean  (none implemented yet — Phase 0)"

$(TARGETS):
	@echo "BLOCKED: 'make $@' is not implemented yet (Phase 0)." >&2
	@exit 1

clean:
	@echo "Nothing to clean (Phase 0)."
