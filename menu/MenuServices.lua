local cfg = require("BeefStranger.UI Tweaks.config")
local id = require("BeefStranger.UI Tweaks.ID")
local bs = require("BeefStranger.UI Tweaks.common")
local sf = string.format
local find = tes3ui.findMenu
local reg = tes3ui.registerID

---@class bsMenuServices
local Services = {}

---@class bsMenuServiceRepair
Services.Repair = {}
function Services.Repair:get() return find(reg(id.ServiceRepair)) end
function Services.Repair:child(child) if self:get() then return self:get():findChild(child) end end
function Services.Repair:Close() if self:get() then return self:child("MenuServiceRepair_Okbutton") end end
local Repair = Services.Repair

---@class bsMenuServiceSpells
Services.Spells = {}
function Services.Spells:get() return find(reg(id.ServiceSpells)) end
function Services.Spells:child(child) if self:get() then return self:get():findChild(child) end end
function Services.Spells:Close() if self:get() then return self:child("MenuServiceSpells_Okbutton") end end
local Spells = Services.Spells

---@class MenuServiceTraining
Services.Train = {}
function Services.Train:get() return find(reg(id.ServiceTraining)) end
function Services.Train:child(child) if self:get() then return self:get():findChild(child) end end
function Services.Train:Close() if self:get() then return self:child("UIEXP_MenuTraining_Cancel") end end
local Train = Services.Train

---@class bsMenuServiceTravel
Services.Travel = {}
function Services.Travel:get() return find(reg(id.ServiceTravel)) end
function Services.Travel:child(child) if not self:get() then return end return self:get():findChild(child) end
function Services.Travel:Destination() if not self:get() then return end return self:child("PartScrollPane_pane") end
function Services.Travel:Close() if not self:get() then return end return self:child("MenuServiceTravel_Okbutton") end
function Services.Travel:Hotkey(child) if not self:get() then return end self:child(child):triggerEvent("bsHotkey") end
local Travel = Services.Travel

--- @param e uiActivatedEventData
local function ServiceTravel(e)
    if cfg.travel.enable then
        for i, destParent in ipairs(Travel:Destination().children) do
            local dest = destParent.children[1]
            local travelText = cfg.travel.showKey and i..":  " or ""

            local travelKey = destParent:createLabel{id = i.."TravelKey", text = travelText}
            travelKey.color = { 0.875, 0.788, 0.624 }
            travelKey:register("bsHotkey", function () dest:triggerEvent(tes3.uiEvent.mouseClick) bs.click() end)

            destParent:reorderChildren(0, travelKey, 1)
            Travel:get():updateLayout()
        end
    end
end
event.register(tes3.event.uiActivated, ServiceTravel, {filter = id.ServiceTravel})


return Services