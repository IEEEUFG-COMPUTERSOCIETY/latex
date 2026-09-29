# IEEE UFG Computer Society LaTeX

Recursos de identidade visual e modelos reutilizáveis em LaTeX para o Capítulo
Estudantil da IEEE Computer Society na UFG.

O projeto fornece a classe `ieeeufgcs` para documentos institucionais e o
pacote de baixo nível `ieeeufgcs-brand` para uso da identidade visual em
outros formatos. Esses componentes incluem:

- as paletas oficiais do IEEE, da IEEE Computer Society e da UFG;
- seletores para títulos em Montserrat e corpo de texto em Open Sans;
- comandos para inserir as marcas oficiais da Computer Society, do IEEE e da
  UFG, respeitando suas áreas de proteção; e
- modos de saída RGB (padrão) e CMYK.

## Início rápido

```tex
\documentclass{ieeeufgcs}

\IEEECSSetup{
  document-type={Documento interno},
  title={Título do documento},
  subtitle={Subtítulo opcional},
  running-title={Título abreviado},
  institution={Capítulo Estudantil da IEEE Computer Society na UFG},
  author={Nome da pessoa autora},
  date={\today}
}

\begin{document}
\maketitle
\section{Introdução}
Conteúdo do documento.
\end{document}
```

Por padrão, a classe usa papel A4, corpo de 11 pt e páginas frente e verso. As
margens medem 27 mm no lado interno, 22 mm no externo, 24 mm no topo e 28 mm na
base. O deslocamento adicional de encadernação é `0mm`. A classe espelha as
margens internas e externas automaticamente em páginas pares e ímpares.

As opções públicas são `paper-size=a4|letter`, `font-size=10pt|11pt|12pt`,
`two-sided=true|false`, `inner-margin`, `outer-margin`, `top-margin`,
`bottom-margin`, `binding-offset`, `title-page=true|false`,
`section-numbering=plain|two-digit` e `color-model=rgb|cmyk`.

A classe não determina o propósito do conteúdo. Planos de trabalho, atas,
decisões, relatórios e materiais futuros usam a mesma definição institucional.
Cada diretório em `templates/` fornece apenas a estrutura inicial adequada ao
tipo de documento.

Para usar somente os elementos visuais em outra classe, carregue o pacote
diretamente:

```tex
\usepackage{ieeeufgcs-brand}

\color{IEEECSOrange}
{\IEEECSHeadingFont Um título da Computer Society}

\IEEECSLogo[variant=orange,width=45mm]
\IEEEMasterBrand[variant=blue,width=55mm,clear-space=print]
\UFGLogo[width=24mm]
```

`\UFGLogo` usa por padrão a assinatura vertical completa, azul, com área de
proteção. As opções são `orientation=vertical|horizontal`,
`variant=blue|black|white`, `width=<dimensão>` e
`clear-space=true|false`. A opção `clear-space=false` deve ser usada somente
quando o leiaute ao redor já garantir a área de proteção oficial.

Use `\usepackage[color-model=cmyk]{ieeeufgcs-brand}` para obter definições
CMYK destinadas à impressão. Use a opção `fonts=false` quando a classe do
documento já for responsável pela seleção das fontes.

O primeiro exemplo completo é o
[`modelo de plano de trabalho`](templates/work-plan/main.tex). Compile os
testes, a folha de referência e o modelo com:

```sh
make test
make docs
make templates
```

LuaLaTeX é o motor de composição do projeto. O Makefile executa
`latexmk -lualatex` e mantém o cache de fontes gerado em `build/`. Montserrat e
Open Sans devem estar instaladas e acessíveis ao LuaLaTeX.

A justificativa das decisões e a lista completa de tokens estão em
[`docs/brand-foundation.md`](docs/brand-foundation.md). Os manuais de identidade
e arquivos de arte originais permanecem fora deste repositório, no diretório
pai. O pacote contém cópias normalizadas em PDF dos arquivos de produção
fornecidos.

O projeto impõe o limite de 80 caracteres por linha nos arquivos-fonte. Use
`make check-style` para verificar essa regra antes de enviar alterações.

## Licença

Copyright (C) 2026 IEEE UFG Computer Society contributors.

Os arquivos produzidos pelo projeto e relacionados em
[`MANIFEST.md`](MANIFEST.md) são distribuídos sob a LaTeX Project Public
License, versão 1.3c ou, à sua escolha, qualquer versão posterior. O trabalho
tem o status LPPL `maintained` e seu mantenedor atual é a IEEE UFG Computer
Society. Consulte [`LICENSE`](LICENSE) para conhecer os termos completos.

Os arquivos oficiais de arte do IEEE, da IEEE Computer Society e da UFG não
fazem parte do trabalho licenciado sob a LPPL. A licença do repositório não
concede permissão para usar seus nomes, marcas ou logotipos.
