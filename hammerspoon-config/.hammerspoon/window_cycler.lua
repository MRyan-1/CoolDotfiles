-- author = "Ryan.ma"
-- optimized for Option+Shift+Tab usage
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
        return f1.y < f2.y -- Y 越小越在上面，排在前面
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

-- 【关键修改】：适配 Option + Shift + Tab 的按键逻辑
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
            if count > 1 then
                -- 【逻辑反转区域】
                -- 因为你的快捷键自带 Shift，所以 flags.shift 为 true。
                -- 我们让 Shift + Tab 执行 "向下/下一个" (index + 1)

                if flags.shift then
                    -- 按住 Shift：从上到下 (Next)
                    state.index = state.index + 1
                    if state.index > count then
                        state.index = 1
                    end
                else
                    -- 松开 Shift (只按 Option + Tab)：从下到上 (Prev)
                    -- 这样你如果不小心切过头了，松开 Shift 按一下 Tab 就能退回去
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

    local fw = hs.window.focusedWindow()
    local currentScreen = fw and fw:screen() or hs.mouse.getCurrentScreen()
    if not currentScreen then
        return
    end

    local wins = getWindowsSnapshot(currentScreen)

    if #wins == 0 then
        hs.alert.show("当前屏幕无窗口", currentScreen)
        return
    end

    local initialIndex = 1
    if fw then
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

    -- 初始动作：选中下一个 (从上到下)
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
