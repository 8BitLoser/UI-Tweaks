local cfg = require("BeefStranger.UI Tweaks.config")
local bs = require("BeefStranger.UI Tweaks.common")
local id = require("BeefStranger.UI Tweaks.ID")
local prop = require("BeefStranger.UI Tweaks.property")
local log = bs.log()
local uid = id.quickLoot

local MENU_BASE_HEIGHT = 107
local ITEM_MAX_HEIGHT = 45 ---Each itemblocks maxHeight + 1

local lootable = {
    [tes3.objectType.container] = true,
    [tes3.objectType.creature] = true,
    [tes3.objectType.npc] = true,
}

---@class bs_MenuQuickLoot
local this = {}

function this:get() return tes3ui.findMenu(uid.menu) end
function this:child(child) return self:get() and self:get():findChild(child) end
function this:Items() return self:child(uid.items_list) end
function this:Title() return self:child(uid.header_title) end


---Check if container is valid for Looting
---@param ref tes3reference
---@return boolean validContainer
function this.isContainerValid(ref)
    local valid = false
    if ref and ref.object then
        if ref.object.objectType == tes3.objectType.creature and ref.isDead then
            valid = true
        elseif ref.object.objectType == tes3.objectType.npc and ref.isDead then
            valid = true
        elseif ref.object.objectType == tes3.objectType.container and not tes3.getLocked({ reference = ref }) then
            valid = true
        end
    end
    return valid
end

function this.create()
    local menu = tes3ui.createMenu{ id = uid.menu, fixedFrame = true, modal = false }
    menu:bs_autoSize(false)
    menu.absolutePosAlignX = nil
    menu.positionX = cfg.quickLoot.posX
    menu.minWidth = 255
    menu.flowDirection = tes3.flowDirection.topToBottom
    menu:setPropertyInt(prop.quickLoot.sel, 1)
    menu.minHeight = MENU_BASE_HEIGHT
    menu.autoWidth = true

    local header = menu:createBlock({ id = uid.header })
    header.autoWidth = true
    header.childAlignX = -1
    header.height = 18
    header.widthProportional = 1
    local title = header:createLabel({ id = uid.header_title, text = "" })
    title.color = bs.rgb.headerColor
    title.borderRight = 20

    local headerInfo = header:createBlock({ id = uid.header_icons })
    headerInfo:bs_autoSize(true)
    headerInfo.widthProportional = 1
    headerInfo.childAlignX = 1

    local gold = headerInfo:createImage({ id = uid.gold_icon, path = "icons/gold.dds" })
    gold.borderRight = 40
    local weight = headerInfo:createImage({ id = uid.weight_icon, path = "icons/weight.dds" })
    weight.borderRight = 25

    ---Scrollbar
    local items = menu:createVerticalScrollPane({ id = uid.items_list })
    items:scrollAutoSize()
    items.autoHeight = false
    items.widthProportional = 1
    items.heightProportional = 1

    -- items:findChild("PartScrollPane_vert_scrollbar").visible = false

    local footer = menu:createBlock({ id = uid.footer })
    footer.widthProportional = 1
    footer.childAlignX = -1
    footer:bs_autoSize(true)

    local take = footer:createLabel({ id = uid.take_button, text = ("%s: %s"):format(bs.GMST(tes3.gmst.sTake), bs.keyindName(tes3.keybind.activate))})
    local takeAll = footer:createLabel({ id = uid.take_all_button, text = ("%s: %s"):format(bs.GMST(tes3.gmst.sTakeAll), bs.keyindName(tes3.keybind.readyWeapon)) })

    menu:register(tes3.uiEvent.preUpdate, function (e)
        -- local ref = e.source:bs_getObj(prop.quickLoot.container)
        -- local total = e.source:getPropertyInt(prop.quickLoot.total)
        local ref = this:getContainer()
        local total = this:getTotal()
        if ref then
            title.text = ref.object.name
            e.source.height = (menu:getContentElement().paddingAllSides * 2) + (math.clamp(cfg.quickLoot.showCount, 1, total) * ITEM_MAX_HEIGHT) + 40
            if not tes3.hasOwnershipAccess({target = ref}) then
                take.text =("%s: %s"):format(bs.tl("quickLoot.steal"), bs.keyindName(tes3.keybind.activate))
                takeAll.text = ("%s: %s"):format(bs.tl("quickLoot.steal"), bs.keyindName(tes3.keybind.readyWeapon))
                take.color = bs.rgb.bsNiceRed
                takeAll.color = bs.rgb.bsNiceRed

            end
            if ref.object.script then
                title.color = bs.rgb.bsRoyalPurple
                title.text = ("%s: %s"):format(title.text, bs.tl("quickLoot.scripted"))
            end
        end
    end)
    menu:register(tes3.uiEvent.update, function (e)
        -- local select = menu:getPropertyInt(prop.quickLoot.sel)
        -- local ref = e.source:bs_getObj(prop.quickLoot.container)
        local select = this:getSelection()
        local ref = this:getContainer()
        if ref then
            -- title.text = ref.object.name

            if #ref.object.inventory < 1 then
                e.source:destroy()
                return
            end
        end
        for index, itemBlock in ipairs(items:getContentElement().children) do
            local label = itemBlock:findChild(uid.item_name)
            if label then
                if index == select then
                    label.widget.state = tes3.uiState.active
                else
                    label.widget.state = tes3.uiState.normal
                end
            end
        end
    end)

    menu:register(tes3.uiEvent.destroy, function (e)
        log:debug("Destroying %s", e.source.name)
        tes3ui.suppressTooltip(false)
        tes3ui.refreshTooltip()
    end)
