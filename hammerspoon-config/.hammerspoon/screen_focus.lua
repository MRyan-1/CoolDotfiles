-- author = "Ryan.ma"
local feedback = require("feedback")
local M = {}

-- Move mouse to the center of the next screen and focus the top-most window on it
function M.focusNextScreen()
    local currentScreen = hs.mouse.getCurrentScreen()
    -- next() returns the next screen in the layout, wrapping around
    local nextScreen = currentScreen:next()

    if not nextScreen or nextScreen:id() == currentScreen:id() then
        -- If only one screen, do nothing or maybe just ensure focus?
        -- User request implies multi-monitor setup.
        return
    end

    -- Move mouse to center of next screen
    local rect = nextScreen:fullFrame()
    local center = hs.geometry.point(rect.x + rect.w / 2, rect.y + rect.h / 2)
    hs.mouse.setAbsolutePosition(center)

    -- Focus the frontmost window on the next screen
    -- hs.window.orderedWindows() returns windows in z-order (front to back).
    local windows = hs.window.orderedWindows()
    local focused = false
    for _, win in ipairs(windows) do
        if win:screen():id() == nextScreen:id() and win:isStandard() and win:isVisible() then
            win:focus()
            feedback.show(win:application():name(), nextScreen)
            focused = true
            break
        end
    end

    if not focused then
        feedback.show("屏幕已切换", nextScreen)
    end
end

return M
