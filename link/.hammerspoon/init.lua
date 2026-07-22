log = hs.logger.new('init.lua', 'debug')

-- Modifiers
meh = { 'ctrl', 'alt', 'shift' }
hyper = { 'shift', 'cmd', 'alt', 'ctrl' }

require("apps")
require("chrome")
require("mouse")
-- require("spaces")
-- require("talon")
require("workspaces")

hs.notify.new({ title = 'Hammerspoon', informativeText = 'Ready to rock 🤘' }):send()