end
--- Example coroutine iterator from the MWSE Docs works exactly how i need, after dozen on hours of attempting and failing, time to learn coroutines
--- This is a generic iterator function that is used
--- to loop over all the items in an inventory
---@param ref tes3reference
---@return fun(): itemTypes, integer, tes3itemData|nil
function this.getInv(ref)
    local function iterate()
        for _, stack in pairs(ref.object.inventory) do
            ---@cast stack tes3itemStack
            local item = stack.object

            -- Account for restocking items,
            -- since their count is negative
            local count = math.abs(stack.count)

            -- first yield stacks with custom data
            if stack.variables then
                for _, data in pairs(stack.variables) do
                    if data then
                        -- Note that data.count is always 1 for items in inventories.
                        -- That field is only relevant for items in the game world, which
                        -- are stored as references. In that case tes3itemData.count field
                        -- contains the amount of items in the in-game-world stack of items.
                        coroutine.yield(item, data.count, data)
                        count = count - data.count
                    end
                end
            end
            -- then yield all the remaining copies
            if count > 0 then
                coroutine.yield(item, count)
            end
        end
    end
    return coroutine.wrap(iterate)
end

---comment
---@param item itemTypes
function this.highlightPotion(item)
    if item.effects then
        for i = 1, item:getActiveEffectCount() do
            local effect = item.effects[i].id
            if effect == tes3.effect.restoreHealth then
                return bs.rgb.bsNiceRed
            end
            if effect == tes3.effect.restoreMagicka then
                return bs.rgb.bsPrettyBlue
            end
            if effect == tes3.effect.restoreFatigue then
                return bs.rgb.bsPrettyGreen
            end
        end
    end
    -- return { 1, 1, 1 }
end

