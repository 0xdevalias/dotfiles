codex-with-pricing() {
  local tmp_log exit_code resume_id resume_line

  tmp_log="$(mktemp "${TMPDIR:-/tmp}/codex-with-pricing.XXXXXX")" || return 1

  if [[ -n "${CODEX_WITH_PRICING_DEBUG:-}" ]]; then
    echo "[codex-with-pricing] tmp_log=$tmp_log" >&2
    printf '[codex-with-pricing] running: script -q %q codex' "$tmp_log" >&2
    for arg in "$@"; do
      printf ' %q' "$arg" >&2
    done
    printf '\n' >&2
  fi

  script -q "$tmp_log" codex "$@"
  exit_code=$?

  resume_line="$(
    tail -c 65536 "$tmp_log" 2>/dev/null \
      | LC_ALL=C grep -aoE 'codex resume [0-9a-f-]{36}' \
      | tail -n 1 \
      | tr -d '\r'
  )"

  if [[ -z "$resume_line" ]]; then
    resume_line="$(
      strings "$tmp_log" 2>/dev/null \
        | grep -E 'codex resume [0-9a-f-]{36}' \
        | tail -n 1 \
        | tr -d '\r'
    )"
  fi

  resume_id="${resume_line##*codex resume }"
  if [[ -z "$resume_id" || "$resume_id" == "$resume_line" ]]; then
    resume_id=""
  fi

  if [[ -n "${CODEX_WITH_PRICING_DEBUG:-}" ]]; then
    echo "[codex-with-pricing] exit_code=$exit_code" >&2
    echo "[codex-with-pricing] resume_id=${resume_id:-<none>}" >&2
  fi

  if [[ -n "$resume_id" ]]; then
    codex-session-cost --format cost-only "$resume_id" >&2
  elif [[ -n "${CODEX_WITH_PRICING_DEBUG:-}" ]]; then
    echo "[codex-with-pricing] failed to extract resume ID" >&2
  fi

  if [[ -z "${CODEX_WITH_PRICING_DEBUG:-}" ]]; then
    rm -f "$tmp_log"
  else
    echo "[codex-with-pricing] keeping transcript at: $tmp_log" >&2
  fi

  return "$exit_code"
}
