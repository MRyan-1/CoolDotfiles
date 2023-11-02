----------------------------------------------------------------------------------------------------
-------------------------------------------- Begin ---------------------------------------------------
----------------------------------------------------------------------------------------------------
hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

-- 鼠标选取区域打开Iterm模块
local yourPath = '/Users/ryan/.hammerspoon/BradensPoon/'
package.path = yourPath .. '?.lua;' .. package.path;
require('init')

-- 输入法切换模块
ime_switcher = require("ime_switcher")
-- 锁屏自动断开蓝牙耳机模块
headphone = require("headphone")

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
    hs.hotkey.bind(hsreload_keys[1], hsreload_keys[2], "重新加载配置!", function()
        hs.reload()
    end)
    hs.alert.show("配置文件已经重新加载！ ")
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
    "AClock" -- 一个钟
    }
end

-- 加载 Spoons
for _, v in pairs(hspoon_list) do
    hs.loadSpoon(v)
end

----------------------------------------------------------------------------------------------------
-- 锁屏
----------------------------------------------------------------------------------------------------
hslock_keys = hslock_keys or {"alt", "L"}
if string.len(hslock_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hslock_keys[1], hslock_keys[2], "锁屏", function()
        hs.caffeinate.lockScreen()
    end)
end

----------------------------------------------------------------------------------------------------
-- 窗口管理
----------------------------------------------------------------------------------------------------
if spoon.WinWin then
    spoon.ModalMgr:new("resizeM")
    local cmodal = spoon.ModalMgr.modal_list["resizeM"]
    cmodal:bind('', 'escape', '退出 ', function()
        spoon.ModalMgr:deactivate({"resizeM"})
    end)
    cmodal:bind('', 'Q', '退出', function()
        spoon.ModalMgr:deactivate({"resizeM"})
    end)
    cmodal:bind('', 'tab', '键位提示', function()
        spoon.ModalMgr:toggleCheatsheet()
    end)

    cmodal:bind('', 'A', '向左移动', function()
        spoon.WinWin:stepMove("left")
    end, nil, function()
        spoon.WinWin:stepMove("left")
    end)
    cmodal:bind('', 'D', '向右移动', function()
        spoon.WinWin:stepMove("right")
    end, nil, function()
        spoon.WinWin:stepMove("right")
    end)
    cmodal:bind('', 'W', '向上移动', function()
        spoon.WinWin:stepMove("up")
    end, nil, function()
        spoon.WinWin:stepMove("up")
    end)
    cmodal:bind('', 'S', '向下移动', function()
        spoon.WinWin:stepMove("down")
    end, nil, function()
        spoon.WinWin:stepMove("down")
    end)

    cmodal:bind('', 'H', '左半屏', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("halfleft")
    end)
    cmodal:bind('', 'L', '右半屏', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("halfright")
    end)
    cmodal:bind('', 'K', '上半屏', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("halfup")
    end)
    cmodal:bind('', 'J', '下半屏', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("halfdown")
    end)

    cmodal:bind('', 'Y', '屏幕左上角', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("cornerNW")
    end)
    cmodal:bind('', 'O', '屏幕右上角', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("cornerNE")
    end)
    cmodal:bind('', 'U', '屏幕左下角', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("cornerSW")
    end)
    cmodal:bind('', 'I', '屏幕右下角', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("cornerSE")
    end)

    cmodal:bind('', 'F', '全屏', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("fullscreen")
    end)
    cmodal:bind('', 'C', '居中', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("center")
    end)
    cmodal:bind('', 'G', '左三分之二屏居中分屏', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("centermost")
    end)
    cmodal:bind('', 'Z', '展示显示', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("show")
    end)
    cmodal:bind('', 'V', '编辑显示', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("shows")
    end)

    cmodal:bind('', 'X', '二分之一居中分屏', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("center-2")
    end)

    cmodal:bind('', '=', '窗口放大', function()
        spoon.WinWin:moveAndResize("expand")
    end, nil, function()
        spoon.WinWin:moveAndResize("expand")
    end)
    cmodal:bind('', '-', '窗口缩小', function()
        spoon.WinWin:moveAndResize("shrink")
    end, nil, function()
        spoon.WinWin:moveAndResize("shrink")
    end)

    cmodal:bind('ctrl', 'H', '向左收缩窗口', function()
        spoon.WinWin:stepResize("left")
    end, nil, function()
        spoon.WinWin:stepResize("left")
    end)
    cmodal:bind('ctrl', 'L', '向右扩展窗口', function()
        spoon.WinWin:stepResize("right")
    end, nil, function()
        spoon.WinWin:stepResize("right")
    end)
    cmodal:bind('ctrl', 'K', '向上收缩窗口', function()
        spoon.WinWin:stepResize("up")
    end, nil, function()
        spoon.WinWin:stepResize("up")
    end)
    cmodal:bind('ctrl', 'J', '向下扩镇窗口', function()
        spoon.WinWin:stepResize("down")
    end, nil, function()
        spoon.WinWin:stepResize("down")
    end)

    cmodal:bind('', 'left', '窗口移至左边屏幕', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("left")
    end)
    cmodal:bind('', 'right', '窗口移至右边屏幕', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("right")
    end)
    cmodal:bind('', 'up', '窗口移至上边屏幕', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("up")
    end)
    cmodal:bind('', 'down', '窗口移动下边屏幕', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("down")
    end)
    cmodal:bind('', 'space', '窗口移至下一个屏幕', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveToScreen("next")
    end)
    cmodal:bind('', 'B', '撤销最后一个窗口操作', function()
        spoon.WinWin:undo()
    end)
    cmodal:bind('', 'R', '重做最后一个窗口操作', function()
        spoon.WinWin:redo()
    end)

    cmodal:bind('', '[', '左三分之二屏', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("mostleft")
    end)
    cmodal:bind('', ']', '右三分之二屏', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("mostright")
    end)
    cmodal:bind('', ',', '左三分之一屏', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("lesshalfleft")
    end)
    cmodal:bind('', '.', '中分之一屏', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("onethird")
    end)
    cmodal:bind('', '/', '右三分之一屏', function()
        spoon.WinWin:stash()
        spoon.WinWin:moveAndResize("lesshalfright")
    end)

    cmodal:bind('', 't', '将光标移至所在窗口中心位置', function()
        spoon.WinWin:centerCursor()
    end)

    -- 定义窗口管理模式快捷键
    hsresizeM_keys = hsresizeM_keys or {"alt", "R"}
    if string.len(hsresizeM_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hsresizeM_keys[1], hsresizeM_keys[2], "进入窗口管理模式", function()
            spoon.ModalMgr:deactivateAll()
            -- 显示状态指示器，方便查看所处模式
            spoon.ModalMgr:activate({"resizeM"}, "#f1c40f")
        end)
    end
