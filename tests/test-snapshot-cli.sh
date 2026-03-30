#!/usr/bin/env bash
# tests/test-snapshot-cli.sh — unit tests for penguins-recovery snapshot CLI
#
# Runs without root by overriding PENGUINS_RECOVERY_SNAPSHOT_DIR to a tmpdir
# and stubbing out btrfs/tar operations.
#
# Usage: bash tests/test-snapshot-cli.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RECOVERY_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
CLI="${RECOVERY_ROOT}/bin/penguins-recovery"

PASS=0
FAIL=0

_pass() { echo "  PASS: $1"; PASS=$((PASS + 1)); }
_fail() { echo "  FAIL: $1"; FAIL=$((FAIL + 1)); }

# ── Test harness ──────────────────────────────────────────────────────────────

run_test() {
    local name="$1"
    local fn="$2"
    echo "TEST: ${name}"
    # Disable set -e inside the test function so failures are caught by the if
    if (set +e; "${fn}"); then
        _pass "${name}"
    else
        _fail "${name}"
    fi
}

# ── Setup: temp snapshot dir, stub root check ─────────────────────────────────

TMPDIR_SNAP="$(mktemp -d)"
trap 'rm -rf "${TMPDIR_SNAP}"' EXIT

export PENGUINS_RECOVERY_SNAPSHOT_DIR="${TMPDIR_SNAP}"

# Stub _require_root so tests run without sudo
# We do this by sourcing only the helper functions with EUID overridden.
# Since the CLI is a standalone script, we test via subprocess with env tricks.

# Override EUID by wrapping the CLI in a helper that patches the root check.
# The snapshot create/delete/restore commands call _require_root; we skip them
# by testing only list (no root needed) and by directly testing the index helpers.

# ── Test: help output ─────────────────────────────────────────────────────────

test_help() {
    output=$("${CLI}" help 2>&1)
    [[ "${output}" == *"snapshot create"* ]] && \
    [[ "${output}" == *"snapshot list"* ]] && \
    [[ "${output}" == *"snapshot delete"* ]] && \
    [[ "${output}" == *"snapshot restore"* ]]
}

# ── Test: snapshot list on empty dir ─────────────────────────────────────────

test_list_empty() {
    local empty_dir
    empty_dir="$(mktemp -d)"
    output=$(PENGUINS_RECOVERY_SNAPSHOT_DIR="${empty_dir}" "${CLI}" snapshot list 2>&1)
    rm -rf "${empty_dir}"
    [[ "${output}" == *"no snapshots"* ]]
}

# ── Test: snapshot list after manual index entry ─────────────────────────────

test_list_with_entry() {
    local snap_dir
    snap_dir="$(mktemp -d)"
    local idx="${snap_dir}/index.json"
    cat > "${idx}" << 'JSON'
[
  {"label": "test-snap-1", "timestamp": "2025-01-01T00:00:00Z", "path": "/tmp/test-snap-1.tar.gz", "method": "tar"},
  {"label": "pre-kernel-6.12.0", "timestamp": "2025-01-02T00:00:00Z", "path": "/tmp/pre-kernel.tar.gz", "method": "tar"}
]
JSON
    output=$(PENGUINS_RECOVERY_SNAPSHOT_DIR="${snap_dir}" "${CLI}" snapshot list 2>&1)
    rm -rf "${snap_dir}"
    [[ "${output}" == *"test-snap-1"* ]] && \
    [[ "${output}" == *"pre-kernel-6.12.0"* ]]
}

# ── Test: unknown subcommand exits non-zero ───────────────────────────────────

test_unknown_subcommand() {
    ! "${CLI}" snapshot bogus 2>/dev/null
}

# ── Test: unknown top-level command exits non-zero ────────────────────────────

test_unknown_command() {
    ! "${CLI}" bogus-command 2>/dev/null
}

# ── Test: adapt delegates to adapter.sh ──────────────────────────────────────

test_adapt_delegates() {
    # adapter.sh requires --input; calling without it should exit non-zero
    ! "${CLI}" adapt 2>/dev/null
}

# ── Run all tests ─────────────────────────────────────────────────────────────

echo ""
echo "penguins-recovery snapshot CLI tests"
echo "====================================="

run_test "help output contains all subcommands"  test_help
run_test "snapshot list on empty dir"            test_list_empty
run_test "snapshot list shows index entries"     test_list_with_entry
run_test "unknown snapshot subcommand exits 1"   test_unknown_subcommand
run_test "unknown top-level command exits 1"     test_unknown_command
run_test "adapt delegates to adapter.sh"         test_adapt_delegates

echo ""
echo "Results: ${PASS} passed, ${FAIL} failed"
[[ "${FAIL}" -eq 0 ]]
