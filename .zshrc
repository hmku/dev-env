# Shared interactive Zsh configuration.

[[ -o interactive ]] || return 0

source "${DEV_ENV_DIR:-$HOME}/.shell_common"

# Prefer vi editing mode.
bindkey -v
export KEYTIMEOUT=1

# History behavior.
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=100000
setopt append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

# Prompt: timestamp + full path, with git branch when available.
setopt prompt_subst

PROMPT='%F{244}[%*]%f %F{33}%/%f%F{37}$(dev_env_git_branch)%f %F{40}%#%f '

if [[ -n "${GHOSTTY_RESOURCES_DIR:-}" && -r "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration" ]]; then
  source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi

# fzf integration, if installed. Key bindings need a real terminal.
if [[ -t 0 && -t 1 ]]; then
  if [[ -f "$HOME/.fzf/shell/key-bindings.zsh" ]]; then
    source "$HOME/.fzf/shell/key-bindings.zsh"
  elif [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
    source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  elif [[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]]; then
    source /usr/local/opt/fzf/shell/key-bindings.zsh
  elif [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
  fi
fi
