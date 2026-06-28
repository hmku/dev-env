# Shared interactive Bash configuration.

if [[ -z "${BASH_VERSION:-}" ]]; then
  return 0 2>/dev/null || exit 0
fi

case $- in
  *i*) ;;
  *) return ;;
esac

# Prefer vi editing mode in Bash/readline.
set -o vi
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-vim}"

# History behavior.
export HISTSIZE=50000
export HISTFILESIZE=100000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# Colors.
if command -v dircolors >/dev/null 2>&1; then
  eval "$(dircolors -b)"
fi
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Prompt: timestamp + full path, with git branch when available.
__prompt_git_branch() {
  command -v git >/dev/null 2>&1 || return 0
  local branch
  branch="$(git branch --show-current 2>/dev/null)"
  [[ -n "$branch" ]] && printf ' (%s)' "$branch"
}

__prompt_command() {
  local exit_code=$?
  local reset='\[\e[0m\]'
  local dim='\[\e[2m\]'
  local cyan='\[\e[36m\]'
  local blue='\[\e[34m\]'
  local green='\[\e[32m\]'
  local red='\[\e[31m\]'
  local status_color="$green"

  if [[ $exit_code -ne 0 ]]; then
    status_color="$red"
  fi

  PS1="${dim}[\A]${reset} ${blue}\w${cyan}$(__prompt_git_branch)${reset} ${status_color}\\$${reset} "
}

PROMPT_COMMAND=__prompt_command

# fzf integration, if installed.
if [[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.bash
elif [[ -f /usr/share/fzf/key-bindings.bash ]]; then
  source /usr/share/fzf/key-bindings.bash
elif [[ -f "$HOME/.fzf/shell/key-bindings.bash" ]]; then
  source "$HOME/.fzf/shell/key-bindings.bash"
elif [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.bash ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.bash
elif [[ -f /usr/local/opt/fzf/shell/key-bindings.bash ]]; then
  source /usr/local/opt/fzf/shell/key-bindings.bash
fi

if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:-} --height=40% --layout=reverse --border"
fi
