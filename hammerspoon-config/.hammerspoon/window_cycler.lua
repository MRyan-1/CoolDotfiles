-- author = "Ryan.ma"
local feedback = require("feedback")
local M = {}

local cycler = {
    windows = {},
    names = {},
    index = 1,
    screen = nil,
    tap = nil
}

-- 辅助函数：获取当前屏幕的所有可见窗口，并按从上到下排序
local function getSortedWindows(screen)
    local screenId = screen:id()
    local allWins = hs.window.filter.new():setFilters({
        visible = true,
        currentSpace = true
    }):getWindows()
    local screenWins = {}

    for _, win in ipairs(allWins) do
        if win:screen():id() == screenId and win:isStandard() then
            if win:application():bundleID() ~= "org.hammerspoon.Hammerspoon" then
                table.insert(screenWins, win)
            end
        end
    end

    -- 严格排序：从上到下 (Top -> Bottom)
    -- Y 坐标小 (Top) 的排在前面
    table.sort(screenWins, function(a, b)
        local f1 = a:frame()
        local f2 = b:frame()
        -- 严格比较 Y，移除模糊阈值以免干扰
        if f1.y ~= f2.y then
            return f1.y < f2.y
        end
        return f1.x < f2.x
    end)

    -- Debug: 打印排序结果
    print("=== Window Sort Order (Top to Bottom) ===")
    for i, w in ipairs(screenWins) do
        print(string.format("%d. %s (y=%.0f)", i, w:title(), w:frame().y))
    end
    print("========================================")

    return screenWins
end

local function buildNames(windows)
    local names = {}
    for _, win in ipairs(windows) do
        local app = win:application()
        local appName = app and app:name() or "?"
        local title = win:title() or ""
        if #title > 60 then
            title = string.sub(title, 1, 57) .. "..."
        end
        table.insert(names, string.format("[%s] %s", appName, title))
    end
    return names
end

cycler.tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.keyDown}, function(event)
    local type = event:getType()
    local flags = event:getFlags()

    if type == hs.eventtap.event.types.flagsChanged then
        if not flags.alt then
            M.stop(true)
            return false
        end
        return true
    elseif type == hs.eventtap.event.types.keyDown then
        local keyCode = event:getKeyCode()

        if keyCode == hs.keycodes.map["tab"] then
            if flags.shift then
                cycler.index = cycler.index + 1
                if cycler.index > #cycler.windows then
                    cycler.index = 1
                end
            else
                cycler.index = cycler.index - 1
                if cycler.index < 1 then
                    cycler.index = #cycler.windows
                end
            end

            feedback.show_palette("窗口切换 - " .. cycler.screen:name(), cycler.names, cycler.screen, cycler.index,
                1)
            return true
        elseif keyCode == hs.keycodes.map["escape"] then
            M.stop(false)
            return true
        end
    end
    return false
end)

function M.start()
    if cycler.tap:isEnabled() then
        M.stop(false)
    end

    local fw = hs.window.focusedWindow()
    local screen = fw and fw:screen() or hs.mouse.getCurrentScreen()
    if not screen then
        return
    end

    local wins = getSortedWindows(screen)

    if #wins == 0 then
        feedback.show("当前屏幕没有窗口", screen)
        return
    end

    if #wins == 1 then
        feedback.show("仅有一个窗口: " .. (wins[1]:title() or ""), screen)
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

    cycler.windows = wins
    cycler.names = buildNames(wins)
    cycler.screen = screen
    -- 初始选中：当前窗口的下一个
    cycler.index = initialIndex + 1
    if cycler.index > #wins then
        cycler.index = 1
    end

    feedback.show_palette("窗口切换 - " .. screen:name(), cycler.names, screen, cycler.index, 1)

    cycler.tap:start()

    if not hs.eventtap.checkKeyboardModifiers().alt then
        M.stop(true)
    end
end

function M.stop(commit)
    if cycler.tap:isEnabled() then
        cycler.tap:stop()
    end
    feedback.hide_palette()

    if commit and cycler.windows and cycler.index and cycler.windows[cycler.index] then
        local target = cycler.windows[cycler.index]
        target:focus()
    end

    cycler.windows = {}
    cycler.names = {}
    cycler.screen = nil
end

return M
