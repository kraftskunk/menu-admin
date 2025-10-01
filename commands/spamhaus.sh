#!/usr/bin/env bash
#DESC: Update Spamhaus blocklist + firewall
#TEST: args=; expect=Spamhaus add complete
set -euo pipefail
IFS=$'\n\t'

source "$(dirname "$0")/../lib/common.sh"

# 1. Download the Spamhaus DROP JSON
# --
curl -s -o "$DROP_JSON" https://www.spamhaus.org/drop/drop_v4.json

# 2. Extract only the CIDR ranges using sed
#    - Looks for "cidr":"<network>"
# --
sed -n 's/.*"cidr":"\([^"]*\)".*/\1/p' "$DROP_JSON" > "$BLOCKLIST"

# 3. Feed into iptables to block
# --
while read -r net; do
    # Check if rule already exists before adding
    # --
    if ! iptables -C INPUT -s "$net" -j DROP 2>/dev/null; then
        iptables -A INPUT -s "$net" -j DROP
        echo "Blocked $net"
    else
        echo "Already blocked $net"
    fi
done < "$BLOCKLIST"

# Add deletion of all temporary files after IPtables add.

log "Spamhaus add complete"