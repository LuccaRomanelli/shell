#!/usr/bin/env bash
set -euo pipefail

POMO_DIR="$HOME/.pomodoro"
OBSIDIAN_DIR="$HOME/obisidian/pomodoro"
SESSIONS_FILE="$POMO_DIR/sessions.json"
WAYBAR_FILE="$POMO_DIR/waybar.json"

mkdir -p "$POMO_DIR" "$OBSIDIAN_DIR"
[ -f "$SESSIONS_FILE" ] || echo '[]' > "$SESSIONS_FILE"

# --- Helpers ---

cleanup() {
  printf '\e[?25h' # restore cursor
  rm -f "$WAYBAR_FILE"
  if [[ -n "${_PARTIAL_START:-}" ]]; then
    local end now_ts duration
    end=$(date +%T)
    now_ts=$(date +%s)
    duration=$(( now_ts - _PARTIAL_TS ))
    if [[ "$_PARTIAL_TYPE" == "work" && $duration -ge 5 ]]; then
      log_session "$_PARTIAL_DATE" "$_PARTIAL_START" "$end" "$_PARTIAL_TYPE" \
        "$_PARTIAL_MODE" "$duration" "$_PARTIAL_TASK" false
    fi
  fi
  exit 0
}
trap cleanup SIGINT SIGTERM

notify() {
  local msg="$1"
  notify-send "Pomodoro" "$msg" 2>/dev/null || true
  paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null &
}

log_session() {
  local date="$1" start="$2" end="$3" type="$4" mode="$5" dur="$6" task="$7" completed="$8"
  local logfile="$POMO_DIR/$date.log"
  local status_str; $completed && status_str="completed" || status_str="partial"
  local mins=$(( dur / 60 ))
  local secs=$(( dur % 60 ))
  local dur_fmt="${mins}m$(printf '%02d' $secs)s"

  # Plain text log
  echo "[$end] END   $type ${dur_fmt} [$status_str]" >> "$logfile"

  # JSON
  local tmp=$(mktemp)
  jq --arg d "$date" --arg s "$start" --arg e "$end" --arg t "$type" \
     --arg m "$mode" --argjson dur "$dur" --arg task "$task" \
     --argjson comp "$completed" \
    '. += [{"date":$d,"start":$s,"end":$e,"type":$t,"mode":$m,
            "duration_seconds":$dur,"task":$task,"completed":$comp}]' \
    "$SESSIONS_FILE" > "$tmp" && mv "$tmp" "$SESSIONS_FILE"

  # Obsidian markdown
  regen_obsidian "$date"
}

