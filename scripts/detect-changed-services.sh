#!/bin/bash

SHARED_DIR=$1
if [[ -z "$SHARED_DIR" ]]; then
  echo "Missing shared dir name"
  exit 1
fi

changed=$(git diff --name-only origin/main...HEAD)

# שירותים רגילים שלא shared
services=$(echo "$changed" | cut -d/ -f1 | grep -v "^$SHARED_DIR$" | sort -u)

# אם core השתנה – נריץ את כולם
if echo "$changed" | grep -q "^$SHARED_DIR/"; then
  all_services=$(find . -maxdepth 1 -mindepth 1 -type d | grep -v "^./$SHARED_DIR" | sed 's|^\./||')
  services="$all_services"
fi

echo "$services" | sort -u | jq -R -s -c 'split("\n") | map(select(. != ""))'
