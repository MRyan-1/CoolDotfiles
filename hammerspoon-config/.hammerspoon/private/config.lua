-- 指定要启用的模块
hspoon_list = {"WinWin", "AClock"}

-- 锁定电脑快捷键绑定
hslock_keys = {"alt", "L"}

-- 窗口自定义大小及位置快捷键绑定
hsresizeM_keys = {"alt", "R"}

-- 重新加载配置文件
hsreload_keys = {{"cmd", "shift", "ctrl"}, "R"}

-- 音量降低
hsVolumeDown_keys = {{"cmd", "alt"}, "Down"}

-- 音量升高
hsVolumeUp_keys = {{"cmd", "alt"}, "Up"}

-- 根据APP自动切换输入法，辅助工具定位
hsImSwitcherAlert_keys = {{"ctrl", "cmd"}, "."}
-- 包含指定切换的APP及语言
ime_switcher.app2Ime = {{'/Applications/iTerm.app', 'English'}, {'/Applications/Visual Studio Code.app', 'English'},
                        {'/Applications/Google Chrome.app', 'Chinese'}, {'/Applications/WeChat.app', 'Chinese'},
                        {'/Applications/System Preferences.app', 'English'}, {'/Applications/TickTick.app', 'Chinese'},
                        {'/Applications/企业微信.app', 'Chinese'}, {'/Applications/语雀.app', 'Chinese'},
                        {'/Applications/印象笔记.app', 'Chinese'}, {'/Applications/Dash.app', 'English'},
                        {'/Applications/Android Studio.app', 'English'}, {'/Applications/Bob.app', 'Chinese'},
                        {'/Applications/IntelliJ IDEA.app', 'English'}, {'/Applications/QQ.app', 'Chinese'},
                        {'/Applications/Typora.app', 'Chinese'}, {'/Applications/Alfred 5.app', 'English'},
                        {'/Applications/starfish.app', 'Chinese'}, {'/Applications/Microsoft Edge.app', 'Chinese'},
                        {'/Applications/Postman.app', 'English'}, {'/Applications/Safari.app', 'Chinese'},
                        {'/Applications/Obsidian.app', 'English'}, {'/Applications/Navicat Premium.app', 'English'},
                        {'/Applications/Lark.app', 'Chinese'}, {'/Applications/wechatwebdevtools.app', 'English'},
                        {'/System/Applications/Reminders.app', 'Chinese'}}
-- 没有在app2IM中指定切换的APP的默认输入法语言
ime_switcher.excludingDefaultIme = 'English'

-- 划定区域打开APP的名称
-- 目前已知支持iTerm和Calculator
dragAppName = 'iTerm'
