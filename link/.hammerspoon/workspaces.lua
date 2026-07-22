-- Omniwm shortcuts
local omniwmctl = "/opt/homebrew/bin/"

for label in ("ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789"):gmatch("[^NEIO]") do
    local key = label:lower()

    hs.hotkey.bind({ "alt" }, key, function()
        hs.execute(string.format("omniwmctl workspace focus-name %q", label), true)
    end)

    hs.hotkey.bind({ "alt", "shift" }, key, function()
        hs.execute(string.format("omniwm-move-node-to-workspace %q", label), true)
    end)
end
