# 1. 用“完美配置”覆盖仓库里的配置文件
mv -f ~/.tmux/ideal_tmux.conf.local ~/.tmux/.tmux.conf.local
# 2. 清理 Home 目录的旧实体文件
rm ~/.tmux.conf ~/.tmux.conf.local
# 3. 重新建立指向仓库的软链接 (这一步让 Home 目录变干净)
ln -s ~/.tmux/.tmux.conf ~/.tmux.conf
ln -s ~/.tmux/.tmux.conf.local ~/.tmux.conf.local
# 4. 删除多余的说明文档 (既然已经配置好了，就不需要复现指南了)
rm ~/.tmux/REPRODUCE_MY_CONFIG.md ~/.tmux/TMUX_INITIALIZATION_SOP.md
# 5. 生效
tmux source-file ~/.tmux.conf