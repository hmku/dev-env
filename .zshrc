# Shared interactive Zsh configuration.

[[ -o interactive ]] || return 0

# Prefer vi editing mode.
bindkey -v
export KEYTIMEOUT=1
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-vim}"

# History behavior.
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=100000
setopt append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

# Colors.
autoload -Uz colors
colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -G'
alias grep='grep --color=auto'

# Prompt: timestamp + full path, with git branch when available.
setopt prompt_subst

prompt_git_branch() {
  command -v git >/dev/null 2>&1 || return 0
  local branch
  branch="$(git branch --show-current 2>/dev/null)"
  [[ -n "$branch" ]] && printf ' (%s)' "$branch"
}

PROMPT='%F{244}[%*]%f %F{33}%~%f%F{37}$(prompt_git_branch)%f %F{40}%#%f '

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

if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:-} --height=40% --layout=reverse --border"
fi
