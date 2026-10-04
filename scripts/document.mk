# Copyright (C) 2026 IEEE UFG Computer Society contributors.
# Distributed under the LaTeX Project Public License 1.3c or later.
# See LICENSE and MANIFEST.md.

PROJECT_ROOT := $(shell cd ../.. && pwd -P)
DOCUMENT_DIR := $(shell pwd -P)

.DEFAULT_GOAL := help

.PHONY: help build clean

help:
	@echo "Documento IEEE UFG Computer Society"
	@echo
	@echo "  make       mostra esta ajuda"
	@echo "  make build compila este documento"
	@echo "  make clean remove os arquivos gerados deste documento"

build:
	@bash "$(PROJECT_ROOT)/scripts/document.sh" \
		build-path "$(DOCUMENT_DIR)"

clean:
	@bash "$(PROJECT_ROOT)/scripts/document.sh" \
		clean-path "$(DOCUMENT_DIR)"
