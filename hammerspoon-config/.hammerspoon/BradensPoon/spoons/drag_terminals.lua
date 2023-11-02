dragAppName = dragAppName or 'iTerm'

local merge = pl.tablex.merge
local fromHexAlpha = poon.utils.colors.fromHexAlpha

local color = fromHexAlpha('#00FFFF', 0.3)
local endColor = fromHexAlpha('#FFFFFF', 0.3)
local strokeColor = merge(color, {
    alpha = 1
}, true)

local rectanglePreview = hs.drawing.rectangle(hs.geometry.rect(0, 0, 0, 0))
rectanglePreview:setStrokeWidth(2)
rectanglePreview:setStrokeColor(strokeColor)
rectanglePreview:setFillGradient(color, endColor, 45)
rectanglePreview:setRoundedRectRadii(2, 2)
rectanglePreview:setStroke(true):setFill(true):setLevel("floating")

local function openIterm()
    local frame = rectanglePreview:frame()
    local createItermWithBounds = string.format([[
    if application "iTerm" is not running then
      launch application "iTerm"
    end if
     tell application "iTerm"
      activate
      delay 0.5
      try
        set newWindow to (create window with default profile)
        set the bounds of newWindow to {%i, %i, %i, %i}
      on error errMsg
        display dialog "Error: " & errMsg
      end try
    end tell
  ]], frame.x, frame.y, frame.x + frame.w, frame.y + frame.h)
    hs.osascript.applescript(createItermWithBounds)
end

local function openCalculator()
    local frame = rectanglePreview:frame()
    local createCalculatorWithBounds = string.format([[
  if application "Calculator" is not running then
    launch application "Calculator"
  end if
  tell application "Calculator"
    set bounds of the first window to {%i, %i, %i, %i}
  end tell
]], frame.x, frame.y, frame.x + frame.w, frame.y + frame.h)
    hs.osascript.applescript(createCalculatorWithBounds)
end

local dragging = false
local fromPoint = nil

local drag_event = hs.eventtap.new({hs.eventtap.event.types.mouseMoved}, function(e)
    if not dragging then
        return nil
    end
    local toPoint = hs.mouse.absolutePosition()
    rectanglePreview:setFrame(hs.geometry.new({
        x1 = fromPoint.x,
        y1 = fromPoint.y,
        x2 = toPoint.x,
        y2 = toPoint.y
    }))
    return nil
end)

local flags_event = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(e)
    local flags = e:getFlags()
    if flags.ctrl and flags.shift and not dragging then
        fromPoint = hs.mouse.absolutePosition()
        if fromPoint ~= nil then
            rectanglePreview:setFrame(hs.geometry.rect(fromPoint.x, fromPoint.y, 0, 0))
            drag_event:start()
            rectanglePreview:show()
            dragging = true
        else
            drag_event:stop()
            rectanglePreview:hide()
            dragging = false
        end
    elseif dragging then
        drag_event:stop()
        rectanglePreview:hide()
        dragging = false
        fromPoint = nil
        if dragAppName == 'iTerm' then
            openIterm()
        elseif dragAppName == 'Calculator' then
            openCalculator()
        else
            hs.alert.show("暂不支持的APP")
        end
    end
end)

flags_event:start()

local esc_event = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
    if e:getKeyCode() == 53 and dragging then
        drag_event:stop()
        rectanglePreview:hide()
        dragging = false
        fromPoint = nil
        return true
    end
end)

esc_event:start()
