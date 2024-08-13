local cfg = require("BeefStranger.UI Tweaks.config")
local id = require("BeefStranger.UI Tweaks.menuID")
local sf = string.format
---@class bsMenuMulti
local Multi = {}

function Multi:get() return tes3ui.findMenu(id.Multi) end
function Multi:child(child) if not self:get() then return end return self:get():findChild(child) end
function Multi:Enchant() if not self:get() then return end return self:child("HelpMenu_enchantmentContainer") end
function Multi:MagicIconLayout() if not self:get() then return end return self:child("MenuMulti_magic_icons_layout") end
function Multi:MagicIcons() if not self:get() then return end return self:child("MenuMulti_magic_icons_1") end

return Multi