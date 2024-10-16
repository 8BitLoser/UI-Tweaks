local cfg = require("BeefStranger.UI Tweaks.config")
local bs = require("BeefStranger.UI Tweaks.common")
local id = require("BeefStranger.UI Tweaks.menuID")
local find = tes3ui.findMenu
local reg = tes3ui.registerID

---@class bsMenuInventory
local Inventory = {}
---Get the Inventory Menu Element
---@return tes3uiElement InventoryMenu
function Inventory:get() return tes3ui.findMenu(tes3ui.registerID(id.Inventory)) end
---Get the first child with this Id/Name
---@param child string|number The Id/Name of the child element
---@return tes3uiElement childElement
function Inventory:child(child) return self:get() and self:get():findChild(child) end
---Get the player encumberance bar
---@return tes3uiElement WeightBar `MenuInventory_Weightbar`
function Inventory:WeightBar() return self:child("MenuInventory_Weightbar") end
---Get the inventory Filter Buttons
---@return tes3uiElement FilterButtons `MenuInventory_Weightbar`
function Inventory:FilterButtons() return self:child("MenuInventory_button_layout") end
---Get the CharacterBox
---@return tes3uiElement CharacterBox `MenuInventory_character_box`
function Inventory:CharacterBox() return self:child("MenuInventory_character_box") end
---Get the Item Tiles Element: Where items are displayed
---@return tes3uiElement ItemScrollPane `PartScrollPane_pane`
function Inventory:ItemScrollPane() return self:child("PartScrollPane_pane") end
---Get the children of `ItemsScrollPane` | Chilren = Number of Columns
---@return tes3uiElement[] ItemScrollPane.children
function Inventory:ItemTileColumns() return self:ItemScrollPane().children end
---Get a specific item in the Item Tiles
---@param column number The column index of the item
---@param row number The row index of the item
---@return tes3uiElement item
function Inventory:Item(column, row) return self:ItemScrollPane().children[column].children[row] end

---@class bsMenuInventorySelect
Inventory.Select = {}
function Inventory.Select:get() return find(reg(id.InventorySelect)) end
function Inventory.Select:child(child) if self:get() then return self:get():findChild(child) end end
function Inventory.Select:Close() if self:get() then return self:child("MenuInventorySelect_button_cancel") end end

--- @param e itemTileUpdatedEventData
local function potionHighlight(e)
    if e.item.objectType == tes3.objectType.alchemy then
        if e.item.effects then
            for i = 1, e.item:getActiveEffectCount() do
                local effect = e.item.effects[i].id
                if effect == tes3.effect.restoreHealth then
                    e.element:findChild("itemTile_icon").color = bs.rgb.bsNiceRed
                    e.element.contentPath = "Textures\\menu_icon_select_magic.tga"
                    e.element.color = bs.rgb.bsNiceRed
                    break
                end
                if effect == tes3.effect.restoreFatigue then
                    e.element:findChild("itemTile_icon").color = bs.rgb.bsPrettyGreen
                    e.element.contentPath = "Textures\\menu_icon_select_magic.tga"
                    e.element.color = bs.rgb.bsPrettyGreen
                    break
                end
                if effect == tes3.effect.restoreMagicka then
                    e.element:findChild("itemTile_icon").color = bs.rgb.bsPrettyBlue
                    e.element.contentPath = "Textures\\menu_icon_select_magic.tga"
                    e.element.color = bs.rgb.bsPrettyBlue
                    break
                end
            end
            return false
        end
    end
end

--- @param e itemTileUpdatedEventData
local function tileUpdated(e)
    if cfg.inv.potionHighlight then potionHighlight(e) end
end
event.register(tes3.event.itemTileUpdated, tileUpdated)

return Inventory