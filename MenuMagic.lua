local id = require("BeefStranger.UI Tweaks.menuID")
---@class bsMenuMagic
local Magic = {}
function Magic:get() return tes3ui.findMenu(id.Magic) end
function Magic:child(child) return self:get() and self:get():findChild(child) end
function Magic:EffectBlock() return self:child("MagicMenu_icons_list_inner") end
function Magic:EffectRow1() return self:child("MagicMenu_t_icon_row_1") end
function Magic:EffectRow2() return self:child("MagicMenu_t_icon_row_2") end
function Magic:EffectRow3() return self:child("MagicMenu_t_icon_row_3") end
function Magic:EffectRow(rowNumber) return self:child("MagicMenu_t_icon_row_"..rowNumber) end


return Magic