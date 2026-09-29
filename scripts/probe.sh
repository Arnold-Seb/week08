#!/usr/bin/env bash
# Continuous availability probe.
#
# Runs in the background from before the traffic switch until after the bake
# window, recording the HTTP status of every request. This is what turns "no
# downtime" from a claim into a measurement, and it is also the signal the
# pipeline uses to decide whether to roll back.
#
# Usage: probe.sh <url> <csv-out> <stop-file> [interval-seconds]

URL="$1"
OUT="$2"
STOP="$3"
INTERVAL="${4:-0.2}"

: > "$OUT"
rm -f "$STOP"

while [ ! -f "$STOP" ]; do
    CODE=$(curl -s -o /dev/null -w '%{http_code}' --max-time 3 "$URL" || echo 000)
    echo "$(date +%s),$CODE" >> "$OUT"
    sleep "$INTERVAL"
done
