
#
# Makefile: GraalVM Rules for Bazel
#

# Configuration
#

CI ?= no
DEBUG ?= no
RELEASE ?= no
VERBOSE ?= no
BZLMOD ?= no
COVERAGE ?= yes
TARGETS ?= //...
TESTS ?= //...
ARGS ?=
CONFIGS ?=

# --------------------------------------------------------

CP ?= $(shell which cp)
MV ?= $(shell which mv)
RM ?= $(shell which rm)
GIT ?= $(shell which git)
PNPM ?= $(shell which pnpm)
BAZEL ?= $(shell which bazel)
MKDIR ?= $(shell which mkdir)

# --------------------------------------------------------

_ARGS = $(ARGS)
_CONFIGS = $(CONFIGS)
_STARTUP =

ifeq ($(COVERAGE),yes)
TEST_TASK = coverage
else
TEST_TASK = test
endif

ifeq ($(VERBOSE),yes)
RULE =
else
RULE = @
endif

ifeq ($(BZLMOD),yes)
_CONFIGS += bzlmod
endif

ifeq ($(DEBUG),yes)
_CONFIGS += debug
else
ifeq ($(RELEASE),yes)
_CONFIGS += release
else
_CONFIGS += fastbuild
endif
endif

_ARGS += $(patsubst %,--config=%,$(_CONFIGS))

# --------------------------------------------------------

all: build test docs


# Targets: Build/Test
#

deps: node_modules

node_modules:
	$(RULE)$(PNPM) install

build: deps  ## Build all targets.
	$(RULE)$(BAZEL) $(_STARTUP) build $(TARGETS) $(_ARGS)

test:  ## Run all tests.
	$(RULE)$(BAZEL) $(_STARTUP) $(TEST_TASK) $(TESTS) $(_ARGS)

docs:  ## Build docs.


# Targets: Diagnosis
#

args:  ## Show current build args.
	@echo "Printing args:"
	@echo "$(_ARGS)"

config:  ## Show current build configuration.
	@echo "Current configuration":
	@echo "CI: $(CI)"
	@echo "Bzlmod: $(BZLMOD)"
	@echo "Debug: $(DEBUG)"
	@echo "Release: $(RELEASE)"
	@echo "Verbose: $(VERBOSE)"
	@echo "Coverage: $(COVERAGE)"
	@echo "Test task: $(TEST_TASK)"
	@echo "Configs: $(CONFIGS)"
	@echo "Targets: $(TARGETS)"
	@echo "Tests: $(TESTS)"
	@echo "Args:"
	@echo "$(_ARGS)"


# Targets: Clean
#

clean:  ## Clean built targets.
	@echo "Cleaning targets..."
	$(RULE)$(BAZEL) clean

distclean: clean  ## Clean and expunge; drops all state and kills worker.
	$(RULE)$(BAZEL) --expunge

reset: distclean  ## Clean, expunge, and perform a hard Git reset (DANGEROUS).
	$(RULE)$(GIT) reset --hard

forceclean: reset  ## Clean, expunge, reset, and drop all ignored files (DANGEROUS).
	$(RULE)$(GIT) clean -xdf


help:  ## Show this help message.
	$(info GraalVM Rules for Bazel:)
	@grep -E '^[a-z1-9A-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: all build test docs clean distclean reset forceclean

