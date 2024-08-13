local cfg = require("BeefStranger.UI Tweaks.config")
local id = require("BeefStranger.UI Tweaks.menuID")
local ts = tostring

---@class bsMenuSpellMaking
local SpellMaking = {}
function SpellMaking:get() return tes3ui.findMenu(tes3ui.registerID(id.Spellmaking)) end
function SpellMaking:child(child) if not self:get() then return end return self:get():findChild(child) end
function SpellMaking:Price() if not self:get() then return end return self:child("MenuSpellmaking_PriceLayout") end



---@param e uiActivatedEventData
local function enchantActivated(e)
    if not cfg.spellmaking.enable then return end
    if cfg.spellmaking.showGold then
        if tes3ui.getServiceActor() then
            local playerGold = 0
            for _, stack in pairs(tes3.mobilePlayer.inventory) do
                if stack.object.name == "Gold" then
                    playerGold = stack.count
                end
            end

            local gold = SpellMaking:Price():createLabel{id = "bsPlayerGold", text = "Gold"}
            gold.borderLeft = 20
            gold.borderRight = 10
            gold.color = { 0.875, 0.788, 0.624 }

            local amount = SpellMaking:Price():createLabel{id = "bsValue", text = ts(playerGold)}
            amount.color = { 1.000, 0.647, 0.376 }
        end
    end
end
event.register(tes3.event.uiActivated, enchantActivated, {filter = id.Spellmaking})


return SpellMaking