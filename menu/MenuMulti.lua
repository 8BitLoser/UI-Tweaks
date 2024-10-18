local cfg = require("BeefStranger.UI Tweaks.config")
local id = require("BeefStranger.UI Tweaks.ID")
local sf = string.format
---@class bsMenuMulti
local Multi = {}

function Multi:get() return tes3ui.findMenu(id.Multi) end
function Multi:child(child) if not self:get() then return end return self:get():findChild(child) end
function Multi:Enchant() if not self:get() then return end return self:child("HelpMenu_enchantmentContainer") end
function Multi:MagicIconLayout() if not self:get() then return end return self:child("MenuMulti_magic_icons_layout") end
function Multi:MagicIcons1() if not self:get() then return end return self:child("MenuMulti_magic_icons_1") end
function Multi:MagicIcons2() if not self:get() then return end return self:child("MenuMulti_magic_icons_2") end
function Multi:MagicIcons3() if not self:get() then return end return self:child("MenuMulti_magic_icons_3") end
function Multi:MagicIconsBox() if not self:get() then return end return self:child("MenuMulti_magic_icons_box") end

return Multi