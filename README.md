# dev-env

Portable shell and tmux setup.

## Includes

- Zsh prompt with timestamp, full working path, git branch, and color.
- Bash fallback prompt with the same style for Linux or explicit Bash sessions.
- Shared shell settings in `.shell_common` to keep Bash and Zsh aligned.
- Vim mode enabled by default for Zsh and Bash/readline.
- fzf key bindings and reverse-layout history search.
- Ghostty installed on macOS via Homebrew cask.
- Hammerspoon installed on macOS with window/app hotkeys.
- tmux config using `` ` `` as the prefix.
- tmux pane navigation with prefix + `h`, `j`, `k`, `l`.
- tmux window navigation with prefix + `H` and `L`.
- tmux mouse mode disabled so normal terminal mouse selection works.
- tmux active pane highlighting and pane titles.

## Install

```bash
git clone <repo-url> ~/dev-env
cd ~/dev-env
./install.sh
```

The installer backs up existing dotfiles into `~/.dotfiles-backup/<timestamp>/`
before replacing them with symlinks.

On macOS, the installer installs Ghostty when Homebrew is available. macOS does
not expose a reliable universal default-terminal setting, so use Ghostty as the
terminal app for this setup after installation.

The installer also installs Hammerspoon and links `~/.hammerspoon/init.lua`.
Open Hammerspoon once and grant Accessibility permission for the window
shortcuts to work.

## Hammerspoon Shortcuts

- `Option` + `Left`: left half
- `Option` + `Right`: right half
- `Option` + `Up`: top half
- `Option` + `Down`: bottom half
- `Option` + `S`: focus Ghostty
- `Option` + `Space`: focus Google Chrome

## Files

- `.bashrc`
- `.zshrc`
- `.shell_common`
- `.inputrc`
- `.tmux.conf`
- `hammerspoon/init.lua`
- `install.sh`
