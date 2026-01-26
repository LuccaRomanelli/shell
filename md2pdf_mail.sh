#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TO_DEFAULT="ldpromanelli@gmail.com"

usage() {
  cat <<'EOF'
Uso:
  md2pdf_mail.sh <arquivo.md> [assunto] [destinatario]
  md2pdf_mail.sh <arquivo.md>... [-- assunto] [-- destinatario]
  md2pdf_mail.sh *.md                    # envia todos os arquivos .md

Converte um arquivo Markdown para PDF e envia por email.

Argumentos:
  arquivo.md    Arquivo markdown de entrada (obrigatório)
  assunto       Assunto do email (opcional, default: "PDF gerado a partir de <nome>")
  destinatario  Email de destino (opcional, default: ldpromanelli@gmail.com)

Variáveis opcionais:
  PDF_ENGINE   (default: xelatex)  Ex: PDF_ENGINE=lualatex
  FROM_EMAIL   (apenas para modo sendmail) Ex: FROM_EMAIL=meu@dominio.com

Exemplos:
  md2pdf_mail.sh README.md
  md2pdf_mail.sh notas.md "Notas da reunião"
  md2pdf_mail.sh doc.md "PDF gerado" "alguem@dominio.com"
  md2pdf_mail.sh *.md
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" || $# -lt 1 ]]; then
  usage
  exit 0
fi

# Detect multi-file mode: all args are .md files
is_multi_file() {
  [[ $# -gt 1 ]] || return 1
  for arg in "$@"; do
    [[ "$arg" == *.md && -f "$arg" ]] || return 1
  done
  return 0
}

if is_multi_file "$@"; then
  for md in "$@"; do
    "$0" "$md"  # recursive call for each file
  done
  exit 0
fi

MD_PATH="$1"
MD_NAME="$(basename "$MD_PATH")"
SUBJECT="${2:-PDF gerado a partir de $MD_NAME}"
TO="${3:-$TO_DEFAULT}"

if [[ ! -f "$MD_PATH" ]]; then
  echo "Erro: arquivo não encontrado: $MD_PATH" >&2
  exit 1
fi

TMP_DIR="$(mktemp -d -t md2pdf_XXXXXX)"
MD_BASE="$(basename "${MD_PATH%.*}")"
PDF_TMP="${TMP_DIR}/${MD_BASE}.pdf"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

PDF_ENGINE="${PDF_ENGINE:-}" "$SCRIPT_DIR/md2pdf.sh" "$MD_PATH" "$PDF_TMP" >/dev/null

FROM_EMAIL="${FROM_EMAIL:-}" "$SCRIPT_DIR/mail_file.sh" "$PDF_TMP" "$SUBJECT" "$TO"

echo "PDF temporário removido."
