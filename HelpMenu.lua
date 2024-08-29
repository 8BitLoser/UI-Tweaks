local Multi = require("BeefStranger.UI Tweaks.MenuMulti") 
local cfg = require("BeefStranger.UI Tweaks.config")
local id = require("BeefStranger.UI Tweaks.menuID")
local sf = string.format
local find = tes3ui.findMenu

---@class bsHelpMenu
local Help = {}
function Help:get() return tes3ui.findHelpLayerMenu(tes3ui.registerID("HelpMenu")) end
function Help:child(child) if not self:get() then return end return self:get():findChild(child) end
function Help:Main() return self:child("PartHelpMenu_main") end
function Help:Enchant() return self:child("HelpMenu_enchantmentContainer") end
function Help:Effect() return self:child("effect") end

---Add Charge Cost to Tooltip
--- @param e uiObjectTooltipEventData
local function chargeCost(e)
    local enchant = e.object.enchantment
    if enchant and enchant.castType ~= tes3.enchantmentType.constant then
        local baseCost = enchant.chargeCost
        local actualCost =  baseCost - (baseCost / 100) * (tes3.mobilePlayer.enchant.current - 10)
        local displayCost = math.max(1, math.floor(actualCost))
        local new = e.tooltip:createLabel({id = "ChargeCost", text = "Charge Cost: ".. displayCost})
        e.tooltip.children[1]:reorderChildren(Help:Enchant(), new, 1)
    end
end

---Add Charge Cost to Tooltip
--- @param e uiObjectTooltipEventData
local function itemTooltip(e)
    if not cfg.tooltip.enable then return end
    if cfg.tooltip.charge then
        chargeCost(e)
    end
end
event.register(tes3.event.uiObjectTooltip, itemTooltip)

local function effectTooltip()
    if (find(id.Inventory) and not find(id.Inventory).visible) or not cfg.tooltip.enable then return end
    if cfg.tooltip.showDur then
        for _, active in pairs(tes3.mobilePlayer.activeMagicEffectList) do
            local source = active.instance.source.id
            local activeInstance = active.effectInstance
            local helpId = "bsDur" .. source                    ---Generate an id using source
            local duration = active.duration                    ---Active Effects Duration
            local effect = tes3.getMagicEffect(active.effectId) ---Get activeEffect effect object
            if effect and active.duration > 1 then
                for _, child in pairs(Multi:MagicIcons().children) do
                    local path = string.gsub(child.contentPath, "Icons\\", "") ---Reformat contentPath to Match Icon Path
                    if effect.icon == path then                                ---If Effect Icons Path matches Active Icon
                        child:registerAfter(tes3.uiEvent.help, function(e)
                            for index, helpChild in pairs(Help:Main().children) do
                                if Help:Main().children[index].name == "null" then ---All Active Labels Have no name set
                                    local pts = sf(": %s pts", active.magnitude)   ---Format mag to match Label.text
                                    local percent = sf(": %s%%", active.magnitude)
                                    if string.find(helpChild.text, pts, 1, true) or string.find(helpChild.text, percent, 1, true) then
                                        local elapsed = (activeInstance.timeActive) ---If a label has pts in it
                                        local remaining = (duration - elapsed)      ---Calc remaining duration
                                        local desc = (helpChild.text)               ---Copy Label.text
                                        helpChild.visible = false                   ---Hide Label
                                        local newDesc = sf("%s | Duration: %s sec", desc, math.floor(remaining))
                                        if Help:child(helpId) then return end
                                        ---Create New Label with Duration appended to end
                                        Help:Main():createLabel { id = helpId, text = newDesc }
                                    end
                                end
                            end
                        end)
                    end
                end
            end
        end
    end
end
event.register(tes3.event.menuEnter, effectTooltip)

return Help
