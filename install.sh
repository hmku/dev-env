#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link_file() {
  local source="$1"
  local target="$2"

  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    printf 'ok: %s already linked\n' "$target"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$backup_dir"
    mv "$target" "$backup_dir/"
    printf 'backup: moved %s to %s/\n' "$target" "$backup_dir"
  fi

  ln -s "$source" "$target"
  printf 'link: %s -> %s\n' "$target" "$source"
}

install_packages() {
  if command -v brew >/dev/null 2>&1; then
    brew list fzf >/dev/null 2>&1 || brew install fzf
    brew list tmux >/dev/null 2>&1 || brew install tmux
    if [[ "$(uname -s)" == "Darwin" ]]; then
      brew list --cask ghostty >/dev/null 2>&1 || brew install --cask ghostty
      brew list --cask hammerspoon >/dev/null 2>&1 || brew install --cask hammerspoon
    fi
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y fzf tmux vim git
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y fzf tmux vim git
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --needed fzf tmux vim git
  else
    printf 'warn: no supported package manager found; install fzf, tmux, vim, and git manually\n' >&2
  fi
}

print_terminal_note() {
  [[ "$(uname -s)" == "Darwin" ]] || return 0

  if [[ -d /Applications/Ghostty.app || -d "$HOME/Applications/Ghostty.app" ]]; then
    printf 'ok: Ghostty is installed. Use Ghostty for this environment instead of Terminal.app.\n'
    printf 'note: macOS does not provide a universal default-terminal setting to switch programmatically.\n'
  fi
}

setup_hammerspoon_permissions() {
  [[ "$(uname -s)" == "Darwin" ]] || return 0

  if [[ -d /Applications/Hammerspoon.app || -d "$HOME/Applications/Hammerspoon.app" ]]; then
    open -a Hammerspoon >/dev/null 2>&1 || true
    open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility" >/dev/null 2>&1 || true
    printf 'note: enable Hammerspoon in System Settings > Privacy & Security > Accessibility.\n'
    printf 'note: Hammerspoon window resizing will not work until Accessibility permission is granted.\n'
  fi
}

ensure_bash_profile_sources_bashrc() {
  local profile="$HOME/.bash_profile"
  local marker="# Source shared dev-env Bash config"
  local snippet='[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"'

  touch "$profile"
  if ! grep -Fq "$snippet" "$profile"; then
    {
      printf '\n%s\n' "$marker"
      printf '%s\n' "$snippet"
    } >> "$profile"
    printf 'update: ensured %s sources ~/.bashrc\n' "$profile"
  fi
}

install_packages
link_file "$repo_dir/.shell_common" "$HOME/.shell_common"
link_file "$repo_dir/.bashrc" "$HOME/.bashrc"
link_file "$repo_dir/.zshrc" "$HOME/.zshrc"
link_file "$repo_dir/.inputrc" "$HOME/.inputrc"
link_file "$repo_dir/.tmux.conf" "$HOME/.tmux.conf"
mkdir -p "$HOME/.hammerspoon"
link_file "$repo_dir/hammerspoon/init.lua" "$HOME/.hammerspoon/init.lua"
ensure_bash_profile_sources_bashrc
print_terminal_note
setup_hammerspoon_permissions

printf '\nDone. Open a new shell, or run: source ~/.zshrc\n'
