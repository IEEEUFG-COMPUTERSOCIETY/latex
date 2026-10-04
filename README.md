# IEEE UFG Computer Society LaTeX

Este projeto permite criar documentos institucionais com as identidades
visuais da IEEE Computer Society e da Universidade Federal de Goiás. Ele usa
LuaLaTeX e oferece modelos prontos para pessoas que não precisam conhecer a
implementação da classe ou dos pacotes de identidade visual.

## Requisitos

- GNU Make;
- LuaLaTeX e `latexmk`;
- fontes Montserrat e Open Sans;
- Bash;
- Beamer, para criar apresentações; e
- Biber, somente para documentos com referências bibliográficas.

## Uso rápido

Execute apenas `make` para consultar os comandos disponíveis:

```sh
make
```

Crie um documento:

```sh
make new
```

O assistente apresenta os modelos disponíveis, solicita um identificador e
pergunta se o documento deve ser compilado imediatamente. O resultado tem a
seguinte estrutura:

```text
documents/<identificador>/
├── img/
├── Makefile
├── main.tex
└── references.bib.example
```

Para começar, edite somente `main.tex`. O próprio arquivo explica as opções de
papel, tamanho da fonte, margens, páginas, cores, metadados, imagens, tabelas e
referências. A pasta `img/` recebe imagens específicas do documento.

O diretório `documents/` é a área de trabalho local do usuário. Os diretórios
`templates/`, `tex/`, `scripts/`, `tests/` e `example/` pertencem ao
desenvolvimento da infraestrutura e não precisam ser editados para criar um
documento.

Se precisar de bibliografia, renomeie `references.bib.example` para
`references.bib` e siga as instruções presentes nos dois arquivos.

Na raiz do repositório, compile todos os documentos criados com:

```sh
make build
```

Para compilar somente documentos específicos, informe seus diretórios:

```sh
make build documents/plano-2027 documents/apresentacao-evento
```

Também é possível entrar no diretório de um documento. Nesse caso, `make`
continua mostrando a ajuda e `make build` compila somente o documento atual:

```sh
cd documents/plano-2027
make
make build
```

Os arquivos gerados ficam em:

```text
build/documents/<identificador>/main.pdf
```

Para listar modelos e documentos ou remover os arquivos gerados:

```sh
make list
make clean
make clean documents/plano-2027
```

Na raiz, `make clean` limpa todo o diretório `build/`. Dentro de um documento,
`make clean` remove somente os arquivos gerados para aquele documento.

## Uso não interativo

Colaboradores e rotinas automatizadas também podem informar as escolhas na
linha de comando:

```sh
make new TEMPLATE=plano-trabalho NAME=plano-2027 BUILD=no
make build documents/plano-2027
```

## Desenvolvimento

O comando `make all` compila testes, a referência visual e modelos canônicos. O
projeto exige no máximo 80 caracteres por linha; `make check-style` verifica
essa regra.

As decisões de implementação e os detalhes da identidade visual são mantidos
como comentários nos arquivos da classe e do pacote. Os modelos disponíveis
estão descritos em [`templates/README.md`](templates/README.md).

O [`guia de desenvolvimento`](development/README.md) apresenta a
arquitetura do projeto, documenta as APIs completas da classe e do pacote de
marca e ensina como criar opções, metadados, componentes, modelos, cores,
ativos e testes.

## Licença

Os arquivos relacionados em [`MANIFEST.md`](MANIFEST.md) são distribuídos sob
a LaTeX Project Public License, versão 1.3c ou posterior, com status
`maintained`.

Os arquivos oficiais de arte do IEEE, da IEEE Computer Society e da UFG não
fazem parte do trabalho licenciado sob a LPPL. Consulte [`LICENSE`](LICENSE)
para conhecer os termos completos e as exclusões de marcas oficiais.
