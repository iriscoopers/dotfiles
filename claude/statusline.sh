#!/bin/bash
input=$(cat)

# Write session data to temp file for any other integrations
echo "$input" > /tmp/claude_context.json

MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

# ANSI colors
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
GOLD='\033[38;5;220m'
CYAN='\033[36m'
RESET='\033[0m'

# Color the bar based on usage
if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

# Build progress bar
BAR_WIDTH=10
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s" && BAR="${FILL// /▓}"
[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s" && BAR="${BAR}${PAD// /░}"

# Format cost (awk always uses C locale for number formatting, avoiding locale issues)
COST_FMT=$(awk -v cost="$COST" 'BEGIN { printf "$%.2f", cost }')

# Format duration
DURATION_SEC=$((DURATION_MS / 1000))
MINS=$((DURATION_SEC / 60))
SECS=$((DURATION_SEC % 60))

printf "${CYAN}[${MODEL}]${RESET} ${BAR_COLOR}${BAR}${RESET} ${PCT}%% | ${GOLD}${COST_FMT}${RESET} | ${CYAN}${MINS}m${SECS}s${RESET}\n"
