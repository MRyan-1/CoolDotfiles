# Tmux Initialization SOP

## Plugins

| Plugin | Source | Description |
|--------|--------|-------------|
| tpm | tmux-plugins/tpm | Tmux Plugin Manager |
| tmux-resurrect | tmux-plugins/tmux-resurrect | Save/restore tmux sessions (tmux-continuum dependency) |
| tmux-continuum | tmux-plugins/tmux-continuum | Auto-save tmux environment every 15 min |
| tmux-open | tmux-plugins/tmux-open | Open selected file/URL from copy mode |

## Plugin Configuration (in `~/.tmux.conf.local`)

```bash
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @continuum-restore 'off'   # auto-save only, no auto-restore
set -g @plugin 'tmux-plugins/tmux-open'
```

> **Note**: `tpm` is built-in to Oh my tmux!, do NOT add `set -g @plugin 'tmux-plugins/tpm'` or `run '~/.tmux/plugins/tpm/tpm'`.

## Setup Steps

复制 /.tmux 目录下的 .tmux.conf 和.tmux.conf.local 到根目录，后执行 tmux source ~/.tmux.conf
