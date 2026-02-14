#!/bin/bash
pane_path=$(tmux display -p '#{pane_current_path}' 2>/dev/null)
if [ -n "$pane_path" ] && [ -d "$pane_path" ]; then
  branch=$(cd "$pane_path" && git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    printf "#[fg=#e0af68,bg=#1f2335,none]#[fg=#1a1b26,bg=#e0af68,bold]  %s #[fg=#1f2335,bg=#e0af68,none]" "$branch"
  fi
fi
