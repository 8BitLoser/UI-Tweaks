local cfg = require("BeefStranger.UI Tweaks.config")
local id = require("BeefStranger.UI Tweaks.menuID")
local find = tes3ui.findMenu
local reg = tes3ui.registerID

---@class bsMenuInventory
local Inventory = {}
function Inventory:get() return find(reg(id.Inventory)) end
function Inventory:child(child) if self:get() then return self:get():findChild(child) end end
function Inventory:ItemTiles() return self:child("PartScrollPane_pane") end
function Inventory:ItemTilesColumns() return self:ItemTiles().children end ---@return table ItemTiles.children


---@class bsMenuInventorySelect
Inventory.Select = {}
function Inventory.Select:get() return find(reg(id.InventorySelect)) end
function Inventory.Select:child(child) if self:get() then return self:get():findChild(child) end end
function Inventory.Select:Close() if self:get() then return self:child("MenuInventorySelect_button_cancel") end end


return Inventory