regen_obsidian() {
  local date="$1"
  local mdfile="$OBSIDIAN_DIR/$date.md"
  local rows count=0 total=0

  rows=$(jq -r --arg d "$date" '
    [.[] | select(.date==$d)] | to_entries[] |
    "| \(.key+1) | \(.value.type) | \(.value.task // "-") | \(.value.start) | \((.value.duration_seconds/60|floor))m | \(if .value.completed then "done" else "partial" end) |"
  ' "$SESSIONS_FILE")

  count=$(jq --arg d "$date" '[.[] | select(.date==$d and .type=="work")] | length' "$SESSIONS_FILE")
  total=$(jq --arg d "$date" '[.[] | select(.date==$d and .type=="work") | .duration_seconds] | add // 0 | ./60 | floor' "$SESSIONS_FILE")

  cat > "$mdfile" <<EOF
# Pomodoro - $date
| # | Type | Task | Start | Duration | Status |
|---|------|------|-------|----------|--------|
$rows

**Total focus: ${total}m | Sessions: $count**
EOF
}

update_waybar() {
  local text="$1" tooltip="$2" class="$3"
  printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$text" "$tooltip" "$class" > "$WAYBAR_FILE"
}

countdown() {
  local label="$1" total_secs="$2" type="$3" mode="$4" task="$5" cycle="$6" cycles="$7"
  local bar_width=30
  local date_today start_time
  date_today=$(date +%F)
  start_time=$(date +%T)

  # Log start to plain text
  echo "[$start_time] START $type ($mode) \"$task\"" >> "$POMO_DIR/$date_today.log"

  # Set partial tracking for cleanup
  _PARTIAL_START="$start_time"
  _PARTIAL_TS=$(date +%s)
  _PARTIAL_TYPE="$type"
  _PARTIAL_MODE="$mode"
  _PARTIAL_TASK="$task"
  _PARTIAL_DATE="$date_today"

  printf '\e[?25l' # hide cursor

  local remaining=$total_secs
  while (( remaining > 0 )); do
    local elapsed=$(( total_secs - remaining ))
    local pct=$(( elapsed * 100 / total_secs ))
    local filled=$(( elapsed * bar_width / total_secs ))
    local empty=$(( bar_width - filled ))
    local mins=$(( remaining / 60 ))
    local secs=$(( remaining % 60 ))
    local time_str=$(printf '%02d:%02d' $mins $secs)

    local bar=""
    (( filled > 0 )) && bar=$(printf '█%.0s' $(seq 1 $filled))
    (( empty > 0 )) && bar+=$(printf '░%.0s' $(seq 1 $empty))

    local type_upper=$(echo "$type" | tr '[:lower:]' '[:upper:]')
    printf '\r\e[K  %s  %s  %s  %3d%%' "$type_upper" "$bar" "$time_str" "$pct"

    # Waybar
    update_waybar "P $time_str [$cycle/$cycles]" "$type_upper: ${task:-none}\\nSession $cycle of $cycles" "$type"

    sleep 1
    remaining=$(( remaining - 1 ))
  done

  printf '\r\e[K' # clear line
  printf '\e[?25h' # restore cursor

  # Log completed session
  local end_time=$(date +%T)
  local actual_dur=$total_secs
  log_session "$date_today" "$start_time" "$end_time" "$type" "$mode" "$actual_dur" "$task" true

  # Clear partial tracking
  _PARTIAL_START=""

  # Notify
  if [[ "$type" == "work" ]]; then
    notify "Work session done! Time for a break."
  else
    notify "Break over! Back to work."
  fi
}

# --- Stats ---

show_stats() {
  local filter="$1" # "today" or "week"
  local date_filter

  if [[ "$filter" == "today" ]]; then
    date_filter=$(date +%F)
    echo "=== Today ($date_filter) ==="
    jq -r --arg d "$date_filter" '
      [.[] | select(.date==$d and .type=="work")] |
      "Completed: \([.[] | select(.completed)] | length)/\(length) sessions",
      "Total focus: \(([.[] | select(.completed) | .duration_seconds] | add // 0) / 60 | floor)m",
      "",
      (group_by(.task)[] |
        "  \(.[0].task // "(no label)"): \(length) session(s), \(([.[].duration_seconds] | add) / 60 | floor)m")
    ' "$SESSIONS_FILE"
  else
    local week_start=$(date -d "last monday" +%F 2>/dev/null || date -d "monday" +%F)
    echo "=== This Week (from $week_start) ==="
    jq -r --arg ws "$week_start" '
      [.[] | select(.date >= $ws and .type=="work")] |
      "Completed: \([.[] | select(.completed)] | length)/\(length) sessions",
      "Total focus: \(([.[] | select(.completed) | .duration_seconds] | add // 0) / 60 | floor)m",
      "",
      (group_by(.task)[] |
        "  \(.[0].task // "(no label)"): \(length) session(s), \(([.[].duration_seconds] | add) / 60 | floor)m")
    ' "$SESSIONS_FILE"
  fi
}

# --- Session Runner ---

run_session() {
  local mode="$1" task="$2" work short long cycles

  case "$mode" in
    classic) work=1500; short=300;  long=900;  cycles=4 ;;
    deep)    work=3000; short=600;  long=1200; cycles=4 ;;
    custom)
      read -rp "Work minutes: " w; work=$(( w * 60 ))
      read -rp "Short break minutes: " s; short=$(( s * 60 ))
      read -rp "Long break minutes: " l; long=$(( l * 60 ))
      read -rp "Cycles: " cycles
      ;;
  esac

  clear
  echo "Starting $mode pomodoro${task:+ — task: $task}"
  echo ""

  while true; do
    for (( c=1; c<=cycles; c++ )); do
      countdown "work" "$work" "work" "$mode" "$task" "$c" "$cycles"

      if (( c < cycles )); then
        countdown "short break" "$short" "short_break" "$mode" "$task" "$c" "$cycles"
      else
        countdown "long break" "$long" "long_break" "$mode" "$task" "$c" "$cycles"
      fi
    done
    echo ""
    echo "Cycle complete! Starting another round..."
    echo ""
  done
}

# --- Main (fzf interactive) ---

main() {
  local action
  action=$(printf 'Start Session\nToday'\''s Stats\nWeek Stats' | fzf --prompt="Pomodoro > " --height=~10 --reverse)

  case "$action" in
    "Start Session")
      local mode
      mode=$(printf 'Classic (25/5)\nDeep (50/10)\nCustom' | fzf --prompt="Mode > " --height=~10 --reverse)
      case "$mode" in
        "Classic (25/5)") mode="classic" ;;
        "Deep (50/10)")   mode="deep" ;;
        "Custom")         mode="custom" ;;
      esac

      local task=""
      read -rp "Task label (optional): " task

      run_session "$mode" "$task"
      ;;
    "Today's Stats")
      show_stats "today"
      ;;
    "Week Stats")
      show_stats "week"
      ;;
  esac
}

main
