#!/bin/bash

# Get the latest VS Code extensions.json that is minified by VS Code
chezmoi add ~/.vscode/extensions/extensions.json --force

# Cleanup part to replace absolute paths with template variables in extensions.json
# This is needed because VS Code can't use paths relative to the home dir and it minifies
# the JSON file which is not nice for version control.

JSON_FILE="extensions.json"

jq --arg home "$HOME" \
  ' (.. | strings) |= gsub($home; "{{ .chezmoi.homeDir }}") ' \
  $JSON_FILE > ${JSON_FILE}.tmpl

# Remove the original file because we only want to have the template version in the repo
rm $JSON_FILE
