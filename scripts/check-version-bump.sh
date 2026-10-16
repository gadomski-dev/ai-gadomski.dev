#!/usr/bin/env bash
# Fails when files under output-styles/ or skills/ changed since a base commit
# but the "version" in .claude-plugin/plugin.json did not.
#
# Why: Claude Code caches an installed plugin by its version string.
# Users who already installed it receive a style or skill change only when that
# string changes, however many commits are pushed.
#
# Usage: scripts/check-version-bump.sh <base-commit>
set -euo pipefail

base="${1:?usage: scripts/check-version-bump.sh <base-commit>}"
manifest=".claude-plugin/plugin.json"

if ! git cat-file -e "${base}^{commit}" 2>/dev/null; then
  echo "Base commit ${base} not found; version check skipped."
  exit 0
fi

if [ -z "$(git diff --name-only "$base" HEAD -- output-styles/ skills/)" ]; then
  echo "No change under output-styles/ or skills/ since ${base}; version check skipped."
  exit 0
fi

version_at() {
  git show "$1:${manifest}" 2>/dev/null \
    | python3 -c 'import json, sys; print(json.load(sys.stdin)["version"])' 2>/dev/null \
    || true
}

old="$(version_at "$base")"
new="$(version_at HEAD)"

if [ -z "$new" ]; then
  echo "${manifest} has no version at HEAD." >&2
  exit 1
fi

if [ -z "$old" ]; then
  echo "No plugin version at ${base}; this is the first release, ${new}."
  exit 0
fi

if [ "$old" = "$new" ]; then
  echo "output-styles/ or skills/ changed, but ${manifest} still says version ${old}." >&2
  echo "Raise the version, or users who already installed the plugin never get this change." >&2
  exit 1
fi

echo "Plugin version ${old} -> ${new}."
