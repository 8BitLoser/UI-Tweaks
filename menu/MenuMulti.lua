local cfg = require("BeefStranger.UI Tweaks.config")
local id = require("BeefStranger.UI Tweaks.ID")
local sf = string.format
---@class bsMenuMulti
local Multi = {}

function Multi:Enchant() if not self:get() then return end return self:child("HelpMenu_enchantmentContainer") end
function Multi:MagicIconLayout() if not self:get() then return end return self:child("MenuMulti_magic_icons_layout") end
function Multi:MagicIcons1() if not self:get() then return end return self:child("MenuMulti_magic_icons_1") end
function Multi:MagicIcons2() if not self:get() then return end return self:child("MenuMulti_magic_icons_2") end
function Multi:MagicIcons3() if not self:get() then return end return self:child("MenuMulti_magic_icons_3") end
function Multi:MagicIconsBox() if not self:get() then return end return self:child("MenuMulti_magic_icons_box") end

---New
function Multi:get() return tes3ui.findMenu(id.Multi) end
function Multi:child(child) return self:get() and self:get():findChild(child) end
function Multi:Main() return self:child("MenuMulti_main") end
function Multi:MapNotify() return self:child("MenuMulti_map_notify") end
function Multi:BottomRow() return self:child("MenuMulti_bottom_row") end
function Multi:BottomLeft() return self:child("MenuMulti_bottom_row_left") end
function Multi:BottomRight() return self:child("MenuMulti_bottom_row_right") end
function Multi:WeaponMagicNotify() return self:child("MenuMulti_weapon_magic_notify") end
function Multi:NPC() return self:child("MenuMulti_npc") end
function Multi:NPCHealth() return self:child("MenuMulti_npc_health_bar") end
function Multi:GearIconsBlock() return self:child("MenuMulti_icons") end
function Multi:WeaponBlock() return self:child("MenuMulti_weapon_layout") end
function Multi:MagicBlock() return self:child("MenuMulti_magic_layout") end
function Multi:SneakBlock() return self:child("MenuMulti_sneak_layout") end
function Multi:Fillbars() return self:child("MenuMulti_fillbars") end
function Multi:Health() return self:child("MenuStat_health_fillbar") end
function Multi:Magicka() return self:child("MenuStat_magic_fillbar") end
function Multi:Fatigue() return self:child("MenuStat_fatigue_fillbar") end
function Multi:EffectsBlock() return self:child("MenuMulti_magic_icons_box") end
function Multi:EffectIcons3() return self:child("MenuMulti_magic_icons_3") end
function Multi:EffectIcons2() return self:child("MenuMulti_magic_icons_2") end
function Multi:EffectIcons1() return self:child("MenuMulti_magic_icons_1") end
function Multi:MinimapBlock() return self:child("MenuMulti_map") end

return Multi