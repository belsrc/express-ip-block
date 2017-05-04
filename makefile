
ISTANBUL = ./node_modules/istanbul/lib/cli.js
MOCHA = ./node_modules/mocha/bin/_mocha
PLATO = ./node_modules/es6-plato/bin/plato
JSDOC = ./node_modules/jsdoc/jsdoc.js
CROSSENV = ./node_modules/cross-env/dist/bin/cross-env.js
ESLINT = ./node_modules/eslint/bin/eslint.js

DOCSDIR = ./documents/documentation
REPORTSDIR = ./documents/analysis
COVERAGEDIR = ./documents/coverage

UNFORMAT = \033[0m
BOLD = \033[1m
BLUE = \033[34m
GREEN = \033[32m

TEST_START = @printf "$(BOLD)$(BLUE)Running Unit Tests...$(UNFORMAT)\n"
TEST_END = @printf "$(BOLD)$(GREEN)Unit Tests Complete!$(UNFORMAT)\n"
ANALYZE_START = @printf "$(BOLD)$(BLUE)Analyzing Code...$(UNFORMAT)\n"
ANALYZE_END = @printf "$(BOLD)$(GREEN)Analyze Code Complete!$(UNFORMAT)\n"
DOC_START = @printf "$(BOLD)$(BLUE)Generating Documentation...$(UNFORMAT)\n"
DOC_END = @printf "$(BOLD)$(GREEN)Documentation Generated!$(UNFORMAT)\n"
LINT_START = @printf "$(BOLD)$(BLUE)Linting Files...$(UNFORMAT)\n"
LINT_END = @printf "$(BOLD)$(GREEN)Linting Complte!$(UNFORMAT)\n"
COMPLETE = @printf "$(BOLD)$(GREEN)Project was successfully built!$(UNFORMAT)\n"

#target: dependencies
#[tab] system command

# Default command. Runs unit tests, analyzes code and generate documentation
all: test analyze docs complete

# Runs unit tests, analyzes code, generate documentation and lints code.
dev: test analyze docs lint

# Run the unit tests for this project
test:
	$(TEST_START)
	node $(ISTANBUL) cover --dir=$(COVERAGEDIR) --print=detail $(MOCHA) -- -R spec --ui tdd --recursive tests
	$(TEST_END)

# Run Plato code analyzer
analyze:
	$(ANALYZE_START)
	node $(PLATO) -r -l .eslintrc -d $(REPORTSDIR) lib
	$(ANALYZE_END)

# Run ESLint (Show only errors)
lint_error:
	$(LINT_START)
	node $(ESLINT) -c .eslintrc --color --quiet --global __base --ignore-path .eslintignore "lib/**"
	$(LINT_END)

# Run ESLint
lint:
	$(LINT_START)
	node $(ESLINT) -c .eslintrc --color --global __base --ignore-path .eslintignore "lib/**"
	$(LINT_END)

# Generate code documentation
docs:
	$(DOC_START)
	node $(JSDOC) -r lib --readme README.md --destination $(DOCSDIR) --package package.json
	$(DOC_END)

# Completion message
complete:
	$(COMPLETE)

# Help menu
help:
	@ echo
	@ echo '  Usage:'
	@ echo ''
	@ echo '    make <target> [flags...]'
	@ echo ''
	@ echo '  Targets:'
	@ echo ''
	@ awk '/^#/{ comment = substr($$0,3) } comment && /^[a-zA-Z][a-zA-Z0-9_-]+ ?:/{ print "   ", $$1, comment }' $(MAKEFILE_LIST) | column -t -s ':' | sort
	@ echo ''
	@ echo '  Flags:'
	@ echo ''
	@ awk '/^#/{ comment = substr($$0,3) } comment && /^[a-zA-Z][a-zA-Z0-9_-]+ ?\?=/{ print "   ", $$1, $$2, comment }' $(MAKEFILE_LIST) | column -t -s '?=' | sort
	@ echo ''

.PHONY: all dev test analyze docs complete help
