# Converted from atlantis.yaml workflows.custom.plan.steps[4].
export WORKSPACE="${TERRATEAM_WORKSPACE:-}"
export REPO_REL_DIR="${TERRATEAM_DIR:-}"
case "${TERRATEAM_DIR}:${TERRATEAM_WORKSPACE}" in
  'app:default') PROJECT_NAME='app' ;;
esac
export PROJECT_NAME
echo "proj=$PROJECT_NAME ws=$WORKSPACE rel=$REPO_REL_DIR stage=$STAGE from=$FROM_CMD a=$A b=$B"
