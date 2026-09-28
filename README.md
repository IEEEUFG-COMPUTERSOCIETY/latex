# IEEE UFG Computer Society LaTeX

Recursos de identidade visual reutilizáveis em LaTeX e, futuramente, modelos de
documentos para o Capítulo Estudantil da IEEE Computer Society na UFG.

A primeira camada da implementação é o pacote `ieeeufgcs-brand`, que fornece:

- a paleta oficial de cores do IEEE e da IEEE Computer Society;
- seletores para títulos em Montserrat e corpo de texto em Open Sans;
- comandos para inserir o logotipo oficial da Computer Society e as assinaturas
  conjuntas com a marca principal do IEEE, respeitando suas áreas de proteção; e
- modos de saída RGB (padrão) e CMYK.

## Início rápido

```tex
\usepackage{ieeeufgcs-brand}

\color{IEEECSOrange}
{\IEEECSHeadingFont Um título da Computer Society}

\IEEECSLogo[variant=orange,width=45mm]
\IEEEMasterBrand[variant=blue,width=55mm,clear-space=print]
```

Use `\usepackage[cmyk]{ieeeufgcs-brand}` para obter definições CMYK destinadas à
impressão ou `\usepackage[nofonts]{ieeeufgcs-brand}` quando a classe do documento
já for responsável pela seleção das fontes.

Compile os testes básicos e a folha de referência com:

```sh
make test
make docs
```

LuaLaTeX é o motor de composição do projeto. O Makefile executa
`latexmk -lualatex` e mantém o cache de fontes gerado em `build/`. Montserrat e
Open Sans devem estar instaladas e acessíveis ao LuaLaTeX.

A justificativa das decisões e a lista completa de tokens estão em
[`docs/brand-foundation.md`](docs/brand-foundation.md). Os manuais de identidade
e arquivos de arte originais permanecem fora deste repositório, no diretório
pai. O pacote contém cópias normalizadas em PDF dos arquivos de produção
fornecidos.
