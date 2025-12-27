-- 指定要启用的模块
hspoon_list = {"WinWin", "AClock", "Cheatsheet", "Music"}

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
                        {'/Applications/Arc.app', 'Chinese'}, {'/System/Applications/Reminders.app', 'Chinese'}}
-- 没有在app2IM中指定切换的APP的默认输入法语言
ime_switcher.excludingDefaultIme = 'English'

-- 应用一键开关快捷键 (打开/隐藏)
-- 格式: {{修饰键}, "按键", "应用名称"}
-- 统一使用 Hyper Key: Ctrl + Shift + Command
app_toggle_keys = {
    {{"ctrl", "shift", "cmd"}, "Q", "iTerm"},
    {{"ctrl", "shift", "cmd"}, "W", "Unreal"},
    {{"ctrl", "shift", "cmd"}, "A", "IntelliJ IDEA"},
    {{"ctrl", "shift", "cmd"}, "S", "GoLand"},
    {{"ctrl", "shift", "cmd"}, "D", "PyCharm"},
    {{"ctrl", "shift", "cmd"}, "Z", "Google Chrome"},
    {{"ctrl", "shift", "cmd"}, "X", "Obsidian"},
    {{"ctrl", "shift", "cmd"}, "C", "Notion"},
}
