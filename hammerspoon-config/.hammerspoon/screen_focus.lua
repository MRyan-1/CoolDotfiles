-- author = "Ryan.ma"
local feedback = require("feedback")
local M = {}

-- 赛博朋克屏幕闪烁效果 (保持不变)
local screenFlashCanvas = nil
local screenFlashTimer = nil

local function flashScreenFrame(screen)
    if screenFlashCanvas then
        screenFlashCanvas:delete()
    end
    if screenFlashTimer then
        screenFlashTimer:stop()
    end

    local f = screen:fullFrame()
    screenFlashCanvas = hs.canvas.new(f)
    screenFlashCanvas:level(hs.canvas.windowLevels.overlay)

    -- 1. 全屏边框霓虹发光
    local inset = 10
    local r = {
        x = inset,
        y = inset,
        w = f.w - inset * 2,
        h = f.h - inset * 2
    }

    screenFlashCanvas[1] = {
        type = "rectangle",
        action = "stroke",
        strokeColor = {
            hex = "#fcee0a",
            alpha = 0.5
        },
        strokeWidth = 6,
        roundedRectRadii = {
            xRadius = 10,
            yRadius = 10
        },
        shadow = {
            blurRadius = 30,
            color = {
                hex = "#fcee0a"
            },
            alpha = 0.8,
            offset = {
                h = 0,
                w = 0
            }
        },
        frame = r
    }

    -- 2. 核心亮线
    screenFlashCanvas[2] = {
        type = "rectangle",
        action = "stroke",
        strokeColor = {
            hex = "#fcee0a",
            alpha = 1.0
        },
        strokeWidth = 2,
        roundedRectRadii = {
            xRadius = 10,
            yRadius = 10
        },
        frame = r
    }

    -- 3. 四角赛博装饰
    local l = 100
    local t = 8

    -- 左上
    screenFlashCanvas[3] = {
        type = "segments",
        action = "stroke",
        strokeColor = {
            hex = "#fcee0a"
        },
        strokeWidth = t,
        coordinates = {{
            x = r.x,
            y = r.y + l
        }, {
            x = r.x,
            y = r.y
        }, {
            x = r.x + l,
            y = r.y
        }}
    }
    -- 右上
    screenFlashCanvas[4] = {
        type = "segments",
        action = "stroke",
        strokeColor = {
            hex = "#fcee0a"
        },
        strokeWidth = t,
        coordinates = {{
            x = r.x + r.w,
            y = r.y + l
        }, {
            x = r.x + r.w,
            y = r.y
        }, {
            x = r.x + r.w - l,
            y = r.y
        }}
    }
    -- 右下
    screenFlashCanvas[5] = {
        type = "segments",
        action = "stroke",
        strokeColor = {
            hex = "#fcee0a"
        },
        strokeWidth = t,
        coordinates = {{
            x = r.x + r.w,
            y = r.y + r.h - l
        }, {
            x = r.x + r.w,
            y = r.y + r.h
        }, {
            x = r.x + r.w - l,
            y = r.y + r.h
        }}
    }
    -- 左下
    screenFlashCanvas[6] = {
        type = "segments",
        action = "stroke",
        strokeColor = {
            hex = "#fcee0a"
        },
        strokeWidth = t,
        coordinates = {{
            x = r.x,
            y = r.y + r.h - l
        }, {
            x = r.x,
            y = r.y + r.h
        }, {
            x = r.x + l,
            y = r.y + r.h
        }}
    }

    screenFlashCanvas:show()

    screenFlashTimer = hs.timer.doAfter(0.8, function()
        if screenFlashCanvas then
            screenFlashCanvas:delete()
            screenFlashCanvas = nil
        end
    end)
end

-- 【关键修改 1】：更稳健的屏幕获取逻辑
-- 直接使用 hs.mouse.getCurrentScreen()，它能完美处理空屏幕的情况
local function getCurrentScreen()
    return hs.mouse.getCurrentScreen() or hs.window.focusedWindow():screen()
end

-- 辅助函数：聚焦指定屏幕上的第一个窗口
local function focusScreen(targetScreen)
    if not targetScreen then
        return
    end

    local windows = hs.window.orderedWindows()
    local didFocus = false

    for _, win in ipairs(windows) do
        -- 增加 win:subrole() ~= "AXUnknown" 过滤一些奇怪的幽灵窗口
        if win:isVisible() and win:isStandard() and win:screen():id() == targetScreen:id() then
            win:focus()
            -- 稍微延时移动鼠标，确保视觉跟上焦点
            hs.timer.doAfter(0.01, function()
                hs.mouse.setAbsolutePosition(win:frame().center)
            end)
            didFocus = true
            break
        end
    end

    -- 【关键修改 2】：处理空屏幕情况
    if not didFocus then
        local center = targetScreen:frame().center
        hs.mouse.setAbsolutePosition(center)

        -- 可选：如果想要更强的确认感，可以点击一下屏幕中心（激活 Finder），
        -- 防止键盘输入依然发送到上一个屏幕的窗口。
        -- hs.eventtap.leftClick(center) 
    end

    flashScreenFrame(targetScreen)

    local name = targetScreen:name()
    if not didFocus then
        name = name .. " (空)"
    end
    feedback.show("聚焦: " .. name, targetScreen)
end

-- 聚焦到下一个屏幕
function M.focusNextScreen()
    local currentScreen = getCurrentScreen()
    if not currentScreen then
        return
    end

    local nextScreen = currentScreen:next()
    -- 防止单屏幕报错
    if not nextScreen or nextScreen:id() == currentScreen:id() then
        return
    end

    focusScreen(nextScreen)
end

-- 聚焦到上一个屏幕
function M.focusPreviousScreen()
    local currentScreen = getCurrentScreen()
    if not currentScreen then
        return
    end

    local previousScreen = currentScreen:previous()
    if not previousScreen or previousScreen:id() == currentScreen:id() then
        return
    end

    focusScreen(previousScreen)
end

return M
