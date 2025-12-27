--- === Music ===
---
--- Apple Music Controller - Pure Control
---

local obj={}
obj.__index = obj

-- Metadata
obj.name = "Music"
obj.version = "2.3.1"
obj.author = "Ryan.ma"

local MUSIC_APP_NAME = "Music"

-- Canvases
obj.feedback_canvas = nil
obj.feedback_timer = nil

-- 配色
local c = {
    bg = { hex = "#050505", alpha = 0.98 },
    yellow = { hex = "#fcee0a" }
}

-- AppleScript Helper
function obj:as(script)
    local ok, result, raw = hs.osascript.applescript(string.format([[
        if application "%s" is running then
            tell application "%s"
                try
                    %s
                end try
            end tell
        end if
    ]], MUSIC_APP_NAME, MUSIC_APP_NAME, script))
    return ok, result
end

function obj:init()
    -- 操作反馈面板
    obj.feedback_canvas = hs.canvas.new({x=0, y=0, w=0, h=0})
    obj.feedback_canvas[1] = { type = "rectangle", action = "fill", fillColor = c.bg, roundedRectRadii = { xRadius = 0, yRadius = 0 }, strokeColor = c.yellow, strokeWidth = 1 }
    obj.feedback_canvas[2] = { type = "text", text = "", textFont = "PingFangSC-Semibold", textSize = 24, textColor = c.yellow, textAlignment = "center" }
end

-- [FIXED] showFeedback is now an internal method
function obj:showFeedback(message)
    if self.feedback_timer then self.feedback_timer:stop() end
    local mainScreen = hs.screen.mainScreen()
    local cres = mainScreen:fullFrame()
    local w, h = 200, 80
    self.feedback_canvas:frame({ x = cres.x + (cres.w - w)/2, y = cres.y + (cres.h - h)/2, w = w, h = h })
    self.feedback_canvas[2].text = message
    self.feedback_canvas[2].frame = { x=0, y=25, w=w, h=h }
    self.feedback_canvas:show()
    self.feedback_timer = hs.timer.doAfter(0.8, function() self.feedback_canvas:hide() end)
end

function obj:bindHotkeys(mapping)
    for key, action in pairs(mapping) do
        local mods, k = table.unpack(key)
        hs.hotkey.bind(mods, k, function() self[action](self) end)
    end
end

-- Media Controls
function obj:playpause() 
    self:showFeedback("播放 / 暂停")
    self:as("playpause")
end
function obj:next() self:showFeedback("下一首"); self:as("next track") end
function obj:previous() self:showFeedback("上一首"); self:as("previous track") end

return obj