# Copyright (C) 2026 IEEE UFG Computer Society contributors.
# Distributed under the LaTeX Project Public License 1.3c or later.
# See project LICENSE and development/MANIFEST.md.

.DEFAULT_GOAL := help

.PHONY: help build clean

help:
	@echo "Documento IEEE UFG Computer Society"
	@echo
	@echo "  make       mostra esta ajuda"
	@echo "  make build compila este documento"
	@echo "  make clean remove os arquivos gerados deste documento"

build:
	@texlua ../../development/scripts/project.lua build-path .

clean:
	@texlua ../../development/scripts/project.lua clean-path .
