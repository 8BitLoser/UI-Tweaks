local cfg = require("BeefStranger.UI Tweaks.config")
local Magic = require("BeefStranger.UI Tweaks.menu.MenuMagic")
local bs = require("BeefStranger.UI Tweaks.common")
local id = require("BeefStranger.UI Tweaks.ID")

---@class bsMenuEnchantedFunctions
local this = {}



---@class bsMenuEnchanted
local Enchant = {}
Enchant.UID = {}
Enchant.UID.Top = tes3ui.registerID("BS_MenuEnchanted")
Enchant.UID.Header = tes3ui.registerID("Header")
Enchant.UID.GearHeader = tes3ui.registerID("Gear Header")
Enchant.UID.GearCost = tes3ui.registerID("Gear Cost")
Enchant.UID.MainBlock = tes3ui.registerID("Main Block")
Enchant.UID.Enchantments = tes3ui.registerID("Enchantments")
Enchant.UID.GearIcons = tes3ui.registerID("Gear Icons")
Enchant.UID.IconPre = "Icon "
Enchant.UID.GearNames = tes3ui.registerID("Gear Names")
Enchant.UID.CostBlock = tes3ui.registerID("CostBlock")
Enchant.UID.ChargeBlock = tes3ui.registerID("ChargeBlock")
Enchant.UID.Cost = tes3ui.registerID("Cost")
Enchant.UID.Charge = tes3ui.registerID("Charge")

Enchant.UID.GearBlock = tes3ui.registerID("Gear Block")
Enchant.UID.ScrollHeader = tes3ui.registerID("Scrolls Header")
Enchant.UID.ScrollsBlock = tes3ui.registerID("Scrolls")
Enchant.UID.ScrollIcons = tes3ui.registerID("Scroll Icons")
Enchant.UID.ScrollLabel = tes3ui.registerID("Scrolls Label")
Enchant.UID.ScrollNames = tes3ui.registerID("Scroll Names")
Enchant.UID.Divider = tes3ui.registerID("Divider")

local TEXT = {}
TEXT.GEAR = "Enchanted Gear"
TEXT.COST_CHARGE = "Cost/Charge"
TEXT.SCROLL = "Scrolls"

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
    local enchantedGear = tes3ui.createMenu({ id = UID.Top, dragFrame = true, modal = false })
    enchantedGear.height = 275
    enchantedGear.width = 300
    enchantedGear.minWidth = 235
    enchantedGear.maxWidth = 450
    -- enchantedGear.text = TEXT.GEAR
    enchantedGear.visible = Magic:get().visible

    local mainBlock = enchantedGear:createVerticalScrollPane { id = UID.MainBlock }
    mainBlock.widthProportional = 1
    mainBlock.heightProportional = 1

    local gearheader = mainBlock:createBlock { id = UID.Header } ---Rename Header/GearHeader Label
    gearheader.widthProportional = 1
    gearheader.childAlignX = -1
    gearheader.autoHeight = true

    gearheader:register(tes3.uiEvent.mouseClick, this.hideGear)

    local headerItem = gearheader:createLabel({ id = UID.GearHeader, text = TEXT.GEAR })
    headerItem.color = bs.rgb.headerColor

    local headerCost = gearheader:createLabel({ id = UID.GearCost, text = TEXT.COST_CHARGE })
    headerCost.color = bs.rgb.headerColor

    local enchants = mainBlock:createBlock({ id = UID.Enchantments })
    enchants.autoHeight = true
    enchants.widthProportional = 1
    enchants.flowDirection = tes3.flowDirection.topToBottom

    local gearBlock = enchants:createBlock({id = UID.GearBlock})
    gearBlock.autoHeight = true
    gearBlock.widthProportional = 1

    local iconBlock = gearBlock:createBlock { id = UID.GearIcons }
    iconBlock.paddingLeft = 2
    iconBlock.paddingRight = 4
    iconBlock.flowDirection = tes3.flowDirection.topToBottom
    iconBlock.autoHeight = true
    iconBlock.autoWidth = true

    local gear = gearBlock:createBlock({ id = UID.GearNames })
    gear.flowDirection = tes3.flowDirection.topToBottom
    gear.autoHeight = true
    gear.widthProportional = 1
    gear.borderBottom = 5

    enchants:createDivider({id = UID.Divider})

    local scrollHeader = enchants:createBlock({id = UID.ScrollHeader})
    scrollHeader.autoHeight = true
    scrollHeader.widthProportional = 1
    scrollHeader.borderBottom = 5
    scrollHeader:register(tes3.uiEvent.mouseClick, this.hideScrolls)

    local scrollLabel = scrollHeader:createLabel({id = UID.ScrollLabel, text = "Scrolls"})
    scrollLabel.color = bs.rgb.headerColor

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

    ---comments
    ---@param stack tes3itemStack
    ---@return tes3uiElement
    local function createScrolls(stack)
        local icon = scrollIcon:createImage({ id = stack.object.id, path = "Icons\\" ..
        stack.object.enchantment.effects[1].object.icon })
        icon.borderTop = 2
        local item = scrollName:createTextSelect({ id = stack.object.id, text = stack.object.name })
        item.widget.idle = bs.rgb.disabledColor
        return item
    end

    ---@param stack tes3itemStack
    ---@return tes3uiElement
    local function createGear(stack)
        local icon = iconBlock:createImage({ id = stack.object.id, path = "Icons\\" ..
        stack.object.enchantment.effects[1].object.icon })
        icon.borderTop = 2
        return gear:createTextSelect({ id = stack.object.id, text = stack.object.name })
    end



    local function createEnchantList()
        Enchant:GearNames():destroyChildren()
        Enchant:ScrollNames():destroyChildren()
        Enchant:GearIcons():destroyChildren()
        Enchant:ScrollIcons():destroyChildren()
        Enchant:get().text = TEXT.GEAR

        for _, stack in pairs(tes3.mobilePlayer.inventory) do
            local enchant = stack.object.enchantment
            local isScroll = stack.object.objectType == tes3.objectType.book
            if enchant and enchant.castType ~= tes3.enchantmentType.constant then
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
                    Enchant:get().text = stack.object.name
                end

                item:register(tes3.uiEvent.mouseClick, function(e) this.onItemClick(e, stack) end)
                item:register(tes3.uiEvent.help, function(e) tes3ui.createTooltipMenu({ item = stack.object, itemData = itemData }) end)
            end
        end
    end

    local function createCostCharge()
        local cost = Enchant:CostBlock()
        local charge = Enchant:ChargeBlock()
        if not cost then
            cost = Enchant:child("Gear Block"):createBlock({ id = UID.CostBlock })
            cost.flowDirection = tes3.flowDirection.topToBottom
            cost.borderLeft = 4
            cost.autoHeight = true
            cost.autoWidth = true
            cost.childAlignX = 1
        end

        if not charge then
            charge = Enchant:child("Gear Block"):createBlock({ id = UID.ChargeBlock })
            charge.flowDirection = tes3.flowDirection.topToBottom
            charge.autoHeight = true
            charge.autoWidth = true
            charge.borderRight = 4
        end

        cost:destroyChildren()
        charge:destroyChildren()

        for i, v in ipairs(Enchant:GearNames().children) do
            local obj = this.getObj(v)
            local data = this.getData(v)
            local maxCharge = data and data.charge or obj.enchantment.maxCharge

            local costText = tostring(obj.enchantment.chargeCost)
            local chargeText = "/" .. tostring(math.round(maxCharge))

            cost:createLabel{id = obj.id, text = costText}
            charge:createLabel{id = obj.id, text = chargeText}
        end
    end

    createEnchantList()
    createCostCharge()

    ---@param e tes3uiEventData
    local function preUpdate(e)
        createEnchantList()
        createCostCharge()

        if cfg.enchantedGear.hideVanilla then
            Magic:Enchants().visible = false
            Magic:EnchantTitle().visible = false
            Magic:Enchants().parent.children[6].visible = false
        end

        bs.savePos(e.source)
    end

    enchantedGear:register(tes3.uiEvent.preUpdate, preUpdate)
    -- enchantedGear:register(tes3.uiEvent.update, this.highlight)
    Magic:get():registerAfter(tes3.uiEvent.preUpdate, this.MagicPre)

    bs.loadPos(enchantedGear)

