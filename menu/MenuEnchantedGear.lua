local cfg = require("BeefStranger.UI Tweaks.config")
local Magic = require("BeefStranger.UI Tweaks.menu.MenuMagic")
local bs = require("BeefStranger.UI Tweaks.common")
local id = require("BeefStranger.UI Tweaks.ID")

---@class bsMenuEnchantedFunctions
local this = {}

---@class bsMenuEnchanted
local Enchant = {}
Enchant.prop = {
    obj = "EnchantedGear_Object",
    data = "EnchantedGear_itemData",
    hidden = "EnchantedGear_Hidden"
}
-- Enchant.prop.obj = "EnchantedGear_Object"
-- Enchant.prop.data = "EnchantedGear_itemData"

Enchant.UID = {
    Top = tes3ui.registerID("BS_MenuEnchanted"),
    Header = tes3ui.registerID("Header"),
    GearHeader = tes3ui.registerID("Gear Header"),
    GearCost = tes3ui.registerID("Gear Cost"),
    MainBlock = tes3ui.registerID("Main Block"),
    Enchantments = tes3ui.registerID("Enchantments"),
    GearIcons = tes3ui.registerID("Gear Icons"),
    IconPre = "Icon ",
    GearNames = tes3ui.registerID("Gear Names"),
    CostBlock = tes3ui.registerID("CostBlock"),
    ChargeBlock = tes3ui.registerID("ChargeBlock"),
    Cost = tes3ui.registerID("Cost"),
    Charge = tes3ui.registerID("Charge"),
    GearBlock = tes3ui.registerID("Gear Block"),
    ScrollHeader = tes3ui.registerID("Scrolls Header"),
    ScrollsBlock = tes3ui.registerID("Scrolls"),
    ScrollIcons = tes3ui.registerID("Scroll Icons"),
    ScrollLabel = tes3ui.registerID("Scrolls Label"),
    ScrollNames = tes3ui.registerID("Scroll Names"),
    Divider = tes3ui.registerID("Divider"),
    MinMax = tes3ui.registerID("Show Gear Menu")
}
-- Enchant.UID.Top = tes3ui.registerID("BS_MenuEnchanted")
-- Enchant.UID.Header = tes3ui.registerID("Header")
-- Enchant.UID.GearHeader = tes3ui.registerID("Gear Header")
-- Enchant.UID.GearCost = tes3ui.registerID("Gear Cost")
-- Enchant.UID.MainBlock = tes3ui.registerID("Main Block")
-- Enchant.UID.Enchantments = tes3ui.registerID("Enchantments")
-- Enchant.UID.GearIcons = tes3ui.registerID("Gear Icons")
-- Enchant.UID.IconPre = "Icon "
-- Enchant.UID.GearNames = tes3ui.registerID("Gear Names")
-- Enchant.UID.CostBlock = tes3ui.registerID("CostBlock")
-- Enchant.UID.ChargeBlock = tes3ui.registerID("ChargeBlock")
-- Enchant.UID.Cost = tes3ui.registerID("Cost")
-- Enchant.UID.Charge = tes3ui.registerID("Charge")

-- Enchant.UID.GearBlock = tes3ui.registerID("Gear Block")
-- Enchant.UID.ScrollHeader = tes3ui.registerID("Scrolls Header")
-- Enchant.UID.ScrollsBlock = tes3ui.registerID("Scrolls")
-- Enchant.UID.ScrollIcons = tes3ui.registerID("Scroll Icons")
-- Enchant.UID.ScrollLabel = tes3ui.registerID("Scrolls Label")
-- Enchant.UID.ScrollNames = tes3ui.registerID("Scroll Names")
-- Enchant.UID.Divider = tes3ui.registerID("Divider")

local TEXT = {}
TEXT.GEAR = "Enchanted Gear"
TEXT.COST_CHARGE = "Cost/Charge"
TEXT.SCROLL = "Scrolls"
TEXT.HIDE = " . . . "
TEXT.MAXIMIZE = "Enchanted Gear"
TEXT.MINIMIZE = "Hide Enchanted Gear"

