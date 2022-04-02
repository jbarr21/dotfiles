local log = hs.logger.new('init.lua', 'debug')

-- Modifiers
meh = {'ctrl', 'alt', 'shift'}
hyper = {'shift', 'cmd', 'alt', 'ctrl'}

-- App shortcuts
local bindApp = function(appName)
  return function()
    hs.application.launchOrFocus(appName)
  end
end

hs.hotkey.bind(hyper, 'a', bindApp('Android Studio'))
hs.hotkey.bind(hyper, 'b', bindApp('Warp'))
hs.hotkey.bind(hyper, 'c', bindApp('Visual Studio Code'))
hs.hotkey.bind(hyper, 'i', bindApp('IntelliJ IDEA CE'))
hs.hotkey.bind(hyper, 'm', bindApp('Spotify'))
hs.hotkey.bind(hyper, 'p', bindApp('Projector'))
hs.hotkey.bind(hyper, 's', bindApp('Slack'))
hs.hotkey.bind(hyper, 't', bindApp('iTerm'))
hs.hotkey.bind(hyper, 'v', bindApp('Warp'))
hs.hotkey.bind(hyper, 'w', bindApp('Google Chrome'))
hs.hotkey.bind(hyper, 'z', bindApp('zoom.us'))

-- Talon & Zoom audio toggle
hs.hotkey.bind('', 'f13', function()
  hs.notify.new({title="Hammerspoon", informativeText="Toggled Zoom audio"}):send()
  hs.eventtap.keyStroke({'cmd', 'shift'}, 'A')
end)
hs.hotkey.bind('', 'f15', function()
  hs.notify.new({title="Hammerspoon", informativeText="Toggled Talon audio"}):send()
  hs.execute([["/Users/jbarr/dotfiles/bin/talon-toggle.sh"]])
end)

-- local vimouse = require('vimouse')
-- vimouse('cmd', 'm')

-- mouse screen jump
hs.hotkey.bind('', 'f16', function()
  local screen = hs.mouse.getCurrentScreen()
  local nextScreen = screen:next()
  local rect = nextScreen:fullFrame()
  local center = hs.geometry.rectMidPoint(rect)
  hs.mouse.setAbsolutePosition(center)
end)

hs.hotkey.bind('', 'f17', function()
  local ptMouse = hs.mouse.getAbsolutePosition()
  local types = hs.eventtap.event.types
  hs.eventtap.event.newMouseEvent(types.rightMouseDown, ptMouse, {}):post()
  hs.eventtap.event.newMouseEvent(types.rightMouseUp, ptMouse, {}):post()
end)

hs.hotkey.bind({'ctrl', 'shift'}, 'f17', function()
  hs.notify.new({title="Hammerspoon", informativeText="Split tab to new half of display"}):send()
  hs.eventtap.keyStroke({'cmd'}, 'l')
  hs.eventtap.keyStroke({'cmd'}, 'x')
  hs.eventtap.keyStroke({'cmd'}, 'w')
  
  -- move to left half of display
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)

  hs.eventtap.keyStroke({'cmd'}, 'n')
  hs.eventtap.keyStroke({'cmd'}, 'v')
  hs.eventtap.keyStroke({}, 'return')
  
  -- move to right half of display
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.notify.new({title='Hammerspoon', informativeText='Ready to rock 🤘'}):send()