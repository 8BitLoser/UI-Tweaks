local cfg = require("BeefStranger.UI Tweaks.config")
local bs = require("BeefStranger.UI Tweaks.common")
local Barter = require("BeefStranger.UI Tweaks.menu.MenuBarter")
local Book = require("BeefStranger.UI Tweaks.menu.MenuBook")
local Dialog = require("BeefStranger.UI Tweaks.menu.MenuDialog")
local Enchant = require("BeefStranger.UI Tweaks.menu.MenuEnchantment")
local Inventory = require("BeefStranger.UI Tweaks.menu.MenuInventory")
local Journal = require("BeefStranger.UI Tweaks.menu.MenuJournal")
local Persuasion = require("BeefStranger.UI Tweaks.menu.MenuPersuasion")
local Repair = require("BeefStranger.UI Tweaks.menu.MenuRepair")
local RestWait = require("BeefStranger.UI Tweaks.menu.MenuRestWait")
local Scroll = require("BeefStranger.UI Tweaks.menu.MenuScroll")
local Service = require("BeefStranger.UI Tweaks.menu.MenuServices")
local Spellmaking = require("BeefStranger.UI Tweaks.menu.MenuSpellmaking")
local TransferEnchant = require("BeefStranger.UI Tweaks.modSupport.TransferEnchant")
local id = require("BeefStranger.UI Tweaks.ID")
local find = tes3ui.findMenu
local leave = { [id.Inventory] = function() tes3ui.leaveMenuMode() end, }
local menuLeft = false  ---Track if a menu has been closed
local leaveMenu = false ---LeaveMenuMode if no Menu was closed

local closeButtons
local closeText
--- @param e initializedEventData
local function initializedCallback(e)
    closeButtons = {
        [id.Ctrls] = "MenuCtrls_Okbutton",
        [id.Video] = "MenuVideo_Okbutton",
        [id.Prefs] = "MenuPrefs_Okbutton",
        [id.Audio] = "MenuAudio_Okbutton",
        [id.Options] = "MenuOptions_Return_container",
        [id.Book] = "MenuBook_button_close",
        [id.Scroll] = "MenuScroll_Close",
    }

    closeText = {
        [bs.GMST(tes3.gmst.sGoodbye)] = true,
        [bs.GMST(tes3.gmst.sCancel)] = true,
        [bs.GMST(tes3.gmst.sClose)] = true,
        [bs.GMST(tes3.gmst.sOK)] = true,
        [bs.GMST(tes3.gmst.sDone)] = true,
    }
end
event.register(tes3.event.initialized, initializedCallback)
local close = {
    [id.Barter] = function() return Barter:Close() end,
    [id.Book] = function() return Book:Close() end,
    [id.Dialog] = function() return Dialog:Close() end,
    [id.Enchantment] = function() return Enchant:Close() end,
    [id.Journal] = function() return Journal:Close() end,
    [id.Persuasion] = function() return Persuasion:Close() end,
    [id.Repair] = function()return Repair:Close() end,
    [id.InventorySelect] = function() return Inventory.Select:Close() end,
    [id.ServiceRepair] = function()return Service.Repair:Close() end,
    [id.ServiceTraining] = function() return Service.Train:Close() end,
    [id.ServiceTravel] = function() return Service.Travel:Close() end,
    [id.RestWait] = function() return RestWait:CancelButton() end,
    [id.Scroll] = function() return Scroll:Close() end,
    [id.ServiceSpells] = function() return Service.Spells:Close() end,
    [id.SetValues] = function() return Spellmaking.SetValues:Close() end,
    [id.Spellmaking] = function() return Spellmaking:Close() end,

    ["bsTransferEnchant"] = function() return TransferEnchant:Close() end,
    ["bsItemSelect"] = function() return TransferEnchant.Select:Close() end,
    ["BS_DecipherScroll"] = function() return find("BS_DecipherScroll"):findChild("Close") end,
    ["BS_IdentifyMenu"] = function() return find("BS_IdentifyMenu"):findChild("close") end,
}

