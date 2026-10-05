<!--
Copyright (C) 2026 IEEE UFG Computer Society contributors.
This README uses the LPPL 1.3c or later. See LICENSE and MANIFEST.md.
The PDF artwork described here is expressly excluded.
-->

# Packaged artwork

Normalized, space-free PDF copies of official artwork:

- `ieeeufgcs-cs-logo-{orange,black,white,orange-white}.pdf` comes from the
  corresponding IEEE Computer Society EPS logos in `example/Logo/`;
- `ieeeufgcs-master-brand-{blue,black,white}.pdf` comes from the corresponding
  supplied IEEE master-brand lockups; and
- `ieeeufgcs-ufg-logo-{horizontal,vertical}-{blue,black,white}.pdf` comes from
  pages 1, 3, 5, 7, 9 and 11 of `example/marca-ufg.pdf`; and
- `ieeeufgcs-student-branch-{horizontal,compact,symbol}.png` comes from the
  supplied IEEE UFG Student Branch raster identity.

EPS files were converted with `epstopdf`. Supplied PDFs were copied directly.
UFG pages were cropped to their vector bounds with Ghostscript. No paths,
colors, proportions or relative positions were changed.

The Student Branch PNG files are byte-for-byte copies of the supplied files.
The package clips only their empty canvas when placing them. The compact mark
has a white background; the other two have transparency. No vector version was
supplied, so these marks must not be traced or reconstructed locally. They
remain RGB raster images even when the package uses its CMYK color model.

The package adds protected areas around marks when requested. Compact UFG
signatures remain unsupported.

These PDFs are not licensed under the LPPL. The repository grants no right to
use IEEE or UFG names, trademarks or logos.
