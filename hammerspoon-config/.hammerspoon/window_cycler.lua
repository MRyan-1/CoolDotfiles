-- author = "Ryan.ma"
local feedback = require("feedback")
local M = {}

local state = {
    windows = {},
    names = {},
    index = 1,
    screen = nil,
    tap = nil,
    active = false
}

-- 严格几何排序 (Top -> Bottom)
local function strictGeometricSort(a, b)
    local f1 = a:frame()
    local f2 = b:frame()

    if math.abs(f1.y - f2.y) > 5 then
        return f1.y < f2.y
    end

    if math.abs(f1.x - f2.x) > 5 then
        return f1.x < f2.x
    end

    return a:id() < b:id()
end

local function getWindowsSnapshot(targetScreen)
    local screenId = targetScreen:id()
    local allWins = hs.window.visibleWindows()
    local candidates = {}

    for _, win in ipairs(allWins) do
        if win:screen():id() == screenId and win:isStandard() and win:isVisible() then
            if win:application():bundleID() ~= "org.hammerspoon.Hammerspoon" then
                table.insert(candidates, win)
            end
        end
    end

    table.sort(candidates, strictGeometricSort)
    return candidates
end

local function buildDisplayNames(windows)
    local names = {}
    for _, win in ipairs(windows) do
        local app = win:application()
        local appName = app and app:name() or "?"
        local title = win:title() or ""
        if #title > 50 then
            title = string.sub(title, 1, 48) .. "..."
        end
        table.insert(names, string.format("[%s] %s", appName, title))
    end
    return names
end

state.tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.keyDown}, function(event)
    if not state.active then
        return false
    end

    local type = event:getType()
    local flags = event:getFlags()

    if type == hs.eventtap.event.types.flagsChanged then
        if not flags.alt then
            M.stop(true)
            return false
        end
        return true
    end

    if type == hs.eventtap.event.types.keyDown then
        local keyCode = event:getKeyCode()
        local isTab = (keyCode == hs.keycodes.map["tab"])
        local isEsc = (keyCode == hs.keycodes.map["escape"])

        if isTab then
            local count = #state.windows
            -- 只有当真实的窗口数量大于1时，才允许切换
            -- 如果是“无窗口”状态（count 为 0），按 Tab 键什么都不做，只是保持面板显示
            if count > 1 then
                if flags.shift then
                    state.index = state.index + 1
                    if state.index > count then
                        state.index = 1
                    end
                else
                    state.index = state.index - 1
                    if state.index < 1 then
                        state.index = count
                    end
                end

                feedback.show_palette("切换窗口 - " .. state.screen:name(), state.names, state.screen, state.index,
                    1)
            end
            return true

        elseif isEsc then
            M.stop(false)
            return true
        end
    end

    return true
end)

function M.start()
    if state.active then
        return
    end

    -- 强制使用鼠标所在的屏幕
    local currentScreen = hs.mouse.getCurrentScreen()
    if not currentScreen then
        return
    end

    local wins = getWindowsSnapshot(currentScreen)
    local initialIndex = 1

    -- 【关键修改】：处理无窗口情况，构建“伪状态”
    if #wins == 0 then
        -- 设置为空数组，这样 state.tap 里的 count 为 0，Tab 键就不会轮询
        state.windows = {}
        -- 设置显示名称，让 feedback 有内容展示
        state.names = {"(当前屏幕无窗口)"}
        state.screen = currentScreen
        state.index = 1
        state.active = true

        -- 展示面板
        feedback.show_palette("切换窗口 - " .. currentScreen:name(), state.names, state.screen, 1, 1)

        -- 启动按键监听（为了检测 Option 松开以关闭面板）
        state.tap:start()

        -- 防止手速过快，启动时 Option 已经松开了
        if not hs.eventtap.checkKeyboardModifiers().alt then
            M.stop(false)
        end
        return
    end

    -- 下面是有窗口时的正常逻辑
    local fw = hs.window.focusedWindow()
    if fw and fw:screen():id() == currentScreen:id() then
        for i, w in ipairs(wins) do
            if w:id() == fw:id() then
                initialIndex = i
                break
            end
        end
    end

    state.windows = wins
    state.names = buildDisplayNames(wins)
    state.screen = currentScreen
    state.active = true

    state.index = initialIndex + 1
    if state.index > #wins then
        state.index = 1
    end

    feedback.show_palette("切换窗口 - " .. currentScreen:name(), state.names, state.screen, state.index, 1)

    state.tap:start()

    if not hs.eventtap.checkKeyboardModifiers().alt then
        M.stop(true)
    end
end

function M.stop(commit)
    if not state.active then
        return
    end

    state.tap:stop()
    state.active = false
    feedback.hide_palette()

    if commit then
        -- 如果是“无窗口”状态，state.windows 为空，这里取出来是 nil，不会报错，也不会执行 focus
        local targetWin = state.windows[state.index]
        if targetWin then
            targetWin:focus()
        end
    end

    state.windows = {}
    state.names = {}
    state.screen = nil
end

return M
