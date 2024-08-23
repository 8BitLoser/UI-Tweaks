---@diagnostic disable: duplicate-set-field
local function register()
    print("[UI Tweaks] Custom tes3uiElement Methods initialized")
    ---=========================================================---
    ---=================Added Class Definitions=================---
    ---=========================================================---


    ---@class tes3uiElement
    tes3uiElement = {}
    --- Sets heightProportional and widthProportional to nil.
    function tes3uiElement:notProp() end

    ---@param self tes3uiElement
    ---@param leave boolean|nil? `Default: true` Leaves MenuMode if true
    function tes3uiElement:exit(leave) end

    ---Enables/Disables both autoHeight and autoWidth
    ---@param enabled boolean? `Default: true`
    function tes3uiElement:autoSize(enabled) end

    ---Create a Close Button that destroys/exits MenuMode
    ---@param self tes3uiElement
    ---@param text string? `Default: Cancel`
    ---@param callback fun(e: tes3uiEventData)? Optional:Additional Function that runs before closing
    ---@return tes3uiElement? button The tes3uiElement for the Close Button
    function tes3uiElement:createClose(text, callback) end

    ---Can be called on Child Elements to update the Top Most Element
    function tes3uiElement:topUpdate() end

    ---Create Tooltip for Items
    ---@param self tes3uiElement
    ---@param item tes3alchemy|tes3apparatus|tes3armor|tes3book|tes3clothing|tes3ingredient|tes3light|tes3lockpick|tes3misc|tes3probe|tes3repairTool|tes3weapon|tes3leveledItem
    ---@param itemData? tes3itemData itemData if used
    function tes3uiElement:itemTooltip(item, itemData) end

    ---Search Children for text matching `string`
    ---@param self tes3uiElement
    ---@param string string
    ---@return tes3uiElement|nil?
    function tes3uiElement:findText(string) end

    ---Create Underline
    ---@param params tes3uiElement.createRect.params
    ---
    --- `id`: string|number|nil — *Optional*. An identifier to help find this element later.
    ---
    --- `color`: tes3vector3|number[]|nil — *Optional*. The fill color for the element.
    ---
    --- `randomizeColor`: boolean? — *Default*: `false`. If true, the creation color will be randomized.
    --- @return tes3uiElement? result Returns Underline Element
    function tes3uiElement:createUnderline(params) end

    ---=========================================================---
    ---===============Added tes3uiElement Methods===============---
    ---=========================================================---


    local uiMeta = getmetatable(tes3ui.findMenu(tes3ui.registerID("MenuOptions")))
    -- debug.log(uiMeta)
    if not uiMeta then
        uiMeta = getmetatable(tes3ui.createMenu { id = "getMetaTest" }) --create Dummy Menu to get tes3uiElement metatable
        -- debug.log(uiMeta)
        tes3ui.findMenu("getMetaTest"):destroy()--destroy Dummy Menu
    end

    function uiMeta:notProp()
        self.heightProportional = nil
        self.widthProportional = nil
    end

    function uiMeta:exit(leave)
        leave = (leave == nil and true) or leave
        self:getTopLevelMenu():destroy()
        if leave then
            tes3ui.leaveMenuMode()
        end
    end

    function uiMeta:autoSize(enabled)
        enabled = (enabled == nil and true) or enabled
        self.autoHeight = enabled
        self.autoWidth = enabled
    end

    function uiMeta:createClose(text, callback)
        local button = self:createButton({ id = "close", text = text or "Cancel" })

        button:registerBefore(tes3.uiEvent.mouseClick, function(e)
            if callback then callback(e) end --callback to run if passed along
            button:exit()
        end)

        return button
    end

    function uiMeta:itemTooltip(item, itemData)
        self:register(tes3.uiEvent.help, function(e)
            tes3ui.createTooltipMenu({ item = item, itemData = itemData })
        end)
    end

    function uiMeta:createUnderline(params)
        local underline = self:createRect(params)
        underline.height = 1
        underline.widthProportional = 1

        return underline
    end

    function uiMeta:findText(string)
        for _, child in pairs(self.children) do
            local childText = child.text or ""
            if childText:lower():find(string:lower(), 1, true) then
                return child
            else
                if #child.children > 0 then
                    local found = child:findText(string)
                    if found then
                        return found
                    end
                end
            end
        end
        return nil -- Return nil if no match is found
    end

    function uiMeta:topUpdate()
        self:getTopLevelMenu():updateLayout()
    end
end
event.register(tes3.event.initialized, register)
