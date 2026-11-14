#!/bin/sh
set -eu
args=""
if [ "${destroy:-}" = "true" ]; then
  args="$args -destroy"
fi
if [ "${refresh_only:-}" = "true" ]; then
  args="$args -refresh-only"
fi
old_ifs=$IFS
IFS=','
for address in ${target:-}; do
  args="$args '-target=$address'"
done
for address in ${replace:-}; do
  args="$args '-replace=$address'"
done
IFS=$old_ifs
printf '%s' "$args"
