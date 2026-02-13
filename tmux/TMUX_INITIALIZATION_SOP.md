# TMUX 初始化 (SOP)

复制 /.tmux 目录下的 .tmux.conf 和.tmux.conf.local 到根目录，后执行 tmux source ~/.tmux.conf

本文档列出当前 tmux 配置中所有需要第三方依赖的脚本和功能，以及对应的安装命令。

## 一、TPM 插件依赖

### 1. TPM (Tmux Plugin Manager)
**用途**: 插件管理器，管理所有其他插件
**安装路径**: `~/.tmux/plugins/tpm`
**安装命令**:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### 2. tmux-resurrect
**用途**: 保存和恢复 tmux 会话（支持系统重启后恢复）
**安装路径**: `~/.tmux/plugins/tmux-resurrect`
**安装命令** (通过 TPM):
```bash
# 在 tmux 中按 prefix + I 安装
# 或手动克隆:
git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect
```

### 3. tmux-continuum
**用途**: 自动保存 tmux 会话，支持开机自动恢复
**安装路径**: `~/.tmux/plugins/tmux-continuum`
**安装命令** (通过 TPM):
```bash
# 在 tmux 中按 prefix + I 安装
# 或手动克隆:
git clone https://github.com/tmux-plugins/tmux-continuum ~/.tmux/plugins/tmux-continuum
```

### 4. tmux-open
**用途**: 在 tmux 中快速打开选中的 URL 或文件
**安装路径**: `~/.tmux/plugins/tmux-open`
**安装命令** (通过 TPM):
```bash
# 在 tmux 中按 prefix + I 安装
# 或手动克隆:
git clone https://github.com/tmux-plugins/tmux-open ~/.tmux/plugins/tmux-open
```

---

## 二、状态栏监控脚本依赖

### 1. GPU 监控脚本
**脚本路径**: `~/.tmux/scripts/macmon_gpu.sh`
**功能**: 显示 GPU 使用率（通过 macmon 读取 Apple Silicon GPU 数据）
**依赖**:

#### macmon (必需)
**用途**: macOS Apple Silicon GPU/CPU 监控工具
**安装命令**:
```bash
brew install macmon
```
**验证安装**:
```bash
/opt/homebrew/bin/macmon --version
```

#### jq (必需)
**用途**: JSON 解析器，用于解析 macmon 输出的 JSON
**安装命令**:
```bash
brew install jq
```
**验证安装**:
```bash
/opt/homebrew/bin/jq --version
```

### 2. 内存监控脚本
**脚本路径**: `~/.tmux/scripts/memory_usage.sh`
**功能**: 显示内存使用情况（已用/总共/百分比）
**依赖**: 仅使用系统内置命令 (`sysctl`, `vm_stat`, `awk`)
**系统要求**: macOS

### 3. CPU 监控脚本
**脚本路径**: `~/.tmux/scripts/cpu_usage.sh`
**功能**: 显示 CPU 使用率
**依赖**: 仅使用系统内置命令 (`iostat`, `awk`)
**系统要求**: macOS

---

## 三、快捷键 Popup 功能依赖

### 1. lazygit (prefix + g)
**用途**: 终端图形化 Git 客户端，在 popup 窗口中使用
**安装命令**:
```bash
brew install lazygit
```
**验证安装**:
```bash
lazygit --version
```

### 2. htop (prefix + T)
**用途**: 交互式进程查看器，在 popup 窗口中使用
**安装命令**:
```bash
brew install htop
```
**验证安装**:
```bash
htop --version
```

---

## 四、字体依赖（可选但推荐）

### Nerd Fonts
**用途**: 显示状态栏中的特殊图标（如 git 分支图标 ``、powerline 箭头 `` ``）
**推荐字体**:
- JetBrainsMono Nerd Font
- FiraCode Nerd Font
- MesloLGS Nerd Font

**安装命令**:
```bash
# 通过 Homebrew 安装
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font

# 或手动下载安装
# https://www.nerdfonts.com/font-downloads
```

**终端配置**:
在 iTerm2/终端中，将字体设置为已安装的 Nerd Font。

---

## 五、一键安装脚本

```bash
#!/bin/bash
# tmux_dependencies_install.sh

echo "=== 安装 tmux 配置依赖 ==="

# 1. 安装 Homebrew (如果未安装)
if ! command -v brew &> /dev/null; then
    echo "安装 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2. 安装系统工具
echo "安装系统监控工具..."
brew install macmon jq htop lazygit

# 3. 安装 TPM
echo "安装 TPM..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 2>/dev/null || echo "TPM 已存在"

# 4. 安装插件
echo "安装 tmux 插件..."
~/.tmux/plugins/tpm/bin/install_plugins 2>/dev/null || echo "请在 tmux 中运行: prefix + I"

# 5. 安装字体 (可选)
echo "安装 Nerd Font..."
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font 2>/dev/null || echo "字体安装失败，可手动安装"

echo "=== 安装完成 ==="
echo "请在终端中设置字体为 'JetBrainsMono Nerd Font'"
echo "然后在 tmux 中按 prefix + I 安装插件"
```

---

## 六、验证清单

安装完成后，逐项验证：

- [ ] `tmux -V` ≥ 3.6
- [ ] `which tmux` 显示正确路径
- [ ] `ls ~/.tmux/plugins/tpm` 存在
- [ ] `ls ~/.tmux/plugins/tmux-resurrect` 存在
- [ ] `ls ~/.tmux/plugins/tmux-continuum` 存在
- [ ] `ls ~/.tmux/plugins/tmux-open` 存在
- [ ] `macmon --version` 正常工作
- [ ] `jq --version` 正常工作
- [ ] `lazygit --version` 正常工作
- [ ] `htop --version` 正常工作
- [ ] 在 tmux 中按 `prefix + g` 能打开 lazygit
- [ ] 在 tmux 中按 `prefix + T` 能打开 htop
- [ ] 状态栏显示 MEM/CPU/GPU 数据

---

## 七、故障排除

### 问题: GPU 显示 "N/A"
**原因**: macmon 或 jq 未安装/未找到
**解决**:
```bash
which macmon  # 应显示 /opt/homebrew/bin/macmon
which jq      # 应显示 /opt/homebrew/bin/jq
brew install macmon jq
```

### 问题: 图标显示为方块或乱码
**原因**: 未安装 Nerd Font 或终端未配置
**解决**:
1. 安装 Nerd Font: `brew install --cask font-jetbrains-mono-nerd-font`
2. 在终端设置中将字体改为 Nerd Font

### 问题: 插件未加载
**原因**: TPM 未安装或插件未下载
**解决**:
```bash
# 重新安装 TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 在 tmux 中重新加载并安装插件
tmux source-file ~/.tmux.conf
tmux prefix + I  # 大写 I
```

---