end

----------------------------------------------------------------------------------------------------
-- 绑定 AClock 快捷键
----------------------------------------------------------------------------------------------------
if spoon.AClock then
    hsaclock_keys = hsaclock_keys or {"alt", "T"}
    if string.len(hsaclock_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hsaclock_keys[1], hsaclock_keys[2], "时钟", function()
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
    spoon.ModalMgr.supervisor:bind(hsconsole_keys[1], hsconsole_keys[2], "打开 Hammerspoon 控制台", function()
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
        hs.alert.closeAll(0.0)
        hs.alert.show("Volume " .. new .. "%", {}, 0.5)
        hs.audiodevice.defaultOutputDevice():setVolume(new)
    end
end

hsVolumeDown_keys = hsVolumeDown_keys or {{"cmd", "alt"}, "Down"}
if string.len(hsVolumeDown_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hsVolumeDown_keys[1], hsVolumeDown_keys[2], "音量降低", changeVolume(-3))
end

hsVolumeUp_keys = hsVolumeUp_keys or {{"cmd", "alt"}, "Up"}
if string.len(hsVolumeUp_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hsVolumeUp_keys[1], hsVolumeUp_keys[2], "音量升高", changeVolume(3))
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
    spoon.ModalMgr.supervisor:bind(hsImSwitcherAlert_keys[1], hsImSwitcherAlert_keys[2], "输入法自动切换定位",
        imSwitcherAlert)
end

----------------------------------------------------------------------------------------------------
-- 初始化 modalMgr
----------------------------------------------------------------------------------------------------
spoon.ModalMgr.supervisor:enter()

----------------------------------------------------------------------------------------------------
-------------------------------------------- End ---------------------------------------------------
----------------------------------------------------------------------------------------------------
