#!/bin/bash
set -uo pipefail
# Declaring frugal in .claude/settings.json's enabledPlugins/extraKnownMarketplaces
# is not enough on its own in this remote environment -- nothing there actually
# fetches and installs the plugin, so its skills/agents/hooks never load. This
# hook does that installation explicitly, once per (possibly cached) container,
# before the session goes interactive.

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

claude plugin marketplace add jjacobl1/frugalclaude || true
claude plugin install frugal@frugal-marketplace || true
exit 0
