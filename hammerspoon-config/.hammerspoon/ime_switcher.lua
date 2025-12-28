-- author = "Ryan.ma"
----------------------------------------------------------------------------------------------------
-------------------------------------------- 根据APP自动切换输入法 ------------------------------------
----------------------------------------------------------------------------------------------------
ime_switcher = {}
ime_switcher.excludingDefaultIme = ''

function ime_switcher.Chinese()
    hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
end

function ime_switcher.English()
    hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end

ime_switcher.app2Ime = ime_switcher.app2Ime or
                           {{'/Applications/iTerm.app', 'English'}, {'/Applications/System Preferences.app', 'English'}}

function ime_switcher.updateFocusAppInputMethod()
    local excludingDefaultIme = ime_switcher.excludingDefaultIme
    local focusAppPath = hs.window.frontmostWindow():application():path()

    -- 检查 ime_switcher.app2Ime 是否有值
    if ime_switcher.app2Ime == nil or next(ime_switcher.app2Ime) == nil then
        -- ime_switcher.app2Ime 是空的或者没有定义，走默认切换逻辑
        ime_switcher.switch(excludingDefaultIme)
    else
        -- ime_switcher.app2Ime 有值，检查当前应用程序是否在表中
        local found = false
        for index, app in pairs(ime_switcher.app2Ime) do
            local appPath = app[1]
            local expectedIme = app[2]
            if focusAppPath == appPath then
                found = true
                if expectedIme == 'English' then
                    ime_switcher.English()
                    -- print("切换英文 appPath:" .. appPath)
                else
                    ime_switcher.Chinese()
                    -- print("切换中文 appPath:" .. appPath)
                end
                break
            end
        end
        if not found then
            -- 当前应用程序不在 app2Ime 表中，走默认切换逻辑
            ime_switcher.switch(excludingDefaultIme)
        end
    end
end

function ime_switcher.switch(excludingDefaultIme)
    if excludingDefaultIme == 'English' then
        ime_switcher.English()
        -- print("默认切换英文")
    elseif excludingDefaultIme == 'Chinese' then
        ime_switcher.Chinese()
        -- print("默认切换中文")
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
