#!/usr/bin/env bash
# Refresh the dataset from the live archive.
#
#   YYA_SSH=user@host YYA_SITE_PATH='~/clickandbuilds/YoyoArchive' scripts/refresh.sh [--push]
#
# Runs `wp yya export-dataset` on the server, copies data/ back, runs the
# guard, updates README/CHANGELOG, and commits "data: refresh export <date>".
# With --push it also pushes. Exits without committing when nothing changed.
set -euo pipefail
cd "$(dirname "$0")/.."

: "${YYA_SSH:?set YYA_SSH to user@host}"
: "${YYA_SITE_PATH:?set YYA_SITE_PATH to the WordPress root on the server}"
tmp='$HOME/yya-export-tmp'
today="$(date -u +%Y-%m-%d)"

old_manifest="$(git show HEAD:data/manifest.json)"

ssh -o BatchMode=yes "$YYA_SSH" "cd $YYA_SITE_PATH && rm -rf $tmp && wp yya export-dataset --out=$tmp --exclude-content=story"
scp -q -r "$YYA_SSH:yya-export-tmp/data/." data/
ssh -o BatchMode=yes "$YYA_SSH" "rm -rf $tmp"
# changelog.json is diffed against an empty export dir, so it would report every record as new.
rm -f data/changelog.json

bash scripts/guard.sh

if git diff --quiet -- data; then
  echo "No data changes."
  exit 0
fi

OLD="$old_manifest" python3 - "$today" <<'PY'
import json, os, sys
today = sys.argv[1]
old = json.loads(os.environ["OLD"])["counts"]
new = json.load(open("data/manifest.json"))["counts"]
parts = [f"{k} {new[k]} ({new[k]-old.get(k,0):+d})" for k in new if new[k] != old.get(k, 0)]
line = (", ".join(parts) + ". " if parts else "") + "Content updates. Other counts unchanged."
cl = open("CHANGELOG.md", encoding="utf-8").read().replace("\r\n", "\n")
cl = cl.replace("# Changelog\n\n", f"# Changelog\n\n## {today}\n\n- {line}\n\n", 1)
open("CHANGELOG.md", "w", encoding="utf-8", newline="\n").write(cl)
rd = open("README.md", encoding="utf-8").read().replace("\r\n", "\n")
import re
rd = re.sub(r"\*\*Last update:\*\* \d{4}-\d{2}-\d{2}", f"**Last update:** {today}", rd, count=1)
open("README.md", "w", encoding="utf-8", newline="\n").write(rd)
PY

git add -A
git commit -q -m "data: refresh export $today"
echo "Committed data refresh $today."
if [ "${1:-}" = "--push" ]; then git push origin HEAD; fi
