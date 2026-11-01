<!--
Copyright (C) 2026 IEEE UFG Computer Society contributors.
Distributed and/or modified under the LaTeX Project Public License,
version 1.3c or later. See ../../LICENSE and ../MANIFEST.md.
-->

# Modelos

`make new` copia um modelo para `documents/<identificador>/`. Edite
`main.tex`, use `img/` e renomeie `references.bib.example` quando necessário.

| Identificador | Uso |
|---|---|
| `documento` | Documento institucional para textos em geral. |
| `atas` | Ata de reunião com presenças, decisões e encaminhamentos. |
| `plano-trabalho` | Plano institucional com objetivos, etapas e responsáveis. |
| `estatuto` | Normas organizadas em capítulos, artigos e incisos. |
| `slides` | Slides institucionais em formato 16:9. |
| `cartao` | Cartão de visita institucional, frente e verso. |

`relatorios` e `materiais-divulgacao` ainda são reservas sem
`main.tex` e não aparecem no assistente.

Para publicar um novo modelo, adicione `main.tex`, registre-o em
`catalog.tsv`, inclua-o em `development/Makefile` e atualize
`development/MANIFEST.md`.
