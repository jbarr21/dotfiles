-- mouse screen jump
hs.hotkey.bind('', 'f16', function()
    local screen = hs.mouse.getCurrentScreen()
    local nextScreen = screen:next()
    local rect = nextScreen:fullFrame()
    local center = hs.geometry.rectMidPoint(rect)
    hs.mouse.setAbsolutePosition(center)
end)

hs.hotkey.bind({ '' }, 'f19', function()
    hs.execute('~/dotfiles/bin/toggle-trackball-scroll.sh', true)
end)

-- local vimouse = require('vimouse')
-- vimouse('cmd', 'm')
