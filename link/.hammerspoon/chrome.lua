-- Toggle Chrome Vertical Tab Sidebar
local function toggleChromeTabSidebar()
    local frontApp = hs.application.frontmostApplication()
    if frontApp:name() == "Google Chrome" then
        local appElm = hs.axuielement.applicationElement(frontApp)
        if appElm then
            local function searchElements(elements)
                for _, el in ipairs(elements) do
                    local desc = el:attributeValue("AXDescription")
                    if desc == "Expand Tabs" or desc == "Collapse Tabs" then
                        el:performAction("AXPress")
                        return true
                    end
                    if el:attributeValue("AXChildren") then
                        if searchElements(el:attributeValue("AXChildren")) then return true end
                    end
                end
                return false
            end
            searchElements(appElm)
        end
    end
end
hs.hotkey.bind({"cmd", "shift"}, "L", toggleChromeTabSidebar)

-- Open link in split view
local modKey = {"ctrl"}
clickWatcher = hs.eventtap.new({ hs.eventtap.event.types.leftMouseDown }, function(event)
    local frontApp = hs.application.frontmostApplication()
    if frontApp:name() ~= "Google Chrome" then
        return false
    end

    local flags = event:getFlags()
    local isModActive = true
    for _, mod in ipairs(modKey) do
        if not flags[mod] then
            isModActive = false
        end
    end

    if isModActive then
        for i = 1, 3 do
            hs.eventtap.keyStroke({}, "down")
        end
        hs.eventtap.keyStroke({}, "return")
    end
    
    return false
end)
clickWatcher:start()
