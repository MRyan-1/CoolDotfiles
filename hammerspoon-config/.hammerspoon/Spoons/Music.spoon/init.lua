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
end

function obj:showFeedback(message)
    local feedback = require("feedback")
    feedback.show(message)
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