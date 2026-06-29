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
- tmux mouse mode enabled for click-to-focus pane switching.
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

The installer also installs Hammerspoon, links `~/.hammerspoon/init.lua`, opens
Hammerspoon, and opens the macOS Accessibility settings pane. The Hammerspoon
config enables launch at login. Enable Hammerspoon in System Settings > Privacy
& Security > Accessibility. Window shortcuts will not work until that permission
is granted.

## Hammerspoon Shortcuts

- `Option` + `Left`: left half; press again from the left half to move to the monitor on the left
- `Option` + `Right`: right half; press again from the right half to move to the monitor on the right
- `Option` + `Up`: top half
- `Option` + `Down`: bottom half
- `Option` + `F`: maximize; press again to restore the previous size
- `Option` + `1`: reload Hammerspoon config
- `Option` + `S`: open or focus Ghostty
- `Option` + `Space`: open or focus Google Chrome

## Files

- `.bashrc`
- `.zshrc`
- `.shell_common`
- `.inputrc`
- `.tmux.conf`
- `hammerspoon/init.lua`
- `install.sh`
