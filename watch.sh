#!/bin/sh
# One check: Telegram alert if the admission page no longer shows the "closed" notice.
URL=https://madrasatussunnah.org/admission
: "${TELEGRAM_TOKEN:?TELEGRAM_TOKEN is not set}" "${TELEGRAM_CHAT_ID:?TELEGRAM_CHAT_ID is not set}"

send() { curl -sf -o /dev/null "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -d chat_id="$TELEGRAM_CHAT_ID" --data-urlencode text="$1"; }

[ -n "$TEST" ] && { send "Test: admission watcher is working. $URL"; exit; }
html=$(curl -sfL --max-time 30 "$URL") || { echo "fetch failed"; exit 0; }
if printf %s "$html" | grep -q 'ভর্তির আবেদন বন্ধ'; then
  echo "still closed"
else
  send "🚨 Admission form is OPEN: $URL"
fi
