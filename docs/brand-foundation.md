<!--
Copyright (C) 2026 IEEE UFG Computer Society contributors.
Distributed and/or modified under the LaTeX Project Public License,
version 1.3c or later. This work has LPPL status `maintained`; the Current
Maintainer is the IEEE UFG Computer Society. See LICENSE and MANIFEST.md.
-->

# Brand foundation

This repository treats the supplied guidelines and artwork as the authority. It
does not redraw, recolor, or recompose either mark.

## Source precedence

1. **IEEE Computer Society Brand Identity & Graphic Style Guide (2023)** is the
   specific source for Computer Society logo use, chapter/sub-brand treatment,
   and typography.
2. **IEEE Brand Identity Guidelines (Q1 2025)** is the newer parent source for
   the IEEE master brand and the common IEEE palette.
3. **Marca UFG: Manual de Identidade Visual (2022)** defines UFG signature
   preference, colors, protected areas, minimum sizes, and joint use.
4. The files supplied in `../Logo` and `../MB Lockups` are the production
   artwork. Normalized PDF copies are packaged under
   `tex/latex/ieeeufgcs/assets` so documents do not depend on directories with
   spaces or on external paths.
5. The local `example/marca-ufg.pdf` file supplies official UFG artwork.

The documents agree on the shared palette. Where display rounding differs, the
2025 parent guide values are used.

## Logo rules represented by the package

- `\IEEECSLogo` uses the official Computer Society artwork and adds clear space
  equal to `0.3 ×` the artwork height by default.
- `\IEEEMasterBrand` uses an official IEEE master-brand lockup and adds `1 ×`
  height for print by default. `clear-space=digital` changes this to `0.5 ×`.
- Computer Society variants are `orange`, `black`, `white`, and
  `orange-white`. Master-brand variants are `blue`, `black`, and `white`.
- Set clear space to `false` (CS) or `none` (master brand) only when the parent
  layout already provides at least the required exclusion zone.
- White and orange-white variants require an appropriate dark background.
- Logo artwork must not be recolored, distorted, screened, rotated, cropped,
  used in a sentence, or placed over a busy background.

The Computer Society guide says a Chapter or Student Chapter mark combines the
primary CS logo with the full chapter name, gives the CS name greater visual
hierarchy, limits the chapter name to two lines, and uses Montserrat. This
repository intentionally does not synthesize that mark: no official UFG chapter
lockup was present in the supplied assets. It should be added only from approved
artwork.

## UFG artwork

The package includes the full-name horizontal and vertical UFG signatures in
blue, black, and white. `\UFGLogo` defaults to the preferred full-name vertical
signature, the blue variant, a 24 mm artwork width, and its protected area.
Its options are `orientation=horizontal|vertical`,
`variant=blue|black|white`, `width=<dimension>`, and
`clear-space=true|false`.

The protected area is `3x` on the left and right and `2x` above and below the
artwork. The construction module `x` is half the side of the largest hexagon.
The package derives it from the normalized vector artwork. Set
`clear-space=false` only when the surrounding layout already guarantees that
space.

The package warns when a full-name signature is below the manual's minimum
artwork width. The horizontal minimum is 24.5 mm wide and 12.6 mm high; the
vertical minimum is 12 mm wide and 21.7 mm high.

The vertical full-name version has absolute preference. A horizontal version
is appropriate when the vertical construction conflicts with a horizontal
layout, including placement beside a mark that is wider than it is tall.
Joint marks should follow the same orientation and have matching overall
heights. The parent layout must provide the required separation between them.

The original sheet also contains compact marks without the full university
name. Those remain outside the package until a concrete layout requires them.
Layouts must not recolor, distort, rotate, or recompose any signature. The blue
symbol with black lettering is preferred on medium- and high-luminosity
backgrounds. White and black variants are reserved for backgrounds or
production processes where the preferred version is unsuitable.

## Typography

The Computer Society-specific choice takes precedence over the general IEEE
font family:

