# dev-env

Portable shell and tmux setup.

## Includes

- Zsh prompt with timestamp, full working path, git branch, and color.
- Bash fallback prompt with the same style for Linux or explicit Bash sessions.
- Vim mode enabled by default for Zsh and Bash/readline.
- fzf key bindings and reverse-layout history search.
- tmux config using `` ` `` as the prefix.
- tmux pane navigation with prefix + `h`, `j`, `k`, `l`.
- tmux window navigation with prefix + `H` and `L`.
- tmux mouse mode disabled so normal terminal mouse selection works.
- macOS dark appearance and dark Terminal.app profile setup.

## Install

```bash
git clone <repo-url> ~/dev-env
cd ~/dev-env
./install.sh
```

The installer backs up existing dotfiles into `~/.dotfiles-backup/<timestamp>/`
before replacing them with symlinks.

## Files

- `.bashrc`
- `.zshrc`
- `.inputrc`
- `.tmux.conf`
- `install.sh`
