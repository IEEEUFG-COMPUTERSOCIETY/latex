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
3. The files supplied in `../Logo` and `../MB Lockups` are the production
   artwork. Normalized PDF copies are packaged under
   `tex/latex/ieeeufgcs/assets` so documents do not depend on directories with
   spaces or on external paths.

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

## Typography

The Computer Society-specific choice takes precedence over the general IEEE
font family:

- `\IEEECSHeadingFont`: Montserrat, for headings and emphasis.
- `\IEEECSBodyFont`: Open Sans, for long-form copy.
- Calibri is the offline fallback named by the guide, but it is not distributed
  here.

The package is LuaLaTeX-only and loads Montserrat and Open Sans through
`fontspec`, including their italic, bold, light, semibold, and extra-bold faces.
It does not change the document's main font. Use the `nofonts` option if the
document class manages fonts itself; the LuaLaTeX engine requirement remains.

## Color tokens

The default option is `rgb`; use `cmyk` for print production. Public names are:

| Role | Token | Hex |
|---|---|---:|
| CS primary | `IEEECSOrange` | `#FFA300` |
| IEEE blue / CS secondary | `IEEEBlue` | `#00629B` |
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
`IEEECSBodyText`. Each non-neutral palette token also has `Eighty`, `Sixty`,
`Forty`, and `Twenty` suffixes, for example `IEEECSOrangeTwenty`.

The guide prefers the bright palette and requires sufficient text/background
contrast. Tints below 10% are not permitted by the parent guide.
