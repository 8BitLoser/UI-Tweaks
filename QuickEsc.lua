local cfg = require("BeefStranger.UI Tweaks.config")
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
local leaveNotDestroy = { MenuInventory = true, MenuContents = true, }
local leave = { [id.Inventory] = function() tes3ui.leaveMenuMode() end, }
local menuLeft = false
local leaveMenu

local close = {
    [id.Barter] = function() return Barter:Close() end,
    [id.Book] = function() return Book:Close() end,
    [id.Dialog] = function() return Dialog:Close() end,
    [id.Enchantment] = function() return Enchant:Close() end,
    [id.Journal] = function() return Journal:Close() end,
    [id.Persuasion] = function() return Persuasion:Close() end,
    [id.Repair] = function()return Repair:Close() end,
    [id.InventorySelect] = function() return Inventory.Select:Close() end,
    ["bsTransferEnchant"] = function() return TransferEnchant:Close() end,
    ["bsItemSelect"] = function() return TransferEnchant.Select:Close() end,
    [id.ServiceRepair] = function()return Service.Repair:Close() end,
    [id.ServiceTraining] = function() return Service.Train:Close() end,
    [id.ServiceTravel] = function() return Service.Travel:Close() end,
    [id.RestWait] = function() return RestWait:Close() end,
    [id.Scroll] = function() return Scroll:Close() end,
    [id.ServiceSpells] = function() return Service.Spells:Close() end,
    [id.SetValues] = function() return Spellmaking.SetValues:Close() end,
    [id.Spellmaking] = function() return Spellmaking:Close() end,
}

---Work around for MenuInventory being not visible whenever MenuOptions is activated
---@param e keyDownEventData
local function Escape(e)
    leaveMenu = false
    menuLeft = false ---Track if menu in close has been left
    if tes3.menuMode() and cfg.escape.enable then
        for menuID, button in pairs(close) do
            local menu = find(menuID)
            if menu and menu.visible and menu == tes3ui.getMenuOnTop() then
                if find(menuID) and menu.visible then
                    button():triggerEvent("click")
                    tes3.playSound { sound = "Menu Click" }
                end

            if menu and menu.visible then
                if --[[ cfg.escape.menus[id.Persuasion] and  ]]find(id.Persuasion) then ---Menus that need Manual Handling
                    Persuasion:Close():triggerEvent("click")
                    tes3.playSound{sound = "Menu Click"}
                    menuLeft = true
                    break
                elseif find(id.Barter) then
                    Barter:Close():triggerEvent("click")
                    tes3.playSound{sound = "Menu Click"}
                    menuLeft = true
                    break
                elseif find(id.SetValues) then
                    Spellmaking.SetValues:Close():triggerEvent("click")
                    tes3.playSound{sound = "Menu Click"}
                    menuLeft = true
                    break
                elseif find(id.Spellmaking) then
                    Spellmaking:Close():triggerEvent("click")
                    tes3.playSound{sound = "Menu Click"}
                    menuLeft = true
                    break
                elseif find(id.InventorySelect) then
                    Inventory.Select:Close():triggerEvent("click")
                    tes3.playSound{sound = "Menu Click"}
                    menuLeft = true
                    break
                elseif find("bsItemSelect") then
                    TransferEnchant.Select:Close():triggerEvent("click")
                    tes3.playSound{sound = "Menu Click"}
                    menuLeft = true
                    break
                end
            end

                timer.delayOneFrame(function() ---Some menus exit too fast and then exit the next
                    if find(menuID) and menu.visible then
                        button():triggerEvent("click")
                        tes3.playSound { sound = "Menu Click" }
                        menuLeft = true
                    end
                end, timer.real)
            end
        end

        timer.delayOneFrame(function (e)
            if not menuLeft then ---If No menu was left and a leaveMenu was visible leaveMenuMode
                if Dialog:child("MenuDialog_answer_block") then return end
                for key, doLeave in pairs(leave) do
                    if find(key) and find(key).visible then
                        tes3.playSound{sound = "Menu Click"}
                        doLeave()
                        leaveMenu = true
                    end
        if not menuLeft then ---If No menu was left and a leaveMenu was visible leaveMenuMode
            for key, doLeave in pairs(leave) do
                if find(key) and find(key).visible then
                    tes3.playSound{sound = "Menu Click"}
                    doLeave()
                    leaveMenu = true
                end
            end
        end , timer.real)
    end
end
event.register(tes3.event.keyDown, Escape, {filter = tes3.scanCode.escape, priority = -10000})

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