<!--
Copyright (C) 2026 IEEE UFG Computer Society contributors.
Distributed and/or modified under the LaTeX Project Public License,
version 1.3c or later. See LICENSE and MANIFEST.md.
-->

# Guia de desenvolvimento

Referência curta da arquitetura, das APIs públicas e dos testes. Para criar um
documento, use apenas `make new`, edite `main.tex` e execute `make build`.

## Arquitetura

```text
documents/ → templates/ → classe ou tema Beamer → pacote de marca
```

| Caminho | Responsabilidade |
|---|---|
| `tex/latex/ieeeufgcs/ieeeufgcs.cls` | Documentos institucionais. |
| `tex/latex/ieeeufgcs/beamerthemeieeeufgcs.sty` | Apresentações. |
| `tex/latex/ieeeufgcs/ieeeufgcs-brand.sty` | Identidade visual. |
| `tex/latex/ieeeufgcs/assets/` | Arte oficial normalizada. |
| `templates/` | Modelos canônicos. |
| `documents/` | Trabalho local, ignorado pelo Git. |
| `tests/` | Testes de fumaça e referência visual. |
| `build/` | Saída descartável. |

O `Makefile` acrescenta `tex/latex//` a `TEXINPUTS` e guarda o cache do LuaTeX
em `build/texmf-var`. Não é necessária uma instalação global da classe.

## Classe `ieeeufgcs`

```tex
\documentclass{ieeeufgcs}
\IEEECSSetup{
  document-type={Relatório},
  title={Título},
  author={Equipe},
  date={\today}
}
\begin{document}
\maketitle
\section{Introdução}
Conteúdo.
\end{document}
```

### Opções

| Opção | Padrão | Valores |
|---|---:|---|
| `paper-size` | `a4` | `a4`, `letter` |
| `font-size` | `11pt` | `10pt`, `11pt`, `12pt` |
| `two-sided` | `true` | `true`, `false` |
| `title-page` | `true` | `true`, `false` |
| `section-numbering` | `plain` | `plain`, `two-digit` |
| `inner-margin` | `22mm` | dimensão TeX |
| `outer-margin` | `22mm` | dimensão TeX |
| `top-margin` | `24mm` | dimensão TeX |
| `bottom-margin` | `28mm` | dimensão TeX |
| `binding-offset` | `0mm` | dimensão TeX |
| `color-model` | `rgb` | `rgb`, `cmyk` |

Opções desconhecidas são encaminhadas para `article`.

### Metadados

| Chave | Uso |
|---|---|
| `document-type` | Rótulo da capa. |
| `title` | Título principal. |
| `subtitle` | Subtítulo. |
| `running-title` | Cabeçalho; usa `title` quando vazio. |
| `institution`, `unit` | Vínculo institucional. |
| `author`, `date` | Autoria e data. |
| `location` | Local. |
| `identifier` | Versão ou código. |

Campos opcionais vazios não reservam espaço. `title`, `author` e `date`
também alimentam os comandos LaTeX padrão.

### Componentes

```tex
\begin{IEEECSNotice}[Atenção]
Mensagem curta.
\end{IEEECSNotice}

\begin{IEEECSBrandedTable}{m{.3\linewidth}X}
\IEEECSHeaderCell{Item} & \IEEECSHeaderCell{Descrição} \\
Prazo & Dezembro. \\
\end{IEEECSBrandedTable}
```

`IEEECSBrandedTable` usa a sintaxe de colunas de `tabularx`. As colunas `X`
são centralizadas verticalmente; use `m{largura}` para obter o mesmo
alinhamento em colunas de largura fixa.

## Pacote `ieeeufgcs-brand`

Outra classe pode carregar a identidade diretamente:

```tex
\usepackage{ieeeufgcs-brand}
```

O pacote exige LuaLaTeX. Suas opções são `color-model=rgb|cmyk` e
`fonts=true|false`. As formas antigas `rgb`, `cmyk` e `nofonts` estão
obsoletas.

### Fontes e cores

- `\IEEECSHeadingFont`: Montserrat;
- `\IEEECSBodyFont`: Open Sans;
- aliases: `IEEECSPrimary`, `IEEECSSecondary`, `IEEECSBodyText`; e
- cores: `IEEEBlue`, `IEEECyan`, `IEEECSOrange`, `IEEEGray`, `IEEERed`,
  `IEEEYellow`, `IEEEBrightGreen`, `IEEEGreen`, `IEEEPurple`, `IEEETeal`,
  `IEEEDarkRed`, `IEEEDarkOrange`, `IEEEDarkYellow`, `IEEEOliveGreen`,
  `IEEEDarkGreen`, `IEEEDarkPurple`, `IEEEDarkTeal`, `IEEEDarkBlue`,
  `IEEEBlack`, `IEEEWhite` e `UFGBlue`.

As cores IEEE possuem os sufixos `Eighty`, `Sixty`, `Forty` e `Twenty`.
`UFGBlue` não possui tonalidades derivadas.

### Marcas

