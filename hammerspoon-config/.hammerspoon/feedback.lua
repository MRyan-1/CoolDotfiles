local feedback = {}
local canvas = nil
local timer = nil
local style = {
    bg = { hex = "#050505", alpha = 0.98 },
    yellow = { hex = "#fcee0a" }
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

return feedback
