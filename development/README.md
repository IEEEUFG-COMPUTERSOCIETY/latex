<!--
Copyright (C) 2026 IEEE UFG Computer Society contributors.
Distributed and/or modified under the LaTeX Project Public License,
version 1.3c or later. This work has LPPL status `maintained`; the Current
Maintainer is the IEEE UFG Computer Society. See LICENSE and MANIFEST.md.
-->

# Guia de desenvolvimento

Este guia de desenvolvimento explica como o projeto funciona por dentro e
como modificá-lo sem
misturar conteúdo, apresentação, identidade visual e automação. Ele foi
escrito para quem está começando a desenvolver classes e pacotes LaTeX, mas
também funciona como referência da API pública do projeto.

Para apenas criar um documento, não é necessário conhecer estes detalhes. Use
`make new`, edite o `main.tex` criado em `documents/` e execute `make build`.

## 1. Modelo mental

O projeto possui quatro camadas. Cada camada responde a uma pergunta
diferente:

```text
documento local
    usa um modelo e contém o texto de uma entrega específica
        ↓
modelo
    sugere a estrutura de conteúdo para um tipo de documento
        ↓
classe ieeeufgcs
    define página, capa, cabeçalhos e componentes institucionais
        ↓
pacote ieeeufgcs-brand
    fornece cores, fontes, marcas e suas regras de proteção
```

Essa separação evita três problemas comuns:

- copiar toda a configuração visual para cada documento;
- incorporar conteúdo de um plano de trabalho na classe genérica; e
- redesenhar ou alterar acidentalmente uma marca oficial.

Um documento escolhe uma classe com `\documentclass`. Uma classe estabelece a
estrutura geral do documento e pode carregar vários pacotes. Um pacote
adiciona uma capacidade específica, mas não decide sozinho a estrutura de
todo o documento.

Neste projeto:

- `ieeeufgcs.cls` é a classe institucional;
- `ieeeufgcs-brand.sty` é o pacote de identidade visual;
- `templates/` contém pontos de partida para tipos de documento; e
- `documents/` contém trabalhos locais criados a partir desses modelos.

## 2. Mapa do repositório

| Caminho | Responsabilidade |
|---|---|
| `tex/latex/ieeeufgcs/ieeeufgcs.cls` | Classe institucional pública. |
| `tex/latex/ieeeufgcs/ieeeufgcs-brand.sty` | Cores, fontes e marcas. |
| `tex/latex/ieeeufgcs/assets/` | Cópias normalizadas da arte oficial. |
| `templates/` | Modelos canônicos de conteúdo. |
| `templates/catalog.tsv` | Catálogo lido pelo assistente. |
| `documents/` | Documentos locais; não pertence ao controle de versão. |
| `scripts/document.sh` | Criação, seleção, compilação e limpeza. |
| `scripts/check-line-length.lua` | Verificação do limite de 80 caracteres. |
| `tests/smoke/` | Testes rápidos das APIs e dos leiautes principais. |
| `tests/reference/` | Referência visual compilável da identidade. |
| `build/` | PDFs, arquivos auxiliares e cache; é descartável. |
| `example/` | Material externo usado como evidência de projeto. |
| `MANIFEST.md` | Relação normativa dos arquivos cobertos pela LPPL. |

Os diretórios `build/`, `documents/` e `example/` têm funções diferentes:

- `build/` pode ser apagado sem perda de fontes;
- `documents/` contém trabalho do usuário e nunca é removido por `make clean`;
- `example/` contém referências, não componentes públicos do projeto.

## 3. Como uma compilação encontra a classe

Uma instalação global em uma árvore TeX não é necessária durante o
desenvolvimento. O `Makefile` e `scripts/document.sh` acrescentam
`tex/latex//` à variável `TEXINPUTS`. Os dois caracteres `/` no final pedem
uma busca recursiva.

O fluxo de uma compilação é:

