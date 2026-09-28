# Copyright (C) 2026 IEEE UFG Computer Society contributors.
# Distributed and/or modified under the LaTeX Project Public License,
# version 1.3c or later. This work has LPPL status `maintained'; the Current
# Maintainer is the IEEE UFG Computer Society. See LICENSE and MANIFEST.md.

LATEXMK ?= latexmk
LATEXMK_FLAGS = -lualatex -interaction=nonstopmode -halt-on-error
BUILD_DIR = build
TEXMFVAR_DIR ?= $(CURDIR)/$(BUILD_DIR)/texmf-var
TEX_ENV = TEXINPUTS=tex/latex//: TEXMFVAR="$(TEXMFVAR_DIR)"

.PHONY: all test docs clean

all: test docs

test:
	mkdir -p $(BUILD_DIR)/tests "$(TEXMFVAR_DIR)"
	$(TEX_ENV) $(LATEXMK) $(LATEXMK_FLAGS) \
		-outdir=$(BUILD_DIR)/tests tests/smoke/brand.tex
	$(TEX_ENV) $(LATEXMK) $(LATEXMK_FLAGS) \
		-outdir=$(BUILD_DIR)/tests tests/smoke/cmyk.tex

docs:
	mkdir -p $(BUILD_DIR)/docs "$(TEXMFVAR_DIR)"
	$(TEX_ENV) $(LATEXMK) $(LATEXMK_FLAGS) \
		-outdir=$(BUILD_DIR)/docs docs/brand-reference.tex

clean:
	$(LATEXMK) -C -outdir=$(BUILD_DIR)/tests tests/smoke/brand.tex
	$(LATEXMK) -C -outdir=$(BUILD_DIR)/tests tests/smoke/cmyk.tex
	$(LATEXMK) -C -outdir=$(BUILD_DIR)/docs docs/brand-reference.tex
