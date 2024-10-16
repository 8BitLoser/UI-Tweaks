local cfg = require("BeefStranger.UI Tweaks.config")
local bs = require("BeefStranger.UI Tweaks.common")
local Barter = require("BeefStranger.UI Tweaks.MenuBarter")
local Book = require("BeefStranger.UI Tweaks.MenuBook")
local Dialog = require("BeefStranger.UI Tweaks.MenuDialog")
local Enchant = require("BeefStranger.UI Tweaks.MenuEnchantment")
local Inventory = require("BeefStranger.UI Tweaks.MenuInventory")
local Journal = require("BeefStranger.UI Tweaks.MenuJournal")
local Persuasion = require("BeefStranger.UI Tweaks.MenuPersuasion")
local Repair = require("BeefStranger.UI Tweaks.MenuRepair")
local RestWait = require("BeefStranger.UI Tweaks.MenuRestWait")
local Scroll = require("BeefStranger.UI Tweaks.MenuScroll")
local Service = require("BeefStranger.UI Tweaks.MenuServices")
local Spellmaking = require("BeefStranger.UI Tweaks.MenuSpellmaking")
local TransferEnchant = require("BeefStranger.UI Tweaks.TransferEnchant")
local id = require("BeefStranger.UI Tweaks.menuID")
local find = tes3ui.findMenu
local leave = { [id.Inventory] = function() tes3ui.leaveMenuMode() end, }
local menuLeft = false  ---Track if a menu has been closed
local leaveMenu = false ---LeaveMenuMode if no Menu was closed

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
    [id.RestWait] = function() return RestWait:Close() end,
    [id.Scroll] = function() return Scroll:Close() end,
    [id.ServiceSpells] = function() return Service.Spells:Close() end,
    [id.SetValues] = function() return Spellmaking.SetValues:Close() end,
    [id.Spellmaking] = function() return Spellmaking:Close() end,

    ["bsTransferEnchant"] = function() return TransferEnchant:Close() end,
    ["bsItemSelect"] = function() return TransferEnchant.Select:Close() end,
    ["BS_DecipherScroll"] = function() return find("BS_DecipherScroll"):findChild("Close") end,
    ["BS_IdentifyMenu"] = function() return find("BS_IdentifyMenu"):findChild("close") end,
}

---Work around for MenuInventory being not visible whenever MenuOptions is activated
---@param e keyDownEventData
local function Escape(e)
    leaveMenu = false
    menuLeft = false
    if tes3.menuMode() and cfg.escape.enable then
        for menuID, button in pairs(close) do
            local menu = find(menuID)
            if menu and menu.visible and menu == tes3ui.getMenuOnTop() then
                if find(menuID) and menu.visible then
                    button():triggerEvent("click")
                    bs.click()
                    menuLeft = true
                end

                timer.delayOneFrame(function() ---Some menus exit too fast and then exit the next
                    if find(menuID) and menu.visible then
                        button():triggerEvent("click")
                        bs.click()
                        menuLeft = true
                    end
                end, timer.real)
            end
        end
    end

    timer.delayOneFrame(function(e)
        if not menuLeft then     ---If No menu was left and a leaveMenu was visible leaveMenuMode
            if Dialog:child("MenuDialog_answer_block") then return end
            for menuID, leaveMenuMode in pairs(leave) do
                if find(menuID) and find(menuID).visible then
                    bs.click()
                    leaveMenuMode()
                    leaveMenu = true
                end
            end
        end
    end, timer.real)
end
event.register(tes3.event.keyDown, Escape, { filter = tes3.scanCode.escape, priority = -10000 })

---@param e uiActivatedEventData
local function onOptions(e)
    if not cfg.escape.enable then return end
    if leaveMenu then ---If menuMode was left destroy Options
        if find(id.Options) then
            find(id.Options):destroy()
        end
    end

    if menuLeft then     ---If a Menu was left destroy Options
        menuLeft = false ---Update visibility
        if find(id.Options) then
            find(id.Options):destroy()
        end
    end
end
event.register(tes3.event.uiActivated, onOptions, {filter = id.Options, priority = -10000})