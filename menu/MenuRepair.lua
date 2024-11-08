local cfg = require("BeefStranger.UI Tweaks.config")
local bs = require("BeefStranger.UI Tweaks.common")
local id = require("BeefStranger.UI Tweaks.ID")
local startTime = os.clock()

---@class bsMenuRepair_This
local this = {}

---@class bsMenuRepair
local Repair = {}
function Repair:get() return tes3ui.findMenu(id.Repair) end---Get Top Level Menu
function Repair:child(child) return self:get() and self:get():findChild(child) or nil end ---@param child string|number
function Repair:Close() return self:child("MenuRepair_Okbutton") end---The Close Button
function Repair:Items() return self:child("PartScrollPane_pane") end---The Direct Parent of Items to Repair
---The List of Items to Repair
function Repair:ServiceList() return self:child("MenuRepair_ServiceList") end
---The Title Block Containing: Icon: Uses: Quality
function Repair:TitleBlock() return self:child("title layout") end
---The Repair Hammer Block
function Repair:ObjectBlock() return self:child("MenuRepair_object_layout") end
---The Icon of the Repair Hammer/Tongs
function Repair:RepairIcon() return self:child("repairimage") end
---The Remaining Uses
function Repair:RepairUses() return self:child("MenuRepair_uses") end
---The Quality of the Hammer/Tongs
function Repair:RepairQuality() return self:child("MenuRepair_quality") end
---The Block Containing the Close button
function Repair:ButtonBlock() return self:child("MenuRepair_Okbutton").parent end
---MenuRepair has updates disabled, this enables it, though only for 1 update.
function Repair:enableUpdates() self:get():setPropertyBool("update_disable", true) end

function Repair:object() return self:get():bs_getObj() end
function Repair:itemData() return self:get():bs_getItemData() end

--- @param e uiActivatedEventData
function this.ToolSelect(e)
    local objectBlock = Repair:ObjectBlock()
    objectBlock:bs_autoSize(true)
    objectBlock.borderAllSides = 0

    local select = objectBlock:createImage({ id = "Select", path = bs.textures.menu_icon_equip })
    select.height = 50
    select.width = 50

    Repair:RepairIcon():move { to = select }
    local icon = Repair:RepairIcon()
    icon.borderAllSides = 6

    Repair:enableUpdates()

    e.element:updateLayout()
    objectBlock:register(tes3.uiEvent.help, function()
        tes3ui.createTooltipMenu({ item = e.element:bs_getObj(), itemData = e.element:bs_getItemData() })
    end)
    objectBlock:register(tes3.uiEvent.mouseClick, function()
        tes3ui.showInventorySelectMenu({
            title = "Repair Tools",
            filter = function(s)
                if s.item.objectType == tes3.objectType.repairItem then
                    return true
                else
                    return false
                end
            end,
            callback = function(s)
                if s.item then
                    -- e.element:setPropertyObject("MenuRepair_Object", s.item)
                    e.element:bs_setObj({ object = s.item })
                    if not s.itemData then
                        local itemData = tes3.addItemData({ item = s.item, to = tes3.mobilePlayer })
                        s.itemData = itemData
                    end

                    e.element:bs_setData({ data = s.itemData })
                    icon.contentPath = "Icons\\" .. s.item.icon

                    Repair:RepairUses().text = "Uses " .. s.itemData.condition
                    Repair:RepairQuality().text = ("Quality %.2f"):format(s.item.quality)

                    e.element:setPropertyBool("update_disable", false)
                    e.element:updateLayout()
                end
            end
        })
    end)
end



---@param e uiActivatedEventData
local function RepairActivated(e)
    if not cfg.repair.enable then return end
    if cfg.repair.select then
        this.ToolSelect(e)
    end

    if cfg.repair.hold then
        for _, value in pairs(Repair:Items().children) do
            local item = value.children[2].children[1]
            if item.type == "image" then
                item:register(tes3.uiEvent.mouseStillPressed, function()
                    if os.clock() - startTime >= cfg.repair.duration then
                        if Repair:get() and tes3.worldController.inputController:isMouseButtonDown(0) then
                            item:triggerEvent("mouseClick")
                            startTime = os.clock()
                        end
                    end
                end)
            end
        end
    end


end
event.register(tes3.event.uiActivated, RepairActivated, {filter = id.Repair})

return Repair