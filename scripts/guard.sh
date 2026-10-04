#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
fail=0
if grep -rEl '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' data; then echo "FAIL: email in data"; fail=1; fi
if grep -rE '"(draft|private|pending|trash|auto-draft)"' data; then echo "FAIL: non-publish marker"; fail=1; fi
if grep -rEi 'DB_PASSWORD|DB_USER|wp-config' data; then echo "FAIL: secret marker"; fail=1; fi
exit $fail
