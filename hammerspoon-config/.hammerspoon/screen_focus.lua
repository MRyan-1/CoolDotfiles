-- author = "Ryan.ma"
local feedback = require("feedback")
local M = {}

-- 赛博朋克屏幕闪烁效果
local screenFlashCanvas = nil
local screenFlashTimer = nil

local function flashScreenFrame(screen)
    if screenFlashCanvas then screenFlashCanvas:delete() end
    if screenFlashTimer then screenFlashTimer:stop() end

    local f = screen:fullFrame()
    screenFlashCanvas = hs.canvas.new(f)
    screenFlashCanvas:level(hs.canvas.windowLevels.overlay)

    -- 1. 全屏边框霓虹发光
    local inset = 10 -- 内缩一点，避免被显示器边框遮挡
    local r = { x = inset, y = inset, w = f.w - inset*2, h = f.h - inset*2 }

    screenFlashCanvas[1] = {
        type = "rectangle",
        action = "stroke",
        strokeColor = { hex = "#fcee0a", alpha = 0.5 },
        strokeWidth = 6,
        roundedRectRadii = { xRadius = 10, yRadius = 10 },
        shadow = { blurRadius = 30, color = { hex = "#fcee0a" }, alpha = 0.8, offset = { h=0, w=0 } },
        frame = r
    }
    
    -- 2. 核心亮线
    screenFlashCanvas[2] = {
        type = "rectangle",
        action = "stroke",
        strokeColor = { hex = "#fcee0a", alpha = 1.0 },
        strokeWidth = 2,
        roundedRectRadii = { xRadius = 10, yRadius = 10 },
        frame = r
    }

    -- 3. 四角赛博装饰 (Armor Corners) - 针对屏幕尺寸放大
    local l = 100 -- 角线长度
    local t = 8   -- 角线宽度
    local cornerInset = inset - t/2 -- 调整角标位置对齐边框

    -- 左上
    screenFlashCanvas[3] = { type = "segments", action = "stroke", strokeColor = { hex = "#fcee0a" }, strokeWidth = t, 
             coordinates = { {x=r.x, y=r.y+l}, {x=r.x, y=r.y}, {x=r.x+l, y=r.y} } }
    -- 右上
    screenFlashCanvas[4] = { type = "segments", action = "stroke", strokeColor = { hex = "#fcee0a" }, strokeWidth = t, 
             coordinates = { {x=r.x+r.w, y=r.y+l}, {x=r.x+r.w, y=r.y}, {x=r.x+r.w-l, y=r.y} } }
    -- 右下
    screenFlashCanvas[5] = { type = "segments", action = "stroke", strokeColor = { hex = "#fcee0a" }, strokeWidth = t, 
             coordinates = { {x=r.x+r.w, y=r.y+r.h-l}, {x=r.x+r.w, y=r.y+r.h}, {x=r.x+r.w-l, y=r.y+r.h} } }
    -- 左下
    screenFlashCanvas[6] = { type = "segments", action = "stroke", strokeColor = { hex = "#fcee0a" }, strokeWidth = t, 
             coordinates = { {x=r.x, y=r.y+r.h-l}, {x=r.x, y=r.y+r.h}, {x=r.x+l, y=r.y+r.h} } }

    screenFlashCanvas:show()
    
    -- 0.8秒后自动消失
    screenFlashTimer = hs.timer.doAfter(0.8, function()
        if screenFlashCanvas then
            screenFlashCanvas:delete()
            screenFlashCanvas = nil
        end
    end)
end

-- 辅助函数：获取当前屏幕（优先鼠标所在屏幕，其次是焦点窗口所在屏幕）
local function getCurrentScreen()
    local mousePoint = hs.mouse.getAbsolutePosition()
    for _, s in ipairs(hs.screen.allScreens()) do
        if s:fullFrame():inside(mousePoint) then
            return s
        end
    end
    local win = hs.window.focusedWindow()
    return win and win:screen()
end

-- 辅助函数：聚焦指定屏幕上的第一个窗口
local function focusScreen(targetScreen)
    if not targetScreen then return end

    local windows = hs.window.orderedWindows()
    local didFocus = false

    for _, win in ipairs(windows) do
        -- 检查窗口是否在目标屏幕上，且可见、标准
        if win:isVisible() and win:isStandard() and win:screen():id() == targetScreen:id() then
            win:focus()
            hs.mouse.setAbsolutePosition(win:frame().center)
            didFocus = true
            break
        end
    end

    -- 如果没有找到合适的窗口，仅移动鼠标到屏幕中心
    if not didFocus then
        local center = targetScreen:frame().center
        hs.mouse.setAbsolutePosition(center)
    end

    -- 显示反馈和赛博闪烁效果
    flashScreenFrame(targetScreen)
    feedback.show("聚焦: " .. (targetScreen:name() or "Unknown Screen"), targetScreen)
end

-- 聚焦到下一个屏幕
function M.focusNextScreen()
    local currentScreen = getCurrentScreen()
    if not currentScreen then return end

    local nextScreen = currentScreen:next()
    if not nextScreen or nextScreen:id() == currentScreen:id() then
        return -- 只有一个屏幕
    end

    focusScreen(nextScreen)
end

-- 聚焦到上一个屏幕
function M.focusPreviousScreen()
    local currentScreen = getCurrentScreen()
    if not currentScreen then return end

    local previousScreen = currentScreen:previous()
    if not previousScreen or previousScreen:id() == currentScreen:id() then
        return -- 只有一个屏幕
    end

    focusScreen(previousScreen)
end

return M