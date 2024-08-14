local cfg = require("BeefStranger.UI Tweaks.config")
local id = require("BeefStranger.UI Tweaks.menuID")
local find = tes3ui.findMenu
local reg = tes3ui.registerID

---@class bsMenuInventorySelect
local InventorySelect= {}
function InventorySelect:get() return find(reg(id.InventorySelect)) end
function InventorySelect:child(child) if self:get() then return self:get():findChild(child) end end
function InventorySelect:Close() if self:get() then return self:child("MenuInventorySelect_button_cancel") end end


return InventorySelect