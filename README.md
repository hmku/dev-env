# dev-env

Portable shell and tmux setup.

## Includes

- Bash prompt with timestamp, full working path, git branch, and color.
- Vim mode enabled by default for Bash/readline.
- fzf key bindings and reverse-layout history search.
- tmux config using `` ` `` as the prefix.
- tmux pane navigation with prefix + `h`, `j`, `k`, `l`.
- tmux window navigation with prefix + `H` and `L`.

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
- `.inputrc`
- `.tmux.conf`
- `install.sh`
