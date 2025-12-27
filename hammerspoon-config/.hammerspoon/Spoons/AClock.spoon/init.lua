--- === AClock ===
---
--- V13.2.1 System Protocol - Global Fix Edition
---

local obj={}
obj.__index = obj

-- Metadata
obj.name = "AClock"
obj.version = "13.2.1"

-- 配色
local c = {
    bg = { hex = "#050505", alpha = 0.98 },
    yellow = { hex = "#fcee0a" },
    yellow_dim = { hex = "#fcee0a", alpha = 0.3 },
    black = { hex = "#000000" },
    text_dim = { hex = "#ffffff", alpha = 0.2 },
    alert = { hex = "#ff003c" },
    track = { hex = "#1a1a1a" },
    grid = { hex = "#ffffff", alpha = 0.04 }
}

function obj:init()
    self.canvas = hs.canvas.new({x=0, y=0, w=0, h=0})

    -- 1. 背景板
    self.canvas:insertElement({
        type = "rectangle", action = "fill", fillColor = c.bg,
        roundedRectRadii = { xRadius = 0, yRadius = 0 },
        strokeColor = c.yellow, strokeWidth = 1,
        shadow = { blurRadius = 40, color = c.yellow, alpha = 0.15, offset = { h=0, w=0 } }
    })

    -- [纹理] 蜂巢
    local hexR = 15
    local hexH = math.sqrt(3) * hexR
    local startX, startY = 20, 20
    for row = 0, 3 do
        for col = 0, 10 do
            local cx = startX + col * (hexR * 3)
            local cy = startY + row * hexH
            if col % 2 == 1 then cy = cy + (hexH / 2) end
            self.canvas:insertElement({
                type = "segments", action = "stroke", strokeColor = c.grid, strokeWidth = 1,
                coordinates = { 
                    { x = cx + math.cos(math.rad(30))*hexR, y = cy + math.sin(math.rad(30))*hexR },
                    { x = cx + math.cos(math.rad(90))*hexR, y = cy + math.sin(math.rad(90))*hexR },
                    { x = cx + math.cos(math.rad(150))*hexR, y = cy + math.sin(math.rad(150))*hexR }
                }
            })
        end
    end

    -- 2. 呼吸装甲
    local bracketWidth = 8
    self.armorIndices = {}
    local armorCoords = {
        {{x="0%", y="25%"}, {x="0%", y="0%"}, {x="12%", y="0%"}},
        {{x="88%", y="0%"}, {x="100%", y="0%"}, {x="100%", y="25%"}},
        {{x="100%", y="75%"}, {x="100%", y="100%"}, {x="88%", y="100%"}},
        {{x="12%", y="100%"}, {x="0%", y="100%"}, {x="0%", y="75%"}}
    }
    for _, coord in ipairs(armorCoords) do
        self.canvas:insertElement({ type = "segments", action = "stroke", strokeColor = c.yellow, strokeWidth = bracketWidth, coordinates = coord })
        table.insert(self.armorIndices, #self.canvas)
    end

    -- 3. 顶部区域
    local stripeBox = { x = 40, y = 20, w = 180, h = 24 }
    self.canvas:insertElement({ type = "rectangle", action = "fill", fillColor = c.yellow, frame = stripeBox })
    self.canvas:insertElement({ type = "text", text = "系统协议 // 联机激活", textFont = "PingFangSC-Semibold", textSize = 11, textColor = c.black, textAlignment = "center", frame = { x = 40, y = 24, w = 180, h = 24 } })
    
    self.canvas:insertElement({ type = "circle", action = "fill", fillColor = c.alert, center = { x = 580, y = 32 }, radius = 5, shadow = { blurRadius = 8, color = c.alert, offset = { h=0, w=0 } } })
    self.heartbeatIndex = #self.canvas

    -- 4. 数据层
    self.canvas:insertElement({ type = "text", text = "", textFont = "PingFangSC-Semibold", textSize = 18, textColor = c.yellow, textAlignment = "left", frame = { x = 40, y = 55, w = 400, h = 30 } })
    self.dateIndex = #self.canvas
    self.visualizerIndices = {}
    local visX, visY = 40, 82
    for i = 1, 12 do
        self.canvas:insertElement({ type = "rectangle", action = "fill", fillColor = c.yellow, frame = { x = visX + (i-1)*8, y = visY, w = 4, h = 5 } })
        table.insert(self.visualizerIndices, #self.canvas)
    end

            -- [主时间]

            local timeRect = { x = 30, y = 95, w = 420, h = 130 }

            self.canvas:insertElement({ type = "text", text = "", textFont = "DIN Alternate-Bold", textSize = 105, textColor = c.yellow, textAlignment = "left", frame = timeRect, shadow = { blurRadius = 35, color = c.yellow_dim, alpha=0.8, offset = {h=0, w=0} } })

            self.timeGlowIndex = #self.canvas

            self.canvas:insertElement({ type = "text", text = "", textFont = "DIN Alternate-Bold", textSize = 105, textColor = { hex="#ffffcc" }, textAlignment = "left", frame = timeRect })

            self.timeCoreIndex = #self.canvas

        

            -- [连接管线]

            local lineY = 190

            self.canvas:insertElement({ type = "segments", action = "stroke", strokeColor = { hex = "#fcee0a", alpha = 0.4 }, strokeWidth = 3, coordinates = { { x = 300, y = lineY }, { x = 460, y = lineY }, { x = 490, y = 170 } } })

            self.packetIndex = #self.canvas + 1

            self.canvas:insertElement({ type = "circle", action = "fill", fillColor = c.yellow, center = { x = 300, y = lineY }, radius = 4, shadow = { blurRadius = 6, color = c.yellow, offset = {h=0, w=0} } })

        

            -- [数据矩阵]

            self.matrixIndices = {}
    local mxStart, myStart = 500, 140
    for r = 0, 2 do
        for c_idx = 0, 3 do
            self.canvas:insertElement({ type = "rectangle", action = "fill", fillColor = { hex = "#fcee0a", alpha = 0.1 }, frame = { x = mxStart + c_idx * 15, y = myStart + r * 15, w = 8, h = 8 } })
            table.insert(self.matrixIndices, #self.canvas)
        end
    end

    -- 秒数区域
    self.canvas:insertElement({ type = "rectangle", action = "fill", fillColor = c.yellow, frame = { x = 515, y = 110, w = 80, h = 20 } })
    self.canvas:insertElement({ type = "text", text = "SEC", textFont = "DIN Alternate-Bold", textSize = 11, textColor = c.black, textAlignment = "center", frame = { x = 515, y = 113, w = 80, h = 20 } })
    self.canvas:insertElement({ type = "text", text = "00", textFont = "DIN Alternate-Bold", textSize = 70, textColor = c.yellow, textAlignment = "right", frame = { x = 480, y = 135, w = 115, h = 80 } })
    self.secIndex = #self.canvas

    -- 5. 底部区域
    local rulerY = 225
    for i = 0, 58 do
        local h = 4; if i % 5 == 0 then h = 8 end
        self.canvas:insertElement({ type = "segments", action = "stroke", strokeColor = c.text_dim, strokeWidth = 1, coordinates = { { x = 30 + i * 10, y = rulerY }, { x = 30 + i * 10, y = rulerY - h } } })
    end
    self.canvas:insertElement({ type = "rectangle", action = "fill", fillColor = c.track, frame = { x = 30, y = 230, w = 580, h = 12 }, roundedRectRadii = { xRadius = 2, yRadius = 2 } })
    self.canvas:insertElement({ type = "rectangle", action = "fill", fillColor = c.yellow, frame = { x = 30, y = 230, w = 0, h = 12 }, roundedRectRadii = { xRadius = 2, yRadius = 2 }, shadow = { blurRadius = 10, color = c.yellow, offset = {h=0, w=0} } })
    self.barIndex = #self.canvas
    self.canvas:insertElement({ type = "text", text = "", textFont = "PingFangSC-Semibold", textSize = 10, textColor = c.text_dim, textAlignment = "right", frame = { x = 30, y = 250, w = 580, h = 20 } })
    self.msIndex = #self.canvas
    
    -- [反光层]
    self.canvas:insertElement({ type = "rectangle", action = "fill", fillGradient = "linear", fillGradientColors = { {hex="#ffffff", alpha=0.04}, {hex="#ffffff", alpha=0.0} }, fillGradientAngle = 60, frame = { x = 0, y = 0, w = 640, h = 140 } })
end

function obj:toggleShow()
    local function stopAndHide()
        if self.secTimer then self.secTimer:stop() self.secTimer = nil end
        self.canvas:hide()
    end

    if self.canvas:isShowing() then
        stopAndHide()
    else
        local mainScreen = hs.screen.mainScreen()
        local cres = mainScreen:fullFrame()
        local w, h = 640, 280
        self.canvas:frame({ x = cres.x + (cres.w - w)/2, y = cres.y + (cres.h - h)/2, w = w, h = h })

        local packetPos = 0
        local function updateClock()
            local now = os.date("*t")
            local time = hs.timer.secondsSinceEpoch()
            local ms = math.floor((time % 1) * 1000)
            
            -- 更新时间和日期
            local timeStr = string.format("%02d:%02d", now.hour, now.min)
            self.canvas[self.timeGlowIndex].text = timeStr
            self.canvas[self.timeCoreIndex].text = timeStr
            self.canvas[self.dateIndex].text = string.format("%d年%d月%d日 %s", now.year, now.month, now.day, ({"周日","周一","周二","周三","周四","周五","周六"})[now.wday])
            self.canvas[self.secIndex].text = string.format("%02d", now.sec)
            self.canvas[self.barIndex].frame.w = (now.sec + ms/1000) / 60 * 580
            self.canvas[self.msIndex].text = string.format("CHRONO_OFFSET // +%03d MS", ms)

            -- 动画效果
            local breath = (math.sin(time * 4) + 1) / 2 * 0.6 + 0.4
            for _, idx in ipairs(self.armorIndices) do self.canvas[idx].strokeColor.alpha = breath end
            
            if self.heartbeatIndex then
                if ms < 200 then
                    self.canvas[self.heartbeatIndex].fillColor.alpha = 1.0
                    self.canvas[self.heartbeatIndex].shadow.color.alpha = 1.0
                else
                    self.canvas[self.heartbeatIndex].fillColor.alpha = 0.2
                    self.canvas[self.heartbeatIndex].shadow.color.alpha = 0.0
                end
            end

            packetPos = packetPos + 8; if packetPos > 190 then packetPos = 0 end
            if packetPos <= 160 then self.canvas[self.packetIndex].center.x = 300 + packetPos; self.canvas[self.packetIndex].center.y = 190
            else local offset = packetPos - 160; self.canvas[self.packetIndex].center.x = 460 + offset; self.canvas[self.packetIndex].center.y = 190 - (offset * 0.66) end
            for _, idx in ipairs(self.visualizerIndices) do local h = math.random(2, 12); self.canvas[idx].frame.h = h; self.canvas[idx].frame.y = 97 - h end
            for _, idx in ipairs(self.matrixIndices) do if math.random() > 0.8 then self.canvas[idx].fillColor.alpha = 0.6 else self.canvas[idx].fillColor.alpha = 0.1 end end
        end
        updateClock(); self.canvas:show(); self.secTimer = hs.timer.doEvery(0.03, updateClock)
    end
end

return obj