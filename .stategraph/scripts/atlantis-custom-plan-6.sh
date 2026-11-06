# Converted from atlantis.yaml workflows.custom.plan.steps[6].
export DIR="${TERRATEAM_ROOT:-}/${TERRATEAM_DIR:-}"
export SHOWFILE="${TERRATEAM_TMPDIR:-/tmp}/atlantis-show.json"
"${TERRATEAM_TF_CMD:-terraform}" show -json "$TERRATEAM_PLAN_FILE" > "$SHOWFILE"
test -s "$SHOWFILE" && echo "showfile-ok $(basename "$DIR")"