1. `latexmk` inicia o LuaLaTeX;
2. `TEXINPUTS` permite localizar `ieeeufgcs.cls` e o pacote de marca;
3. a classe processa suas opções antes de carregar `article`;
4. a classe repassa `color-model` ao pacote de marca;
5. o pacote localiza a arte PDF pelo mesmo caminho de busca; e
6. `latexmk` repete a compilação enquanto referências estiverem mudando.

`TEXMFVAR` aponta para `build/texmf-var`. Assim, o cache de fontes do LuaTeX
fica dentro do projeto, em vez de depender de uma pasta gravável do sistema.

## 4. Classe `ieeeufgcs`

### 4.1 Responsabilidade

A classe é destinada a documentos institucionais genéricos. Ela não é uma
classe para artigos científicos e não contém regras específicas de atas,
relatórios ou planos de trabalho. Essas diferenças pertencem aos modelos.

Internamente, ela usa `article` como base e acrescenta:

- margens semânticas internas e externas;
- capa completa ou título compacto;
- identidade tipográfica e cromática;
- cabeçalhos correntes e números de página externos;
- títulos de seção institucionais;
- tabelas com identidade visual; e
- avisos destacados.

### 4.2 Exemplo mínimo

```tex
\documentclass{ieeeufgcs}

\IEEECSSetup{
  document-type={Relatório},
  title={Relatório do projeto},
  author={Equipe responsável},
  date={\today}
}

\begin{document}
\maketitle
\section{Introdução}
Conteúdo do relatório.
\end{document}
```

O motor deve ser LuaLaTeX. A própria classe encerra a compilação com uma
mensagem de erro se for carregada por pdfLaTeX ou XeLaTeX.

### 4.3 Opções da classe

As opções são informadas entre colchetes em `\documentclass`.

| Opção | Padrão | Valores ou unidade | Efeito |
|---|---:|---|---|
| `paper-size` | `a4` | `a4`, `letter` | Tamanho do papel. |
| `font-size` | `11pt` | `10pt`, `11pt`, `12pt` | Corpo base. |
| `two-sided` | `true` | `true`, `false` | Páginas espelhadas. |
| `title-page` | `true` | `true`, `false` | Capa ou título compacto. |
| `section-numbering` | `plain` | `plain`, `two-digit` | Formato da seção. |
| `inner-margin` | `27mm` | dimensão TeX | Margem junto à encadernação. |
| `outer-margin` | `22mm` | dimensão TeX | Margem externa. |
| `top-margin` | `24mm` | dimensão TeX | Margem superior. |
| `bottom-margin` | `28mm` | dimensão TeX | Margem inferior. |
| `binding-offset` | `0mm` | dimensão TeX | Reserva para encadernação. |
| `color-model` | `rgb` | `rgb`, `cmyk` | Modelo das cores públicas. |

Uma dimensão TeX combina número e unidade, como `25mm`, `2.5cm` ou `1in`.
Use margens internas e externas em vez de esquerda e direita: em impressão
frente e verso, o lado interno muda entre páginas ímpares e pares.

Exemplo com opções:

```tex
\documentclass[
  paper-size=a4,
  font-size=12pt,
  two-sided=false,
  title-page=false,
  section-numbering=two-digit,
  color-model=cmyk
]{ieeeufgcs}
```

Opções desconhecidas pela classe são encaminhadas para `article`. Isso mantém
compatibilidade com opções legítimas da classe-base, mas erros de digitação
podem aparecer como erros de `article`, e não de `ieeeufgcs`.

### 4.4 Metadados

`\IEEECSSetup` recebe uma lista `chave={valor}`. Chaves com textos que contêm
vírgulas devem sempre usar chaves ao redor do valor.

