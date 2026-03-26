#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <stitch-url-or-project-id> <output-dir>" >&2
  exit 1
fi

SOURCE="$1"
OUTDIR="$2"
case "$SOURCE" in
  http*) PROJECT_ID="$(printf '%s' "$SOURCE" | /usr/bin/sed -E 's#.*projects/([0-9]+).*#\1#')" ;;
  *) PROJECT_ID="$SOURCE" ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(cd "$SCRIPT_DIR/../../.." && pwd)"
TMPDIR="$WORKSPACE/Temporal/stitch-import-${PROJECT_ID}"
mkdir -p "$TMPDIR" "$OUTDIR/public"
"$WORKSPACE/skills/stitch-sdk/scripts/stitch_sdk.sh" list-screens --project "$PROJECT_ID" > "$TMPDIR/screens.json"

echo "Imported screen metadata to $TMPDIR/screens.json"
echo "Download step is intentionally repo-specific; see top-level import implementation for a working example."
