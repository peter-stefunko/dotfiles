# shellcheck shell=bash
# Shared helpers for the long-running (event-driven) waybar module scripts.
# Source it, don't run it.
#
# Waybar config notes for modules using these scripts:
#   - omit "interval" entirely; a numeric interval (even 0) makes waybar
#     re-run the script on a timer (0 is clamped to every 1 ms!).
#   - set "restart-interval" so waybar restarts the script if its monitor dies.

# Loadable builtin: `sleep` without forking a process each time.
enable -f /usr/lib/bash/sleep sleep 2>/dev/null

_wb_stat() {
    local s
    read -r s < /proc/$$/stat
    s=${s##*) }           # drop "pid (comm) "; comm may contain spaces
    set -- $s             # $1=state $2=ppid $3=pgrp
    _wb_ppid=$2 _wb_pgrp=$3
}

# wb_init "$@" — call first. Ensures the script leads its own process group
# (waybar already does this) and kills that whole group on exit, so event
# monitors started by the script die with it instead of lingering as orphans.
# Define a function `wb_on_exit` before calling to run extra cleanup.
wb_init() {
    _wb_stat
    [[ $_wb_pgrp == "$$" ]] || exec setsid "$0" "$@"
    trap 'trap - EXIT; declare -F wb_on_exit >/dev/null && wb_on_exit; trap "" TERM; kill -TERM 0 2>/dev/null' EXIT
    trap 'exit 0' TERM INT HUP PIPE
}

# wb_sleep SECONDS — fork-free sleep that, unlike the loadable `sleep`,
# is interrupted by signals immediately (read on a pipe nobody writes to).
wb_sleep() {
    [[ -n ${_wb_sleep_fd-} ]] || exec {_wb_sleep_fd}<> <(:)
    read -r -t "$1" -u "$_wb_sleep_fd" _
}

# True once waybar is gone (we got re-parented).
wb_orphaned() {
    _wb_stat
    [[ $_wb_ppid != "$PPID" ]]
}

# wb_print TEXT — send TEXT to waybar only if it changed (an empty line hides
# the module). Writing to a dead waybar raises SIGPIPE -> exit.
_wb_last=$'\x01'
wb_print() {
    [[ $1 == "$_wb_last" ]] && return 0
    printf '%s\n' "$1" || exit 0
    _wb_last=$1
}

# wb_wait_event FD — block until the next line arrives on FD, then swallow the
# rest of a burst (e.g. a monitor's initial dump) so the caller updates once.
# Returns 1 on EOF (the monitor died). Exits if waybar went away.
wb_wait_event() {
    local fd=$1 line rc n=0
    while :; do
        read -r -t 30 -u "$fd" line
        rc=$?
        (( rc == 0 )) && break
        (( rc > 128 )) || return 1      # EOF
        wb_orphaned && exit 0           # 30 s of silence: is waybar still there?
    done
    while (( n++ < 1000 )) && read -r -t 0.1 -u "$fd" line; do :; done
    return 0
}
