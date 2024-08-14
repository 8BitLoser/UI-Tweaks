local cfg = require("BeefStranger.UI Tweaks.config")
local id = require("BeefStranger.UI Tweaks.menuID")
local sf = string.format

---@class bsMenuServiceTravel
local Travel = {}
function Travel:get() return tes3ui.findMenu(tes3ui.registerID(id.ServiceTravel)) end
function Travel:child(child) if not self:get() then return end return self:get():findChild(child) end
function Travel:Destination() if not self:get() then return end return self:child("PartScrollPane_pane") end
function Travel:Hotkey(child) if not self:get() then return end self:child(child):triggerEvent("bsHotkey") end


--- @param e uiActivatedEventData
local function ServiceTravel(e)
    if cfg.travel.enable then
        for i, destParent in ipairs(Travel:Destination().children) do
            local dest = destParent.children[1]
            local travelKey = destParent:createLabel{id = i.."TravelKey", text = i..":  "}
            travelKey.color = { 0.875, 0.788, 0.624 }
            travelKey:register("bsHotkey", function () dest:triggerEvent(tes3.uiEvent.mouseClick) end)
            destParent:reorderChildren(0, travelKey, 1)
            Travel:get():updateLayout()
        end
    end
end
event.register(tes3.event.uiActivated, ServiceTravel, {filter = id.ServiceTravel})


return Travel