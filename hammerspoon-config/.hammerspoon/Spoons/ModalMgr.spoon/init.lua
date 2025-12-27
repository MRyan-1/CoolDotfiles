---=== ModalMgr ===
---
--- Mode binding environment management.
--- Cyberpunk Style Enhanced V2.1
---

local obj = {}
obj.__index = obj

obj.name = "ModalMgr"
obj.version = "2.1"
obj.author = "ashfinal <ashfinal@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.modal_tray = nil
obj.which_key = nil
obj.modal_list = {}
obj.active_list = {}
obj.supervisor = nil

-- 配色
local c = {
    bg = { hex = "#0a0a0a", alpha = 0.95 },
    yellow = { hex = "#fcee0a" },
    text = { hex = "#ffffff" },
    border = { hex = "#fcee0a", alpha = 0.5 },
    header_bg = { hex = "#fcee0a", alpha = 0.1 }
}

function obj:init()
    hsupervisor_keys = hsupervisor_keys or {{"cmd", "shift", "ctrl"}, "Q"}
    obj.supervisor = hs.hotkey.modal.new(hsupervisor_keys[1], hsupervisor_keys[2], 'Initialize Modal Environment')
    
    -- 1. 右下角状态托盘
    obj.modal_tray = hs.canvas.new({x = 0, y = 0, w = 0, h = 0})
    obj.modal_tray:level(hs.canvas.windowLevels.tornOffMenu)
    
    -- 背景
    obj.modal_tray[1] = {
        type = "rectangle",
        action = "fill",
        fillColor = c.bg,
        roundedRectRadii = { xRadius = 4, yRadius = 4 },
        strokeColor = c.yellow,
        strokeWidth = 2,
        shadow = { blurRadius = 15, color = c.yellow, alpha = 0.6, offset = { h=0, w=0 } }
    }
    -- 文字
    obj.modal_tray[2] = {
        type = "text",
        text = "MODE",
        textFont = "DIN Alternate",
        textStyle = { weight = "bold" },
        textSize = 14,
        textColor = c.yellow,
        textAlignment = "center",
        frame = { x = "0%", y = "15%", w = "100%", h = "85%" }
    }

    -- 2. 快捷键面板
    obj.which_key = hs.canvas.new({x = 0, y = 0, w = 0, h = 0})
    obj.which_key:level(hs.canvas.windowLevels.tornOffMenu)
end

function obj:new(id)
    obj.modal_list[id] = hs.hotkey.modal.new()
end

function obj:toggleCheatsheet(iterList, force)
    if obj.which_key:isShowing() and not force then
        obj.which_key:hide()
    else
        local cscreen = hs.screen.mainScreen()
        local cres = cscreen:fullFrame()
        
        local keys_pool = {}
        local tmplist = iterList or obj.active_list
        for i, v in pairs(tmplist) do
            if type(v) == "string" then
                for _, m in ipairs(obj.modal_list[v].keys) do table.insert(keys_pool, m.msg) end
            elseif type(i) == "string" then
                for _, m in pairs(v.keys) do table.insert(keys_pool, m.msg) end
            end
        end
        if #keys_pool == 0 then return end

        local cols = 2
        local rows = math.ceil(#keys_pool / cols)
        local itemH = 35 -- 更紧凑
        local headerH = 50
        local w = 550
        local h = headerH + (rows * itemH) + 15
        
        obj.which_key:frame({
            x = cres.x + (cres.w - w) / 2,
            y = cres.y + (cres.h - h) / 2,
            w = w,
            h = h
        })

        -- 清空
        while #obj.which_key > 0 do obj.which_key[#obj.which_key] = nil end

        -- [1] 背景
        obj.which_key[#obj.which_key+1] = {
            type = "rectangle", action = "fill", fillColor = c.bg,
            roundedRectRadii = { xRadius = 6, yRadius = 6 },
            strokeColor = c.border, strokeWidth = 1,
            shadow = { blurRadius = 20, color = {hex="#000000", alpha=0.8}, offset = {h=10, w=0} }
        }

        -- [2] 标题栏背景 (Header BG)
        obj.which_key[#obj.which_key+1] = {
            type = "rectangle", action = "fill", fillColor = c.header_bg,
            frame = { x = 0, y = 0, w = w, h = headerH },
            roundedRectRadii = { xRadius = 6, yRadius = 6 } -- 仅顶部圆角效果需复杂路径，这里简单处理
        }
        
        -- [3] 标题文字
        obj.which_key[#obj.which_key+1] = {
            type = "text",
            text = "COMMANDS // 指令",
            textFont = "PingFang SC",
            textStyle = { weight = "bold" },
            textSize = 15,
            textColor = c.yellow,
            textAlignment = "center",
            frame = { x = 0, y = 15, w = w, h = 30 }
        }
        
        -- [4] 装饰线
        obj.which_key[#obj.which_key+1] = {
            type = "segments", action = "stroke", strokeColor = c.yellow, strokeWidth = 2,
            coordinates = { { x = 0, y = headerH }, { x = w, y = headerH } }
        }

        -- [5] 列表内容
        for idx, val in ipairs(keys_pool) do
            local col = (idx - 1) % cols
            local row = math.floor((idx - 1) / cols)
            local x = col * (w / 2)
            local y = headerH + row * itemH + 8
            
            -- 指示点
            obj.which_key[#obj.which_key+1] = {
                type = "rectangle", action = "fill", fillColor = c.yellow,
                frame = { x = x + 30, y = y + 8, w = 4, h = 4 },
                rotation = 45 -- 菱形点
            }
            
            -- 文字
            obj.which_key[#obj.which_key+1] = {
                type = "text",
                text = val,
                textFont = "Menlo",
                textSize = 13,
                textColor = c.text,
                textAlignment = "left",
                frame = { x = x + 45, y = y, w = (w/2) - 50, h = 30 }
            }
        end

        obj.which_key:show()
    end
end

function obj:activate(idList, trayColor, showKeys)
    for _, val in ipairs(idList) do
        obj.modal_list[val]:enter()
        obj.active_list[val] = obj.modal_list[val]
    end
    
    if trayColor then
        local cscreen = hs.screen.mainScreen()
        local cres = cscreen:fullFrame()
        local w, h = 120, 40
        obj.modal_tray:frame({
            x = cres.x + cres.w - w - 30,
            y = cres.y + cres.h - h - 30, -- 稍微往里一点
            w = w, h = h
        })
        
        local modeName = string.upper(idList[1] or "MODE")
        obj.modal_tray[2].text = modeName
        obj.modal_tray[1].strokeColor = {hex = trayColor, alpha = 1}
        obj.modal_tray[1].shadow.color = {hex = trayColor, alpha = 0.8} -- 增强阴影
        
        obj.modal_tray:show()
    end
    
    if showKeys then
        obj:toggleCheatsheet(idList, true)
    end
end

function obj:deactivate(idList)
    for _, val in ipairs(idList) do
        obj.modal_list[val]:exit()
        obj.active_list[val] = nil
    end
    obj.modal_tray:hide()
    obj.which_key:hide()
end

function obj:deactivateAll()
    local list = {}
    for i, v in pairs(obj.active_list) do
        table.insert(list, i)
    end
    obj:deactivate(list)
end

return obj