| Chave | Onde aparece |
|---|---|
| `document-type` | Rótulo acima do título. |
| `title` | Título principal e fallback do cabeçalho. |
| `subtitle` | Subtítulo da capa ou do título compacto. |
| `running-title` | Cabeçalho das páginas internas. |
| `institution` | Bloco institucional da capa. |
| `unit` | Unidade abaixo da instituição. |
| `author` | Autoria ou equipe responsável. |
| `date` | Data do documento. |
| `location` | Local indicado na capa. |
| `identifier` | Versão ou código no rodapé da capa. |

`title`, `author` e `date` alimentam os comandos padrão `\title`, `\author` e
`\date`. Portanto, pacotes que consultam esses metadados continuam
funcionando. Quando `running-title` fica vazio, a classe usa `title`.

Os campos opcionais podem ser omitidos. A capa testa cada um antes de criar o
respectivo bloco, evitando espaços destinados a conteúdo inexistente.

### 4.5 Capa e título compacto

Com `title-page=true`, `\maketitle` cria uma página independente. A faixa
superior, os logotipos, o título e os metadados são construídos pela própria
classe. Depois da capa, a contagem recomeça em 1.

Com `title-page=false`, `\maketitle` produz um bloco compacto no início da
página atual. Esse formato é adequado para registros curtos e documentos que
não justificam uma folha exclusiva.

Nos dois casos, o usuário chama somente `\maketitle`. A decisão de leiaute
pertence à opção da classe.

### 4.6 Cabeçalhos e numeração

O estilo de página `ieeeufgcs` é instalado como padrão:

- em frente e verso, o título corrente e o nome institucional alternam lados;
- em uma face, cada informação ocupa um lado fixo; e
- o número fica sempre na borda externa.

`section-numbering=two-digit` transforma `1`, `2` e `3` em `01`, `02` e `03`.
A mudança atinge apenas a representação das seções. Subseções preservam a
estrutura normal baseada no número da seção.

### 4.7 Componentes de conteúdo

#### Célula de cabeçalho

`\IEEECSHeaderCell{Texto}` aplica fundo azul, texto branco e negrito. Ela foi
feita para uso dentro de uma tabela institucional.

#### Tabela institucional

`IEEECSBrandedTable` recebe a especificação de colunas de `tabularx`:

```tex
\begin{IEEECSBrandedTable}{p{0.30\linewidth}X}
\IEEECSHeaderCell{Item} & \IEEECSHeaderCell{Descrição} \\
Prazo & Entrega prevista para dezembro. \\
Responsável & Equipe de projetos. \\
\end{IEEECSBrandedTable}
```

A coluna `X` ocupa o espaço restante. Colunas `p{...}` têm largura fixa e
quebram linhas. O ambiente ocupa `\linewidth`, aumenta o espaçamento vertical
das células e alterna linhas azul-claro e brancas.

O ambiente não cria automaticamente o cabeçalho porque tabelas diferentes
podem ter quantidades e tipos de coluna diferentes.

#### Aviso institucional

`IEEECSNotice` cria um bloco delimitado por linhas azuis. O argumento opcional
é o título:

```tex
\begin{IEEECSNotice}[Atenção]
Este prazo depende da aprovação do orçamento.
\end{IEEECSNotice}
```

Sem o argumento opcional, apenas o corpo e as linhas são exibidos.

## 5. Pacote `ieeeufgcs-brand`

### 5.1 Quando usar diretamente

A classe já carrega o pacote. Carregue-o diretamente somente quando outra
classe precisar das cores, fontes ou marcas:

```tex
\documentclass{article}
\usepackage{ieeeufgcs-brand}
```

O pacote também exige LuaLaTeX.

### 5.2 Opções do pacote

| Opção | Padrão | Efeito |
|---|---:|---|
| `color-model=rgb` | sim | Define cores para tela. |
| `color-model=cmyk` | não | Define cores para produção gráfica. |
| `fonts=true` | sim | Carrega Montserrat e Open Sans. |
| `fonts=false` | não | Usa seletores genéricos de fallback. |