function Enchant:get() return tes3ui.findMenu(self.UID.Top) end
function Enchant:child(child) return self:get() and self:get():findChild(child) end
function Enchant:ChargeBlock() return self:child(self.UID.ChargeBlock) end
function Enchant:CostBlock() return self:child(self.UID.CostBlock) end
function Enchant:Enchantments() return self:child(self.UID.Enchantments) end
function Enchant:GearIcons() return self:child(self.UID.GearIcons) end
function Enchant:GearNames() return self:child(self.UID.GearNames) end
function Enchant:GearBlock() return self:child(self.UID.GearBlock) end
function Enchant:GearHeader() return self:child(self.UID.GearHeader) end
function Enchant:ScrollIcons() return self:child(self.UID.ScrollIcons) end
function Enchant:ScrollNames() return self:child(self.UID.ScrollNames) end
function Enchant:ScrollLabel() return self:child(self.UID.ScrollLabel) end
function Enchant:ScrollBlock() return self:child(self.UID.ScrollsBlock) end

local UID = Enchant.UID

local function createMenuEnchanted()
    if not tes3.isCharGenFinished() then return end
    local enchantedGear = tes3ui.createMenu({ id = UID.Top, dragFrame = true, modal = false })
    enchantedGear.height = 275
    enchantedGear.width = 300
    enchantedGear.minWidth = 235
    enchantedGear.minHeight = 90
    enchantedGear.maxWidth = 450
    enchantedGear.visible = Magic:get().visible

    this.setHidden(false)

    local mainBlock = enchantedGear:createVerticalScrollPane { id = UID.MainBlock }
    mainBlock.widthProportional = 1
    mainBlock.heightProportional = 1

    local gearheader = mainBlock:createBlock { id = UID.Header } ---Rename Header/GearHeader Label
    gearheader.widthProportional = 1
    gearheader.childAlignX = -1
    gearheader.autoHeight = true

    local gearTitle = gearheader:createLabel({ id = UID.GearHeader, text = TEXT.GEAR })
    gearTitle.color = bs.rgb.headerColor
    gearTitle:register(tes3.uiEvent.mouseClick, this.hideGear)

    local gearCost = gearheader:createLabel({ id = UID.GearCost, text = TEXT.COST_CHARGE })
    gearCost.color = bs.rgb.headerColor

    local enchants = mainBlock:createBlock({ id = UID.Enchantments })
    enchants.autoHeight = true
    enchants.widthProportional = 1
    enchants.flowDirection = tes3.flowDirection.topToBottom

    local gearBlock = enchants:createBlock({id = UID.GearBlock})
    gearBlock.autoHeight = true
    gearBlock.widthProportional = 1

    local gearIcons = gearBlock:createBlock { id = UID.GearIcons }
    gearIcons.paddingLeft = 2
    gearIcons.paddingRight = 4
    gearIcons.flowDirection = tes3.flowDirection.topToBottom
    gearIcons.autoHeight = true
    gearIcons.autoWidth = true

    local gearNames = gearBlock:createBlock({ id = UID.GearNames })
    gearNames.flowDirection = tes3.flowDirection.topToBottom
    gearNames.autoHeight = true
    gearNames.widthProportional = 1
    gearNames.borderBottom = 5

    local cost = gearBlock:createBlock({ id = UID.CostBlock })
    cost.flowDirection = tes3.flowDirection.topToBottom
    cost.borderLeft = 4
    cost.autoHeight = true
    cost.autoWidth = true
    cost.childAlignX = 1

    local charge = gearBlock:createBlock({ id = UID.ChargeBlock })
    charge.flowDirection = tes3.flowDirection.topToBottom
    charge.autoHeight = true
    charge.autoWidth = true
    charge.borderRight = 4

---========================================
    enchants:createDivider({id = UID.Divider})
