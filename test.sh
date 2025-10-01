#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

source "./lib/common.sh"

COMMANDS_DIR="./commands"
MODE="text"
if [[ "${1:-}" == "--markdown" ]]; then
    MODE="markdown"
    shift
fi

STAMP="$(date +%Y%m%d_%H%M%S)"
MD="test-report-$STAMP.md"
LOG="test-report-$STAMP.log"
ARCHIVE="test-report-$STAMP.tar.gz"

> "$MD"
> "$LOG"

log_line() {
    if [[ "$MODE" == "markdown" ]]; then
        echo "$1" >> "$MD"
    else
        echo "$1" | tee -a "$LOG"
    fi
}

total=0
passed=0
failed=0
declare -a RESULTS

log_line "# Admin Menu Framework Test Report"
log_line ""
log_line "🧪 **System Info**"
log_line ""
log_line "\`\`\`"
log_line "$(uname -a)"
log_line "$(uptime)"
log_line "$(df -h)"
log_line "\`\`\`"
log_line ""
log_line "## Test Results"

for script in "$COMMANDS_DIR"/*.sh; do
    name="$(basename "$script")"
    total=$((total + 1))

    test_line=$(grep -m1 '^#TEST:' "$script" || true)
    args=""
    expected=""
    if [[ -n "$test_line" ]]; then
        args=$(echo "$test_line" | sed -n 's/^#TEST:[[:space:]]*args=\([^;]*\).*/\1/p')
        expected=$(echo "$test_line" | sed -n 's/^#TEST:[^;]*;[[:space:]]*expect=\(.*\)/\1/p')
    fi

    output=$(bash "$script" $args 2>&1 || true)

    if [[ -n "$expected" ]]; then
        if echo "$output" | grep -q "$expected"; then
            RESULTS+=("| $name | ✅ Passed | $expected |")
            passed=$((passed + 1))
        else
            RESULTS+=("| $name | ❌ Failed | Expected '$expected' |")
            failed=$((failed + 1))
        fi
    else
        RESULTS+=("| $name | ⚠️ Skipped | No #TEST: metadata |")
        passed=$((passed + 1))
    fi
done

log_line ""
log_line "| Script | Result | Notes |"
log_line "|--------|--------|-------|"
for row in "${RESULTS[@]}"; do
    log_line "$row"
done

log_line ""
log_line "---"
log_line "📊 **Summary**: $passed passed, $failed failed, $total total"

# Archive the report
tar -czf "$ARCHIVE" "$MD" "$LOG"
echo "📦 Archived report: $ARCHIVE"

# Email the report
echo "📧 Sending report to $SUPERVISION_EMAIL..."
{
    echo "Subject: Admin Menu Framework Test Report [$STAMP]"
    echo "To: $SUPERVISION_EMAIL"
    echo "Content-Type: text/markdown"
    echo ""
    cat "$MD"
} | mail

echo "✅ Report sent"

echo "✅ Markdown saved to $MD"