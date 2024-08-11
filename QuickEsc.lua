local cfg = require("BeefStranger.UI Tweaks.config")
local menu = require("BeefStranger.UI Tweaks.menuID")
local find = tes3ui.findMenu
local leaveNotDestroy = { MenuInventory = true, MenuContents = true, }
local menuLeft = false

---Work around for MenuInventory being not visible whenever MenuOptions is activated
---@param e keyDownEventData
local function Escape(e)
    if tes3.menuMode() and cfg.escape.enable then
        for menuID, _ in pairs(cfg.escape.menus) do
            if find(menuID) then
                if menuID == menu.Barter or menuID == menu.Book or menuID == menu.Scroll then
                    return
                elseif menuID == menu.Inventory then
                    if find(menuID).visible then
                        tes3ui.leaveMenuMode()
                        menuLeft = true
                    end
                end
            end
        end
    end
end
event.register(tes3.event.keyDown, Escape, {filter = tes3.scanCode.escape, priority = -10000})

---Destroy/leaveMenuMode on Menus in menus table
---@param e uiActivatedEventData
local function onOptions(e)
    if not cfg.escape.enable then return end
    for menuID, enabled in pairs(cfg.escape.menus) do
        if enabled and not leaveNotDestroy[menuID] then
            local foundMenu = find(menuID)
            if foundMenu then
                ---Prevent Exiting Dialog if theres something to Select
                if foundMenu:findChild("MenuDialog_answer_block") then return end
                foundMenu:destroy()                   ---Destroy foundMenu in menus table
                if find(menu.Options) then ---Destroy Options as soon as it opens
                    find(menu.Options):destroy()
                    tes3ui.leaveMenuMode()
                end
            end
        end
    end

    if menuLeft then     ---If the Inventory is Open
        menuLeft = false ---Update visibility
        if find(menu.Options) then
            find(menu.Options):destroy()
        end
    end
end
event.register(tes3.event.uiActivated, onOptions, {filter = menu.Options, priority = -10000})