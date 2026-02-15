# TMUX 初始化 SOP

> 从全新 Oh My Tmux 恢复个人配置的完整依赖清单。

## 基础框架

- **Oh My Tmux** — [gpakosz/.tmux](https://github.com/gpakosz/.tmux)
- 克隆到 `~/.tmux/`，符号链接或复制 `.tmux.conf` 到 `~`，再将 `.tmux.conf.local` 复制到 `~`

## 恢复步骤

1. 克隆 Oh My Tmux 到 `~/.tmux/`
2. 复制 `.tmux/.tmux.conf` → `~/.tmux.conf`
3. 复制 `.tmux.conf.local` → `~/.tmux.conf.local`
4. 复制 `scripts/` 目录到 `~/.tmux/scripts/`
5. 复制 `tmux_shortcuts.md` 到 `~/.tmux/tmux_shortcuts.md`
6. 安装下方所有系统依赖：`brew install fzf fd yq jq htop lazygit macmon`
7. 执行 `tmux source ~/.tmux.conf`，TPM 会自动克隆并安装所有插件
8. 在 LunarVim `~/.config/nvim/config.lua` 中添加 `christoomey/vim-tmux-navigator` 插件

## TPM 插件清单

| 插件 | 用途 | 系统依赖 |
| :--- | :--- | :--- |
| `tmux-plugins/tmux-resurrect` | 手动保存/恢复 tmux 会话 | 无 |
| `tmux-plugins/tmux-continuum` | 自动定时保存会话 | 无 |
| `tmux-plugins/tmux-open` | 复制模式中打开 URL / 文件 | 无 |
| `sainnhe/tmux-fzf` | 模糊搜索 session/window/pane/命令 | `fzf` |
| `christoomey/vim-tmux-navigator` | Ctrl-h/j/k/l 在 vim 和 tmux 间无缝导航 | neovim 端需装同名插件 |
| `joshmedeski/tmux-nerd-font-window-name` | 根据运行程序自动显示 Nerd Font 图标 | `yq`、Nerd Font 字体 |
| `fcsonline/tmux-thumbs` | 快速复制屏幕可见文本（URL/路径/哈希等） | Rust (`cargo`) 首次需编译 |

## 自定义状态栏脚本

| 脚本 | 用途 | 系统依赖 |
| :--- | :--- | :--- |
| `scripts/git_branch.sh` | 状态栏显示 Git 分支名 | `git` |
| `scripts/cpu_usage.sh` | 状态栏显示 CPU 使用率 | `iostat`（macOS 自带） |
| `scripts/memory_usage.sh` | 状态栏显示内存使用量 | `vm_stat`（macOS 自带） |
| `scripts/macmon_gpu.sh` | 状态栏显示 GPU 使用率 | `macmon`、`jq` |

## 自定义快捷键依赖

| 快捷键 | 功能 | 系统依赖 |
| :--- | :--- | :--- |
| `Prefix + g` | 弹窗打开 lazygit | `lazygit` |
| `Prefix + T` | 弹窗打开 htop | `htop` |
| `Prefix + /` | 弹窗 fzf 文件查找 | `fd`、`fzf` |

## 所有 Homebrew 依赖汇总

```bash
brew install fzf fd yq jq htop lazygit macmon
```

> 终端需要安装 **Nerd Font** 字体（如 JetBrainsMono Nerd Font）以支持 Powerline 分隔符和窗口图标。

## Neovim 侧配置

在 LunarVim 的 `~/.config/nvim/config.lua` 中添加：

```lua
lvim.plugins = {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
}
```

使 `Ctrl-h/j/k/l` 在 neovim 分屏和 tmux 窗格之间无缝切换。
