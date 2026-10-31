#!/usr/bin/env bash
# Copyright (C) 2026 IEEE UFG Computer Society contributors.
# Distributed under the LaTeX Project Public License 1.3c or later.
# See ../../LICENSE and ../MANIFEST.md.

set -euo pipefail

readonly SCRIPT_DIR="$(
  cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P
)"
readonly DEVELOPMENT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"
readonly ROOT_DIR="$(cd -- "$DEVELOPMENT_DIR/.." && pwd -P)"
readonly CATALOG_FILE="$DEVELOPMENT_DIR/templates/catalog.tsv"
readonly DOCUMENT_MAKEFILE="$SCRIPT_DIR/document.mk"
readonly DOCUMENTS_DIR="$ROOT_DIR/documents"
readonly BUILD_DIR="$DEVELOPMENT_DIR/build"
readonly DOCUMENT_BUILD_DIR="$BUILD_DIR/documents"
readonly TEXMFVAR_DIR="$BUILD_DIR/texmf-var"

declare -a TEMPLATE_KEYS=()
declare -a TEMPLATE_LABELS=()
declare -a TEMPLATE_DESCRIPTIONS=()
declare -a DOCUMENT_NAMES=()

fail() {
  printf 'Erro: %s\n' "$*" >&2
  exit 1
}

