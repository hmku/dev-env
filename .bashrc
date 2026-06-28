# Shared interactive Bash configuration.

if [[ -z "${BASH_VERSION:-}" ]]; then
  return 0 2>/dev/null || exit 0
fi

case $- in
  *i*) ;;
  *) return ;;
esac

source "${DEV_ENV_DIR:-$HOME}/.shell_common"

# Prefer vi editing mode in Bash/readline.
set -o vi

# History behavior.
export HISTSIZE=50000
export HISTFILESIZE=100000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# Prompt: timestamp + full path, with git branch when available.
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

  PS1="${dim}[\A]${reset} ${blue}${PWD}${cyan}$(dev_env_git_branch)${reset} ${status_color}\\$${reset} "
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
