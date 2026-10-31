# Copyright (C) 2026 IEEE UFG Computer Society contributors.
# Distributed under the LaTeX Project Public License 1.3c or later.
# See ../LICENSE and MANIFEST.md.

LATEXMK ?= latexmk
LATEXMK_FLAGS = -lualatex -interaction=nonstopmode -halt-on-error
BUILD_DIR = build
TEXMFVAR_DIR ?= $(CURDIR)/$(BUILD_DIR)/texmf-var
TEX_ENV = TEXINPUTS="$(CURDIR)/tex/latex//:" \
	TEXMFVAR="$(TEXMFVAR_DIR)"

.DEFAULT_GOAL := help
.PHONY: help all check-style test reference templates clean

help:
	@echo "Desenvolvimento IEEE UFG Computer Society LaTeX"
	@echo
	@echo "  make all         executa testes, referência e modelos"
	@echo "  make test        executa os testes de fumaça"
	@echo "  make reference   compila a referência visual"
	@echo "  make templates   compila os modelos canônicos"
	@echo "  make check-style verifica o limite de 80 caracteres"
	@echo "  make clean       limpa as saídas de desenvolvimento"

all: test reference templates

check-style:
	@find .. \
		-path '../.git' -prune -o \
		-path '../.agents' -prune -o \
		-path '../.aws' -prune -o \
		-path '../.codex' -prune -o \
		-path '../documents' -prune -o \
		-path '../development/build' -prune -o \
		-path '../development/reference-material' -prune -o \
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
	$(TEX_ENV) $(LATEXMK) $(LATEXMK_FLAGS) \
		-outdir=$(BUILD_DIR)/tests tests/smoke/slides.tex

reference:
	mkdir -p $(BUILD_DIR)/reference "$(TEXMFVAR_DIR)"
	$(TEX_ENV) $(LATEXMK) $(LATEXMK_FLAGS) \
		-outdir=$(BUILD_DIR)/reference \
		tests/reference/brand-reference.tex

templates:
	mkdir -p $(BUILD_DIR)/templates/plano-trabalho \
		$(BUILD_DIR)/templates/slides \
		$(BUILD_DIR)/templates/cartao \
		"$(TEXMFVAR_DIR)"
	$(TEX_ENV) $(LATEXMK) $(LATEXMK_FLAGS) \
		-outdir=$(BUILD_DIR)/templates/plano-trabalho \
		templates/plano-trabalho/main.tex
	$(TEX_ENV) $(LATEXMK) $(LATEXMK_FLAGS) \
		-outdir=$(BUILD_DIR)/templates/slides \
		templates/slides/main.tex
	$(TEX_ENV) $(LATEXMK) $(LATEXMK_FLAGS) \
		-outdir=$(BUILD_DIR)/templates/cartao \
		templates/cartao/main.tex

clean:
	@bash scripts/document.sh clean-development
