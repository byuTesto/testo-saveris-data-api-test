#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-all}"
BASE_URL="https://api-docs.eu.p.savr.saveris.net"

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REFERENCES_DIR="$SKILL_DIR/references"
DATE_SUFFIX="$(date -u +%F)"

download_file() {
  local url="$1"
  local destination="$2"
  mkdir -p "$(dirname "$destination")"
  curl -fsSL "$url" -o "$destination"
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
    r',\s*\{\n\s*"url":\s*"https://data-api\.eu\.smartconnect\.testo\.com/",\n\s*"description":\s*"Smart Connect API"\s*\}',
    "",
    text,
)
text = re.sub(
    r'\{\n\s*"url":\s*"https://data-api\.eu\.smartconnect\.testo\.com/",\n\s*"description":\s*"Smart Connect API"\s*\}',
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
  local legacy_path="$directory/$base_name"
  local pattern="${stem}-*.${ext}"

  rm -f "$legacy_path"

  while IFS= read -r -d '' file; do
    if [[ "$file" != "$keep_path" ]]; then
      rm -f "$file"
    fi
  done < <(find "$directory" -maxdepth 1 -type f -name "$pattern" -print0)
}

sync_dated_doc() {
  local url="$1"
  local directory="$2"
  local base_name="$3"
  local stem="${base_name%.*}"
  local ext="${base_name##*.}"
  local dated_path="$directory/${stem}-${DATE_SUFFIX}.${ext}"

  mkdir -p "$directory"

  if [[ -f "$dated_path" ]]; then
    sanitize_doc_file "$dated_path"
    cleanup_legacy_versions "$directory" "$base_name" "$dated_path"
    echo "Already up to date: $dated_path"
    return
  fi

  download_file "$url" "$dated_path"
  sanitize_doc_file "$dated_path"
  cleanup_legacy_versions "$directory" "$base_name" "$dated_path"
}

handle_data_api() {
  local url="$BASE_URL/data-api/data-api-docs.json"
  local directory="$REFERENCES_DIR/data-api"

  sync_dated_doc "$url" "$directory" "data-api-docs.json"
}

handle_real_time_api() {
  local async_url="$BASE_URL/real-time-api/async-api.yaml"
  local openapi_url="$BASE_URL/real-time-api/openapi/openapi.yaml"
  local directory="$REFERENCES_DIR/real-time-api"

  sync_dated_doc "$async_url" "$directory" "async-api.yaml"
  sync_dated_doc "$openapi_url" "$directory" "openapi.yaml"
}

case "$TARGET" in
  data)
    handle_data_api
    ;;
  real-time|realtime|stomp|rest)
    handle_real_time_api
    ;;
  all|*)
    handle_data_api
    handle_real_time_api
    ;;
 esac

echo "Processed API docs using base URL: $BASE_URL"