- `\IEEECSHeadingFont`: Montserrat, for headings and emphasis.
- `\IEEECSBodyFont`: Open Sans, for long-form copy.
- Calibri is the offline fallback named by the guide, but it is not distributed
  here.

The package is LuaLaTeX-only and loads Montserrat and Open Sans through
`fontspec`, including their italic, bold, light, semibold, and extra-bold faces.
It does not change the document's main font. Use `fonts=false` if the document
class manages fonts itself; the LuaLaTeX engine requirement remains.

## Generic document class

The `ieeeufgcs` class defines the shared visual and structural foundation for
institutional documents. It builds internally on the standard `article` class,
but does not represent an article or publication content type. Work plans,
minutes, decisions, reports, and future promotional formats are templates or
layout profiles using the same identity layer.

Its default layout is A4 at 11 pt with mirrored two-sided margins:

- inner: 27 mm;
- outer: 22 mm;
- top: 24 mm;
- bottom: 28 mm; and
- binding offset: 0 mm.

The wider inner margin alternates sides on odd and even pages. A binding offset
can be requested independently, but the project does not add one by default.

The class uses Open Sans for body copy and Montserrat for headings. It provides
a strong full-page cover by default, a compact title alternative, text-only
running headers, outer page numbers, branded tables, and notices.

The public class options are:

- `paper-size=a4|letter`;
- `font-size=10pt|11pt|12pt`;
- `two-sided=true|false`;
- `title-page=true|false`;
- `section-numbering=plain|two-digit`;
- `inner-margin`, `outer-margin`, `top-margin`, and `bottom-margin`;
- `binding-offset`; and
- `color-model=rgb|cmyk`.

Standard options unknown to this class are forwarded to the base `article`
class. The `\IEEECSSetup` command accepts `title`, `subtitle`, `author`, `date`,
`document-type`, `institution`, `unit`, `location`, `identifier`, and
`running-title` metadata. The standard `\title`, `\author`, and `\date`
commands remain available.

Content-specific structures belong in templates. The first such template is
`templates/work-plan/main.tex`, based on the recurring structure observed in
the supplied work-plan references without copying their text or artwork.

## Color tokens

The default is `color-model=rgb`; use `color-model=cmyk` for print production.
Public names are:

| Role | Token | Hex |
|---|---|---:|
| CS primary | `IEEECSOrange` | `#FFA300` |
| IEEE blue / CS secondary | `IEEEBlue` | `#00629B` |
| UFG blue | `UFGBlue` | `#0067AC` |
| Cyan | `IEEECyan` | `#00B5E2` |
| Gray | `IEEEGray` | `#75787B` |
| Red | `IEEERed` | `#BA0C2F` |
| Yellow | `IEEEYellow` | `#FFD100` |
| Bright green | `IEEEBrightGreen` | `#78BE20` |
| Green | `IEEEGreen` | `#00843D` |
| Purple | `IEEEPurple` | `#981D97` |
| Teal | `IEEETeal` | `#009CA6` |
| Dark red | `IEEEDarkRed` | `#862041` |
| Dark orange | `IEEEDarkOrange` | `#E87722` |
| Dark yellow | `IEEEDarkYellow` | `#FFC72C` |
| Olive green | `IEEEOliveGreen` | `#658D1B` |
| Dark green | `IEEEDarkGreen` | `#006341` |
| Dark purple | `IEEEDarkPurple` | `#772583` |
| Dark teal | `IEEEDarkTeal` | `#007377` |
| Dark blue | `IEEEDarkBlue` | `#002855` |
| Black | `IEEEBlack` | `#000000` |
| White | `IEEEWhite` | `#FFFFFF` |

Semantic aliases are `IEEECSPrimary`, `IEEECSSecondary`, and
`IEEECSBodyText`. Each non-neutral IEEE palette token also has `Eighty`,
`Sixty`, `Forty`, and `Twenty` suffixes, for example
`IEEECSOrangeTwenty`. No tints are generated for `UFGBlue` because the UFG
manual requires its supplied colors to remain unaltered.

The guide prefers the bright palette and requires sufficient text/background
contrast. Tints below 10% are not permitted by the parent guide.
