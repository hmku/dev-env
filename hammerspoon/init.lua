hs.window.animationDuration = 0
hs.screen.strictScreenInDirection = true
hs.autoLaunch(true)
hs.ipc.cliInstall()

local hyper = { "alt" }
local unitTolerance = 0.03

local units = {
  left = { x = 0, y = 0, w = 0.5, h = 1 },
  right = { x = 0.5, y = 0, w = 0.5, h = 1 },
  top = { x = 0, y = 0, w = 1, h = 0.5 },
  bottom = { x = 0, y = 0.5, w = 1, h = 0.5 },
  full = { x = 0, y = 0, w = 1, h = 1 },
}

local maximizedWindowFrames = {}

local function focusedWindow()
  local window = hs.window.focusedWindow() or hs.window.frontmostWindow()
  if not window then
    hs.alert.show("Grant Hammerspoon Accessibility permission")
  end
  return window
end

local function moveFocusedWindow(unit)
  return function()
    local window = focusedWindow()
    if window then
      window:moveToUnit(unit)
    end
  end
end

local function isApproxUnit(window, unit)
  local screen = window:screen()
  if not screen then
    return false
  end

  local current = screen:toUnitRect(window:frame())
  return math.abs(current.x - unit.x) < unitTolerance
    and math.abs(current.y - unit.y) < unitTolerance
    and math.abs(current.w - unit.w) < unitTolerance
    and math.abs(current.h - unit.h) < unitTolerance
end

local function moveFocusedWindowHorizontally(direction)
  return function()
    local window = focusedWindow()
    if not window then
      return
    end

    local screen = window:screen()
    if not screen then
      return
    end

    local unit = units[direction]
    if not isApproxUnit(window, unit) then
      window:moveToUnit(unit)
      return
    end

    local nextScreen = nil
    local nextUnit = nil
    if direction == "left" then
      nextScreen = screen:toWest(window:frame(), true)
      nextUnit = units.right
    else
      nextScreen = screen:toEast(window:frame(), true)
      nextUnit = units.left
    end

    if nextScreen then
      window:move(nextUnit, nextScreen, true)
    end
  end
end

local function toggleFocusedWindowMaximized()
  local window = focusedWindow()
  if not window then
    return
  end

  local windowId = window:id()
  if not windowId then
    window:moveToUnit(units.full)
    return
  end

  local savedFrame = maximizedWindowFrames[windowId]
  if savedFrame and isApproxUnit(window, units.full) then
    maximizedWindowFrames[windowId] = nil
    window:setFrame(savedFrame)
    return
  end

  maximizedWindowFrames[windowId] = window:frame()
  window:moveToUnit(units.full)
end

local function focusApp(name)
  return function()
    local ok = hs.application.launchOrFocus(name)
    if not ok then
      hs.alert.show("Could not open " .. name)
    end
  end
end

hs.hotkey.bind(hyper, "left", moveFocusedWindowHorizontally("left"))
hs.hotkey.bind(hyper, "right", moveFocusedWindowHorizontally("right"))
hs.hotkey.bind(hyper, "up", moveFocusedWindow(units.top))
hs.hotkey.bind(hyper, "down", moveFocusedWindow(units.bottom))
hs.hotkey.bind(hyper, "f", toggleFocusedWindowMaximized)
hs.hotkey.bind(hyper, "1", hs.reload)

hs.hotkey.bind(hyper, "s", focusApp("Ghostty"))
hs.hotkey.bind(hyper, "space", focusApp("Google Chrome"))

hs.alert.show("Hammerspoon config loaded")
