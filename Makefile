# Copyright (C) 2026 IEEE UFG Computer Society contributors.
# Distributed and/or modified under the LaTeX Project Public License,
# version 1.3c or later. This work has LPPL status `maintained'; the Current
# Maintainer is the IEEE UFG Computer Society. See LICENSE and MANIFEST.md.

LATEXMK ?= latexmk
LATEXMK_FLAGS = -lualatex -interaction=nonstopmode -halt-on-error
BUILD_DIR = build
TEXMFVAR_DIR ?= $(CURDIR)/$(BUILD_DIR)/texmf-var
TEX_ENV = TEXINPUTS=tex/latex//: TEXMFVAR="$(TEXMFVAR_DIR)"

.PHONY: all check-style test docs templates clean

all: test docs templates

check-style:
	@find . \
		-path './.git' -prune -o \
		-path './build' -prune -o \
		-type f \( \
			-name '*.cls' -o \
			-name '*.lua' -o \
			-name '*.md' -o \
			-name '*.sty' -o \
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

docs:
	mkdir -p $(BUILD_DIR)/docs "$(TEXMFVAR_DIR)"
	$(TEX_ENV) $(LATEXMK) $(LATEXMK_FLAGS) \
		-outdir=$(BUILD_DIR)/docs docs/brand-reference.tex

templates:
	mkdir -p $(BUILD_DIR)/templates/work-plan "$(TEXMFVAR_DIR)"
	$(TEX_ENV) $(LATEXMK) $(LATEXMK_FLAGS) \
		-outdir=$(BUILD_DIR)/templates/work-plan \
		templates/work-plan/main.tex

clean:
	$(LATEXMK) -C -outdir=$(BUILD_DIR)/tests tests/smoke/brand.tex
	$(LATEXMK) -C -outdir=$(BUILD_DIR)/tests tests/smoke/cmyk.tex
	$(LATEXMK) -C -outdir=$(BUILD_DIR)/tests tests/smoke/document.tex
	$(LATEXMK) -C -outdir=$(BUILD_DIR)/tests tests/smoke/compact.tex
	$(LATEXMK) -C -outdir=$(BUILD_DIR)/docs docs/brand-reference.tex
	$(LATEXMK) -C -outdir=$(BUILD_DIR)/templates/work-plan \
		templates/work-plan/main.tex
