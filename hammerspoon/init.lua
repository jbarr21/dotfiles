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
hs.hotkey.bind(hyper, 'b', bindApp('Bitwarden'))
hs.hotkey.bind(hyper, 'c', bindApp('Visual Studio Code'))
hs.hotkey.bind(hyper, 'i', bindApp('IntelliJ'))
hs.hotkey.bind(hyper, 'm', bindApp('Spotify'))
hs.hotkey.bind(hyper, 'p', bindApp('Projector'))
hs.hotkey.bind(hyper, 's', bindApp('Slack'))
hs.hotkey.bind(hyper, 't', bindApp('iTerm'))
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

hs.notify.new({title='Hammerspoon', informativeText='Ready to rock 🤘'}):send()