```tex
\IEEECSLogo[variant=orange,width=45mm,clear-space=true]
\IEEEMasterBrand[variant=blue,width=55mm,clear-space=digital]
\UFGLogo[orientation=vertical,variant=blue,width=24mm]
\IEEEUFGStudentBranchMark[variant=horizontal,width=60mm]
```

| Comando | Variantes e proteção |
|---|---|
| `\IEEECSLogo` | `orange`, `black`, `white`, `orange-white`; 0,3 da altura. |
| `\IEEEMasterBrand` | `blue`, `black`, `white`; `print`, `digital`, `none`. |
| `\UFGLogo` | `blue`, `black`, `white`; proteção própria da UFG. |
| `\IEEEUFGStudentBranchMark` | `horizontal`, `compact`, `symbol`; raster. |

A assinatura UFG pode ser `vertical` ou `horizontal`. As larguras mínimas são
12mm e 24,5mm, respectivamente. `width` mede a arte, não a área protegida.

Não distorça, corte, gire, recolora ou reconstrua marcas. Use versões brancas
somente em fundos escuros e preserve contraste e áreas de proteção.

As marcas do Student Branch usam os PNGs oficiais fornecidos. `horizontal` é a
assinatura completa, `compact` contém “IEEE UFG” sobre fundo branco e `symbol`
é o símbolo isolado. Como não há fonte vetorial, use-as apenas em tamanhos nos
quais a resolução original seja suficiente.
Os PNGs permanecem em RGB mesmo com `color-model=cmyk`; confirme o fluxo de
conversão com a gráfica antes de usá-los em produção impressa.
Para cerca de 300 ppi, limite `horizontal` a 93mm, `compact` a 66mm e
`symbol` a 22mm. Os padrões do comando ficam abaixo desses limites.

## Tema Beamer `ieeeufgcs`

```tex
\documentclass[aspectratio=169]{beamer}
\usetheme{ieeeufgcs}
\title[Título breve]{Título}
\begin{document}
\begin{frame}[plain,noframenumbering]
  \titlepage
\end{frame}
\section{Contexto}
\begin{frame}{Título do quadro}
  Conteúdo.
\end{frame}
\end{document}
```

O tema cria capa, divisórias, títulos, rodapé e blocos. Divisórias podem ser
desativadas com `\usetheme[sectionpages=false]{ieeeufgcs}`.

Use `\IEEECSMetric{valor}{rótulo}` para um indicador curto. O tema e a classe
compartilham a mesma geometria de icosaedros pelo pacote de marca.

## Modelos e documentos

Um modelo deve conter `main.tex`, `references.bib.example` e, quando útil,
`img/README.md`. Para publicá-lo:

1. crie `templates/<identificador>/`;
2. registre `identificador|nome|descrição` em `templates/catalog.tsv`;
3. adicione a compilação ao alvo `templates` do `Makefile`;
4. atualize `MANIFEST.md`; e
5. execute `make all`.

Mantenha conteúdo específico no modelo. Promova um componente à classe apenas
quando ele tiver significado institucional reutilizável.

O assistente aceita identificadores com letras, números, hífen e sublinhado.
Seus comandos internos de caminho operam somente em filhos de `documents/`.
`make clean` nunca remove fontes em `documents/`.

## Comandos e testes

| Comando | Resultado |
|---|---|
| `make new` | Cria um documento. |
| `make build` | Compila documentos locais. |
| `make list` | Lista modelos e documentos. |
| `make test` | Executa estilo e testes de fumaça. |
| `make reference` | Compila a referência visual. |
| `make templates` | Compila modelos canônicos. |
| `make all` | Executa testes, referência e modelos. |
| `make clean` | Limpa `build/`. |

| Teste | Cobertura |
|---|---|
| `brand.tex` | Fontes, cores e marcas. |
| `cmyk.tex` | CMYK e `fonts=false`. |
| `document.tex` | Capa e componentes documentais. |
| `compact.tex` | Título compacto. |
| `slides.tex` | Tema Beamer. |

Após mudanças visuais, inspecione os PDFs em `build/tests/`,
`build/reference/` e `build/templates/`.

## Manutenção

- use interfaces públicas com prefixo `IEEECS`;
- mantenha auxiliares internos no módulo `ieeecs`;
- preserve compatibilidade ou emita aviso de obsolescência;
- atualize versão, documentação e testes junto com a interface;
- limite arquivos-fonte a 80 caracteres por linha; e
- registre todo arquivo distribuído em `MANIFEST.md`.

Novas cores e marcas precisam de fonte oficial, variantes RGB e CMYK quando
aplicável, teste visual e registro de origem. A arte oficial permanece fora da
LPPL.

## Problemas comuns

- classe ausente: compile pelo `Makefile` ou confira `TEXINPUTS`;
- fontes ausentes: instale Montserrat e Open Sans e limpe o cache;
- primeira compilação lenta: o LuaTeX está criando o cache de fontes;
- marca aparentemente pequena: `width` não inclui a área protegida; e
- PDF desatualizado: execute `make clean` e compile novamente.

Antes de concluir uma mudança, execute `make all`, revise o resultado visual e
confirme `MANIFEST.md`, compatibilidade e licenciamento.