---comment
---@param ref tes3reference
function this.popMenu(ref)
    log:debug("Populating %s", this:get().name)
    local clone = ref:clone()
    local accessColor
    ---Total item count, need this because of itemData counting as same stack
    local total = 0
    ref.object.inventory:resolveLeveledItems(tes3.mobilePlayer)
    this:setContainer(ref)
    -- this:get():setPropertyObject(prop.quickLoot.container, ref)
    -- for key, stack in pairs(ref.object.inventory) do

    this:Title().text = ref.object.name
    if not tes3.hasOwnershipAccess({ target = ref }) then
        accessColor = bs.rgb.bsNiceRed
        this:Title().color = accessColor
        this:Title().text = ("%s: %s"):format(ref.object.name, tes3.getOwner({ reference = ref }).name)
    end

    for item, count, data in this.getInv(ref) do
        log:trace("Item: %s",item)
        local itemBlock = this:Items():createBlock({ id = item.id })
        itemBlock:register(tes3.uiEvent.mouseClick, this.onItemClick)
        itemBlock:bs_autoSize(true)
        itemBlock.childAlignX = -1
        itemBlock.childAlignY = 0.5
        itemBlock.widthProportional = 1
        itemBlock.borderRight = 10
        itemBlock.maxHeight = ITEM_MAX_HEIGHT
        local border = itemBlock:createImage({ id = "Border", path = bs.textures.menu_icon_equip })
        border.width = 44
        border.height = 44

        local icon = border:createImage { id = "icon", path = "Icons\\" .. item.icon }
        icon.absolutePosAlignX = 0
        icon.absolutePosAlignY = 0
        icon.borderAllSides = 6

        if count > 1 then
            local countLabel = icon:createLabel({ id = "count", text = "" .. count })
            countLabel.absolutePosAlignX = 1
            countLabel.absolutePosAlignY = 1
        end

        local textSelect = itemBlock:createTextSelect({ id = uid.item_name, text = item.name })

        if accessColor then
            textSelect.widget.idleActive = accessColor
            -- textSelect.widget.idle = bs.rgb.bsNicePink
        end

        if item.objectType == tes3.objectType.alchemy then
            local potionColor = this.highlightPotion(item)
            if potionColor then
                border.color = potionColor
                icon.color = potionColor
            end
        end

        if data then
            if item.isSoulGem then
                textSelect.text = ("%s (%s)"):format(item.name, data.soul.name)
            end
            if not (item.objectType == tes3.objectType.clothing) then
                local fillbar = border:bs_createVerticalFillbar({ id = "Fillbar", border = false })
                fillbar.width = 5
                fillbar.height = 39
                fillbar.absolutePosAlignX = 0.06
                fillbar.absolutePosAlignY = 0.5
                if data.condition and data.condition > 0 then
                    fillbar.widget.current = data.condition
                    fillbar.widget.max = item.maxCondition
                end
                if data.soul then
                    fillbar.widget.current = data.soul.soul
                    fillbar.widget.max = item.soulGemCapacity
                    fillbar.widget.fillColor = bs.rgb.magicColor
                end
            end
        end

        local info = itemBlock:createBlock({ id = "info" })
        info:bs_autoSize(true)
        info.borderLeft = 25


        

        -- local value = info:createLabel({ id = uid.value, text = "" ..
        -- tes3.getValue({ item = item, itemData = data }) .. "gp" })
        local value = info:createLabel({ id = uid.value, text = ("%sgp"):format(tes3.getValue{ item = item, itemData = data })})
        value.borderRight = 25
        local weight = info:createLabel({ text = ("%.2f"):format(item.weight) })
        itemBlock:bs_setObj({ object = item })
        this:setItemCount(itemBlock, count)
        -- itemBlock:setPropertyInt(prop.quickLoot.count, count)
        if data then
            itemBlock:bs_setItemData({ data = data })
        end
        total = total + 1
        -- loot:get():updateLayout()
    end
    -- this:get():setPropertyInt(prop.quickLoot.total, total)
    this:setTotal(total)
    this:get():updateLayout()
    ---Completely randomly started requiring 2 updates to make autoWidth work.
    this:get():updateLayout()
end

function this:getTotal()
    return self:get():getPropertyInt(prop.quickLoot.total)
