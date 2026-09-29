%% Generic IEEE UFG Computer Society document class.
%% Copyright (C) 2026 IEEE UFG Computer Society contributors.
%%
%% This work may be distributed and/or modified under the conditions of the
%% LaTeX Project Public License, either version 1.3c of this license or (at your
%% option) any later version. The latest version is available at
%% https://www.latex-project.org/lppl.txt.
%%
%% This work has the LPPL maintenance status `maintained'. The Current
%% Maintainer is the IEEE UFG Computer Society. The work consists of the files
%% listed in MANIFEST.md.
%%
%% The official artwork distributed beside this file is not part of the LPPL
%% work. See LICENSE and tex/latex/ieeeufgcs/assets/README.md.
%%
%% Implementation reference
%% ------------------------
%% This is a generic institutional document class, not an article-publication
%% format. Work plans, minutes, decisions, reports, and future promotional
%% formats are templates or profiles built on this shared identity layer. The
%% standard article class is only the internal structural foundation. The
%% official material retained in example/ is the evidence for design choices;
%% source files here contain the resulting implementation specification.
%%
%% The default is A4 at 11 pt with a two-sided mirrored text block. Inner,
%% outer, top, and bottom margins are 27, 22, 24, and 28 mm respectively. The
%% wider inner margin alternates on odd and even pages. Binding offset is zero
%% by policy and remains independently configurable for exceptional uses.
%% Open Sans is the body face and Montserrat is the heading face.
%%
%% The class supplies a full-page cover by default, an optional compact title,
%% text-only running heads, outer page numbers, branded tables, and notices.
%% Content-specific structures belong in templates, beginning with the work
%% plan distilled from recurring structures in example/ without copying its
%% text or artwork.
%%
%% Public class keys are paper-size, font-size, two-sided, title-page,
%% section-numbering, inner-margin, outer-margin, top-margin, bottom-margin,
%% binding-offset, and color-model. Unknown standard options are forwarded to
%% article. IEEECSSetup accepts title, subtitle, author, date, document-type,
%% institution, unit, location, identifier, and running-title. Standard title,
%% author, and date commands remain valid.
\NeedsTeXFormat{LaTeX2e}[2022-06-01]
\ProvidesClass{ieeeufgcs}
  [2026-09-29 v0.3 Generic IEEE UFG CS document class]

\RequirePackage{iftex}
\RequireLuaTeX

\newif\ifieeecs@titlepage
\newif\ifieeecs@twodigitsections

\ExplSyntaxOn
\tl_new:N \l__ieeecs_class_paper_tl
\tl_new:N \l__ieeecs_class_font_size_tl
\tl_new:N \l__ieeecs_class_color_model_tl
\tl_new:N \l__ieeecs_class_base_options_tl
\tl_new:N \l__ieeecs_class_geometry_options_tl
\bool_new:N \l__ieeecs_class_two_sided_bool
\bool_new:N \l__ieeecs_class_title_page_bool
\bool_new:N \l__ieeecs_class_two_digit_sections_bool
\dim_new:N \l__ieeecs_class_inner_margin_dim
\dim_new:N \l__ieeecs_class_outer_margin_dim
\dim_new:N \l__ieeecs_class_top_margin_dim
\dim_new:N \l__ieeecs_class_bottom_margin_dim
\dim_new:N \l__ieeecs_class_binding_offset_dim

\tl_set:Nn \l__ieeecs_class_paper_tl { a4paper }
\tl_set:Nn \l__ieeecs_class_font_size_tl { 11pt }
\tl_set:Nn \l__ieeecs_class_color_model_tl { rgb }
\bool_set_true:N \l__ieeecs_class_two_sided_bool
\bool_set_true:N \l__ieeecs_class_title_page_bool
\bool_set_false:N \l__ieeecs_class_two_digit_sections_bool
\dim_set:Nn \l__ieeecs_class_inner_margin_dim { 27mm }
\dim_set:Nn \l__ieeecs_class_outer_margin_dim { 22mm }
\dim_set:Nn \l__ieeecs_class_top_margin_dim { 24mm }
\dim_set:Nn \l__ieeecs_class_bottom_margin_dim { 28mm }
\dim_zero:N \l__ieeecs_class_binding_offset_dim

\DeclareKeys [ ieeeufgcs ]
  {
    paper-size .choice:,
    paper-size / a4 .code:n =
      { \tl_set:Nn \l__ieeecs_class_paper_tl { a4paper } },
    paper-size / letter .code:n =
      { \tl_set:Nn \l__ieeecs_class_paper_tl { letterpaper } },
    paper-size .usage = load,
    font-size .choice:,
    font-size / 10pt .code:n =
      { \tl_set:Nn \l__ieeecs_class_font_size_tl { 10pt } },
    font-size / 11pt .code:n =
      { \tl_set:Nn \l__ieeecs_class_font_size_tl { 11pt } },
    font-size / 12pt .code:n =
      { \tl_set:Nn \l__ieeecs_class_font_size_tl { 12pt } },
    font-size .usage = load,
    two-sided .bool_set:N = \l__ieeecs_class_two_sided_bool,
    two-sided .default:n = true,
    two-sided .usage = load,
    title-page .bool_set:N = \l__ieeecs_class_title_page_bool,
    title-page .default:n = true,
    title-page .usage = load,
    section-numbering .choice:,
    section-numbering / plain .code:n =
      { \bool_set_false:N \l__ieeecs_class_two_digit_sections_bool },
    section-numbering / two-digit .code:n =
      { \bool_set_true:N \l__ieeecs_class_two_digit_sections_bool },
    section-numbering .usage = load,
    inner-margin .dim_set:N = \l__ieeecs_class_inner_margin_dim,
    inner-margin .usage = load,
    outer-margin .dim_set:N = \l__ieeecs_class_outer_margin_dim,
    outer-margin .usage = load,
    top-margin .dim_set:N = \l__ieeecs_class_top_margin_dim,
    top-margin .usage = load,
    bottom-margin .dim_set:N = \l__ieeecs_class_bottom_margin_dim,
    bottom-margin .usage = load,
    binding-offset .dim_set:N = \l__ieeecs_class_binding_offset_dim,
    binding-offset .usage = load,
    color-model .choice:,
    color-model / rgb .code:n =
      { \tl_set:Nn \l__ieeecs_class_color_model_tl { rgb } },
    color-model / cmyk .code:n =
      { \tl_set:Nn \l__ieeecs_class_color_model_tl { cmyk } },
    color-model .usage = load,
  }

\DeclareUnknownKeyHandler [ ieeeufgcs ]
  { \PassOptionsToClass { \CurrentOption } { article } }
\ProcessKeyOptions [ ieeeufgcs ]

\bool_if:NTF \l__ieeecs_class_title_page_bool
  { \ieeecs@titlepagetrue }
  { \ieeecs@titlepagefalse }
\bool_if:NTF \l__ieeecs_class_two_digit_sections_bool
  { \ieeecs@twodigitsectionstrue }
  { \ieeecs@twodigitsectionsfalse }

\tl_set:Nx \l__ieeecs_class_base_options_tl
  {
    \l__ieeecs_class_paper_tl,
    \l__ieeecs_class_font_size_tl,
    \bool_if:NTF \l__ieeecs_class_two_sided_bool
      { twoside }
      { oneside }
  }
\exp_args:NV \PassOptionsToClass
  \l__ieeecs_class_base_options_tl { article }
\ExplSyntaxOff

\LoadClass{article}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{tikz}
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{colortbl}

\ExplSyntaxOn
\tl_set:Nx \l__ieeecs_class_geometry_options_tl
  {
    inner = \dim_use:N \l__ieeecs_class_inner_margin_dim,
    outer = \dim_use:N \l__ieeecs_class_outer_margin_dim,
    top = \dim_use:N \l__ieeecs_class_top_margin_dim,
    bottom = \dim_use:N \l__ieeecs_class_bottom_margin_dim,
    bindingoffset =
      \dim_use:N \l__ieeecs_class_binding_offset_dim,
    includeheadfoot,
    heightrounded,
    headheight = 14pt
  }
\exp_args:NV \geometry \l__ieeecs_class_geometry_options_tl

\exp_args:Nx \PassOptionsToPackage
  { color-model = \l__ieeecs_class_color_model_tl }
  { ieeeufgcs-brand }
\ExplSyntaxOff

\RequirePackage{ieeeufgcs-brand}
\setmainfont{OpenSans}

\makeatletter
\newcommand{\@ieeecs@documenttype}{}
\newcommand{\@ieeecs@subtitle}{}
\newcommand{\@ieeecs@institution}{}
\newcommand{\@ieeecs@unit}{}
\newcommand{\@ieeecs@location}{}
\newcommand{\@ieeecs@identifier}{}
\newcommand{\@ieeecs@runningtitle}{}

\ExplSyntaxOn
\keys_define:nn { ieeeufgcs / metadata }
  {
    title .code:n = { \title {#1} },
    subtitle .code:n = { \gdef \@ieeecs@subtitle {#1} },
    author .code:n = { \author {#1} },
    date .code:n = { \date {#1} },
    document-type .code:n = { \gdef \@ieeecs@documenttype {#1} },
    institution .code:n = { \gdef \@ieeecs@institution {#1} },
    unit .code:n = { \gdef \@ieeecs@unit {#1} },
    location .code:n = { \gdef \@ieeecs@location {#1} },
    identifier .code:n = { \gdef \@ieeecs@identifier {#1} },
    running-title .code:n = { \gdef \@ieeecs@runningtitle {#1} },
  }

\NewDocumentCommand \IEEECSSetup { m }
  { \keys_set:nn { ieeeufgcs / metadata } {#1} }
\ExplSyntaxOff

\AtBeginDocument{%
  \ifx\@ieeecs@runningtitle\@empty
    \global\let\@ieeecs@runningtitle\@title
  \fi
}

\newcommand{\ieeecs@coverbackground}{%
  \noindent
  \begin{tikzpicture}[remember picture,overlay]
    \fill[IEEEDarkBlue]
      (current page.north west)
      rectangle ([yshift=-112mm]current page.north east);
    \fill[IEEECSOrange]
      ([yshift=-112mm]current page.north west)
      rectangle ([yshift=-115mm]current page.north east);
    \draw[IEEECyan,line width=0.6pt]
      ([xshift=-92mm,yshift=-72mm]current page.north east)
      -- ([xshift=-18mm,yshift=-72mm]current page.north east)
      -- ([xshift=-18mm,yshift=-102mm]current page.north east);
    \draw[IEEEBlueTwenty,line width=0.6pt]
      ([xshift=-72mm,yshift=-78mm]current page.north east)
      -- ([xshift=-34mm,yshift=-100mm]current page.north east)
      -- ([xshift=-34mm,yshift=-106mm]current page.north east);
    \fill[IEEECyan]
      ([xshift=-18mm,yshift=-72mm]current page.north east)
      circle[radius=1.2mm];
    \fill[IEEECSOrange]
      ([xshift=-34mm,yshift=-100mm]current page.north east)
      circle[radius=1.2mm];
  \end{tikzpicture}\par
}

\newcommand{\ieeecs@maketitlepage}{%
  \begin{titlepage}
    \thispagestyle{empty}%
    \ieeecs@coverbackground
    \noindent
    \begin{minipage}[t][76mm][t]{\linewidth}
      \color{IEEEWhite}%
      \noindent
      \IEEECSLogo[
        variant=orange-white,
        width=48mm,
        clear-space=false
      ]%
      \hfill
      \UFGLogo[
        orientation=horizontal,
        variant=white,
        width=28.5mm,
        clear-space=false
      ]\par
      \vspace{14mm}
      \ifx\@ieeecs@documenttype\@empty\else
        {\IEEECSHeadingFont\bfseries\large
          \MakeUppercase{\@ieeecs@documenttype}\par}
        \smallskip
      \fi
      {\IEEECSHeadingFont\bfseries\Huge\@title\par}
    \end{minipage}
    \vspace{30mm}
    \ifx\@ieeecs@subtitle\@empty\else
      {\IEEECSHeadingFont\Large\color{IEEEBlue}
        \@ieeecs@subtitle\par}
      \bigskip
    \fi
    {\large\@author\par}
    \ifx\@ieeecs@institution\@empty\else
      \smallskip
      {\@ieeecs@institution\par}
    \fi
    \ifx\@ieeecs@unit\@empty\else
      {\@ieeecs@unit\par}
    \fi
    \medskip
    {\@date\par}
    \ifx\@ieeecs@location\@empty\else
      {\@ieeecs@location\par}
    \fi
    \vfill
    \noindent
    \IEEEMasterBrand[
      variant=blue,
      width=44mm,
      clear-space=none
    ]%
    \ifx\@ieeecs@identifier\@empty\else
      \hfill
      {\small\@ieeecs@identifier}
    \fi
    \par
    \@thanks
  \end{titlepage}
  \setcounter{page}{1}%
}

\newcommand{\ieeecs@makecompacttitle}{%
  \thispagestyle{ieeeufgcs}%
  \ifx\@ieeecs@documenttype\@empty\else
    {\IEEECSHeadingFont\bfseries\color{IEEEBlue}
      \MakeUppercase{\@ieeecs@documenttype}\par}
    \smallskip
  \fi
  {\IEEECSHeadingFont\bfseries\color{IEEECSOrange}\huge
    \@title\par}
  \ifx\@ieeecs@subtitle\@empty\else
    \medskip
    {\IEEECSHeadingFont\Large\color{IEEEBlue}
      \@ieeecs@subtitle\par}
  \fi
  \medskip
  {\@author\hfill\@date\par}
  \bigskip
}

\RenewDocumentCommand{\maketitle}{}{%
  \ifieeecs@titlepage
    \ieeecs@maketitlepage
  \else
    \ieeecs@makecompacttitle
  \fi
}

\ifieeecs@twodigitsections
  \renewcommand{\thesection}{%
    \ifnum\value{section}<10 0\fi\arabic{section}}
\fi

\renewcommand\section{%
  \@startsection{section}{1}{\z@}%
    {-3.5ex \@plus -1ex \@minus -.2ex}%
    {2.3ex \@plus .2ex}%
    {\IEEECSHeadingFont\Large\bfseries\color{IEEECSOrange}}}
\renewcommand\subsection{%
  \@startsection{subsection}{2}{\z@}%
    {-3.25ex \@plus -1ex \@minus -.2ex}%
    {1.5ex \@plus .2ex}%
    {\IEEECSHeadingFont\large\bfseries\color{IEEEBlue}}}
\renewcommand\subsubsection{%
  \@startsection{subsubsection}{3}{\z@}%
    {-3.25ex \@plus -1ex \@minus -.2ex}%
    {1.5ex \@plus .2ex}%
    {\IEEECSHeadingFont\normalsize\bfseries\color{IEEEBlue}}}

\fancypagestyle{ieeeufgcs}{%
  \fancyhf{}
  \if@twoside
    \fancyhead[LE,RO]{%
      \small\IEEECSHeadingFont\@ieeecs@runningtitle}
    \fancyhead[LO,RE]{%
      \small\IEEECSHeadingFont IEEE Computer Society -- UFG}
    \fancyfoot[LE,RO]{\thepage}
  \else
    \fancyhead[L]{%
      \small\IEEECSHeadingFont IEEE Computer Society -- UFG}
    \fancyhead[R]{%
      \small\IEEECSHeadingFont\@ieeecs@runningtitle}
    \fancyfoot[R]{\thepage}
  \fi
  \renewcommand{\headrulewidth}{0.4pt}
  \renewcommand{\footrulewidth}{0pt}
}
\pagestyle{ieeeufgcs}
\makeatother

\NewDocumentCommand{\IEEECSHeaderCell}{m}{%
  \cellcolor{IEEEBlue}%
  \color{IEEEWhite}%
  \bfseries #1%
}

\NewDocumentEnvironment{IEEECSBrandedTable}{m}{%
  \par\smallskip
  \begingroup
  \renewcommand{\arraystretch}{1.25}%
  \setlength{\tabcolsep}{5pt}%
  \rowcolors{2}{IEEEBlueTwenty}{IEEEWhite}%
  \noindent
  \tabularx{\linewidth}{#1}%
}{%
  \endtabularx
  \endgroup
  \par\smallskip
}

\NewDocumentEnvironment{IEEECSNotice}{O{}}{%
  \par\medskip
  \noindent
  \begin{minipage}{\linewidth}
    \color{IEEEBlue}\rule{\linewidth}{0.8pt}\par
    \smallskip
    \raggedright
    \if\relax\detokenize{#1}\relax\else
      {\IEEECSHeadingFont\bfseries\color{IEEEBlue}#1\par}
      \smallskip
    \fi
    \color{IEEECSBodyText}%
}{%
    \smallskip
    \color{IEEEBlue}\rule{\linewidth}{0.8pt}
  \end{minipage}
  \par\medskip
}

\endinput