As opções antigas `rgb`, `cmyk` e `nofonts` ainda funcionam, mas emitem um
aviso de obsolescência. Código novo deve usar as formas com chave e valor.

`fonts=false` é útil quando a classe hospedeira já controla as fontes. Nesse
modo, `\IEEECSHeadingFont` usa `\sffamily` e `\IEEECSBodyFont` usa
`\rmfamily`. Isso preserva a API, mas não reproduz a tipografia oficial.

### 5.3 Fontes

O pacote oferece dois seletores:

- `\IEEECSHeadingFont`: Montserrat para títulos e destaques; e
- `\IEEECSBodyFont`: Open Sans para texto longo.

Eles são seletores, não comandos com argumento. Limite seu efeito com um
grupo:

```tex
{
  \IEEECSHeadingFont
  \bfseries
  Título em Montserrat
}
```

A classe usa Open Sans como fonte principal com `\setmainfont{OpenSans}`. O
pacote declara variantes leves, seminegritas e extranegritas quando os
arquivos correspondentes estão instalados.

### 5.4 Cores

Os nomes públicos podem ser usados em qualquer comando de `xcolor`, como
`\color`, `\textcolor` e `\colorbox`.

| Papel | Nome público | RGB hexadecimal |
|---|---|---:|
| Primária da CS | `IEEECSOrange` | `#FFA300` |
| Azul IEEE | `IEEEBlue` | `#00629B` |
| Azul UFG | `UFGBlue` | `#0067AC` |
| Ciano | `IEEECyan` | `#00B5E2` |
| Cinza | `IEEEGray` | `#75787B` |
| Vermelho | `IEEERed` | `#BA0C2F` |
| Amarelo | `IEEEYellow` | `#FFD100` |
| Verde claro | `IEEEBrightGreen` | `#78BE20` |
| Verde | `IEEEGreen` | `#00843D` |
| Roxo | `IEEEPurple` | `#981D97` |
| Azul-petróleo | `IEEETeal` | `#009CA6` |
| Vermelho escuro | `IEEEDarkRed` | `#862041` |
| Laranja escuro | `IEEEDarkOrange` | `#E87722` |
| Amarelo escuro | `IEEEDarkYellow` | `#FFC72C` |
| Verde-oliva | `IEEEOliveGreen` | `#658D1B` |
| Verde escuro | `IEEEDarkGreen` | `#006341` |
| Roxo escuro | `IEEEDarkPurple` | `#772583` |
| Azul-petróleo escuro | `IEEEDarkTeal` | `#007377` |
| Azul escuro | `IEEEDarkBlue` | `#002855` |
| Preto | `IEEEBlack` | `#000000` |
| Branco | `IEEEWhite` | `#FFFFFF` |

Os aliases semânticos são `IEEECSPrimary`, `IEEECSSecondary` e
`IEEECSBodyText`. Eles expressam função, enquanto os demais nomes expressam a
cor exata. Prefira um alias quando o significado for mais importante que a
cor atual.

Cada cor IEEE, exceto preto e branco, possui os sufixos `Eighty`, `Sixty`,
`Forty` e `Twenty`. Por exemplo, `IEEEBlueTwenty` mistura 20% de azul com
branco. Não existem variações de `UFGBlue`, pois a cor da UFG não deve ser
alterada.

### 5.5 Marca da IEEE Computer Society

```tex
\IEEECSLogo[
  variant=orange,
  width=45mm,
  clear-space=true
]
```

| Chave | Padrão | Valores |
|---|---:|---|
| `variant` | `orange` | `orange`, `black`, `white`, `orange-white` |
| `width` | `45mm` | dimensão TeX |
| `clear-space` | `true` | `true`, `false` |

Com `clear-space=true`, o comando acrescenta em todos os lados uma distância
igual a 30% da altura da arte. A largura informada pertence à arte, não à
caixa final que inclui a área de proteção.

### 5.6 Marca principal IEEE

```tex
\IEEEMasterBrand[
  variant=blue,
  width=55mm,
  clear-space=print
]
```

