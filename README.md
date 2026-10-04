# IEEE UFG Computer Society LaTeX

Modelos institucionais da IEEE Computer Society e da UFG para LuaLaTeX.

## Requisitos

- GNU Make, Bash, LuaLaTeX e `latexmk`;
- Montserrat e Open Sans;
- Beamer para apresentações; e
- Biber para referências bibliográficas.

## Uso

```sh
make new
make build
```

O assistente cria `documents/<identificador>/`. Edite `main.tex`, coloque
imagens em `img/` e encontre o PDF em
`build/documents/<identificador>/main.pdf`.

Comandos úteis:

```sh
make                         # ajuda
make list                    # modelos e documentos
make build documents/meu-doc
make clean
```

Dentro de um documento, `make build` compila apenas esse documento e
`make clean` remove apenas sua saída.

Para uso não interativo:

```sh
make new TEMPLATE=slides NAME=evento BUILD=yes
make new TEMPLATE=plano-trabalho NAME=plano-2027 BUILD=no
```

Para referências, renomeie `references.bib.example` para `references.bib` e
ative as linhas indicadas em `main.tex`.

## Desenvolvimento

```sh
make all          # testes, referência visual e modelos
make test         # estilo e testes de fumaça
make templates    # modelos canônicos
make check-style  # limite de 80 caracteres
```

Consulte os [modelos](templates/README.md) e o
[guia de desenvolvimento](development/README.md).

## Licença

O código listado em [MANIFEST.md](MANIFEST.md) usa a LPPL 1.3c ou posterior.
As marcas oficiais não fazem parte desse trabalho. Consulte [LICENSE](LICENSE).
