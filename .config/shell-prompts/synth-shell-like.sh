# ~/.config/custom-prompt.sh

sep=""
git_end_sep="\[\e[38;5;173m\]$sep\[\e[0m\]"
git_yes_sep="\[\e[48;5;173;38;5;15m\]$sep\[\e[0m\]"
git_not_sep="\[\e[38;5;15m\]$sep\[\e[0m\]"

getBranch() {
  # Only continue if we're in a Git repository
  git rev-parse --is-inside-work-tree &>/dev/null || { echo ""; return; }

  # Get branch name or short commit hash
  ref=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

  # Get git status
  git_status=$(git status --porcelain=2 --branch 2>/dev/null)
  ab_status=$(echo "$git_status" | awk -F '^# branch.ab ' '{print $2}')

  # Extract ahead/behind values
  ahead=$(echo "$ab_status" | awk '{print $1}' | tr -d '\n')
  behind=$(echo "$ab_status" | awk '{print $2}' | tr -d '\n')

  # Default if empty
  ahead=${ahead:-0}
  behind=${behind:-0}

  # Compose remote status
  remote_status=""
  if [[ "$ahead" -gt 0 ]]; then
    remote_status=" $ahead"
  fi
  if [[ "$behind" -gt 0 ]]; then
    remote_status="$remote_status $behind"
  fi

  # Indicators
  dirty=""
  staged=""
  untracked=""
  echo "$git_status" | grep '^1 ' &>/dev/null && staged="+"
  echo "$git_status" | grep '^2 ' &>/dev/null && dirty="*"
  echo "$git_status" | grep '^? ' &>/dev/null && untracked="?"
  status="$staged$dirty$untracked"
  [ -n "$status" ] && status=" $status"

  # Print final status
  printf ' %s%s%s' "$ref" "$remote_status" "$status"
}

export PS1="\
\[\e[48;5;137;38;5;255;1m\] \u \[\e[0m\]\
\[\e[48;5;180;38;5;137m\]$sep\[\e[0m\]\
\[\e[48;5;180;38;5;242;1m\] \h \[\e[0m\]\
\[\e[48;5;15;38;5;180m\]$sep\[\e[0m\]\
\[\e[48;5;15;38;5;242;1m\] \W \[\e[0m\]\
$git_yes_sep\
\[\e[48;5;173;38;5;255;1m\] \$(getBranch) \[\e[0m\]\\
$git_end_sep "

export PS1="\n$PS1"
