#!/usr/bin/env bash
set -euo pipefail

TO_DEFAULT="ldpromanelli@gmail.com"

usage() {
  cat <<'EOF'
Uso:
  mail_file.sh <arquivo> [assunto] [destinatario]

Envia um arquivo como anexo por email.

Argumentos:
  arquivo       Arquivo para anexar (obrigatório)
  assunto       Assunto do email (opcional, default: "Arquivo: <nome>")
  destinatario  Email de destino (opcional, default: ldpromanelli@gmail.com)

Variáveis opcionais:
  FROM_EMAIL   (apenas para modo sendmail) Ex: FROM_EMAIL=meu@dominio.com

Exemplos:
  mail_file.sh documento.pdf
  mail_file.sh relatorio.pdf "Relatório mensal"
  mail_file.sh doc.pdf "PDF gerado" "alguem@dominio.com"
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" || $# -lt 1 ]]; then
  usage
  exit 0
fi

FILE_PATH="$1"
FILE_NAME="$(basename "$FILE_PATH")"
SUBJECT="${2:-Arquivo: $FILE_NAME}"
TO="${3:-$TO_DEFAULT}"

if [[ ! -f "$FILE_PATH" ]]; then
  echo "Erro: arquivo não encontrado: $FILE_PATH" >&2
  exit 1
fi

BODY="Segue em anexo o arquivo: $FILE_NAME"

send_with_mutt() {
  echo "$BODY" | mutt -s "$SUBJECT" -a "$FILE_PATH" -- "$TO"
}

send_with_mailx() {
  echo "$BODY" | mailx -s "$SUBJECT" -a "$FILE_PATH" "$TO"
}

send_with_sendmail() {
  if ! command -v base64 >/dev/null 2>&1; then
    echo "Erro: 'base64' não está disponível para enviar via sendmail." >&2
    exit 1
  fi

  local boundary="BOUNDARY_$(date +%s)_$$"
  local from="${FROM_EMAIL:-$(whoami)@$(hostname -f 2>/dev/null || hostname)}"
  local content_type

  case "$FILE_PATH" in
    *.pdf) content_type="application/pdf" ;;
    *.png) content_type="image/png" ;;
    *.jpg|*.jpeg) content_type="image/jpeg" ;;
    *.txt) content_type="text/plain" ;;
    *.html) content_type="text/html" ;;
    *.zip) content_type="application/zip" ;;
    *) content_type="application/octet-stream" ;;
  esac

  {
    echo "From: $from"
    echo "To: $TO"
    echo "Subject: $SUBJECT"
    echo "MIME-Version: 1.0"
    echo "Content-Type: multipart/mixed; boundary=\"$boundary\""
    echo
    echo "--$boundary"
    echo "Content-Type: text/plain; charset=utf-8"
    echo "Content-Transfer-Encoding: 7bit"
    echo
    echo "$BODY"
    echo
    echo "--$boundary"
    echo "Content-Type: $content_type; name=\"$FILE_NAME\""
    echo "Content-Transfer-Encoding: base64"
    echo "Content-Disposition: attachment; filename=\"$FILE_NAME\""
    echo
    base64 < "$FILE_PATH"
    echo
    echo "--$boundary--"
  } | sendmail -t
}

echo "Enviando '$FILE_NAME' para: $TO"
if command -v mutt >/dev/null 2>&1; then
  send_with_mutt
elif command -v mailx >/dev/null 2>&1; then
  send_with_mailx
elif command -v sendmail >/dev/null 2>&1; then
  send_with_sendmail
else
  echo "Erro: não encontrei 'mutt', 'mailx' ou 'sendmail' para enviar o e-mail." >&2
  echo "Instale um deles e/ou configure um método de envio SMTP no seu sistema." >&2
  exit 1
fi

echo "OK: email enviado."