| Chave | Padrão | Valores |
|---|---:|---|
| `variant` | `blue` | `blue`, `black`, `white` |
| `width` | `55mm` | dimensão TeX |
| `clear-space` | `print` | `print`, `digital`, `none` |

`print` reserva uma altura da arte em cada lado. `digital` reserva meia
altura. `none` não acrescenta espaço e só deve ser usado quando o leiaute
externo já garante a área exigida.

### 5.7 Marca da UFG

```tex
\UFGLogo[
  orientation=vertical,
  variant=blue,
  width=24mm,
  clear-space=true
]
```

| Chave | Padrão | Valores |
|---|---:|---|
| `orientation` | `vertical` | `vertical`, `horizontal` |
| `variant` | `blue` | `blue`, `black`, `white` |
| `width` | `24mm` | dimensão TeX |
| `clear-space` | `true` | `true`, `false` |

A área protegida é calculada a partir do módulo geométrico da própria arte:
três módulos nas laterais e dois acima e abaixo. A assinatura vertical tem
preferência. A horizontal deve ser usada quando a composição exigir uma forma
mais larga.

O pacote avisa quando a largura fica abaixo do mínimo oficial:

- `24.5mm` para a assinatura horizontal com nome completo; e
- `12mm` para a assinatura vertical com nome completo.

### 5.8 Regras que o código não consegue impor

O pacote controla arquivo, proporção, tamanho e área de proteção. Ele não
consegue avaliar todo o contexto visual. A pessoa responsável ainda deve:

- usar variantes brancas somente sobre fundos adequadamente escuros;
- manter contraste suficiente para textos e elementos gráficos;
- evitar fundos visualmente ruidosos;
- não girar, cortar, distorcer, recolorir ou reconstruir as marcas; e
- confirmar permissões de uso das marcas oficiais.

## 6. Como a implementação LaTeX está organizada

### 6.1 LaTeX2e e `expl3`

Os arquivos combinam duas interfaces:

- LaTeX2e para classe, pacotes, títulos, estilos de página e compatibilidade;
- `expl3` para chaves, listas de tokens, booleanos, dimensões e mensagens.

Nomes como `\l__ieeecs_class_paper_tl` seguem a convenção de `expl3`:

- `l` indica uma variável local;
- `ieeecs` é o módulo;
- `class_paper` descreve a finalidade; e
- `tl` indica uma lista de tokens.

Outros sufixos usados são `bool` para booleano, `dim` para dimensão e `box`
para caixa. Funções internas terminam com a assinatura dos argumentos, como
`:n` para um argumento não expandido.

Comandos contendo `@` pertencem à implementação LaTeX2e. Por isso, o trecho
que manipula `\@title` e outros nomes internos fica entre `\makeatletter` e
`\makeatother`.

### 6.2 Dependências e suas funções

A classe e o pacote carregam dependências pequenas e especializadas:

| Pacote | Motivo |
|---|---|
| `iftex` | Exigir o motor LuaLaTeX. |
| `geometry` | Aplicar margens semânticas e encadernação. |
| `fancyhdr` | Construir cabeçalhos e rodapés. |
| `tikz` | Desenhar o fundo vetorial da capa. |
| `array` | Oferecer tipos e modificadores de coluna. |
| `tabularx` | Criar tabelas que ocupam a largura disponível. |
| `colortbl` | Colorir células e alternar fundos das linhas. |
| `xcolor` | Declarar e aplicar as cores institucionais. |
| `graphicx` | Carregar a arte oficial em PDF. |
| `fontspec` | Selecionar Montserrat e Open Sans. |

Não carregue uma dependência nova apenas para abreviar poucas linhas. Uma
dependência passa a fazer parte do ambiente exigido de todos os documentos.

### 6.3 Ordem de inicialização da classe

A ordem do arquivo `.cls` é importante:

