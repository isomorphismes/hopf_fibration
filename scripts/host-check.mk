# Existing compiler launchers remain explicit bootstrap interfaces.
ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)
IDRIC_ROOT ?= $(ROOT)/.idric-toolchain
AICI_ROOT ?= $(ROOT)/.ai-ci-ick
ICK ?=
ICK_FLAGS ?= -fno-link-libatomic
OUTPUT ?= $(ROOT)/build/host-check

.PHONY: bootstrap check
bootstrap:
	cd "$(IDRIC_ROOT)" && ./edric scheme
	cd "$(IDRIC_ROOT)" && PATH="$(IDRIC_ROOT)/.tools/bin:$(PATH)" ./edric bootstrap

check:
	test -x "$(ICK)"
	mkdir -p "$(OUTPUT)"
	IDRIC="$(IDRIC_ROOT)/_/build/exec/idris2" IDRIS2_PREFIX="$(IDRIC_ROOT)/_/bootstrap-build" IDRIS2_PATH="$(IDRIC_ROOT)/_/libs/prelude/build/ttc:$(IDRIC_ROOT)/_/libs/base/build/ttc" sh "$(ROOT)/scripts/regenerate-hopf-math.sh" --check
	"$(ICK)" $(ICK_FLAGS) -std=c11 -Wall -Wextra -Wpedantic -Werror -I"$(ROOT)/app/src/main/cpp" "$(ROOT)/app/src/main/cpp/hopf_math.c" "$(ROOT)/tests/hopf_math_test.c" -lm -o "$(OUTPUT)/hopf-math-test"
	"$(OUTPUT)/hopf-math-test"
	"$(ICK)" $(ICK_FLAGS) -std=c11 -O2 -Wall -Wextra -Werror "$(AICI_ROOT)/src/aici.c" -o "$(OUTPUT)/aici"
	"$(OUTPUT)/aici" verify "$(AICI_ROOT)/contracts/build-toolchain-v0.contract.tsv" "$(ROOT)"
	cat "$(ROOT)/ci/build-toolchain.tsv"
