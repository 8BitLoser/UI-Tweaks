local cfg = require("BeefStranger.UI Tweaks.config")
local id = require("BeefStranger.UI Tweaks.menuID")
local sf = string.format

local Multi = {}

function Multi:get() return tes3ui.findMenu(id.Multi) end
function Multi:child(child) if not self:get() then return end return self:get():findChild(child) end
function Multi:Enchant() if not self:get() then return end return self:child("HelpMenu_enchantmentContainer") end
function Multi:MagicIconLayout() if not self:get() then return end return self:child("MenuMulti_magic_icons_layout") end
function Multi:MagicIcons() if not self:get() then return end return self:child("MenuMulti_magic_icons_1") end

-- local function effectTime()
--     if not tes3ui.findMenu(id.Inventory).visible or not cfg.multi.enable or not cfg.multi.showDur  then return end
--     for _, value in ipairs(tes3.mobilePlayer.activeMagicEffectList) do
--         local source = value.instance.source.id
--         local helpId = "bsDur"..source
--         local duration = value.duration
--         local remaining = duration - value.effectInstance.timeActive
--         local effect = tes3.getMagicEffect(value.effectId)
--         if not effect then return end
--         for _, child in pairs(Multi:MagicIcons().children) do
--             local path = string.gsub(child.contentPath, "Icons\\", "")
--             if effect.icon == path then
--                 if duration > 1 then
--                     child:registerAfter(tes3.uiEvent.help, function(e)
--                         -- local help = tes3ui.findHelpLayerMenu("HelpMenu")
--                         if not Help:get() then return end
--                         if Help:child(helpId) then return end
--                         Help:Main():createLabel {id = helpId, text = sf("Duration: %s sec", math.floor(remaining)) }
--                     end)
--                 end
--             end
--         end
--     end
-- end
-- event.register(tes3.event.menuEnter, effectTime)

return Multi