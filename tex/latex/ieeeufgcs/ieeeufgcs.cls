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
%% outer, top, and bottom margins are 22, 22, 24, and 28 mm respectively. The
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

% LaTeX2e conditionals are used later in title and section definitions, where
% their direct if/else syntax is clearer than repeatedly entering expl3 mode.
\newif\ifieeecs@titlepage
\newif\ifieeecs@twodigitsections

% Phase 1: collect class options before loading article. Paper size, base font
% size, and sidedness are immutable article choices and must be forwarded
% before \LoadClass. Geometry and brand choices remain available for phase 2.
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
\dim_set:Nn \l__ieeecs_class_inner_margin_dim { 22mm }
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

% Bridge expl3 booleans into the LaTeX2e conditionals used below.
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

% Phase 2: build the institutional class on the standard structural base.
\LoadClass{article}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{colortbl}

% Translate semantic margins into geometry after article has established the
% paper and page mode. Pass the color model before loading the brand package.
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

% Metadata is stored independently so that a missing optional field consumes
% no space. Title, author, and date deliberately reuse LaTeX's standard state.
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

% Title rendering
% ---------------
% The public \maketitle command is a dispatcher.  The title-page class option
% is copied into \ifieeecs@titlepage while options are processed above; that
% conditional selects one of the two private renderers below.  Keep the
% selection here rather than in the metadata commands so that both renderers
% consume the same stored title, author, date, and IEEECSSetup state.
%
% The full-page renderer creates and closes a titlepage, paints artwork against
% the physical page, and restarts body-page numbering at one.  The compact
% renderer emits an in-flow heading on the current page and leaves pagination
% alone.  In particular, it is safe for compact \maketitle to follow material
% already placed by a template; it must not acquire an implicit page break.
%
% Full-page cover artwork.  This command paints only the background layer; the
% logos and metadata are normal page content added by
% \ieeecs@maketitlepage.  All coordinates are deliberately relative to
% `current page', not to the geometry text block.  Changing the document
% margins therefore does not move the artwork, while changing the paper size
% preserves its offsets from the top and right paper edges.
%
% The measurements form one coupled composition and should be reviewed
% together:
%   * 110mm is the bottom of the dark-blue field;
%   * 110--115mm is the 5mm orange divider immediately below that field;
%   * the three wireframe icosahedrons occupy the right side of the field in the
%     same approximate -92mm to -18mm horizontal and -72mm to -106mm vertical
%     region as the line artwork they replaced.
% `remember picture' makes the page node available and `overlay' prevents the
% picture from contributing its page-sized bounds to TeX's layout.  The
% surrounding \noindent ... \par gives the zero-sized overlay a predictable
% paragraph context without adding visible content.
%
\newcommand{\ieeecs@coverbackground}{%
  \noindent
  \begin{tikzpicture}[remember picture,overlay]
    \fill[IEEEDarkBlue]
      (current page.north west)
      rectangle ([yshift=-110mm]current page.north east);
    \fill[IEEECSOrange]
      ([yshift=-110mm]current page.north west)
      rectangle ([yshift=-115mm]current page.north east);
    \ieeecs@brandicosahedron
      {([xshift=-54mm,yshift=-74mm]current page.north east)}
      {2.55}
      {IEEECyan}
      {1.7}
    \ieeecs@brandicosahedron
      {([xshift=-32mm,yshift=-93mm]current page.north east)}
      {1.30}
      {IEEEBlueTwenty}
      {2.0}
    \ieeecs@brandicosahedron
      {([xshift=-125mm,yshift=-90mm]current page.north east)}
      {7.6}
      {IEEECSOrange}
      {1.2}
    \fill[IEEEWhite]
      ([yshift=-110mm]current page.south west)
      rectangle ([yshift=-115mm]current page.north east);
  \end{tikzpicture}\par
}

% Full-page title implementation (the default).  The titlepage environment is
% responsible for isolating the cover from surrounding content and for the
% page breaks at both boundaries.  Its page style is explicitly empty because
% the global ieeeufgcs fancyhdr style must not place running furniture over the
% cover artwork.
%
% The first 76mm of text-area content is a top-aligned minipage placed over the
% 110mm blue field.  It contains the two white-compatible logo variants,
% followed by the optional document type and the title.  Its fixed height is
% part of the cover geometry: it keeps all subsequent metadata below the
% colored header independently of how little content appears in this block.
% A long title or document type can overfill it, so adjust the typography or
% revisit the cover dimensions when allowing unusually long metadata; do not
% simply remove the fixed height.
%
% Optional metadata is guarded with \ifx ... \@empty so absent values consume
% neither text nor their associated vertical space.  The information hierarchy
% is subtitle; author; institution and unit; date and location.  The final
% \vfill pins the master-brand/identifier row toward the bottom of the
% available text area.  The identifier is right-aligned only when present.
% \@thanks is expanded inside the titlepage so standard \thanks entries remain
% attached to the cover rather than leaking into the document body.
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
        width=32.5mm,
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
  % In two-sided article documents, titlepage advances the counter when it
  % ships the cover.  The cover is intentionally outside the numbered body, so
  % normalize the first body page to page 1 in every sidedness mode.
  \setcounter{page}{1}%
}

% Compact title implementation.  Unlike the full cover, this is ordinary
% vertical material in the current text block: it neither opens a titlepage nor
% resets the page counter.  Apply the branded page style locally to the page on
% which the heading lands, since a template may have changed the surrounding
% pagestyle.
%
% Compact titles intentionally present only document type, title, subtitle,
% author, and date.  Institution, unit, location, identifier, logos, and
% \@thanks belong to the full cover and are not silently squeezed into this
% smaller treatment.  The author/date pair shares one line with stretchable
% space; maintainers adding potentially wide fields should introduce an
% explicit wrapping policy rather than adding more \hfill-separated items.
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

% Preserve LaTeX's public entry point while replacing article's title layout.
% This command deliberately takes no arguments: callers configure all content
% through \title, \author, \date, and \IEEECSSetup before invoking it.
\RenewDocumentCommand{\maketitle}{}{%
  \ifieeecs@titlepage
    \ieeecs@maketitlepage
  \else
    \ieeecs@makecompacttitle
  \fi
}

% Section styling and page furniture belong to the class because they are
% shared by every institutional document, regardless of its template.
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

% Public content components. These intentionally accept ordinary array and
% tabularx column declarations instead of introducing another table language.
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
