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
    local _, isRunning = hs.osascript.applescript('application "Music" is running')
    if isRunning then
        local _, hasTrack = hs.osascript.applescript('tell application "Music" to exists current track')
        if hasTrack then
            self:showFeedback("播放 / 暂停")
            self:as("playpause")
        else
            self:showFeedback("播放资料库")
            hs.osascript.applescript('tell application "Music" to play playlist "资料库"')
        end
    else
        self:showFeedback("启动音乐app")
        hs.application.launchOrFocusByBundleID("com.apple.Music")
        hs.timer.doAfter(3, function()
            hs.osascript.applescript('tell application "Music" to play playlist "资料库"')
        end)
    end
end
function obj:next() self:showFeedback("下一首"); self:as("next track") end
function obj:previous() self:showFeedback("上一首"); self:as("previous track") end

return obj