---=========================================

    local scrollHeader = enchants:createBlock({id = UID.ScrollHeader})
    scrollHeader.autoHeight = true
    scrollHeader.widthProportional = 1
    scrollHeader.borderBottom = 5

    local scrollLabel = scrollHeader:createLabel({id = UID.ScrollLabel, text = TEXT.SCROLL})
    scrollLabel.color = bs.rgb.headerColor

    scrollLabel:register(tes3.uiEvent.mouseClick, this.hideScrolls)

    local scrolls = enchants:createBlock({ id = UID.ScrollsBlock })
    scrolls.autoHeight = true
    scrolls.widthProportional = 1

    local scrollIcon = scrolls:createBlock { id = UID.ScrollIcons }
    scrollIcon.paddingLeft = 2
    scrollIcon.paddingRight = 4
    scrollIcon.flowDirection = tes3.flowDirection.topToBottom
    scrollIcon.autoHeight = true
    scrollIcon.autoWidth = true

    local scrollName = scrolls:createBlock({ id = UID.ScrollNames })
    scrollName.flowDirection = tes3.flowDirection.topToBottom
    scrollName.autoHeight = true
    scrollName.widthProportional = 1

    ---Create Gear Text Select
    ---@param stack tes3itemStack
    ---@return tes3uiElement
    local function createGear(stack)
        local effectIcon = stack.object.enchantment.effects[1].object.icon
        local icon = gearIcons:createImage({ id = stack.object.id, path = "Icons\\" .. effectIcon })
        icon.borderTop = 2
        return gearNames:createTextSelect({ id = stack.object.id, text = stack.object.name })
    end

    ---Create Gear Cost/Charge
    ---@param stack tes3itemStack
    ---@param itemData tes3itemData
    local function createCharge(stack, itemData)
        local maxCharge = itemData and itemData.charge or stack.object.enchantment.maxCharge

        local costText = tostring(stack.object.enchantment.chargeCost)
        local chargeText = "/" .. tostring(math.round(maxCharge))

        cost:createLabel { id = stack.object.id, text = costText }
        charge:createLabel { id = stack.object.id, text = chargeText }
    end

    ---Create Scroll Text Select
    ---@param stack tes3itemStack
    ---@return tes3uiElement
    local function createScrolls(stack)
        local effectIcon = stack.object.enchantment.effects[1].object.icon
        local icon = scrollIcon:createImage({ id = stack.object.id, path = "Icons\\" .. effectIcon })
        icon.borderTop = 2
        local item = scrollName:createTextSelect({ id = stack.object.id, text = stack.object.name })
        item.widget.idle = bs.rgb.disabledColor
        return item
    end

    local function createEnchantList()
        local top = Enchant:get()
        Enchant:GearNames():destroyChildren()
        Enchant:ScrollNames():destroyChildren()
        Enchant:GearIcons():destroyChildren()
        Enchant:ScrollIcons():destroyChildren()
        Enchant:ChargeBlock():destroyChildren()
        Enchant:CostBlock():destroyChildren()
        top.text = TEXT.GEAR

        for _, stack in pairs(tes3.mobilePlayer.inventory) do
            local enchant = stack.object.enchantment
            local onUse = enchant and enchant.castType == tes3.enchantmentType.onUse
            local isScroll = enchant and enchant.castType == tes3.enchantmentType.castOnce
            local castable = isScroll or onUse
            if castable then
                local itemData, item
                if isScroll then
                    item = createScrolls(stack)
                else
                    item = createGear(stack)
                end

                this.setObj(item, stack)

                ---If there itemData
                if stack.variables then
                    for _, data in pairs(stack.variables) do
                        if data then
                            itemData = data
                            this.setData(item, data)
                        end
                    end
                end

                this.highlightNew(stack, item)
                if cfg.enchantedGear.highlightNew then
                    local lookedAt = bs.initData().lookedAt
                    if not lookedAt[stack.object.id] then
                        item.color = bs.color(cfg.magic.highlightColor)
                    end
                end

                ---Update Text State to be Active if Enchant Equipped
                if tes3.mobilePlayer.currentEnchantedItem.object == stack.object then
                    item.widget.state = tes3.uiState.active
                    top.text = stack.object.name
                end

                if not isScroll then
                    createCharge(stack, itemData)
                end

                item:register(tes3.uiEvent.mouseClick, function(e) this.onItemClick(e, stack) end)
                item:register(tes3.uiEvent.help, function(e) tes3ui.createTooltipMenu({ item = stack.object, itemData = itemData }) end)
            end
        end
    end

    createEnchantList()

    ---@param e tes3uiEventData
    local function preUpdate(e)
        createEnchantList()
        bs.savePos(e.source)
    end

    enchantedGear:register(tes3.uiEvent.preUpdate, preUpdate)
    Magic:get():registerAfter(tes3.uiEvent.preUpdate, this.MagicPre)

    bs.loadPos(enchantedGear)
end

---===============================================
---===================Events======================
---===============================================

--- @param e menuEnterEventData
local function menuEnterCallback(e)
    if cfg.enchantedGear.enable and not Enchant:get() then
        createMenuEnchanted()
    end

    if Enchant:get() and Magic:get().visible then
        Enchant:get().visible = not this.getHidden()
        Enchant:get():updateLayout()
    end
