-- move current window to the space space_num
local spaces = require("hs.spaces")

function len(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function MoveWindowToSpace(space_num)
    local win = hs.window.focusedWindow()
    local all_spaces = spaces.allSpaces()
    local main_screen = hs.screen.primaryScreen()
    local num_main_spaces = len(all_spaces[main_screen:getUUID()])
    local dest_screen = nil

    if (space_num > num_main_spaces) then
        space_num = space_num - num_main_spaces
        dest_screen = main_screen:next()
    else
        dest_screen = main_screen
    end

    if (win:screen():getUUID() ~= dest_screen:getUUID()) then
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
