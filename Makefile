# Copyright (C) 2026 IEEE UFG Computer Society contributors.
# Distributed under the LaTeX Project Public License 1.3c or later.
# See LICENSE and development/MANIFEST.md.

DOCUMENT_DIRS := $(foreach dir,$(wildcard documents/*),\
  $(if $(wildcard $(dir)/$(notdir $(dir)).tex),$(dir)))
DOCUMENT_GOALS := $(filter documents/%,$(MAKECMDGOALS))
COMMAND_GOALS := $(filter build clean,$(MAKECMDGOALS))
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
	@bash development/scripts/document.sh new \
		"$(TEMPLATE)" "$(NAME)" "$(BUILD)"

ifeq ($(strip $(DOCUMENT_GOALS)),)
build: $(DOCUMENT_DIRS)
	@if [ -z "$(strip $(DOCUMENT_DIRS))" ]; then \
		echo "Nenhum documento criado. Execute 'make new'."; \
	fi
else
build:
	@:
endif

list:
	@bash development/scripts/document.sh list

ifeq ($(strip $(DOCUMENT_GOALS)),)
clean:
	@bash development/scripts/document.sh clean
else
clean:
	@:
endif

documents/%: FORCE
	@bash development/scripts/document.sh validate-path "$@"
	+@$(MAKE) --no-print-directory -C "$@" $(DOCUMENT_ACTION)

FORCE:
