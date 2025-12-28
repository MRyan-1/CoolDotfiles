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

-- 性能优化：预先定义 window filter，避免每次启动都全量扫描
local wf = hs.window.filter.new(nil)
wf:setFilters({
    visible = true, -- 只看可见窗口
    currentSpace = true -- 只看当前桌面的窗口
})

local function getWindowsOnScreen(screen)
    local screenId = screen:id()
    -- 改用物理位置排序：从上到下
    local wins = wf:getWindows()
    table.sort(wins, function(a, b)
        local frameA = a:frame()
        local frameB = b:frame()
        if frameA.y == frameB.y then
            return frameA.x < frameB.x
        end
        return frameA.y < frameB.y
    end)

    local filteredWins = {}
    local names = {}
    local focusedIdx = 1
    local fw = hs.window.focusedWindow()

    for _, win in ipairs(wins) do
        local winScreen = win:screen()
        if winScreen and winScreen:id() == screenId then
            local app = win:application()
            local bundleID = app and app:bundleID() or ""
            if bundleID ~= "org.hammerspoon.Hammerspoon" and bundleID ~= "" then
                table.insert(filteredWins, win)
                if fw and win:id() == fw:id() then
                    focusedIdx = #filteredWins
                end
                local appName = app:name() or "Unknown"
                local title = win:title() or ""
                if #title > 50 then
                    title = string.sub(title, 1, 47) .. "..."
                end
                table.insert(names, string.format("[%s] %s", appName, title))
            end
        end
    end
    return filteredWins, names, focusedIdx
end

function M.start()
    if cycler.tap then
        cycler.tap:stop()
    end

    local fw = hs.window.focusedWindow()
    if not fw then
        return
    end

    local screen = fw:screen()
    local wins, names, focusedIdx = getWindowsOnScreen(screen)

    if #wins <= 1 then
        feedback.show("当前屏幕仅有一个窗口", screen)
        return
    end

    cycler.windows = wins
    cycler.names = names
    cycler.screen = screen
    -- 初始索引：当前窗口的下一个（向下移动）
    cycler.index = (focusedIdx % #wins) + 1

    feedback.show_palette("窗口切换 - " .. screen:name(), cycler.names, screen, cycler.index, 1)

    cycler.tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.keyDown},
        function(event)
            local type = event:getType()
            local flags = event:getFlags()

            if type == hs.eventtap.event.types.flagsChanged then
                if not flags.alt then
                    M.stop(true)
                    return false
                end
            elseif type == hs.eventtap.event.types.keyDown then
                local keyCode = event:getKeyCode()
                if keyCode == hs.keycodes.map["tab"] then
                    if flags.shift then
                        -- Shift + Tab -> 视觉向上移动
                        cycler.index = cycler.index + 1
                        if cycler.index > #cycler.windows then
                            cycler.index = 1
                        end
                    else
                        -- Tab -> 视觉向下移动
                        cycler.index = cycler.index - 1
                        if cycler.index < 1 then
                            cycler.index = #cycler.windows
                        end
                    end
                    feedback.show_palette("窗口切换 - " .. screen:name(), cycler.names, screen, cycler.index, 1)
                    return true
                elseif keyCode == hs.keycodes.map["escape"] then
                    M.stop(false)
                    return true
                end
            end
            return false
        end)
    cycler.tap:start()
end

function M.stop(commit)
    if cycler.tap then
        cycler.tap:stop()
        cycler.tap = nil
    end
    feedback.hide_palette()

    if commit and cycler.windows[cycler.index] then
        -- 核心：直接聚焦并置顶选中的窗口，不涉及复杂的沉底逻辑
        local target = cycler.windows[cycler.index]
        target:focus()
    end

    cycler.windows = {}
    cycler.names = {}
end

return M
