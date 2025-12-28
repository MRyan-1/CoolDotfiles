-- author = "Ryan.ma"
local feedback = {}
local canvas = nil
local palette = nil
local timer = nil
local style = {
    bg = { hex = "#050505", alpha = 0.98 },
    yellow = { hex = "#fcee0a" },
    text = { hex = "#ffffff" },
    header_bg = { hex = "#fcee0a", alpha = 0.1 }
}

function feedback.show(text, screen)
    if not canvas then
        canvas = hs.canvas.new({x=0, y=0, w=0, h=0})
        -- 1. 背景板 (带阴影)
        canvas[1] = { 
            type = "rectangle", action = "fill", fillColor = style.bg, 
            roundedRectRadii = { xRadius = 0, yRadius = 0 }, 
            strokeColor = style.yellow, strokeWidth = 1,
            shadow = { blurRadius = 20, color = style.yellow, alpha = 0.15, offset = { h=0, w=0 } }
        }
        
        -- 2. 四角装饰边框 (Armor)
        local armorWidth = 4
        local armorCoords = {
            {{x="0%", y="25%"}, {x="0%", y="0%"}, {x="15%", y="0%"}},
            {{x="85%", y="0%"}, {x="100%", y="0%"}, {x="100%", y="25%"}},
            {{x="100%", y="75%"}, {x="100%", y="100%"}, {x="85%", y="100%"}},
            {{x="15%", y="100%"}, {x="0%", y="100%"}, {x="0%", y="75%"}}
        }
        for i, coord in ipairs(armorCoords) do
            canvas[1 + i] = { type = "segments", action = "stroke", strokeColor = style.yellow, strokeWidth = armorWidth, coordinates = coord }
        end
        
        -- 3. 文字内容
        canvas[6] = { type = "text", text = "", textFont = "PingFangSC-Semibold", textSize = 24, textColor = style.yellow, textAlignment = "center" }
    end

    if timer then timer:stop() end

    local targetScreen = screen or hs.screen.mainScreen()
    local cres = targetScreen:fullFrame()
    
    -- 动态计算宽度
    local textStyle = { font = "PingFangSC-Semibold", size = 24 }
    local textSizeInfo = hs.drawing.getTextDrawingSize(text, textStyle)
    local w = math.max(200, textSizeInfo.w + 80)
    local h = 80
    
    canvas:frame({ x = cres.x + (cres.w - w)/2, y = cres.y + (cres.h - h)/2, w = w, h = h })
    canvas[6].text = text
    canvas[6].frame = { x=0, y=25, w=w, h=h }
    canvas:show()
    timer = hs.timer.doAfter(0.8, function() canvas:hide() end)
end

function feedback.show_palette(title, items, screen, selectedIndex, columns)
    if not palette then
        palette = hs.canvas.new({x=0, y=0, w=0, h=0})
        palette:level(hs.canvas.windowLevels.tornOffMenu)
    end

    if not items or #items == 0 then
        palette:hide()
        return
    end

    local targetScreen = screen or hs.screen.mainScreen()
    local cres = targetScreen:fullFrame()

    local cols = columns or 1
    local rows = math.ceil(#items / cols)
    local itemH = 40
    local headerH = 50
    local w = (cols == 1) and 550 or 700
    local h = headerH + (rows * itemH) + 20

    palette:frame({
        x = cres.x + (cres.w - w) / 2,
        y = cres.y + (cres.h - h) / 2,
        w = w,
        h = h
    })

    -- 清空
    while #palette > 0 do palette[#palette] = nil end

    -- [1] 背景板
    palette[1] = {
        type = "rectangle", action = "fill", fillColor = style.bg,
        roundedRectRadii = { xRadius = 0, yRadius = 0 },
        strokeColor = style.yellow, strokeWidth = 1,
        shadow = { blurRadius = 20, color = style.yellow, alpha = 0.15, offset = {h=0, w=0} }
    }
    
    -- 四角装饰
    local armorWidth = 4
    local armorCoords = {
        {{x="0%", y="15%"}, {x="0%", y="0%"}, {x="10%", y="0%"}},
        {{x="90%", y="0%"}, {x="100%", y="0%"}, {x="100%", y="15%"}},
        {{x="100%", y="85%"}, {x="100%", y="100%"}, {x="90%", y="100%"}},
        {{x="10%", y="100%"}, {x="0%", y="100%"}, {x="0%", y="85%"}}
    }
    for i, coord in ipairs(armorCoords) do
        palette[1 + i] = { type = "segments", action = "stroke", strokeColor = style.yellow, strokeWidth = armorWidth, coordinates = coord }
    end

    -- [2] 标题栏
    palette[6] = {
        type = "rectangle", action = "fill", fillColor = style.header_bg,
        frame = { x = 0, y = 0, w = w, h = headerH }
    }
    
    palette[7] = {
        type = "text",
        text = title,
        textFont = "PingFang SC",
        textStyle = { weight = "bold" },
        textSize = 16,
        textColor = style.yellow,
        textAlignment = "center",
        frame = { x = 0, y = 15, w = w, h = 30 }
    }

    -- [3] 列表项
    for idx, val in ipairs(items) do
        local col = (idx - 1) % cols
        local row = math.floor((idx - 1) / cols)
        local cellW = w / cols
        local x = col * cellW
        local y = headerH + row * itemH + 10
        
        local isSelected = (selectedIndex and idx == selectedIndex)
        
        if isSelected then
            palette[#palette+1] = {
                type = "rectangle", action = "fill",
                fillColor = { hex = style.yellow.hex, alpha = 0.2 },
                frame = { x = x + 5, y = y, w = cellW - 10, h = itemH - 4 }
            }
            palette[#palette+1] = {
                type = "rectangle", action = "fill",
                fillColor = style.yellow,
                frame = { x = x + 5, y = y, w = 4, h = itemH - 4 }
            }
        end
        
        palette[#palette+1] = {
            type = "text",
            text = val,
            textFont = (cols == 1) and "PingFangSC-Regular" or "Menlo",
            textSize = (cols == 1) and 14 or 12,
            textColor = isSelected and style.yellow or style.text,
            textAlignment = "left",
            frame = { x = x + 25, y = y + 10, w = cellW - 40, h = 30 }
        }
    end

    palette:show()
end

function feedback.is_palette_visible()
    return palette and palette:isShowing()
end

function feedback.hide_palette()
    if palette then palette:hide() end
end

return feedback