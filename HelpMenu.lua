local cfg = require("BeefStranger.UI Tweaks.config")
local Multi = require("BeefStranger.UI Tweaks.MenuMulti")
local id = require("BeefStranger.UI Tweaks.menuID")
local sf = string.format

local Help = {}
function Help:get() return tes3ui.findHelpLayerMenu(tes3ui.registerID("HelpMenu")) end
function Help:child(child) if not self:get() then return end return self:get():findChild(child) end
function Help:Main() if not self:get() then return end return self:child("PartHelpMenu_main") end
function Help:Enchant() if not self:get() then return end return self:child("HelpMenu_enchantmentContainer") end
function Help:Effect() if not self:get() then return end return self:child("effect") end

---Add Charge Cost to Tooltip
--- @param e uiObjectTooltipEventData
local function Tooltips(e)
    if not cfg.tooltip.enable then return end
    local enchant = e.object.enchantment
    if cfg.tooltip.charge then
        if enchant and enchant.castType ~= tes3.enchantmentType.constant then
            local baseCost = enchant.chargeCost
            local actualCost =  baseCost - (baseCost / 100) * (tes3.mobilePlayer.enchant.current - 10)
            local displayCost = math.max(1, math.floor(actualCost))
            local new = e.tooltip:createLabel({id = "ChargeCost", text = "Charge Cost: ".. displayCost})
            e.tooltip.children[1]:reorderChildren(Help:Enchant(), new, 1)
        end
    end
end
event.register(tes3.event.uiObjectTooltip, Tooltips)

local function effectTime()
    if not tes3ui.findMenu(id.Inventory).visible or not cfg.tooltip.enable then return end
    if cfg.tooltip.showDur then
        for _, value in ipairs(tes3.mobilePlayer.activeMagicEffectList) do
            local source = value.instance.source.id
            local helpId = "bsDur" .. source
            local duration = value.duration
            local effect = tes3.getMagicEffect(value.effectId)
            if not effect then return end
            for _, child in pairs(Multi:MagicIcons().children) do
                local path = string.gsub(child.contentPath, "Icons\\", "")
                if effect.icon == path then
                    if duration > 1 then
                        child:registerAfter(tes3.uiEvent.help, function(e)
                            local remaining = duration - value.effectInstance.timeActive
                            if not Help:get() then return end
                            if Help:child(helpId) then return end
                            Help:Main():createLabel { id = helpId, text = sf("Duration: %s sec", math.floor(remaining)) }
                        end)
                    end
                end
            end
        end
    end
end
event.register(tes3.event.menuEnter, effectTime)

return Help