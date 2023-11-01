----------------------------------------------------------------------------------------------------
-------------------------------------------- 根据APP自动切换输入法 ------------------------------------
----------------------------------------------------------------------------------------------------
local ime_switcher = {}

function ime_switcher.Chinese()
    hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
end

function ime_switcher.English()
    hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end

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
                        {'/Applications/Lark.app', 'Chinese'}, {'/Applications/wechatwebdevtools.app', 'English'}}

function ime_switcher.updateFocusAppInputMethod()
    local focusAppPath = hs.window.frontmostWindow():application():path()
    for index, app in pairs(ime_switcher.app2Ime) do
        local appPath = app[1]
        local expectedIme = app[2]

        if focusAppPath == appPath then
            if expectedIme == 'English' then
                ime_switcher.English()
                print("切换英文 appPath:" .. appPath)
            else
                ime_switcher.Chinese()
                print("切换中文 appPath:" .. appPath)
            end
            break
        end
    end
end

function ime_switcher.applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        ime_switcher.updateFocusAppInputMethod()
    end
end

ime_switcher.appWatcher = hs.application.watcher.new(ime_switcher.applicationWatcher)
ime_switcher.appWatcher:start()

return ime_switcher
