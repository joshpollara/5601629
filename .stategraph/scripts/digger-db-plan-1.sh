# Converted from digger.yml workflows.db.plan.steps[1].
case "${TERRATEAM_DIR}:${TERRATEAM_WORKSPACE}" in
  'database:default') PROJECT_NAME='database' ;;
esac
echo "db plan for $PROJECT_NAME in $(basename "$PWD")"
