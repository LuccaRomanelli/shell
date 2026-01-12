#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Uso:
  md2pdf.sh <arquivo.md> [arquivo.pdf]

Converte um arquivo Markdown para PDF usando pandoc.

Argumentos:
  arquivo.md    Arquivo markdown de entrada (obrigatório)
  arquivo.pdf   Arquivo PDF de saída (opcional, default: mesmo nome no mesmo diretório)

Variáveis opcionais:
  PDF_ENGINE   (default: xelatex)  Ex: PDF_ENGINE=lualatex

Exemplos:
  md2pdf.sh README.md
  md2pdf.sh notas.md relatorio.pdf
  PDF_ENGINE=lualatex md2pdf.sh doc.md
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" || $# -lt 1 ]]; then
  usage
  exit 0
fi

MD_PATH="$1"
PDF_ENGINE="${PDF_ENGINE:-xelatex}"

if [[ ! -f "$MD_PATH" ]]; then
  echo "Erro: arquivo não encontrado: $MD_PATH" >&2
  exit 1
fi

case "$MD_PATH" in
  *.md|*.markdown) ;;
  *)
    echo "Erro: o arquivo precisa ser .md ou .markdown: $MD_PATH" >&2
    exit 1
    ;;
esac

if ! command -v pandoc >/dev/null 2>&1; then
  echo "Erro: 'pandoc' não está instalado (necessário para converter MD -> PDF)." >&2
  exit 1
fi

if [[ -n "${2:-}" ]]; then
  PDF_PATH="$2"
else
  MD_DIR="$(dirname "$MD_PATH")"
  MD_BASE="$(basename "${MD_PATH%.*}")"
  PDF_PATH="${MD_DIR}/${MD_BASE}.pdf"
fi

echo "Convertendo: $MD_PATH -> $PDF_PATH" >&2
pandoc "$MD_PATH" -o "$PDF_PATH" --pdf-engine="$PDF_ENGINE"

echo "$PDF_PATH"