end
event.register(tes3.event.menuEnter, menuEnterCallback)

--- @param e menuExitEventData
local function menuExitCallback(e)
    if not cfg.enchantedGear.enable and Enchant:get() then
        debug.log(not cfg.enchantedGear.enable)
        Magic:get():unregisterAfter(tes3.uiEvent.preUpdate, this.MagicPre)
        Enchant:get():destroy()
    end
    if Enchant:get() then
        Enchant:get().visible = false
    end
end
event.register(tes3.event.menuExit, menuExitCallback)

--- @param e uiActivatedEventData
local function uiActivatedCallback(e)
    local hide = e.element:createButton({id = UID.MinMax, text = TEXT.MINIMIZE })
    hide:register(tes3.uiEvent.mouseClick, function(e)
        this.setHidden(not this.getHidden())
        Enchant:get().visible = not this.getHidden()
        e.source.text = this.getHidden() and TEXT.MAXIMIZE or TEXT.MINIMIZE
        if cfg.enchantedGear.showVanillaOnHide then
            Magic:Enchants().visible = true
            Magic:EnchantTitle().visible = true
            Magic:Enchants().parent.children[6].visible = true
        end
        e.source:getTopLevelMenu():updateLayout()
    end)
end
event.register(tes3.event.uiActivated, uiActivatedCallback, {filter = id.Magic})

---===============================================
---==============Helper Functions=================
---===============================================

---Highlight New Enchants/Scrolls
---@param stack tes3itemStack
---@param item tes3uiElement
function this.highlightNew(stack, item)
    if cfg.enchantedGear.highlightNew then
        local lookedAt = bs.initData().lookedAt
        if not lookedAt[stack.object.id] then
            item.color = bs.color(cfg.magic.highlightColor)
        end
    end
end
---Hide the Enchanted Gear Category
function this.hideGear()
    local gearBlock = Enchant:GearBlock()
    local title = Enchant:GearHeader()
    gearBlock.visible = not gearBlock.visible
    title.text = not gearBlock.visible and TEXT.GEAR .. TEXT.HIDE or TEXT.GEAR
end

---Hide the Scrolls Category
function this.hideScrolls()
    local scrollBlock = Enchant:ScrollBlock()
    local title = Enchant:ScrollLabel()
    scrollBlock.visible = not scrollBlock.visible
    title.text = not scrollBlock.visible and TEXT.SCROLL .. TEXT.HIDE or TEXT.SCROLL
end

---Update Enchanted Gear layout everytime Vanilla Magic Menu Updates
function this.MagicPre()
    if cfg.enchantedGear.hideVanilla then
        Magic:Enchants().visible = false
        Magic:EnchantTitle().visible = false
        Magic:Enchants().parent.children[6].visible = false
    end
    if cfg.enchantedGear.showVanillaOnHide and this.getHidden() then
        Magic:Enchants().visible = true
        Magic:EnchantTitle().visible = true
        Magic:Enchants().parent.children[6].visible = true
    end
    Enchant:get():updateLayout()
end

---When an Item/Scroll is Clicked
---@param stack tes3itemStack
function this.onItemClick(e, stack)
    local castable = stack.object.enchantment.castType == tes3.enchantmentType.onUse
    local isScroll = stack.object.enchantment.castType == tes3.enchantmentType.castOnce

    if castable or isScroll then
        tes3.mobilePlayer:equipMagic({ source = stack.object, equipItem = true })
    else
        tes3.mobilePlayer:equip({item = stack.object, itemData = stack.variables})
    end

    Enchant:get().text = stack.object.name
end

---@param hide boolean
function this.setHidden(hide)
    Enchant:get():setPropertyBool(Enchant.prop.hidden, hide)
end

function this.setObj(menu, stack)
    menu:setPropertyObject(Enchant.prop.obj, stack.object)
end

function this.setData(menu, data)
    menu:setPropertyObject(Enchant.prop.data, data)
end

---@return boolean
function this.getHidden()
    return Enchant:get():getPropertyBool(Enchant.prop.hidden)
end

---@return tes3weapon|tes3clothing|tes3armor|tes3book
function this.getObj(menu)
    return menu:getPropertyObject(Enchant.prop.obj)
end

---@return tes3itemData
function this.getData(menu)
    return menu:getPropertyObject(Enchant.prop.data, "tes3itemData")
end

return Enchant