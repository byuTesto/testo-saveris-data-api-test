#!/usr/bin/env bash
set -euo pipefail

BASE_URL="https://api-docs.eu.p.savr.saveris.net"

SKILL_NAME="testo-real-time-api-doc"
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REFERENCES_DIR="$SKILL_DIR/references"

# Refuse to write anywhere other than the testo-real-time-api-doc skill's references folder.
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
import sys

path = pathlib.Path(sys.argv[1])
text = path.read_text(encoding="utf-8")

text = text.replace("REGION.ENV", "{testo_env}")
text = text.replace("eu.i", "{testo_env}")
text = text.replace("eu.p", "{testo_env}")
text = text.replace("{region}.{stage}", "{testo_env}")
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

sync_dated_doc() {
  local url="$1"
  local base_name="$2"
  local stem="${base_name%.*}"
  local ext="${base_name##*.}"
  local dated_path="$REFERENCES_DIR/${stem}-${DATE_SUFFIX}.${ext}"

  mkdir -p "$REFERENCES_DIR"

  if [[ -f "$dated_path" ]]; then
    echo "Already up to date: $dated_path"
  else
    download_file "$url" "$dated_path"
    echo "Downloaded: $dated_path"
  fi

  sanitize_doc_file "$dated_path"
  cleanup_legacy_versions "$REFERENCES_DIR" "$base_name" "$dated_path"
}

sync_dated_doc "$BASE_URL/real-time-api/async-api.yaml" "async-api.yaml"
sync_dated_doc "$BASE_URL/real-time-api/openapi/openapi.yaml" "openapi.yaml"

echo "Processed Real-Time API docs using base URL: $BASE_URL"
