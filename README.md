# IEEE UFG Computer Society LaTeX

Modelos institucionais da IEEE Computer Society e da UFG para LuaLaTeX.
Versão 1.0.0.

## Criar e editar um documento

É necessário ter GNU Make, Bash, LuaLaTeX, `latexmk`, Montserrat e Open Sans.
Apresentações também exigem Beamer; bibliografias exigem Biber.

```sh
make new
```

O assistente cria `documents/<nome>/<nome>.tex`. Edite esse arquivo e coloque
imagens na pasta `img/` do documento. Os documentos são locais e não entram
no Git.

```sh
make build
```

O PDF aparece ao lado do código, em `documents/<nome>/<nome>.pdf`.
Para trabalhar em um documento específico:

```sh
make build documents/meu-doc
make clean documents/meu-doc
```

Dentro da pasta do documento, `make build` e `make clean` também funcionam.
`make list` mostra modelos e documentos; `make clean` limpa todas as saídas.

Para criar um documento sem perguntas:

```sh
make new TEMPLATE=slides NAME=evento BUILD=yes
```

Para referências, renomeie `references.bib.example` para `references.bib` e
ative as linhas indicadas no arquivo `.tex` do documento.

## Desenvolvimento e licença

Código, modelos, testes, referências e comandos de manutenção estão em
[development/](development/README.md). Use `make -C development` para ver os
comandos de desenvolvimento.

O código listado em [development/MANIFEST.md](development/MANIFEST.md) usa a
LPPL 1.3c ou posterior. As marcas oficiais não fazem parte desse trabalho.
Consulte [LICENSE](LICENSE).

A versão 1.0.0 altera o layout e o nome do arquivo principal. Para migrar
documentos de versões anteriores, consulte o
[guia de desenvolvimento](development/README.md).
