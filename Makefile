# Copyright (C) 2026 IEEE UFG Computer Society contributors.
# Distributed and/or modified under the LaTeX Project Public License,
# version 1.3c or later. This work has LPPL status `maintained'; the Current
# Maintainer is the IEEE UFG Computer Society. See LICENSE and MANIFEST.md.

LATEXMK ?= latexmk
LATEXMK_FLAGS = -lualatex -interaction=nonstopmode -halt-on-error
BUILD_DIR = build
TEXMFVAR_DIR ?= $(CURDIR)/$(BUILD_DIR)/texmf-var
TEX_ENV = TEXINPUTS=tex/latex//: TEXMFVAR="$(TEXMFVAR_DIR)"

.DEFAULT_GOAL := help

.PHONY: help new build list all check-style test reference templates clean

help:
	@echo "IEEE UFG Computer Society LaTeX"
	@echo
	@echo "Uso de documentos:"
	@echo "  make new       cria um documento a partir de um modelo"
	@echo "  make build     compila um documento criado"
	@echo "  make list      lista modelos e documentos"
	@echo "  make clean     remove arquivos gerados em build/"
	@echo
	@echo "Desenvolvimento:"
	@echo "  make all       executa testes, referência e modelos"
	@echo "  make test      executa os testes de fumaça"
	@echo "  make reference compila a referência visual"
	@echo "  make templates compila os modelos canônicos"
	@echo "  make check-style verifica o limite de 80 caracteres"

new:
	@bash scripts/document.sh new "$(TEMPLATE)" "$(NAME)" "$(BUILD)"

build:
	@bash scripts/document.sh build "$(NAME)"

list:
	@bash scripts/document.sh list

all: test reference templates

check-style:
	@find . \
		-path './.git' -prune -o \
		-path './build' -prune -o \
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
	mkdir -p $(BUILD_DIR)/templates/work-plan "$(TEXMFVAR_DIR)"
	$(TEX_ENV) $(LATEXMK) $(LATEXMK_FLAGS) \
		-outdir=$(BUILD_DIR)/templates/work-plan \
		templates/work-plan/main.tex

clean:
	@bash scripts/document.sh clean
