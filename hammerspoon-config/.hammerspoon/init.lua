----------------------------------------------------------------------------------------------------
-------------------------------------------- Begin ---------------------------------------------------
----------------------------------------------------------------------------------------------------
hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

-- 输入法切换模块
ime_switcher = require("ime_switcher")
-- 锁屏自动断开蓝牙耳机模块
headphone = require("headphone")
-- 屏幕切换模块
screen_focus = require("screen_focus")
-- 公共反馈提示模块
local feedback = require("feedback")

----------------------------------------------------------------------------------------------------
------------------------------------------ 配置设置 -------------------------------------------------
-- 配置文件
-- 使用自定义配置 （如果存在的话）
----------------------------------------------------------------------------------------------------
custom_config = hs.fs.pathToAbsolute(os.getenv("HOME") .. '/.config/hammerspoon/private/config.lua')
if custom_config then
    print("加载自定义配置文件。")
    dofile(os.getenv("HOME") .. "/.config/hammerspoon/private/config.lua")
    privatepath = hs.fs.pathToAbsolute(hs.configdir .. '/private/config.lua')
    if privatepath then
        hs.alert("已发现你的私有配置，将优先使用它。")
    end
else
    -- 否则使用默认配置
    if not privatepath then
        privatepath = hs.fs.pathToAbsolute(hs.configdir .. '/private')
        -- 如果没有 `~/.hammerspoon/private` 目录，则创建它。
        hs.fs.mkdir(hs.configdir .. '/private')
    end
    privateconf = hs.fs.pathToAbsolute(hs.configdir .. '/private/config.lua')
    if privateconf then
        -- 加载自定义配置，如果存在的话
        require('private/config')
    end
end

----------------------------------------------------------------------------------------------------
-- 重新加载配置
----------------------------------------------------------------------------------------------------
hsreload_keys = hsreload_keys or {{"cmd", "shift", "ctrl"}, "R"}
if string.len(hsreload_keys[2]) > 0 then
    hs.hotkey.bind(hsreload_keys[1], hsreload_keys[2], nil, function()
        hs.reload()
    end)
    feedback.show("配置文件已重载")
end

----------------------------------------------------------------------------------------------------
---------------------------------------- Spoons 加载项 ----------------------------------------------
----------------------------------------------------------------------------------------------------
-- 加载 Spoon
----------------------------------------------------------------------------------------------------
hs.loadSpoon("ModalMgr")

-- 定义默认加载的 Spoons
if not hspoon_list then
    hspoon_list = {"WinWin", -- 窗口管理
    "AClock", -- 一个钟
    "Cheatsheet" -- 快捷键面板
    }
end

-- 加载 Spoons
for _, v in pairs(hspoon_list) do
    hs.loadSpoon(v)
end

----------------------------------------------------------------------------------------------------
-- 音乐控制 (Apple Music)
----------------------------------------------------------------------------------------------------
if spoon.Music then
    local music_keys = {
        [{{ "cmd", "alt" }, "left"}] = "previous",
        [{{ "cmd", "alt" }, "right"}] = "next",
        [{{ "cmd", "alt" }, "return"}] = "playpause",
    }
    spoon.Music:bindHotkeys(music_keys)
    -- [REMOVED] 音乐信息轮询已停止
end

----------------------------------------------------------------------------------------------------
-- 快捷键面板 (Cheatsheet)
----------------------------------------------------------------------------------------------------
if spoon.Cheatsheet then
    hs.hotkey.bind({"ctrl", "shift", "cmd"}, "/", function()
        -- 从 private/config.lua 中读取的 app_toggle_keys
        if app_toggle_keys then
            spoon.Cheatsheet:show(app_toggle_keys)
        else
            hs.alert.show("未找到 app_toggle_keys 配置")
        end
    end)
end

----------------------------------------------------------------------------------------------------
-- 锁屏
----------------------------------------------------------------------------------------------------
hslock_keys = hslock_keys or {"alt", "L"}
if string.len(hslock_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hslock_keys[1], hslock_keys[2], nil, function()
        hs.caffeinate.lockScreen()
    end)
end

