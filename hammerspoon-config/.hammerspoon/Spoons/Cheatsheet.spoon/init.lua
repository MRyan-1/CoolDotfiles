--- === Cheatsheet ===
---
--- A Cyberpunk Style Shortcut Viewer (Fixed)
---

local obj={}
obj.__index = obj

-- Metadata
obj.name = "Cheatsheet"
obj.version = "1.2"
obj.author = "Ryan.ma"

-- 配色
local c = {
    bg = { hex = "#0a0a0a", alpha = 0.95 },
    yellow = { hex = "#fcee0a" },
    text = { hex = "#ffffff" },
    key_bg = { hex = "#222222" },
    border = { hex = "#fcee0a", alpha = 0.5 }
}

function obj:init()
    self.canvas = hs.canvas.new({x=0, y=0, w=0, h=0})
end

function obj:show(keysTable)
    if self.canvas:isShowing() then
        self.canvas:hide()
        return
    end

    local mainScreen = hs.screen.mainScreen()
    local cres = mainScreen:fullFrame()
    
    local itemHeight = 40
    local headerHeight = 60
    local padding = 20
    local count = #keysTable
    local totalHeight = headerHeight + (count * itemHeight) + padding
    local width = 500
    
    self.canvas:frame({
        x = cres.x + (cres.w - width) / 2,
        y = cres.y + (cres.h - totalHeight) / 2,
        w = width,
        h = totalHeight
    })

    while #self.canvas > 0 do self.canvas[#self.canvas] = nil end

    -- 1. 背景
    self.canvas[1] = {
        type = "rectangle", action = "fill", fillColor = c.bg,
        roundedRectRadii = { xRadius = 8, yRadius = 8 },
        strokeColor = c.border, strokeWidth = 2,
        shadow = { blurRadius = 20, color = {hex="#000000", alpha=0.8}, offset = {h=10, w=0} }
    }

    -- 2. 标题
    self.canvas[2] = {
        type = "text",
        text = "SYSTEM SHORTCUTS // 快捷键映射",
        textFont = "PingFangSC-Semibold",
        textSize = 18,
        textColor = c.yellow,
        textAlignment = "center",
        frame = { x = 0, y = 20, w = width, h = 30 }
    }
    
    -- 3. 分割线
    self.canvas[3] = {
        type = "segments", action = "stroke", strokeColor = c.border, strokeWidth = 1,
        coordinates = { { x = 20, y = 50 }, { x = width - 20, y = 50 } }
    }

    -- 4. 列表项
    for i, item in ipairs(keysTable) do
        local yPos = headerHeight + (i - 1) * itemHeight
        local mods = item[1]
        local key = item[2]
        local appName = item[3]
        
        local keyStr = ""
        for j, mod in ipairs(mods) do
            local modName = ""
            if mod == "ctrl" then modName = "Ctrl"
            elseif mod == "shift" then modName = "Shift"
            elseif mod == "cmd" then modName = "Cmd"
            elseif mod == "alt" then modName = "Alt"
            end
            
            if j == 1 then keyStr = modName
            else keyStr = keyStr .. " + " .. modName end
        end
        keyStr = keyStr .. " + " .. string.upper(key)

        self.canvas[#self.canvas + 1] = {
            type = "text", text = appName, textFont = "PingFang SC", textSize = 14, textColor = c.text,
            textAlignment = "left", frame = { x = 40, y = yPos + 10, w = 250, h = 30 }
        }

        self.canvas[#self.canvas + 1] = {
            type = "rectangle", action = "fill", fillColor = c.key_bg,
            roundedRectRadii = { xRadius = 4, yRadius = 4 },
            frame = { x = width - 220, y = yPos + 5, w = 180, h = 30 }
        }

        self.canvas[#self.canvas + 1] = {
            type = "text",
            text = keyStr,
            textFont = "Menlo-Bold",
            textSize = 12,
            textColor = c.yellow,
            textAlignment = "center",
            frame = { x = width - 220, y = yPos + 10, w = 180, h = 30 }
        }
    end

    self.canvas:show()
    
    self.canvas:canvasMouseEvents(true, true, false, false)
    self.canvas:mouseCallback(function(canvas, event, id, x, y)
        if event == "mouseUp" then
            canvas:hide()
        end
    end)
end

return obj
