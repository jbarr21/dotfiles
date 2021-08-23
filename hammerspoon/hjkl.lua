local function pressFn(mods, key)
	if key == nil then
		key = mods
		mods = {}
	end

	return function() hs.eventtap.keyStroke(mods, key, 1000) end
end

local function remap(mods, key, pressFn)
	hs.hotkey.bind(mods, key, pressFn, nil, pressFn)
end

remap({'ctrl', 'cmd', 'alt', 'shift'}, 'h', pressFn('h'))
remap({'ctrl', 'cmd', 'alt', 'shift'}, 'n', pressFn('j'))
remap({'ctrl', 'cmd', 'alt', 'shift'}, 'e', pressFn('k'))
remap({'ctrl', 'cmd', 'alt', 'shift'}, 'i', pressFn('l'))