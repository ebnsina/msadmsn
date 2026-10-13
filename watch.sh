#!/bin/sh
# One check: Telegram alert only when the admission form itself is on the page.
URL=https://madrasatussunnah.org/admission
: "${TELEGRAM_TOKEN:?TELEGRAM_TOKEN is not set}" "${TELEGRAM_CHAT_ID:?TELEGRAM_CHAT_ID is not set}"

send() { curl -sf -o /dev/null "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -d chat_id="$TELEGRAM_CHAT_ID" --data-urlencode text="$1"; }

[ -n "$TEST" ] && { send "Test: admission watcher is working. $URL"; exit; }
html=$(curl -sfL --max-time 30 "$URL") || { echo "fetch failed"; exit 0; }
if printf %s "$html" | grep -q 'id="app_form"'; then
  send "🚨 Admission form is OPEN: $URL"
elif printf %s "$html" | grep -q 'ভর্তির আবেদন বন্ধ'; then
  echo "still closed"
else
  echo "unexpected page, no form:"; printf %s "$html" | head -c 2000
fi
