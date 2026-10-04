# Copyright (C) 2026 IEEE UFG Computer Society contributors.
# Distributed and/or modified under the LaTeX Project Public License,
# version 1.3c or later. This work has LPPL status `maintained'; the Current
# Maintainer is the IEEE UFG Computer Society. See LICENSE and MANIFEST.md.

LATEXMK ?= latexmk
LATEXMK_FLAGS = -lualatex -interaction=nonstopmode -halt-on-error
BUILD_DIR = build
TEXMFVAR_DIR ?= $(CURDIR)/$(BUILD_DIR)/texmf-var
TEX_ENV = TEXINPUTS=tex/latex//: TEXMFVAR="$(TEXMFVAR_DIR)"

DOCUMENT_DIRS := $(patsubst %/main.tex,%,$(wildcard documents/*/main.tex))
DOCUMENT_GOALS := $(filter documents/%,$(MAKECMDGOALS))
COMMAND_GOALS := $(filter build clean,$(MAKECMDGOALS))
KNOWN_GOALS := help new build list all check-style test reference
KNOWN_GOALS += templates clean
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

.PHONY: help new build list all check-style test reference templates clean FORCE

help:
	@echo "IEEE UFG Computer Society LaTeX"
	@echo
	@echo "Uso de documentos:"
	@echo "  make new       cria um documento a partir de um modelo"
	@echo "  make build     compila todos os documentos"
	@echo "  make build documents/x [...] compila documentos específicos"
	@echo "  make list      lista modelos e documentos"
	@echo "  make clean     remove arquivos gerados em build/"
	@echo "  make clean documents/x [...] limpa documentos específicos"
	@echo
	@echo "Desenvolvimento:"
	@echo "  make all       executa testes, referência e modelos"
	@echo "  make test      executa os testes de fumaça"
	@echo "  make reference compila a referência visual"
	@echo "  make templates compila os modelos canônicos"
	@echo "  make check-style verifica o limite de 80 caracteres"

new:
	@bash scripts/document.sh new "$(TEMPLATE)" "$(NAME)" "$(BUILD)"

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
	@bash scripts/document.sh list

all: test reference templates

check-style:
	@find . \
		-path './.git' -prune -o \
		-path './build' -prune -o \
		-path './documents' -prune -o \
		-path './example' -prune -o \
		-type f \( \
			-name '*.cls' -o \
			-name '*.bib' -o \
			-name '*.bib.example' -o \
			-name '*.lua' -o \
			-name '*.md' -o \
			-name '*.sh' -o \
			-name '*.sty' -o \
			-name '*.tsv' -o \
			-name '*.tex' -o \
			-name '.gitignore' -o \
			-name 'Makefile' \
		\) -exec texlua scripts/check-line-length.lua {} +

test: check-style
	mkdir -p $(BUILD_DIR)/tests "$(TEXMFVAR_DIR)"
	$(TEX_ENV) $(LATEXMK) $(LATEXMK_FLAGS) \
		-outdir=$(BUILD_DIR)/tests tests/smoke/brand.tex
	$(TEX_ENV) $(LATEXMK) $(LATEXMK_FLAGS) \
		-outdir=$(BUILD_DIR)/tests tests/smoke/cmyk.tex
	$(TEX_ENV) $(LATEXMK) $(LATEXMK_FLAGS) \
		-outdir=$(BUILD_DIR)/tests tests/smoke/document.tex
	$(TEX_ENV) $(LATEXMK) $(LATEXMK_FLAGS) \
		-outdir=$(BUILD_DIR)/tests tests/smoke/compact.tex

reference:
	mkdir -p $(BUILD_DIR)/reference "$(TEXMFVAR_DIR)"
	$(TEX_ENV) $(LATEXMK) $(LATEXMK_FLAGS) \
		-outdir=$(BUILD_DIR)/reference \
		tests/reference/brand-reference.tex

templates:
	mkdir -p $(BUILD_DIR)/templates/plano-trabalho "$(TEXMFVAR_DIR)"
	$(TEX_ENV) $(LATEXMK) $(LATEXMK_FLAGS) \
		-outdir=$(BUILD_DIR)/templates/plano-trabalho \
		templates/plano-trabalho/main.tex

ifeq ($(strip $(DOCUMENT_GOALS)),)
clean:
	@bash scripts/document.sh clean
else
clean:
	@:
endif

documents/%: FORCE
	@bash scripts/document.sh validate-path "$@"
	+@$(MAKE) --no-print-directory -C "$@" $(DOCUMENT_ACTION)

FORCE:
