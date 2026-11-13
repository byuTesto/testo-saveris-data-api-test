#!/usr/bin/env bash
set -euo pipefail

BASE_URL="https://api-docs.eu.p.savr.saveris.net"
DOC_URL="$BASE_URL/data-api/data-api-docs.json"
BASE_NAME="data-api-docs.json"

SKILL_NAME="testo-data-api-doc"
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REFERENCES_DIR="$SKILL_DIR/references"

# Refuse to write anywhere other than the testo-data-api-doc skill's references folder.
if ! grep -Eq "^name:[[:space:]]*${SKILL_NAME}[[:space:]]*$" "$SKILL_DIR/SKILL.md" 2>/dev/null; then
  echo "Error: $SKILL_DIR is not the $SKILL_NAME skill directory; refusing to download." >&2
  exit 1
fi
DATE_SUFFIX="$(date -u +%F)"

download_file() {
  local url="$1"
  local destination="$2"
  local tmp_file="$destination.tmp"

  mkdir -p "$(dirname "$destination")"
  if ! curl -fsSL "$url" -o "$tmp_file"; then
    rm -f "$tmp_file"
    return 1
  fi
  mv "$tmp_file" "$destination"
}

sanitize_doc_file() {
  local file_path="$1"
  local python_bin="python3"

  if ! command -v "$python_bin" >/dev/null 2>&1; then
    python_bin="python"
  fi

  "$python_bin" - "$file_path" <<'PY'
import pathlib
import re
import sys

path = pathlib.Path(sys.argv[1])
text = path.read_text(encoding="utf-8")

text = text.replace("REGION.ENV", "{testo_env}")
text = text.replace("eu.i", "{testo_env}")
text = text.replace("eu.p", "{testo_env}")
text = text.replace("{region}.{stage}", "{testo_env}")
text = re.sub(
    r',\s*\{\s*"url":\s*"https://data-api\.eu\.smartconnect\.testo\.com/",\s*"description":\s*"Smart Connect API"\s*\}',
    "",
    text,
)
text = re.sub(
    r'\{\s*"url":\s*"https://data-api\.eu\.smartconnect\.testo\.com/",\s*"description":\s*"Smart Connect API"\s*\}',
    "",
    text,
)
path.write_text(text, encoding="utf-8")
PY
}

cleanup_legacy_versions() {
  local directory="$1"
  local base_name="$2"
  local keep_path="$3"
  local stem="${base_name%.*}"
  local ext="${base_name##*.}"

  rm -f "$directory/$base_name"

  while IFS= read -r -d '' file; do
    if [[ "$file" != "$keep_path" ]]; then
      rm -f "$file"
    fi
  done < <(find "$directory" -maxdepth 1 -type f -name "${stem}-*.${ext}" -print0)
}

stem="${BASE_NAME%.*}"
ext="${BASE_NAME##*.}"
dated_path="$REFERENCES_DIR/${stem}-${DATE_SUFFIX}.${ext}"

mkdir -p "$REFERENCES_DIR"

if [[ -f "$dated_path" ]]; then
  echo "Already up to date: $dated_path"
else
  download_file "$DOC_URL" "$dated_path"
  echo "Downloaded: $dated_path"
fi

sanitize_doc_file "$dated_path"
cleanup_legacy_versions "$REFERENCES_DIR" "$BASE_NAME" "$dated_path"

echo "Processed Data API docs using base URL: $BASE_URL"
