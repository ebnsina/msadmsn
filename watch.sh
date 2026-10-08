#!/bin/sh
# One check: push an alert if the admission page no longer shows the "closed" notice.
URL=https://madrasatussunnah.org/admission
: "${NTFY_TOPIC:?NTFY_TOPIC is not set}"

html=$(curl -sfL --max-time 30 "$URL") || { echo "fetch failed"; exit 0; }
if printf %s "$html" | grep -q 'ভর্তির আবেদন বন্ধ'; then
  echo "still closed"
else
  curl -sf -H "Priority: urgent" -H "Click: $URL" -d "Admission form is OPEN: $URL" "https://ntfy.sh/$NTFY_TOPIC"
fi
