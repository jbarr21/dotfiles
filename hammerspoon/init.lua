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

hs.hotkey.bind(meh, 'i', bindApp('IntelliJ'))
hs.hotkey.bind(meh, 'p', bindApp('Projector'))
hs.hotkey.bind(meh, 't', bindApp('iTerm'))
hs.hotkey.bind(meh, 'w', bindApp('Google Chrome'))
hs.hotkey.bind(meh, 'c', bindApp('Visual Studio Code'))
hs.hotkey.bind(meh, 's', bindApp('Slack'))
hs.hotkey.bind(meh, 'f', bindApp('Finder'))

-- Talon & Zoom audio toggle
hs.hotkey.bind('', 'f13', function()
  hs.notify.new({title="Hammerspoon", informativeText="Toggled Zoom audio"}):send()
  hs.eventtap.keyStroke({'cmd', 'shift'}, 'A')
end)
hs.hotkey.bind('', 'f15', function()
  hs.notify.new({title="Hammerspoon", informativeText="Toggled Talon audio"}):send()
  hs.execute([["/Users/jbarr/dotfiles/bin/talon-toggle.sh"]])
end)

local vimouse = require('vimouse')
vimouse('cmd', 'm')

-- mouse screen jump
local hyperShift = {'ctrl', 'alt', 'cmd', 'shift'}
hs.hotkey.bind(hyperShift, '`', function()
  local screen = hs.mouse.getCurrentScreen()
  local nextScreen = screen:next()
  local rect = nextScreen:fullFrame()
  local center = hs.geometry.rectMidPoint(rect)
  hs.mouse.setAbsolutePosition(center)
end)

hs.notify.new({title='Hammerspoon', informativeText='Ready to rock 🤘'}):send()