end

--- @param e menuEnterEventData
local function menuEnterCallback(e)
    if cfg.enchantedGear.enable and not Enchant:get() then
        createMenuEnchanted()
    end

    if Enchant:get() and Magic:get().visible then
        Enchant:get().visible = true
        Enchant:get():updateLayout()
    end
end
event.register(tes3.event.menuEnter, menuEnterCallback)

--- @param e menuExitEventData
local function menuExitCallback(e)
    if not cfg.enchantedGear.enable and Enchant:get() then
        Magic:get():unregisterAfter(tes3.uiEvent.preUpdate, this.MagicPre)
        Enchant:get():destroy()
    end
    if Enchant:get() then
        Enchant:get().visible = false
    end
end
event.register(tes3.event.menuExit, menuExitCallback)


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

function this.hideGear()
    local gear = Enchant:GearBlock()
    local title = Enchant:GearHeader()
    gear.visible = not gear.visible
    title.text = not gear.visible and TEXT.GEAR .. " . . . " or TEXT.GEAR
end

function this.hideScrolls()
    local scroll = Enchant:ScrollBlock()
    local title = Enchant:ScrollLabel()
    scroll.visible = not scroll.visible
    title.text = not scroll.visible and TEXT.SCROLL .. " . . . " or TEXT.SCROLL
end

function this.MagicPre()
    Enchant:get():updateLayout()
end

---@param stack tes3itemStack
function this.onItemClick(e, stack)
    local onUse = stack.object.enchantment.castType == tes3.enchantmentType.onUse
    local castOnce = stack.object.enchantment.castType == tes3.enchantmentType.castOnce

    if onUse or castOnce then
        tes3.mobilePlayer:equipMagic({ source = stack.object, equipItem = true })
    else
        tes3.mobilePlayer:equip({item = stack.object, itemData = stack.variables})
    end

    for i, v in ipairs(Enchant:GearNames().children) do
        v.widget.state = tes3.uiState.normal
    end
    for i, v in ipairs(Enchant:ScrollNames().children) do
        v.widget.state = tes3.uiState.normal
    end
    Enchant:get().text = stack.object.name
    -- e.source.widget.state = tes3.uiState.active
end

function this.setObj(menu, stack)
    menu:setPropertyObject("object", stack.object)
end

function this.setData(menu, data)
    menu:setPropertyObject("itemData", data)
end

---@return tes3weapon|tes3clothing|tes3armor|tes3book
function this.getObj(menu)
    return menu:getPropertyObject("object")
end

---@return tes3itemData
function this.getData(menu)
    return menu:getPropertyObject("itemData", "tes3itemData")
end

return Enchant