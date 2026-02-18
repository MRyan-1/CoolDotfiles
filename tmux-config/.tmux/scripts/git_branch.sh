#!/bin/bash
# Git branch block in Indicators segment (bg #1a1b26)
# Draws a self-contained yellow block with left/right arrows
# Outputs nothing when not in a git repo
pane_path=$(tmux display -p '#{pane_current_path}' 2>/dev/null)
if [ -n "$pane_path" ] && [ -d "$pane_path" ]; then
  branch=$(cd "$pane_path" && git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    # Indicators segment bg (same as status bar bg)
    BAR_BG="#1a1b26"
    # Git pill colors
    PILL_FG="#1a1b26"
    PILL_BG="#e0af68"
    # U+E0B2 left-pointing arrow (same as framework uses on right side)
    ARROW=$'\xee\x82\xb2'
    ICON=$'\xef\x84\xa6'  # U+F126 git branch
    # [left arrow: yellow on bar bg] [content: black on yellow] [right arrow: bar bg on yellow]
    printf " #[fg=${PILL_BG},bg=${BAR_BG},none]${ARROW}#[fg=${PILL_FG},bg=${PILL_BG},bold] ${ICON} %s #[fg=${BAR_BG},bg=${PILL_BG},none]${ARROW}#[fg=#565f89,bg=${BAR_BG},none]" "$branch"
  fi
fi
