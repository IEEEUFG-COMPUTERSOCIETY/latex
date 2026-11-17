# IEEE UFG Computer Society LaTeX

Modelos institucionais da IEEE Computer Society e da UFG para LuaLaTeX.
Versão 1.0.0.

## Criar e editar um documento

É necessário ter LuaLaTeX, `latexmk`, `texlua`, Montserrat e Open Sans.
GNU Make é opcional para os comandos `make` abaixo.
Apresentações também exigem Beamer; bibliografias exigem Biber.

```sh
make new
```

O assistente cria `documents/<nome>/main.tex`. Edite esse arquivo e coloque
imagens na pasta `img/` do documento. Os documentos são locais e não entram
no Git.

```sh
make build
```

O PDF aparece ao lado do código, em `documents/<nome>/main.pdf`.
Para trabalhar em um documento específico:

```sh
make build documents/meu-doc
make clean documents/meu-doc
```

Dentro da pasta do documento, `make build` e `make clean` também funcionam.
`make list` mostra modelos e documentos; `make clean` limpa todas as saídas.

No macOS e no Windows, instale uma distribuição TeX que inclua LuaLaTeX,
`latexmk` e `texlua`, além das fontes indicadas acima. No Windows, execute os
comandos abaixo no PowerShell ou no Prompt de Comando, a partir da raiz do
projeto. Eles também funcionam no macOS e no Linux, sem GNU Make ou Bash:

```text
texlua development/scripts/project.lua list
texlua development/scripts/project.lua new slides evento no
texlua development/scripts/project.lua build-all
texlua development/scripts/project.lua build-path documents/evento
texlua development/scripts/project.lua clean-path documents/evento
texlua development/scripts/project.lua clean
```

Para usar as verificações de desenvolvimento sem Make, execute
`texlua development/scripts/project.lua dev-all` na raiz do projeto.

Para criar um documento sem perguntas:

```sh
make new TEMPLATE=slides NAME=evento BUILD=yes
```

Use `TEMPLATE=documento` para um texto geral ou `TEMPLATE=plano-trabalho`
para um plano com seções de objetivos, etapas e responsáveis. Ambos usam a
mesma classe institucional.
Use `TEMPLATE=atas` para registrar reuniões com presenças, deliberações,
encaminhamentos e assinaturas, em formato compacto.
Use `TEMPLATE=relatorios` para registrar execução, resultados e evidências
de uma atividade após sua realização.
Use `TEMPLATE=plano-projeto` para apresentar à Diretoria um plano de
execução de projeto em slides e registrar a versão aprovada.
Use `TEMPLATE=estatuto` para um texto com capítulos e artigos numerados.

O [guia de casos de uso](development/document-use-cases.md) indica quando
criar cada registro operacional e quem deve prepará-lo.

Para referências, renomeie `references.bib.example` para `references.bib` e
ative as linhas indicadas no arquivo `.tex` do documento.

## Desenvolvimento e licença

Código, modelos, testes, referências e comandos de manutenção estão em
[development/](development/README.md). Use `make -C development` para ver os
comandos de desenvolvimento.

O código listado em [development/MANIFEST.md](development/MANIFEST.md) usa a
LPPL 1.3c ou posterior. As marcas oficiais não fazem parte desse trabalho.
Consulte [LICENSE](LICENSE).

A versão 1.0.0 altera o layout. Para migrar
documentos de versões anteriores, consulte o
[guia de desenvolvimento](development/README.md).

## TODO

- [ ] cartão de visita no formato "pitch", com blocos de áreas de interesse,
  curso, etc.