local blacklist = {
    [id.Audio] = true,
}

--- Close menus on Right click
--- @param e keybindTestedEventData
local function keybindTestedCallback(e)
    if not cfg.escape.enable then return end
    if e.keybind == cfg.escape.keybind and e.result then
        if tes3.isCharGenRunning() then return end
        if tes3ui.menuMode() then
            local menu = tes3ui.getMenuOnTop()
            if cfg.escape.blacklist[menu.name] then
                -- debug.log(menu.name)
                return
            end
            ---Menus that dont have "Cancel" buttons
            for menuID, button in pairs(closeButtons) do
                if menuID == menu.name then
                    local child = menu:findChild(button)
                    if child.visible then
                        -- debug.log(child)
                        child:bs_click()
                        return false
                    end
                end
            end

            ---Most Menus can be closed by findind the cancel button
            for button in table.traverse(menu.children) do
                ---@cast button tes3uiElement
                if button.type == tes3.uiElementType.button then
                    if button.visible then
                        if closeText[button.text] then
                            -- debug.log(button)
                            button:bs_click()
                            return false
                        end
                    end
                end
            end
            tes3ui.leaveMenuMode()
            return false
        end
    end
end
event.register(tes3.event.keybindTested, keybindTestedCallback)


---NEEDS TO MOVE TO MENUOPTIONS!!!
---@param e uiActivatedEventData
local function uiActivatedCallback(e)
    local width = 400
    local height = 500
    if e.element.name == id.Ctrls then
        e.element.width = width
        e.element.height = height
        for child in table.traverse(e.element:getContentElement().children) do ---@param child tes3uiElement
            if child.type == tes3.uiElementType.button  then
                if child.text == bs.GMST(tes3.gmst.sOK) then
                    child:bs_Rename("MenuCtrls_Okbutton")
                end
            end
        end
        e.element:updateLayout()
    end
end
event.register(tes3.event.uiActivated, uiActivatedCallback)

---Work around for MenuInventory being not visible whenever MenuOptions is activated
-- ---@param e keyDownEventData
-- local function Escape(e)
--     leaveMenu = false
--     menuLeft = false
--     if tes3.menuMode() and cfg.escape.enable then
--         for menuID, button in pairs(close) do
--             local menu = find(menuID)
--             if menu and menu.visible and menu == tes3ui.getMenuOnTop() then
--                 if find(menuID) and menu.visible then
--                     button():triggerEvent("click")
--                     bs.click()
--                     menuLeft = true
--                 end

--                 timer.delayOneFrame(function() ---Some menus exit too fast and then exit the next
--                     if find(menuID) and menu.visible then
--                         button():triggerEvent("click")
--                         bs.click()
--                         menuLeft = true
--                     end
--                 end, timer.real)
--             end
--         end
--     end

--     timer.delayOneFrame(function(e)
--         if not menuLeft then     ---If No menu was left and a leaveMenu was visible leaveMenuMode
--             if Dialog:child("MenuDialog_answer_block") then return end
--             for menuID, leaveMenuMode in pairs(leave) do
--                 if find(menuID) and find(menuID).visible then
--                     bs.click()
--                     leaveMenuMode()
--                     leaveMenu = true
--                 end
--             end
--         end
--     end, timer.real)
-- end
-- event.register(tes3.event.keyDown, Escape, { filter = tes3.scanCode.escape, priority = -10000 })

-- ---@param e uiActivatedEventData
-- local function onOptions(e)
--     if not cfg.escape.enable then return end
--     if leaveMenu then ---If menuMode was left destroy Options
--         if find(id.Options) then
--             find(id.Options):destroy()
--         end
--     end

--     if menuLeft then     ---If a Menu was left destroy Options
--         menuLeft = false ---Update visibility
--         if find(id.Options) then
--             find(id.Options):destroy()
--         end
--     end
-- end
-- event.register(tes3.event.uiActivated, onOptions, {filter = id.Options, priority = -10000})