1. declarar a versão mínima do formato e identificar a classe;
2. exigir LuaLaTeX;
3. declarar variáveis e instalar valores padrão;
4. processar as opções públicas;
5. encaminhar papel, fonte e lateralidade para `article`;
6. carregar `article` e os pacotes estruturais;
7. configurar `geometry` e o pacote de marca;
8. declarar metadados e `\maketitle`;
9. configurar títulos e páginas; e
10. declarar os componentes públicos de conteúdo.

Papel, tamanho base e modo frente e verso precisam ser conhecidos antes de
`\LoadClass{article}`. Já `geometry` só pode ser configurado depois que a
classe-base existe.

### 6.4 Estado interno e API pública

Variáveis com `__ieeecs` ou comandos com `\ieeecs@` são internos. Documentos
não devem depender deles. A API pública é composta por:

- opções documentadas da classe e do pacote;
- `\IEEECSSetup`;
- `\IEEECSHeadingFont` e `\IEEECSBodyFont`;
- `\IEEECSLogo`, `\IEEEMasterBrand` e `\UFGLogo`;
- `\IEEECSHeaderCell`;
- `IEEECSBrandedTable`; e
- `IEEECSNotice`.

Essa fronteira permite reorganizar a implementação sem quebrar documentos.

### 6.5 Escopo dos comandos de marca

Cada comando de marca começa um grupo, instala seus padrões, aplica as opções
do usuário, monta a caixa e encerra o grupo. Assim, uma chamada não vaza seu
arquivo, largura ou variante para a próxima.

O fluxo interno é:

```text
valores padrão
    → chaves fornecidas pelo usuário
    → seleção do arquivo PDF
    → medição da caixa da arte
    → cálculo da área protegida
    → composição da caixa final
```

Para a UFG, a área de proteção depende da largura escolhida. Para as marcas
IEEE, ela depende da altura medida depois que a arte é carregada.

## 7. Modelos e documentos locais

Um modelo contém a estrutura recomendada, exemplos de componentes e
orientações de edição. Ele não deve conter fatos de um evento ou gestão
específicos.

`make new` copia o diretório completo do modelo. Depois da cópia, o documento
local é independente: mudar o modelo não altera documentos já criados.

### 7.1 Criar um modelo

1. Crie `templates/<identificador>/main.tex`.
2. Adicione `templates/<identificador>/references.bib.example`.
3. Inclua `templates/<identificador>/img/README.md` se imagens forem úteis.
4. Cadastre o modelo em `templates/catalog.tsv`.
5. Adicione os arquivos autorais a `MANIFEST.md`.
6. Inclua uma compilação canônica no alvo `templates` do `Makefile`.
7. Execute `make all`.

Cada linha ativa do catálogo possui três campos separados por `|`:

```text
identificador|Nome exibido|Descrição curta.
```

O identificador deve ser igual ao nome do diretório. O formato não possui
escape para `|`; portanto, esse caractere não pode aparecer nos campos.

### 7.2 Projetar um bom modelo

Um modelo deve:

- explicar quais valores o autor precisa substituir;
- oferecer uma estrutura útil sem fingir conhecer o conteúdo final;
- demonstrar componentes menos óbvios da classe;
- manter bibliografia opcional e desativada por padrão; e
- compilar antes de qualquer edição.

Evite criar um novo comando na classe para um detalhe usado por apenas um
tipo de documento. Primeiro mantenha esse detalhe no modelo. Ele só deve subir
para a classe quando tiver significado institucional reutilizável.

## 8. Assistente de documentos

`scripts/document.sh` usa `set -euo pipefail`: um comando com erro, uma
variável não definida ou uma falha em um pipeline encerra a execução.

As ações públicas são:

| Ação | Operação |
|---|---|
| `new` | Seleciona um modelo, copia-o e oferece compilação. |
| `build` | Seleciona e compila um documento local. |
| `list` | Lista modelos e documentos locais. |
| `clean` | Remove apenas o conteúdo de `build/`. |

