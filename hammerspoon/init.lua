hs.window.animationDuration = 0
hs.autoLaunch(true)
hs.ipc.cliInstall()

local hyper = { "alt" }

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

local function focusApp(name)
  return function()
    local ok = hs.application.launchOrFocus(name)
    if not ok then
      hs.alert.show("Could not open " .. name)
    end
  end
end

hs.hotkey.bind(hyper, "left", moveFocusedWindow({ x = 0, y = 0, w = 0.5, h = 1 }))
hs.hotkey.bind(hyper, "right", moveFocusedWindow({ x = 0.5, y = 0, w = 0.5, h = 1 }))
hs.hotkey.bind(hyper, "up", moveFocusedWindow({ x = 0, y = 0, w = 1, h = 0.5 }))
hs.hotkey.bind(hyper, "down", moveFocusedWindow({ x = 0, y = 0.5, w = 1, h = 0.5 }))

hs.hotkey.bind(hyper, "s", focusApp("Ghostty"))
hs.hotkey.bind(hyper, "space", focusApp("Google Chrome"))

hs.alert.show("Hammerspoon config loaded")
