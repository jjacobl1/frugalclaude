#!/usr/bin/env bash
# Resolves a working Python interpreter and execs it against the given
# hook/report script, forwarding stdin and all remaining arguments and
# preserving the resolved interpreter's exit code.
#
# Windows commonly ships `python` and the `py` launcher but no `python3`
# on PATH. The other hooks used to hardcode `python3` directly in
# hooks.json; on such a machine the shell reports "command not found"
# before the .py script ever runs. Guards fail open on that already (by
# design), so routing itself keeps working -- but log_metrics.py fails
# open too, meaning delegation can be happening for real while every run
# goes unrecorded and /frugal:router-stats reports nothing. This mirrors
# the fallback guard_expensive.sh already carried inline for itself.
for candidate in python3 python py; do
  command -v "$candidate" >/dev/null 2>&1 && exec "$candidate" "$@"
done
exit 0