O `Makefile` fornece uma interface mais amigável para essas ações.

Identificadores são validados pela expressão
`^[[:alnum:]][[:alnum:]_-]*$`. Eles devem começar com letra ou número e podem
continuar com letras, números, hífen ou sublinhado. Essa restrição impede que
um identificador seja interpretado como caminho arbitrário.

`clean` recusa um `build/` que seja link simbólico. Em seguida, usa `find` com
profundidade mínima 1, preservando o diretório e apagando somente seus
descendentes. O script nunca remove `documents/`.

## 9. Makefile e comandos de desenvolvimento

| Comando | Resultado |
|---|---|
| `make` | Mostra a ajuda. |
| `make new` | Inicia o assistente de criação. |
| `make build` | Compila um documento local. |
| `make list` | Lista modelos e documentos. |
| `make check-style` | Verifica o limite de 80 caracteres. |
| `make test` | Executa estilo e testes de fumaça. |
| `make reference` | Compila a referência visual. |
| `make templates` | Compila todos os modelos canônicos. |
| `make all` | Executa testes, referência e modelos. |
| `make clean` | Limpa produtos gerados. |

Para automação sem perguntas interativas:

```sh
make new TEMPLATE=plano-trabalho NAME=plano-2027 BUILD=no
make build NAME=plano-2027
```

`LATEXMK` pode selecionar outro executável compatível. `TEXMFVAR_DIR` pode
selecionar outro diretório de cache. Essas substituições são principalmente
úteis em integração contínua.

## 10. Estratégia de testes

Os testes de fumaça respondem a perguntas diferentes:

| Arquivo | O que verifica |
|---|---|
| `brand.tex` | Fontes, cores e todas as famílias de marca. |
| `cmyk.tex` | CMYK, `fonts=false` e variantes pretas. |
| `document.tex` | Capa, margens, páginas, tabelas e avisos. |
| `compact.tex` | Título compacto e documento de uma face. |

`tests/reference/brand-reference.tex` não é apenas um teste de compilação. Seu
PDF serve para inspeção humana das cores, fontes, variantes e áreas de
proteção.

Os testes comprovam que os exemplos compilam. Eles não comprovam sozinhos:

- fidelidade visual em todos os visualizadores e processos de impressão;
- conformidade legal de um uso concreto de marca;
- contraste de qualquer combinação criada pelo autor; ou
- qualidade editorial do conteúdo de um documento.

Depois de uma alteração visual, compile `make all` e também abra os PDFs em
`build/tests/`, `build/reference/` e `build/templates/`.

## 11. Receitas de extensão

### 11.1 Adicionar uma opção à classe

1. Declare uma variável interna com o tipo adequado.
2. Defina um padrão explícito perto dos demais padrões.
3. Registre a chave em `\DeclareKeys[ieeeufgcs]`.
4. Aplique o valor no ponto correto do ciclo de carregamento.
5. Adicione a opção a este guia e ao modelo canônico, se apropriado.
6. Crie um teste que exercite um valor não padrão.

Uma opção que afeta `article` deve ser resolvida antes de
`\LoadClass{article}`. Uma opção que afeta apenas um componente posterior pode
ser aplicada depois.

### 11.2 Adicionar um metadado

1. Crie o armazenamento interno vazio.
2. Adicione uma chave em `ieeeufgcs / metadata`.
3. Decida em qual leiaute o campo aparece.
4. Teste o campo presente e ausente.
5. Documente seu significado, não apenas sua posição visual.

Campos opcionais devem evitar espaço residual quando estão vazios.

### 11.3 Adicionar um componente reutilizável

Antes de alterar a classe, confirme que o componente:

- aparece em mais de um tipo de documento;
- possui significado institucional estável;
- pode ter uma interface pequena e previsível; e
- não duplica um ambiente LaTeX já adequado.

