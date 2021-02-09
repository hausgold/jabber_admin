MAKEFLAGS += --warn-undefined-variables -j1
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:
.PHONY:

# Environment switches
MAKE_ENV ?= docker
COMPOSE_RUN_SHELL_FLAGS ?= --rm

# Directories
VENDOR_DIR ?= vendor/bundle

# Host binaries
BASH ?= bash
COMPOSE ?= docker-compose
ECHO ?= echo
GREP ?= grep
ID ?= id
MKDIR ?= mkdir
RM ?= rm
SED ?= sed
SORT ?= sort

# Container binaries
BUNDLE ?= bundle
RAKE ?= rake
RUBOCOP ?= rubocop

all:
	# jabber_admin
	#
	# install                  Install the dependencies
	# test                     Run the whole test suite
	# test-style               Check the coding styles
	# clean                    Clean the dependencies
	#
	# shell                    Run an interactive shell on the container
	# shell-irb                Run an interactive IRB shell on the container
	#
	# supported-commands-list  Generate the supported commands list

# Define a generic shell run wrapper
# $1 - The command to run
ifeq ($(MAKE_ENV),docker)
define run-shell
	$(COMPOSE) run $(COMPOSE_RUN_SHELL_FLAGS) \
		-e LANG=en_US.UTF-8 -e LANGUAGE=en_US.UTF-8 -e LC_ALL=en_US.UTF-8 \
		-e HOME=/tmp -e BUNDLE_APP_CONFIG=/app/.bundle \
		-u `$(ID) -u` test bash -c 'sleep 0.1; echo; $(1)'
endef
else ifeq ($(MAKE_ENV),baremetal)
define run-shell
	$(1)
endef
endif

install:
	# Install the dependencies
	@$(MKDIR) -p $(VENDOR_DIR)
	@$(call run-shell,$(BUNDLE) check || $(BUNDLE) install --path $(VENDOR_DIR))

test: install
	# Run the whole test suite
	@$(call run-shell,$(BUNDLE) exec $(RAKE))

test-style: test-style-ruby

test-style-ruby:
	# Run the static code analyzer (rubocop)
	@$(call run-shell,$(BUNDLE) exec $(RUBOCOP) -a)

clean:
	# Clean the dependencies
	@$(RM) -rf $(VENDOR_DIR)

clean-containers:
	# Clean running containers
ifeq ($(MAKE_ENV),docker)
	@$(COMPOSE) down
endif

distclean: clean clean-containers

shell: install
	# Run an interactive shell on the container
	@$(call run-shell,$(BASH) -i)

shell-irb: install
	# Run an interactive IRB shell on the container
	@$(call run-shell,bin/console)

release:
	# Release a new gem version
	@$(BUNDLE) exec $(RAKE) release

supported-commands-list:
	# Generate the supported commands list
	@$(ECHO)
	@$(GREP) -oP '@see https?://.*' -R lib/jabber_admin/commands/ \
		| $(SED) \
			-e 's/@see //g' \
			-e 's/.rb:/](/g' \
			-e 's/$$/)/g' \
			-e 's#^lib/jabber_admin/commands/#- [#g' \
		| $(SORT)
