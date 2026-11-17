#!/usr/bin/env bash
# Copyright (C) 2026 IEEE UFG Computer Society contributors.
# Distributed under the LaTeX Project Public License 1.3c or later.
# See ../../LICENSE and ../MANIFEST.md.

set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
exec texlua "$script_dir/project.lua" "$@"
