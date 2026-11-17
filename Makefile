# Copyright (C) 2026 IEEE UFG Computer Society contributors.
# Distributed under the LaTeX Project Public License 1.3c or later.
# See LICENSE and development/MANIFEST.md.

DOCUMENT_GOALS := $(filter documents/%,$(MAKECMDGOALS))
COMMAND_GOALS := $(filter build clean,$(MAKECMDGOALS))
PROJECT_SCRIPT := development/scripts/project.lua
KNOWN_GOALS := help new build list clean
UNKNOWN_GOALS := $(filter-out $(KNOWN_GOALS) documents/%,$(MAKECMDGOALS))

ifneq ($(strip $(UNKNOWN_GOALS)),)
$(error alvo desconhecido: $(firstword $(UNKNOWN_GOALS)))
endif

ifneq ($(strip $(DOCUMENT_GOALS)),)
ifneq ($(words $(COMMAND_GOALS)),1)
$(error use build ou clean antes dos diretórios de documentos)
endif
endif

DOCUMENT_ACTION := $(firstword $(COMMAND_GOALS))

.DEFAULT_GOAL := help
.PHONY: help new build list clean FORCE

help:
	@echo "IEEE UFG Computer Society LaTeX"
	@echo
	@echo "  make new       cria um documento a partir de um modelo"
	@echo "  make build     compila todos os documentos"
	@echo "  make build documents/x [...] compila documentos específicos"
	@echo "  make list      lista modelos e documentos"
	@echo "  make clean     limpa os arquivos gerados"
	@echo "  make clean documents/x [...] limpa documentos específicos"
	@echo
	@echo "Desenvolvimento: make -C development"

new:
	@texlua $(PROJECT_SCRIPT) new "$(TEMPLATE)" "$(NAME)" "$(BUILD)"

ifeq ($(strip $(DOCUMENT_GOALS)),)
build:
	@texlua $(PROJECT_SCRIPT) build-all
else
build:
endif

list:
	@texlua $(PROJECT_SCRIPT) list

ifeq ($(strip $(DOCUMENT_GOALS)),)
clean:
	@texlua $(PROJECT_SCRIPT) clean
else
clean:
endif

documents/%: FORCE
	@texlua $(PROJECT_SCRIPT) $(DOCUMENT_ACTION)-path "$@"

FORCE:
