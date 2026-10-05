<!--
Copyright (C) 2026 IEEE UFG Computer Society contributors.
Distributed and/or modified under the LaTeX Project Public License,
version 1.3c or later. See LICENSE and MANIFEST.md.
-->

# Modelos

`make new` copia um modelo para `documents/<identificador>/`. Edite
`main.tex`, use `img/` e renomeie `references.bib.example` quando necessário.

| Identificador | Uso |
|---|---|
| `plano-trabalho` | Plano, proposta ou pedido institucional. |
| `slides` | Apresentação institucional em formato 16:9. |
| `cartao` | Cartão de visita institucional, frente e verso. |

`atas`, `relatorios` e `materiais-divulgacao` ainda são reservas sem
`main.tex` e não aparecem no assistente.

Para publicar um novo modelo, adicione `main.tex`, registre-o em
`catalog.tsv`, inclua-o no `Makefile` e atualize `MANIFEST.md`.
