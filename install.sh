#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

find_brew() {
  if command -v brew >/dev/null 2>&1; then
    command -v brew
    return 0
  fi

  if [[ -x /opt/homebrew/bin/brew ]]; then
    printf '%s\n' /opt/homebrew/bin/brew
    return 0
  fi

  if [[ -x /usr/local/bin/brew ]]; then
    printf '%s\n' /usr/local/bin/brew
    return 0
  fi

  return 1
}

print_homebrew_note() {
  printf 'error: Homebrew installation finished, but brew was not found.\n' >&2
  printf '       Expected brew at /opt/homebrew/bin/brew or /usr/local/bin/brew.\n' >&2
}

install_homebrew() {
  local installer
  local installer_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

  if ! command -v curl >/dev/null 2>&1; then
    printf 'error: curl is required to install Homebrew.\n' >&2
    return 1
  fi

  installer="$(mktemp)"
  printf 'install: Homebrew not found; downloading official installer from %s\n' "$installer_url"
  if ! curl -fsSL "$installer_url" -o "$installer"; then
    rm -f "$installer"
    printf 'error: failed to download the Homebrew installer.\n' >&2
    return 1
  fi

  printf 'install: running Homebrew installer. It may ask for your macOS password.\n'
  if ! /bin/bash "$installer"; then
    rm -f "$installer"
    printf 'error: Homebrew installer failed.\n' >&2
    return 1
  fi

  rm -f "$installer"
}

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

install_brew_packages() {
  local brew_bin="$1"

  "$brew_bin" list fzf >/dev/null 2>&1 || "$brew_bin" install fzf
  "$brew_bin" list tmux >/dev/null 2>&1 || "$brew_bin" install tmux
  if [[ "$(uname -s)" == "Darwin" ]]; then
    "$brew_bin" list --cask ghostty >/dev/null 2>&1 || "$brew_bin" install --cask ghostty
    "$brew_bin" list --cask hammerspoon >/dev/null 2>&1 || "$brew_bin" install --cask hammerspoon
  fi
}

install_packages() {
  local brew_bin

  if brew_bin="$(find_brew)"; then
    install_brew_packages "$brew_bin"
  elif [[ "$(uname -s)" == "Darwin" ]]; then
    install_homebrew
    if brew_bin="$(find_brew)"; then
      install_brew_packages "$brew_bin"
    else
      print_homebrew_note
      return 1
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

open_hammerspoon() {
  local app_path

  if [[ -d /Applications/Hammerspoon.app ]]; then
    app_path="/Applications/Hammerspoon.app"
  elif [[ -d "$HOME/Applications/Hammerspoon.app" ]]; then
    app_path="$HOME/Applications/Hammerspoon.app"
  else
    return 1
  fi

  printf 'open: launching Hammerspoon before opening Accessibility settings\n'
  open "$app_path" >/dev/null 2>&1 || return 1
}

wait_for_hammerspoon() {
  local attempt

  if ! command -v pgrep >/dev/null 2>&1; then
    sleep 2
    return 0
  fi

  for attempt in 1 2 3 4 5 6 7 8 9 10; do
    if pgrep -x Hammerspoon >/dev/null 2>&1; then
      return 0
    fi
    sleep 1
  done

  return 0
}

setup_hammerspoon_permissions() {
  [[ "$(uname -s)" == "Darwin" ]] || return 0

  if [[ -d /Applications/Hammerspoon.app || -d "$HOME/Applications/Hammerspoon.app" ]]; then
    open_hammerspoon || true
    wait_for_hammerspoon
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
