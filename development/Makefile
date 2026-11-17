# Copyright (C) 2026 IEEE UFG Computer Society contributors.
# Distributed under the LaTeX Project Public License 1.3c or later.
# See ../LICENSE and MANIFEST.md.

.DEFAULT_GOAL := help
.PHONY: help all check-style test reference templates clean

help:
	@echo "Desenvolvimento IEEE UFG Computer Society LaTeX"
	@echo "  make all         executa testes, referência e modelos"
	@echo "  make test        executa os testes de fumaça"
	@echo "  make reference   compila a referência visual"
	@echo "  make templates   compila os modelos canônicos"
	@echo "  make check-style verifica o limite de 80 caracteres"
	@echo "  make clean       limpa as saídas de desenvolvimento"

all:
	@texlua scripts/project.lua dev-all

check-style:
	@texlua scripts/project.lua check-style

test:
	@texlua scripts/project.lua dev-test

reference:
	@texlua scripts/project.lua dev-reference

templates:
	@texlua scripts/project.lua dev-templates

clean:
	@texlua scripts/project.lua clean-development
