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
hs.hotkey.bind(hyper, 'c', bindApp('Visual Studio Code'))
-- F used for vimac show links
hs.hotkey.bind(hyper, 'g', bindApp('JetBrains Client'))
hs.hotkey.bind(hyper, 'i', bindApp('IntelliJ IDEA CE'))
hs.hotkey.bind(hyper, 'm', bindApp('Spotify'))
-- O used by Whoosh
hs.hotkey.bind(hyper, 'n', bindApp('Obsidian'))
-- P used by Paletro
hs.hotkey.bind(hyper, 'j', bindApp('Projector'))
hs.hotkey.bind(hyper, 's', bindApp('Slack'))
hs.hotkey.bind(hyper, 't', bindApp('iTerm'))
-- U used for vimac scroll mode
hs.hotkey.bind(hyper, 'v', bindApp('Warp'))
hs.hotkey.bind(hyper, 'w', bindApp('Google Chrome'))
hs.hotkey.bind(hyper, 'z', bindApp('zoom.us'))

spaces = require("hs.spaces")
-- move current window to the space sp
function MoveWindowToSpace(sp)
  local win = hs.window.focusedWindow()      -- current window
  local cur_screen = hs.screen.mainScreen()
  local cur_screen_id = cur_screen:getUUID()
  local all_spaces=spaces.allSpaces()
  local spaceID = all_spaces[cur_screen_id][sp]
  spaces.moveWindowToSpace(win:id(), spaceID)
  spaces.gotoSpace(spaceID)              -- follow window to new space
end
hs.hotkey.bind(hyper, '1', function() MoveWindowToSpace(1) end)
hs.hotkey.bind(hyper, '2', function() MoveWindowToSpace(2) end)
hs.hotkey.bind(hyper, '3', function() MoveWindowToSpace(3) end)
hs.hotkey.bind(hyper, '4', function() MoveWindowToSpace(4) end)
hs.hotkey.bind(hyper, '5', function() MoveWindowToSpace(5) end)
hs.hotkey.bind(hyper, '6', function() MoveWindowToSpace(6) end)

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

hs.hotkey.bind({}, 'f17', function()
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

hs.hotkey.bind({''}, 'f19', function()
  hs.execute('~/dotfiles/bin/toggle-trackball-scroll.sh', true)
end)

-- hs.hotkey.bind({''}, 'f24', function()
--   hs.execute('~/toggle-office-lights.sh', true)
-- end)

hs.notify.new({title='Hammerspoon', informativeText='Ready to rock 🤘'}):send()