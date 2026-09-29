<!--
Copyright (C) 2026 IEEE UFG Computer Society contributors.
Distributed and/or modified under the LaTeX Project Public License,
version 1.3c or later. This work has LPPL status `maintained`; the Current
Maintainer is the IEEE UFG Computer Society. See LICENSE and MANIFEST.md.
-->

# Modelos disponíveis

Use `make new` na raiz do repositório para escolher um modelo. O assistente
copia o diretório escolhido para `documents/<identificador>/`, cria `img/` e
oferece a compilação imediata.

Cada modelo contém um `main.tex` documentado e um
`references.bib.example`. A pessoa autora começa editando somente `main.tex`.
Arquivos de imagem podem ser colocados em `img/`. A cópia criada pode ser
alterada livremente sem modificar o modelo canônico.

Todos os documentos institucionais usam a classe `ieeeufgcs`. Um modelo
seleciona opções da classe, fornece metadados de exemplo e sugere uma estrutura
de conteúdo que pode ser adaptada conforme a necessidade.

- `work-plan`: plano de trabalho, proposta institucional ou pedido de
  aprovação com objetivos, etapas, responsabilidades e decisões solicitadas.

Modelos futuros para atas, registros de decisão, relatórios e materiais de
divulgação devem seguir a mesma separação entre apresentação e conteúdo. Para
cadastrar um novo modelo no assistente, adicione uma entrada a `catalog.tsv`.