load_templates() {
  local key label description

  [[ -f "$CATALOG_FILE" ]] || fail "catálogo de modelos não encontrado"
  while IFS='|' read -r key label description; do
    [[ -z "$key" || "$key" == \#* ]] && continue
    TEMPLATE_KEYS+=("$key")
    TEMPLATE_LABELS+=("$label")
    TEMPLATE_DESCRIPTIONS+=("$description")
  done < "$CATALOG_FILE"
  ((${#TEMPLATE_KEYS[@]} > 0)) || fail "nenhum modelo cadastrado"
}

validate_name() {
  local name=$1

  if [[ ! "$name" =~ ^[[:alnum:]][[:alnum:]_-]*$ ]]; then
    fail "use apenas letras, números, hífen e sublinhado no identificador"
  fi
}

template_index() {
  local requested=$1 index

  for index in "${!TEMPLATE_KEYS[@]}"; do
    if [[ "${TEMPLATE_KEYS[$index]}" == "$requested" ]]; then
      printf '%s\n' "$index"
      return 0
    fi
  done
  return 1
}

print_templates() {
  local index

  printf 'Modelos disponíveis:\n'
  for index in "${!TEMPLATE_KEYS[@]}"; do
    printf '  %d) %s\n' "$((index + 1))" \
      "${TEMPLATE_LABELS[$index]}"
    printf '     %s\n' "${TEMPLATE_DESCRIPTIONS[$index]}"
  done
}

choose_template() {
  local requested=${1:-} answer index

  if [[ -n "$requested" ]]; then
    index="$(template_index "$requested")" || {
      fail "modelo desconhecido: $requested"
    }
  else
    print_templates
    printf '\nSelecione um modelo [1]: '
    read -r answer || answer=1
    answer=${answer:-1}
    [[ "$answer" =~ ^[0-9]+$ ]] || fail "selecione um número da lista"
    ((answer >= 1 && answer <= ${#TEMPLATE_KEYS[@]})) || {
      fail "selecione um número da lista"
    }
    index=$((answer - 1))
  fi
  SELECTED_TEMPLATE=${TEMPLATE_KEYS[$index]}
}

choose_new_name() {
  local requested=${1:-}

  if [[ -z "$requested" ]]; then
    printf 'Identificador do documento: '
    read -r requested || fail "identificador não informado"
  fi
  validate_name "$requested"
  SELECTED_DOCUMENT=$requested
}

load_documents() {
  local document_dir name

  DOCUMENT_NAMES=()
  shopt -s nullglob
  for document_dir in "$DOCUMENTS_DIR"/*; do
    [[ -d "$document_dir" ]] || continue
    name="${document_dir##*/}"
    [[ -f "$document_dir/$name.tex" ]] || continue
    DOCUMENT_NAMES+=("$name")
  done
  shopt -u nullglob
}

print_documents() {
  local index

  if ((${#DOCUMENT_NAMES[@]} == 0)); then
    printf 'Nenhum documento criado. Execute `make new`.\n'
    return
  fi
  printf 'Documentos:\n'
  for index in "${!DOCUMENT_NAMES[@]}"; do
    printf '  %d) %s\n' "$((index + 1))" "${DOCUMENT_NAMES[$index]}"
  done
}

choose_existing_document() {
  local requested=${1:-} answer

  load_documents
  ((${#DOCUMENT_NAMES[@]} > 0)) || {
    fail "nenhum documento criado; execute 'make new' primeiro"
  }
  if [[ -n "$requested" ]]; then
    validate_name "$requested"
    [[ -f "$DOCUMENTS_DIR/$requested/$requested.tex" ]] || {
      fail "documento não encontrado: $requested"
    }
    SELECTED_DOCUMENT=$requested
    return
  fi
  if ((${#DOCUMENT_NAMES[@]} == 1)); then
    SELECTED_DOCUMENT=${DOCUMENT_NAMES[0]}
    return
  fi
  print_documents
  printf '\nSelecione um documento [1]: '
  read -r answer || answer=1
  answer=${answer:-1}
  [[ "$answer" =~ ^[0-9]+$ ]] || fail "selecione um número da lista"
  ((answer >= 1 && answer <= ${#DOCUMENT_NAMES[@]})) || {
    fail "selecione um número da lista"
  }
  SELECTED_DOCUMENT=${DOCUMENT_NAMES[$((answer - 1))]}
}

choose_document_path() {
  local requested=$1 actual parent name

  [[ -n "$requested" ]] || fail "diretório de documento não informado"
  [[ -d "$requested" ]] || fail "diretório não encontrado: $requested"
  actual="$(cd -- "$requested" && pwd -P)"
  parent="$(cd -- "$actual/.." && pwd -P)"
  name="${actual##*/}"
  validate_name "$name"
  [[ "$parent" == "$DOCUMENTS_DIR" ]] || {
    fail "o diretório deve estar diretamente dentro de documents/"
  }
  [[ -f "$actual/$name.tex" ]] || {
    fail "arquivo principal não encontrado em $requested"
  }
  SELECTED_DOCUMENT=$name
}

build_document() {
  local name=$1 source_dir output_dir pdf_path

  validate_name "$name"
  source_dir="$DOCUMENTS_DIR/$name"
  output_dir="$DOCUMENT_BUILD_DIR/$name"
  pdf_path="$source_dir/$name.pdf"
  [[ -f "$source_dir/$name.tex" ]] || {
    fail "arquivo principal não encontrado para $name"
  }
  command -v latexmk >/dev/null || fail "latexmk não está instalado"
  command -v lualatex >/dev/null || fail "LuaLaTeX não está instalado"
  mkdir -p -- "$output_dir" "$TEXMFVAR_DIR"
  printf 'Compilando %s...\n' "$name"
  (
    cd -- "$source_dir"
    TEXINPUTS="$DEVELOPMENT_DIR/tex/latex//:${TEXINPUTS:-}" \
      TEXMFVAR="$TEXMFVAR_DIR" \
      latexmk \
        -lualatex \
        -interaction=nonstopmode \
        -halt-on-error \
        -outdir="$output_dir" \
        "$name.tex"
  )
  cp -- "$output_dir/$name.pdf" "$pdf_path"
  printf '\nPDF gerado em:\n  %s\n' \
    "${pdf_path#"$ROOT_DIR/"}"
}

ask_to_build() {
  local requested=${1:-} answer

  if [[ -n "$requested" ]]; then
    answer=$requested
  else
    printf 'Compilar agora? [S/n]: '
    read -r answer || answer=s
    answer=${answer:-s}
  fi
  case "${answer,,}" in
    s|sim|y|yes)
      build_document "$SELECTED_DOCUMENT"
      ;;
    n|não|nao|no)
      printf 'Use `make build` quando desejar compilar.\n'
      ;;
    *)
      fail "responda sim ou não"
      ;;
  esac
}

new_document() {
  local template=${1:-} name=${2:-} build_now=${3:-}
  local source_dir target_dir

  load_templates
  choose_template "$template"
  choose_new_name "$name"
  source_dir="$DEVELOPMENT_DIR/templates/$SELECTED_TEMPLATE"
  target_dir="$DOCUMENTS_DIR/$SELECTED_DOCUMENT"
  [[ -f "$source_dir/main.tex" ]] || {
    fail "o modelo $SELECTED_TEMPLATE não contém main.tex"
  }
  [[ ! -e "$target_dir" ]] || {
    fail "o documento $SELECTED_DOCUMENT já existe"
  }
  [[ -f "$DOCUMENT_MAKEFILE" ]] || {
    fail "Makefile de documento não encontrado"
  }
  mkdir -p -- "$DOCUMENTS_DIR"
  cp -R -- "$source_dir" "$target_dir"
  cp -- "$DOCUMENT_MAKEFILE" "$target_dir/Makefile"
  mv -- "$target_dir/main.tex" "$target_dir/$SELECTED_DOCUMENT.tex"
  mkdir -p -- "$target_dir/img"
  printf '\nDocumento criado em:\n  %s\n\n' \
    "${target_dir#"$ROOT_DIR/"}/$SELECTED_DOCUMENT.tex"
  printf 'Edite somente esse arquivo para começar.\n'
  ask_to_build "$build_now"
}

list_items() {
  load_templates
  print_templates
  printf '\n'
  load_documents
  print_documents
}

clean_build() {
  local name

  load_documents
  for name in "${DOCUMENT_NAMES[@]}"; do
    clean_document "$name"
  done
  clean_development
}

clean_document() {
  local name=$1 output_dir pdf_path

  validate_name "$name"
  output_dir="$DOCUMENT_BUILD_DIR/$name"
  pdf_path="$DOCUMENTS_DIR/$name/$name.pdf"
  if [[ ! -e "$output_dir" && ! -L "$output_dir" && \
        ! -e "$pdf_path" && ! -L "$pdf_path" ]]; then
    printf 'Nenhum arquivo gerado para %s.\n' "$name"
    return
  fi
  if [[ -e "$output_dir" || -L "$output_dir" ]]; then
    [[ -d "$output_dir" && ! -L "$output_dir" ]] || {
      fail "a saída de $name deve ser um diretório, não um link"
    }
    find "$output_dir" -mindepth 1 -depth -delete
    rmdir -- "$output_dir"
  fi
  if [[ -e "$pdf_path" || -L "$pdf_path" ]]; then
    unlink -- "$pdf_path"
  fi
  printf 'Arquivos gerados removidos para %s.\n' "$name"
}

clean_development() {
  if [[ ! -d "$BUILD_DIR" ]]; then
    printf 'Nenhum arquivo de desenvolvimento para remover.\n'
    return
  fi
  [[ ! -L "$BUILD_DIR" ]] || {
    fail "development/build/ não pode ser um link simbólico"
  }
  find "$BUILD_DIR" -mindepth 1 -depth -delete
  printf 'Arquivos gerados removidos de development/build/.\n'
}

case "${1:-}" in
  new)
    new_document "${2:-}" "${3:-}" "${4:-}"
    ;;
  build)
    choose_existing_document "${2:-}"
    build_document "$SELECTED_DOCUMENT"
    ;;
  build-path)
    choose_document_path "${2:-}"
    build_document "$SELECTED_DOCUMENT"
    ;;
  validate-path)
    choose_document_path "${2:-}"
    ;;
  list)
    list_items
    ;;
  clean)
    clean_build
    ;;
  clean-development)
    clean_development
    ;;
  clean-path)
    choose_document_path "${2:-}"
    clean_document "$SELECTED_DOCUMENT"
    ;;
  *)
    fail "ação desconhecida; use new, build, list ou clean"
    ;;
esac
