<!--
Copyright (C) 2026 IEEE UFG Computer Society contributors.
This README is distributed and/or modified under the LaTeX Project Public
License, version 1.3c or later. This work has LPPL status `maintained`; the
Current Maintainer is the IEEE UFG Computer Society. See LICENSE and
MANIFEST.md. The PDF artwork described here is expressly excluded.
-->

# Packaged artwork

These files are normalized PDF copies of official artwork supplied with the
project. Filenames were changed only to provide stable, space-free package
paths.

- `ieeeufgcs-cs-logo-orange.pdf`
  - Source: `Logo/IEEE-CS_LogoTM-orange.eps`
- `ieeeufgcs-cs-logo-black.pdf`
  - Source: `Logo/IEEE-CS_LogoTM-black.eps`
- `ieeeufgcs-cs-logo-white.pdf`
  - Source: `Logo/IEEE-CS_LogoTM-white.eps`
- `ieeeufgcs-cs-logo-orange-white.pdf`
  - Source: `Logo/IEEE-CS_LogoTM-orange bug-white text.eps`
- `ieeeufgcs-master-brand-blue.pdf`
  - Source: `MB Lockups/.../IEEE ComputerSoc_MB Blue Lockup CMYK.pdf`
- `ieeeufgcs-master-brand-black.pdf`
  - Source: `MB Lockups/.../IEEE ComputerSoc_MB Black Lockup CMYK.pdf`
- `ieeeufgcs-master-brand-white.pdf`
  - Source: `MB Lockups/.../IEEE ComputerSoc_MB Lockup WHITE CMYK.eps`
- `ieeeufgcs-ufg-logo-horizontal-blue.pdf`
- `ieeeufgcs-ufg-logo-horizontal-black.pdf`
- `ieeeufgcs-ufg-logo-horizontal-white.pdf`
- `ieeeufgcs-ufg-logo-vertical-blue.pdf`
- `ieeeufgcs-ufg-logo-vertical-black.pdf`
- `ieeeufgcs-ufg-logo-vertical-white.pdf`
  - Source: full-name signatures on pages 1, 3, 5, 7, 9, and 11 of
    `example/marca-ufg.pdf`

EPS sources were converted with `epstopdf`; the supplied CMYK PDFs were copied
without content changes. Trademark and usage restrictions remain those of IEEE
and the IEEE Computer Society.

The UFG signatures were extracted as individual pages, cropped to their vector
artwork, and normalized with Ghostscript. No paths, colors, proportions, or
relative positions within the marks were changed. Compact signatures without
the full university name remain only in the local reference file.

Usage rules come from the supplied 2022 UFG visual identity manual in
`example/`. The normalized files contain only the artwork; the `\UFGLogo`
command supplies the manual's protected area when requested.

The PDF files in this directory are not licensed under the LPPL. The repository
license grants no permission to use IEEE or UFG names, trademarks, logos, or
other brand assets.