----------------------------------------------------------------------------------------------------
-- 窗口管理
----------------------------------------------------------------------------------------------------
if spoon.WinWin then
    spoon.ModalMgr:new("resizeM")
    local cmodal = spoon.ModalMgr.modal_list["resizeM"]
    cmodal:bind('', 'escape', nil, function()
        spoon.ModalMgr:deactivate({"resizeM"})
    end)
    cmodal:bind('', 'Q', nil, function()
        spoon.ModalMgr:deactivate({"resizeM"})
    end)
    cmodal:bind('', 'tab', nil, function()
        spoon.ModalMgr:toggleCheatsheet()
    end)

    cmodal:bind('', 'A', nil, function()
        spoon.WinWin:stepMove("left")
    end, nil, function()
        spoon.WinWin:stepMove("left")
    end)
    cmodal:bind('', 'D', nil, function()
        spoon.WinWin:stepMove("right")
    end, nil, function()
        spoon.WinWin:stepMove("right")
    end)
    cmodal:bind('', 'W', nil, function()
        spoon.WinWin:stepMove("up")
    end, nil, function()
        spoon.WinWin:stepMove("up")
    end)
    cmodal:bind('', 'S', nil, function()
        spoon.WinWin:stepMove("down")
    end, nil, function()
        spoon.WinWin:stepMove("down")
    end)

    cmodal:bind('', 'H', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("halfleft")
    end)
    cmodal:bind('', 'L', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("halfright")
    end)
    cmodal:bind('', 'K', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("halfup")
    end)
    cmodal:bind('', 'J', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("halfdown")
    end)

    cmodal:bind('', 'Y', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("cornerNW")
    end)
    cmodal:bind('', 'O', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("cornerNE")
    end)
    cmodal:bind('', 'U', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("cornerSW")
    end)
    cmodal:bind('', 'I', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("cornerSE")
    end)

    cmodal:bind('', 'F', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("fullscreen")
    end)
    cmodal:bind('', 'C', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("center")
    end)
    cmodal:bind('', 'G', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("centermost")
    end)
    cmodal:bind('', 'Z', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("show")
    end)
    cmodal:bind('', 'V', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("shows")
    end)

    cmodal:bind('', 'X', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("center-2")
    end)

    cmodal:bind('', '=', nil, function()
        spoon.WinWin:moveAndResize("expand")
    end, nil, function()
        spoon.WinWin:moveAndResize("expand")
    end)
    cmodal:bind('', '-', nil, function()
        spoon.WinWin:moveAndResize("shrink")
    end, nil, function()
        spoon.WinWin:moveAndResize("shrink")
    end)

    cmodal:bind('ctrl', 'H', nil, function()
        spoon.WinWin:stepResize("left")
    end, nil, function()
        spoon.WinWin:stepResize("left")
    end)
    cmodal:bind('ctrl', 'L', nil, function()
        spoon.WinWin:stepResize("right")
    end, nil, function()
        spoon.WinWin:stepResize("right")
    end)
    cmodal:bind('ctrl', 'K', nil, function()
        spoon.WinWin:stepResize("up")
    end, nil, function()
        spoon.WinWin:stepResize("up")
    end)
    cmodal:bind('ctrl', 'J', nil, function()
        spoon.WinWin:stepResize("down")
    end, nil, function()
        spoon.WinWin:stepResize("down")
    end)

    cmodal:bind('', 'left', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("left")
    end)
    cmodal:bind('', 'right', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("right")
    end)
    cmodal:bind('', 'up', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("up")
    end)
    cmodal:bind('', 'down', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("down")
    end)
    cmodal:bind('', 'space', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("next")
    end)
    cmodal:bind('', 'B', nil, function()
        spoon.WinWin:undo()
    end)
    cmodal:bind('', 'R', nil, function()
        spoon.WinWin:redo()
    end)

    cmodal:bind('', '[', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("mostleft")
    end)
    cmodal:bind('', ']', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("mostright")
    end)
    cmodal:bind('', ',', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("lesshalfleft")
    end)
    cmodal:bind('', '.', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("onethird")
    end)
    cmodal:bind('', '/', nil, function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("lesshalfright")
    end)

    cmodal:bind('', 't', nil, function()
        spoon.WinWin:centerCursor()
    end)

    -- 定义窗口管理模式快捷键
    hsresizeM_keys = hsresizeM_keys or {"alt", "R"}
    if string.len(hsresizeM_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hsresizeM_keys[1], hsresizeM_keys[2], nil, function()
            -- 检查 resizeM 是否已经在 active_list 中
            if spoon.ModalMgr.active_list["resizeM"] then
                -- 如果已激活，则退出
                spoon.ModalMgr:deactivate({"resizeM"})
            else
                -- 如果未激活，则进入
                spoon.ModalMgr:deactivateAll()
                spoon.ModalMgr:activate({"resizeM"}, "#f1c40f")
            end
        end)
    end
