---=== ModalMgr ===
--- Mode binding environment management.
---
local feedback = require("feedback")
local obj = {}
obj.__index = obj

-- Metadata
obj.name = "ModalMgr"
obj.version = "1.0.0"
obj.author = "Ryan.ma"

obj.modal_tray = nil
obj.modal_list = {}
obj.active_list = {}
obj.supervisor = nil

-- 配色
local c = {
    bg = {
        hex = "#0a0a0a",
        alpha = 0.95
    },
    yellow = {
        hex = "#fcee0a"
    },
    text = {
        hex = "#ffffff"
    },
    border = {
        hex = "#fcee0a",
        alpha = 0.5
    },
    header_bg = {
        hex = "#fcee0a",
        alpha = 0.1
    }
}

function obj:init()
    hsupervisor_keys = hsupervisor_keys or {{"cmd", "shift", "ctrl"}, "Q"}
    obj.supervisor = hs.hotkey.modal.new(hsupervisor_keys[1], hsupervisor_keys[2], nil)

    -- 1. 右下角状态托盘
    obj.modal_tray = hs.canvas.new({
        x = 0,
        y = 0,
        w = 0,
        h = 0
    })
    obj.modal_tray:level(hs.canvas.windowLevels.tornOffMenu)

    -- 背景
    obj.modal_tray[1] = {
        type = "rectangle",
        action = "fill",
        fillColor = c.bg,
        roundedRectRadii = {
            xRadius = 4,
            yRadius = 4
        },
        strokeColor = c.yellow,
        strokeWidth = 4,
        shadow = {
            blurRadius = 15,
            color = c.yellow,
            alpha = 0.6,
            offset = {
                h = 0,
                w = 0
            }
        }
    }
    -- 文字
    obj.modal_tray[2] = {
        type = "text",
        text = "MODE",
        textFont = "DIN Alternate",
        textStyle = {
            weight = "bold"
        },
        textSize = 22,
        textColor = c.yellow,
        textAlignment = "center",
        frame = {
            x = "0%",
            y = "22%",
            w = "100%",
            h = "78%"
        }
    }
end

function obj:new(id)
    obj.modal_list[id] = hs.hotkey.modal.new()
end

function obj:toggleCheatsheet(iterList, force)
    if feedback.is_palette_visible() and not force then
        feedback.hide_palette()
    else
        local keys_pool = {}
        local tmplist = iterList or obj.active_list
        for i, v in pairs(tmplist) do
            local modal = obj.modal_list[v] or v
            if modal and modal.keys then
                for _, m in pairs(modal.keys) do
                    if m.msg then
                        -- 构造 "[按键] 描述"
                        local modStr = ""
                        if m.mods and #m.mods > 0 then
                            modStr = table.concat(m.mods, "+") .. "+"
                        end
                        local keyLine = string.format("%s%s  %s", string.upper(modStr), string.upper(m.key or ""),
                            m.msg)
                        table.insert(keys_pool, keyLine)
                    end
                end
            end
        end
        if #keys_pool == 0 then
            return
        end

        feedback.show_palette("COMMANDS // 指令", keys_pool, nil, nil, 2)
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
        local w, h = 200, 50
        obj.modal_tray:frame({
            x = cres.x + cres.w - w - 40,
            y = cres.y + cres.h - h - 40, -- 稍微往里一点
            w = w,
            h = h
        })

        local modeName = string.upper(idList[1] or "MODE")
        obj.modal_tray[2].text = modeName
        obj.modal_tray[1].strokeColor = {
            hex = trayColor,
            alpha = 1
        }
        obj.modal_tray[1].shadow.color = {
            hex = trayColor,
            alpha = 0.8
        } -- 增强阴影

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
    feedback.hide_palette()
end

function obj:deactivateAll()
    local list = {}
    for i, v in pairs(obj.active_list) do
        table.insert(list, i)
    end
    obj:deactivate(list)
end

return obj
