#!/usr/bin/env bash
# Reads the probe log and decides whether the release held up.
# Exits non-zero when the failure rate is above the threshold, which is what
# triggers the rollback step in the workflow.
#
# Usage: probe-report.sh <csv> <max-failure-percent>

CSV="$1"
MAX="$2"

TOTAL=$(wc -l < "$CSV" | tr -d ' ')
[ "$TOTAL" -eq 0 ] && { echo "No requests recorded."; exit 1; }

# Anything that is not a 2xx or 3xx counts as a failed request, including the
# 000 that curl reports on a timeout or a refused connection.
FAILED=$(awk -F, '$2 !~ /^[23][0-9][0-9]$/' "$CSV" | wc -l | tr -d ' ')
PCT=$(awk -v f="$FAILED" -v t="$TOTAL" 'BEGIN { printf "%.2f", (f/t)*100 }')

echo "Requests sent      : $TOTAL"
echo "Failed requests    : $FAILED"
echo "Failure rate       : ${PCT}%"
echo "Threshold          : ${MAX}%"
echo ""
echo "Status codes seen  :"
awk -F, '{ print "  " $2 }' "$CSV" | sort | uniq -c | sort -rn

OVER=$(awk -v p="$PCT" -v m="$MAX" 'BEGIN { print (p > m) ? 1 : 0 }')
if [ "$OVER" -eq 1 ]; then
    echo ""
    echo "Failure rate above threshold. Rolling back."
    exit 1
fi

echo ""
echo "Within threshold. Keeping the new version."