end
function this:getSelection()
    return self:get():getPropertyInt(prop.quickLoot.sel)
end
function this:getContainer()
    return self:get():bs_getObj(prop.quickLoot.container)
end
---@param element tes3uiElement
function this:getItemCount(element)
    return element:getPropertyInt(prop.quickLoot.count)
end

---@param element tes3uiElement
---@param count number
function this:setItemCount(element, count)
    element:setPropertyInt(prop.quickLoot.count, count)
end

---@param total number
function this:setTotal(total)
    self:get():setPropertyInt(prop.quickLoot.total, total)
end
---@param selection number
function this:setSelection(selection)
    self:get():setPropertyInt(prop.quickLoot.sel, selection)
end
---@param ref tes3reference
function this:setContainer(ref)
    self:get():setPropertyObject(prop.quickLoot.container, ref)
end

function this.update()
    if this:get() then
        this:get():updateLayout()
    end
end


---Item Click Event
---@param e tes3uiEventData
function this.onItemClick(e)
    log:debug("%s `clicked`", e.source.name)
    -- local ref = e.source:getTopLevelMenu():bs_getObj(prop.quickLoot.container)
    local ref = this:getContainer()
    local obj = e.source:bs_getObj()
    local itemData = e.source:bs_getItemData()
    local count = this:getItemCount(e.source)
    -- local count = e.source:getPropertyInt(prop.quickLoot.count)
    local select = this:getSelection()
    local total = this:getTotal()
    -- local select = e.source:getTopLevelMenu():getPropertyInt(prop.quickLoot.sel)
    -- local total = e.source:getTopLevelMenu():getPropertyInt(prop.quickLoot.total)

    if not tes3.hasOwnershipAccess({ target = ref }) then
        tes3.triggerCrime{ type = tes3.crimeType.theft, value = (obj.value * count), victim = tes3.getOwner{ reference = ref }}
    end
    tes3.transferItem({ item = obj, from = ref, to = tes3.player, count = count, itemData = itemData })
    -- if select > cfg.showCount then
    --     debug.log(loot:itemIndex(select - 1).name)
    -- end
    if ref.lockNode and not ref.lockNode.locked and ref.lockNode.trap then
        tes3.applyMagicSource({ reference = tes3.player, source = ref.lockNode.trap })
        ref.lockNode.trap = nil
        tes3ui.refreshTooltip()
    end
    this:setSelection(math.clamp(select - 1, 1, total - 1))
    this:setTotal(total - 1)
    -- e.source:getTopLevelMenu():setPropertyInt(prop.quickLoot.sel, math.clamp(select - 1, 1, total - 1))
    -- e.source:getTopLevelMenu():setPropertyInt(prop.quickLoot.total, total - 1)
    e.source:destroy()
    this.updateScrollbar()
    log:trace("ITEMCLICK UPDATE")
    this.update()
    -- e.source:getTopLevelMenu():updateLayout()
end

function this.updateScrollbar()
    local menu = this:get()
    if menu then
        local totalItems = this:getTotal()
        -- local totalItems = menu:getPropertyInt(prop.quickLoot.total)
        local height = math.max(0, (totalItems * ITEM_MAX_HEIGHT) - (math.min(cfg.quickLoot.showCount, totalItems) * ITEM_MAX_HEIGHT))
        this:Items().widget.positionY = math.clamp(this:Items().widget.positionY - ITEM_MAX_HEIGHT, 0, height)
    end
end

