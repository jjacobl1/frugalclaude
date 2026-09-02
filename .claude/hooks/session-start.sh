#!/bin/bash
set -uo pipefail
# Installs the frugal plugin into this (possibly cached) container before the
# session goes interactive. Declaring it in settings.json's enabledPlugins is
# not acted on by itself in remote environments; this hook does the install.
#
# Pause switch: if .claude/frugal.paused exists in the repo, the plugin is
# disabled for the session instead (via a local-scope override in
# .claude/settings.local.json, which beats the committed enabledPlugins:true
# and is never committed). Delete the file to resume. Both take effect on the
# next session start.

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

ROOT="${CLAUDE_PROJECT_DIR:-.}"
LOCAL="$ROOT/.claude/settings.local.json"

if [ -f "$ROOT/.claude/frugal.paused" ]; then
  echo "frugal: paused (.claude/frugal.paused present) - plugin disabled for this session"
  claude plugin disable --scope local frugal@frugal-marketplace 2>/dev/null || true
  exit 0
fi

claude plugin marketplace add jjacobl1/frugalclaude || true
claude plugin install frugal@frugal-marketplace || true

# a previous pause on this container left a local-scope "false"; lift it
if [ -f "$LOCAL" ] && grep -q '"frugal@frugal-marketplace": *false' "$LOCAL"; then
  claude plugin enable --scope local frugal@frugal-marketplace 2>/dev/null || true
fi
exit 0