Nomeie interfaces públicas com o prefixo `IEEECS`. Mantenha auxiliares
internos no módulo `ieeecs` e não os use nos modelos.

### 11.4 Adicionar uma cor

1. Confirme a cor em uma fonte oficial aplicável.
2. Registre valores RGB e CMYK em `ieeeufgcs-brand.sty`.
3. Decida se variações de tonalidade são permitidas.
4. Acrescente uma amostra à referência visual.
5. Exercite a cor nos modos RGB e CMYK.
6. Documente a origem e a função da cor.

Não calcule um valor CMYK apenas por conveniência se o manual fornecer um
valor de produção oficial.

### 11.5 Adicionar arte oficial

1. Obtenha o arquivo aprovado e preserve uma referência à origem.
2. Normalize o formato sem redesenhar, recolorir ou recompor a marca.
3. Use um nome estável, minúsculo e sem espaços.
4. Documente a origem em `assets/README.md`.
5. Adicione o arquivo à seção de arte excluída em `MANIFEST.md`.
6. Implemente a variante sem alterar os padrões existentes.
7. Adicione testes e uma amostra à referência visual.

A arte oficial é distribuída ao lado do trabalho, mas não recebe a licença
LPPL. Essa diferença deve permanecer explícita.

## 12. Estilo e manutenção

Arquivos-fonte têm limite de 80 caracteres por linha. O verificador conta
caracteres UTF-8, não bytes, de modo que letras acentuadas contam como um
caractere.

Ao alterar uma interface pública:

- preserve o comportamento existente quando possível;
- ofereça aviso de obsolescência antes de remover uma forma antiga;
- atualize exemplos, testes e documentação no mesmo conjunto de mudanças; e
- atualize a versão declarada em `\ProvidesClass` ou `\ProvidesPackage`.

Comentários devem explicar decisões e restrições. O código já mostra que uma
variável recebe um valor; o comentário deve explicar por que aquele valor ou
aquela ordem é necessária.

Todo novo arquivo autoral distribuído como parte do projeto precisa:

- do aviso de direitos autorais apropriado;
- de uma entrada em `MANIFEST.md`; e
- de linhas com no máximo 80 caracteres.

## 13. Solução de problemas

### A classe ou o pacote não foi encontrado

Compile por meio do `Makefile` ou confirme que `TEXINPUTS` contém
`tex/latex//:`. O sinal `:` final mantém os caminhos padrão da distribuição
TeX.

### Montserrat ou Open Sans não foi encontrada

Instale as fontes como OpenType ou TrueType em um local visível ao sistema e
ao LuaLaTeX. Depois, remova `build/texmf-var` ou execute `make clean` para
forçar a reconstrução do cache.

### A primeira compilação é lenta

O LuaTeX pode estar criando seu banco e cache de fontes. Compilações seguintes
reutilizam `build/texmf-var` e normalmente são mais rápidas.

### A marca parece pequena apesar da largura informada

`width` mede somente a arte. A caixa ocupada também inclui a área de proteção.
Não desative essa área apenas para fazer a marca caber; primeiro ajuste o
leiaute ao redor.

### O PDF continua desatualizado

Execute `make clean` e compile novamente. O comando remove apenas produtos em
`build/`, não o documento-fonte.

### `make check-style` acusa um arquivo local

A verificação percorre as fontes da infraestrutura. Os diretórios locais
`documents/`, `example/` e `build/` são ignorados pelo alvo de estilo.

## 14. Lista de verificação antes de concluir uma mudança

- A mudança está na camada correta?
- A API pública está documentada e possui valores padrão claros?
- O comportamento antigo continua funcionando ou avisa sobre obsolescência?
- Há um teste para o caminho novo e para pelo menos um caso alternativo?
- A referência visual foi conferida quando o resultado gráfico mudou?
- Todos os arquivos autorais constam em `MANIFEST.md`?
- A separação jurídica entre código e arte oficial foi preservada?
- `make all` termina sem erros?