end

----------------------------------------------------------------------------------------------------
-- 绑定 AClock 快捷键
----------------------------------------------------------------------------------------------------
if spoon.AClock then
    hsaclock_keys = hsaclock_keys or {"alt", "T"}
    if string.len(hsaclock_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hsaclock_keys[1], hsaclock_keys[2], nil, function()
            spoon.AClock:toggleShow()
        end)
    end
end
--

----------------------------------------------------------------------------------------------------
-- 快捷显示 Hammerspoon 控制台
----------------------------------------------------------------------------------------------------
hsconsole_keys = hsconsole_keys or {"alt", "Z"}
if string.len(hsconsole_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hsconsole_keys[1], hsconsole_keys[2], nil, function()
        hs.toggleConsole()
    end)
end

----------------------------------------------------------------------------------------------------
-- 快捷调节音量
----------------------------------------------------------------------------------------------------
function changeVolume(diff)
    return function()
        local current = hs.audiodevice.defaultOutputDevice():volume()
        local new = math.min(100, math.max(0, math.floor(current + diff)))
        if new > 0 then
            hs.audiodevice.defaultOutputDevice():setMuted(false)
        end
        feedback.show("音量 " .. new .. "%")
        hs.audiodevice.defaultOutputDevice():setVolume(new)
    end
end

hsVolumeDown_keys = hsVolumeDown_keys or {{"cmd", "alt"}, "Down"}
if string.len(hsVolumeDown_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hsVolumeDown_keys[1], hsVolumeDown_keys[2], nil, changeVolume(-3))
end

hsVolumeUp_keys = hsVolumeUp_keys or {{"cmd", "alt"}, "Up"}
if string.len(hsVolumeUp_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hsVolumeUp_keys[1], hsVolumeUp_keys[2], nil, changeVolume(3))
end

----------------------------------------------------------------------------------------------------
-- 根据APP自动切换输入法，辅助工具定位
----------------------------------------------------------------------------------------------------
function imSwitcherAlert()
    hs.alert.show("App path:        " .. hs.window.focusedWindow():application():path() .. "\n" .. "App name:      " ..
                      hs.window.focusedWindow():application():name() .. "\n" .. "IM source id:  " ..
                      hs.keycodes.currentSourceID())
end

hsImSwitcherAlert_keys = hsImSwitcherAlert_keys or {{"ctrl", "cmd"}, "."}
if string.len(hsImSwitcherAlert_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hsImSwitcherAlert_keys[1], hsImSwitcherAlert_keys[2], nil, imSwitcherAlert)
end

----------------------------------------------------------------------------------------------------
-- 屏幕切换 (Screen Focus)
----------------------------------------------------------------------------------------------------
hsscreen_focus_keys = hsscreen_focus_keys or {"alt", "tab"}
if string.len(hsscreen_focus_keys[2]) > 0 then
    hs.hotkey.bind(hsscreen_focus_keys[1], hsscreen_focus_keys[2], nil, function()
        screen_focus.focusNextScreen()
    end)
end

----------------------------------------------------------------------------------------------------
-- 音乐控制 (Apple Music)
----------------------------------------------------------------------------------------------------
function toggleApp(appIdOrName)
    -- 先尝试作为 Bundle ID 查找
    local app = hs.application.get(appIdOrName)
    
    if not app then
        -- 如果没找到，且看起来不像 Bundle ID，尝试 launch
        hs.application.launchOrFocus(appIdOrName)
        return
    end

    -- 优先判断是否为最前端应用
    if app:isFrontmost() then
        app:hide()
    else
        -- 尝试激活
        if not app:activate() then
            hs.application.launchOrFocus(appIdOrName)
        end
        local mainWin = app:mainWindow()
        if mainWin then
            mainWin:focus()
        end
    end
end

if app_toggle_keys then
    for _, mapping in ipairs(app_toggle_keys) do
        local mods = mapping[1]
        local key = mapping[2]
        local appName = mapping[3]
        
        if string.len(key) > 0 then
            hs.hotkey.bind(mods, key, nil, function()
                toggleApp(appName)
            end)
        end
    end
end

----------------------------------------------------------------------------------------------------
-- 初始化 modalMgr
----------------------------------------------------------------------------------------------------
spoon.ModalMgr.supervisor:enter()

----------------------------------------------------------------------------------------------------
-------------------------------------------- End ---------------------------------------------------
----------------------------------------------------------------------------------------------------