--- @param e activationTargetChangedEventData
local function onTargetChange(e)
    local ref = e.current
    if ref and ref.object and lootable[ref.object.objectType] then
        if bs.isKeyDown(tes3.scanCode.e) and bs.isKeyDown(tes3.scanCode.lShift) then
            tes3.player:activate(ref)
            return
        end
    end
    if this:get() then
        log:trace("ActiveateDestroy")
        -- tes3ui.suppressTooltip(false)
        this:get():destroy()
    end
    if ref and this.isContainerValid(ref) then
        ref:clone()
        log:trace("QuickLoot Ref: %s", ref.object.name)
        if #ref.object.inventory > 0 then
            this.create()
            this.popMenu(ref)
            tes3ui.suppressTooltip(true) ---Gets unsuppressed in destroy callback
        else
            if this:get() then
                log:trace("DESTROY QUICKLOOT")
                -- tes3ui.suppressTooltip(false)
                this:get():destroy()
            end
        end
    end

    if not ref and this:get() then
        log:trace("Destroy")
        this:get():destroy()
    end
end
event.register(tes3.event.activationTargetChanged, onTargetChange)


--- @param e mouseWheelEventData
local function onScrollWheel(e)
    log:trace(""..e.delta)
    local menu = this:get()
    if menu and menu.visible and not tes3ui.menuMode() then
        -- -- -Scrollbar
        local select = this:getSelection()
        local totalItems = this:getTotal()
        local posY = this:Items().widget.positionY
        local height = math.max(0, (totalItems * ITEM_MAX_HEIGHT) - (math.min(cfg.quickLoot.showCount, totalItems) * ITEM_MAX_HEIGHT))
        --[[topVisibleIndex: CHATGPT Solved my scrolling problems, dont fully understand so leaving explanation for future reference.
                This is the index of the first visible item. It’s calculated by dividing the vertical scroll position (posY) by the height of an item (itemHeight).
                Example: If posY = 44 and itemHeight = 44, math.floor(44 / 44) gives 1. Add 1 to this, so the first visible item is index 2.

                bottomVisibleIndex: This is the index of the last visible item. It’s derived by adding the number of visible items (visibleItems) to
                the topVisibleIndex. The math.min ensures it doesn’t exceed the total number of items. ]]

        local topVisibleIndex = math.floor(posY / ITEM_MAX_HEIGHT) + 1
        -- Calculate the bottommost visible item's index
        local bottomVisibleIndex = math.min(topVisibleIndex + cfg.quickLoot.showCount - 1, totalItems)

        if e.delta > 0 then     ---Up
            if select > 1 then
                select = select - 1
                -- Update `positionY` only if `select` moves out of the visible range
                if select < topVisibleIndex then
                    this:Items().widget.positionY = math.clamp(posY - ITEM_MAX_HEIGHT, 0, height)
                end
            end
        else     ---Down
            if select < totalItems then
                select = select + 1
                if select > bottomVisibleIndex then
                    this:Items().widget.positionY = math.clamp(posY + ITEM_MAX_HEIGHT, 0, height)
                end
            end
        end
        -- menu:setPropertyInt(prop.quickLoot.sel, select)
        this:setSelection(select)
        log:trace("MOUSE UPDATE")
        this:update()
        -- menu:updateLayout()
    end
end
event.register(tes3.event.mouseWheel, onScrollWheel)


--- @param e keybindTestedEventData
local function keybindTestedCallback(e)
    if this:get() then
        if e.result and e.keybind == tes3.keybind.activate then
            if not bs.isKeyDown(tes3.scanCode.lShift) then
                -- local select = this:get():getPropertyInt(prop.quickLoot.sel)
                local select = this:getSelection()
                this:Items():getContentElement().children[select]:triggerEvent(tes3.uiEvent.mouseClick)
                return false
            end
        end
        if e.result and e.keybind == tes3.keybind.readyWeapon then
            if this:get() then
                -- local ref = this:get():bs_getObj(prop.quickLoot.container)
                local ref = this:getContainer()
                tes3.transferInventory({ from = ref, to = tes3.player, checkCrime = true })
                log:trace("KEYBIND WEAPON UPDATE")
                this.update()
                return false
            end
        end
    end
end
event.register(tes3.event.keybindTested, keybindTestedCallback)

return this