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
        
        -- 3. 文字内容 (索引后移)
        canvas[6] = { type = "text", text = "", textFont = "PingFangSC-Semibold", textSize = 24, textColor = style.yellow, textAlignment = "center" }
    end

    if timer then timer:stop() end

    local targetScreen = screen or hs.screen.mainScreen()
    local cres = targetScreen:fullFrame()
    local w, h = 200, 80
    canvas:frame({ x = cres.x + (cres.w - w)/2, y = cres.y + (cres.h - h)/2, w = w, h = h })
    canvas[6].text = text
    canvas[6].frame = { x=0, y=25, w=w, h=h }
    canvas:show()
    timer = hs.timer.doAfter(0.8, function() canvas:hide() end)
end

function feedback.show_palette(title, items, screen)
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

    local cols = 2
    local rows = math.ceil(#items / cols)
    local itemH = 35
    local headerH = 50
    local w = 550
    local h = headerH + (rows * itemH) + 15

    palette:frame({
        x = cres.x + (cres.w - w) / 2,
        y = cres.y + (cres.h - h) / 2,
        w = w,
        h = h
    })

    -- 清空画布内容
    while #palette > 0 do palette[#palette] = nil end

    -- [1] 背景
    palette[#palette+1] = {
        type = "rectangle", action = "fill", fillColor = style.bg,
        roundedRectRadii = { xRadius = 6, yRadius = 6 },
        strokeColor = style.yellow, strokeWidth = 1,
        shadow = { blurRadius = 20, color = {hex="#000000", alpha=0.8}, offset = {h=10, w=0} }
    }

    -- [2] 标题栏背景
    palette[#palette+1] = {
        type = "rectangle", action = "fill", fillColor = style.header_bg,
        frame = { x = 0, y = 0, w = w, h = headerH },
        roundedRectRadii = { xRadius = 6, yRadius = 6 }
    }
    
    -- [3] 标题文字
    palette[#palette+1] = {
        type = "text",
        text = title,
        textFont = "PingFang SC",
        textStyle = { weight = "bold" },
        textSize = 15,
        textColor = style.yellow,
        textAlignment = "center",
        frame = { x = 0, y = 15, w = w, h = 30 }
    }
    
    -- [4] 装饰线
    palette[#palette+1] = {
        type = "segments", action = "stroke", strokeColor = style.yellow, strokeWidth = 2,
        coordinates = { { x = 0, y = headerH }, { x = w, y = headerH } }
    }

    -- [5] 列表内容
    for idx, val in ipairs(items) do
        local col = (idx - 1) % cols
        local row = math.floor((idx - 1) / cols)
        local x = col * (w / 2)
        local y = headerH + row * itemH + 8
        
        -- 指示点
        palette[#palette+1] = {
            type = "rectangle", action = "fill", fillColor = style.yellow,
            frame = { x = x + 30, y = y + 8, w = 4, h = 4 },
            rotation = 45
        }
        
        -- 文字
        palette[#palette+1] = {
            type = "text",
            text = val,
            textFont = "Menlo",
            textSize = 13,
            textColor = style.text,
            textAlignment = "left",
            frame = { x = x + 45, y = y, w = (w/2) - 50, h = 30 }
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
