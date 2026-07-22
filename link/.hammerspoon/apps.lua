-- App shortcuts
local hyperModeAppMappings = {
    { 'a', 'Android Studio' },
    -- B used for Bartender item search
    { 'c', 'Visual Studio Code' },
    -- D used for dictation
    { 'h', 'Hyper' },
    { 'i', 'IntelliJ IDEA' },
    -- J used for homerow scrolling
    { 'k', 'Obsidian' },
    { 'm', 'Spotify' },
    -- P used by Search Menu Items feature of Raycast
    { 's', 'Slack' },
    { 't', 'iTerm' },
    { 'w', 'Google Chrome' },
    { 'z', 'zoom.us' },
}

local bindApp = function(appName)
    return function()
        hs.application.launchOrFocus(appName)
    end
end

for i, mapping in ipairs(hyperModeAppMappings) do
    local key = mapping[1]
    local app = mapping[2]
    hs.hotkey.bind(hyper, key, bindApp(app))
end
