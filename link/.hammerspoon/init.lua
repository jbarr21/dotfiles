local log = hs.logger.new('init.lua', 'debug')

function len(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

-- Modifiers
meh = {'ctrl', 'alt', 'shift'}
hyper = {'shift', 'cmd', 'alt', 'ctrl'}

-- App shortcuts
local bindApp = function(appName)
  return function()
    hs.application.launchOrFocus(appName)
  end
end

local hyperModeAppMappings = {
  { 'a', 'Android Studio' },
  { 'c', 'Visual Studio Code' },
  -- B used for Bartender item search
  -- D used for dictation
  { 'g', 'JetBrains Client' },
  { 'h', 'Hyper' },
  { 'i', 'IntelliJ IDEA Community Edition' },
  -- J used for homerow scrolling
  { 'm', 'Spotify' },
  { 'n', 'Obsidian' },
  -- P used by Search Menu Items feature of Raycast
  { 's', 'Slack' },
  { 't', 'iTerm' },
  { 'v', 'Warp' },
  { 'w', 'Google Chrome' },
  { 'z', 'zoom.us' },
}

for i, mapping in ipairs(hyperModeAppMappings) do
  local key = mapping[1]
  local app = mapping[2]
  hs.hotkey.bind(hyper, key, bindApp(app))
end

-- move current window to the space space_num
spaces = require("hs.spaces")
function MoveWindowToSpace(space_num)
  local win = hs.window.focusedWindow()
  local all_spaces=spaces.allSpaces()
  local main_screen = hs.screen.primaryScreen()
  local num_main_spaces = len(all_spaces[main_screen:getUUID()])
  local dest_screen = nil
  
  if(space_num > num_main_spaces) then
    space_num = space_num - num_main_spaces
    dest_screen = main_screen:next()
  else
    dest_screen = main_screen
  end

  if(win:screen():getUUID() ~= dest_screen:getUUID()) then
    win:moveToScreen(dest_screen)
  end

  local spaceID = all_spaces[dest_screen:getUUID()][space_num]
  spaces.moveWindowToSpace(win:id(), spaceID)
  spaces.gotoSpace(spaceID)
end
hs.hotkey.bind(hyper, '1', function() MoveWindowToSpace(1) end)
hs.hotkey.bind(hyper, '2', function() MoveWindowToSpace(2) end)
hs.hotkey.bind(hyper, '3', function() MoveWindowToSpace(3) end)
hs.hotkey.bind(hyper, '4', function() MoveWindowToSpace(4) end)
hs.hotkey.bind(hyper, '5', function() MoveWindowToSpace(5) end)
hs.hotkey.bind(hyper, '6', function() MoveWindowToSpace(6) end)
hs.hotkey.bind(hyper, '7', function() MoveWindowToSpace(7) end)
hs.hotkey.bind(hyper, '8', function() MoveWindowToSpace(8) end)

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

hs.notify.new({title='Hammerspoon', informativeText='Ready to rock 🤘'}):send()
