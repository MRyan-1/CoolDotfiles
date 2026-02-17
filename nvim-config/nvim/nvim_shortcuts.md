# Neovim (LunarVim) 快捷键速查

> Leader 键: `,` (逗号)

## 核心操作

  Ctrl+s        保存文件
  ,w            保存
  ,W            保存 (不触发格式化)
  ,q            退出 (带确认)
  ,e            切换文件树 NvimTree
  ,f            查找项目文件
  ,h            清除搜索高亮
  ,/            切换行注释
  ,c            关闭当前 buffer
  ,;            打开 Dashboard
  ,?            本快捷键速查 (浮窗)
  jk            退出 Insert 模式 (替代 Esc)

## 窗口 / 终端 / Buffer

  Ctrl+h/j/k/l  窗口导航 (兼容 tmux)
  Ctrl+方向键    调整窗口大小
  Shift+H       上一个 buffer
  Shift+L       下一个 buffer
  ,bc           关闭所有 buffer 只留当前
  Ctrl+\        切换浮动终端
  Alt+1         水平终端
  Alt+2         垂直终端
  Alt+3         浮动终端

## 移动 / 编辑增强

  Alt+j         行/块下移 (Normal/Insert/Visual)
  Alt+k         行/块上移 (Normal/Insert/Visual)
  Ctrl+d        半页下跳 (自动居中)
  Ctrl+u        半页上跳 (自动居中)
  J             合并行 (光标不跳走)
  p (Visual)    粘贴不覆盖寄存器

## LSP (代码智能)

  K             悬浮文档
  gd            跳转到定义
  gD            跳转到声明
  gr            查看引用
  gI            跳转到实现
  gs            签名帮助
  gl            行内诊断
  ,la           代码操作 (Code Action)
  ,ld           Buffer 诊断列表
  ,lf           格式化
  ,lr           重命名
  ,ls           文档符号列表
  ,lS           工作区符号
  ,lj / ,lk     下/上一个诊断
  ,li           LspInfo
  ,lI           Mason 管理

## Git (,g)

  ,gg           打开 Lazygit
  ,gj / ,gk     下/上一个 hunk
  ,gl           Blame 当前行
  ,gp           预览 hunk
  ,gs           Stage hunk
  ,gr           重置 hunk
  ,gR           重置整个 buffer
  ,go           Git 状态 (Telescope)
  ,gb           分支列表
  ,gc           提交历史
  ,gd           Git diff

## 搜索 (,s)

  ,st           全文搜索 (Live Grep)
  ,sf           查找文件
  ,sr           最近文件
  ,sb           分支列表
  ,sc           颜色主题
  ,sh           帮助文档
  ,sk           快捷键列表
  ,sC           命令列表
  ,sl           恢复上次搜索

## Buffer (,b)

  ,bj           跳转到 buffer
  ,bf           查找 buffer
  ,bb / ,bn     上/下一个 buffer
  ,be           选择关闭 buffer
  ,bh / ,bl     关闭左/右侧 buffer

## 调试 DAP (,d)

  ,dt           设置断点
  ,dc           继续
  ,di           步入
  ,do           步过
  ,du           步出
  ,dU           切换 DAP UI
  ,dq           退出调试

## 注释

  gcc           切换行注释
  gbc           切换块注释
  gcO / gco     上方/下方添加注释
  gcA           行尾添加注释

## 补全 (CMP)

  Ctrl+Space    触发补全
  Ctrl+j/k      下/上一项
  Tab/S-Tab     下/上一项 或 Snippet 跳转
  Ctrl+y        确认选择
  Ctrl+e        取消
  Enter         确认

## NvimTree 文件树

  l / Enter     打开文件
  h             折叠目录
  v             垂直分屏打开
  C             cd 进入目录

## 插件管理 (,p)

  ,ps           Lazy sync
  ,pu           Lazy update
  ,pi           Lazy install
  ,pc           Lazy clean

## 复制模式

  v             开始选择
  y             复制 (Yank)
  Esc           退出
  /             向下搜索
  ?             向上搜索
