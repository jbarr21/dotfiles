-- Omniwm shortcuts
local omniwmctl = "/opt/homebrew/bin/"
local boundHotkeys = {}

local function bindOmniShortcuts()
    for label in ("ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789"):gmatch("[^NEIO]") do
        local key = label:lower()

        local hk1 = hs.hotkey.bind({ "alt" }, key, function()
            hs.execute(string.format("omniwmctl workspace focus-name %q", label), true)
        end)
        table.insert(boundHotkeys, hk1)

        local hk2 = hs.hotkey.bind({ "alt", "shift" }, key, function()
            hs.execute(string.format("omniwm-move-node-to-workspace %q", label), true)
        end)
        table.insert(boundHotkeys, hk2)
    end
end

local function unbindOmniShortcuts()
    for _, hk in ipairs(boundHotkeys) do
        hk:delete()
    end
    boundHotkeys = {}
end

local function omniWMIsRunning()
    return hs.application.find("OmniWM") ~= nil
end

if omniWMIsRunning() then
    bindOmniShortcuts()
end

appWatcher = hs.application.watcher.new(function(appName, event, app)
    if appName == "OmniWM" then
        if event == hs.application.watcher.launched then
            bindOmniShortcuts()
        elseif event == hs.application.watcher.terminated then
            unbindOmniShortcuts()
        end
    end
end)
appWatcher:start()
