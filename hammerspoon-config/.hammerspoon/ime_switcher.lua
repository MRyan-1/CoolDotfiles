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
    print("excludingDefaultIme: " .. tostring(excludingDefaultIme))

    -- 如果excludingDefaultIme没有配置，则遍历app2Ime
    if excludingDefaultIme == nil or type(excludingDefaultIme) ~= "string" or excludingDefaultIme == "" then
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
                return
            end
        end
    else
        -- 如果excludingDefaultIme被配置了，则直接切换到默认输入法
        if excludingDefaultIme == 'English' then
            ime_switcher.English()
            print("默认切换英文")
        elseif excludingDefaultIme == 'Chinese' then
            ime_switcher.Chinese()
            print("默认切换中文")
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
