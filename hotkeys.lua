local cfg = require("BeefStranger.UI Tweaks.config")
local bs = require("BeefStranger.UI Tweaks.common")
local keybind = cfg.keybind
local dialog = cfg.dialog
local Barter = require("BeefStranger.UI Tweaks.menu.MenuBarter")
local Dialog = require("BeefStranger.UI Tweaks.menu.MenuDialog")
local Book = require("BeefStranger.UI Tweaks.menu.MenuBook")
local Scroll = require("BeefStranger.UI Tweaks.menu.MenuScroll")
local Persuasion = require("BeefStranger.UI Tweaks.menu.MenuPersuasion")
local RestWait = require("BeefStranger.UI Tweaks.menu.MenuRestWait")
local Service = require("BeefStranger.UI Tweaks.menu.MenuServices")
local id = require("BeefStranger.UI Tweaks.ID")
local ts = tostring

local function key(e, cfgKey) return tes3.isKeyEqual({actual = e, expected = cfgKey}) end

---@param keybind mwseKeyCombo
local function keyDown(keybind) return tes3.worldController.inputController:isKeyDown(keybind.keyCode) end

local time = os.clock()

local this = {}
this.button = {
    embed_admire = function () Dialog.embed:child(id.embed.persuade_Admire):bs_click() end,
    embed_intimidate = function () Dialog.embed:child(id.embed.persuade_Intimidate):bs_click() end,
    embed_taunt = function () Dialog.embed:child(id.embed.persuade_Taunt):bs_click() end,
    embed_bribe10 = function () Dialog.embed:child(id.embed.persuade_Bribe_10):bs_click() end,
    embed_bribe100 = function () Dialog.embed:child(id.embed.persuade_Bribe_100):bs_click() end,
    embed_bribe1000 = function () Dialog.embed:child(id.embed.persuade_Bribe_1000):bs_click() end,
}


local function RestWaitHold()
    if cfg.wait.enable and RestWait:get() then
        if keyDown(cfg.keybind.waitUp) then
            RestWait:TimeUp():bs_triggerHold()
        elseif keyDown(cfg.keybind.waitDown) then
            RestWait:TimeDown():bs_triggerHold()
        end
    end
end

-- local persuadeTime = os.clock()
---@param e enterFrameEventData
local function buttonHold(e)
    if not cfg.keybind.enable then return end

    RestWaitHold()

    if Barter:get() and cfg.barter.enable then
        if keyDown(cfg.keybind.barterUp) then
            Barter:BarterUp():triggerEvent(tes3.uiEvent.mouseStillPressed)
        elseif keyDown(cfg.keybind.barterDown) then
            Barter:BarterDown():triggerEvent(tes3.uiEvent.mouseStillPressed)
        end
    end

    if cfg.persuade.enable and Persuasion:get() and cfg.persuade.hold then
        if os.clock() - time >= cfg.persuade.delay then
            if keyDown(cfg.keybind.admire) then Persuasion:trigger("Admire") end
            if keyDown(cfg.keybind.intimidate) then Persuasion:trigger("Intimidate") end
            if keyDown(cfg.keybind.taunt) then Persuasion:trigger("Taunt") end
            if cfg.persuade.holdBribe then
                if keyDown(cfg.keybind.bribe10) then Persuasion:trigger("Bribe10") end
                if keyDown(cfg.keybind.bribe100) then Persuasion:trigger("Bribe100") end
                if keyDown(cfg.keybind.bribe1000) then Persuasion:trigger("Bribe1000") end
            end
            time = os.clock()
        end
    end
end
event.register(tes3.event.enterFrame, buttonHold)

local Take = {}
function Take.Book() if Book:get() then Book:Take():triggerEvent("mouseClick") end end
function Take.Scroll() if Scroll:get() then Scroll:Take():triggerEvent("mouseClick") end end

---@param element tes3uiElement
local function click(element)
    if element and element.visible then
        Dialog.click(element)
    end
end

local function DialogKeyDown(e)
    if dialog.enable and (Dialog:get() and Dialog:get():bs_isOnTop()) then
        if key(e, keybind.barter) then click(Dialog:Barter()) end
        if key(e, keybind.companion) then click(Dialog:Companion()) end
        if key(e, keybind.enchanting) then click(Dialog:Enchanting()) end
        if key(e, keybind.persuasion) then click(Dialog:Persuasion()) end
        if key(e, keybind.repair) then click(Dialog:Repair()) end
        if key(e, keybind.spells) then click(Dialog:Spells()) end
        if key(e, keybind.spellmaking) then click(Dialog:Spellmaking()) end
        if key(e, keybind.training) then click(Dialog:Training()) end
        if key(e, keybind.travel) then click(Dialog:Travel()) end
    end
end

local function PersuasionKeyDown(e)
    if cfg.persuade.enable and Persuasion:get() then
        if key(e, keybind.admire) then Persuasion:trigger("Admire") end
        if key(e, keybind.intimidate) then Persuasion:trigger("Intimidate") end
        if key(e, keybind.taunt) then Persuasion:trigger("Taunt") end
        if not cfg.persuade.holdBribe then
            if key(e, keybind.bribe10) then Persuasion:trigger("Bribe10") end
            if key(e, keybind.bribe100) then Persuasion:trigger("Bribe100") end
            if key(e, keybind.bribe1000) then Persuasion:trigger("Bribe1000") end
        end
    end

    -- if cfg.embed_persuade.enable and Dialog.embed:get() then
    --     if key(e, keybind.admire) then this.button.embed_admire() end
    --     if key(e, keybind.intimidate) then this.button.embed_intimidate() end
    --     if key(e, keybind.taunt) then this.button.embed_taunt() end
    -- end
end

local function RestWaitKeyDown(e)
    if RestWait:get() then
        -- if key(e, keybind.waitDown) then RestWait:waitDown(1) end
        -- if key(e, keybind.waitUp) then RestWait:waitUp(1) end
        if key(e, keybind.wait) then RestWait:trigger_wait_rest() end
        if key(e, keybind.heal) and RestWait:HealedButton().visible then
            RestWait:HealedButton():bs_click()
        end
        if key(e, keybind.day) and cfg.wait.fullRest then RestWait:FullRest():bs_click() end
    end
end   

local function TravelKeyDown(e)
    if cfg.travel.enable and Service.Travel:get() then
        for index, _ in ipairs(Service.Travel:Destination().children) do
            if e.keyCode == tes3.scanCode[ts(index)] then Service.Travel:Hotkey(index.."TravelKey") end
        end
    end
end

local function BarterKeyDown(e)
    if Barter:get() then
        if keyDown(keybind.barterDown) then Barter:BarterDown():triggerEvent("pressed") end
        if keyDown(keybind.barterUp) then Barter:BarterUp():triggerEvent("pressed") end
        if keyDown(keybind.barterDown100) then mge.macros.haggleLess100() event.trigger("UITweaks:BarterChance") end
        if keyDown(keybind.barterUp100) then mge.macros.haggleMore100() event.trigger("UITweaks:BarterChance") end
        if key(e, keybind.offer) then Barter:Offer():triggerEvent("mouseClick") bs.click() end
    end
end

---@param e keyDownEventData
local function Keybinds(e)
    if keybind.enable then
        if cfg.take.enable then if key(e, keybind.take) then Take.Scroll() Take.Book() end end
        DialogKeyDown(e)
        PersuasionKeyDown(e)
        RestWaitKeyDown(e)
        TravelKeyDown(e)
        BarterKeyDown(e)
    end
end
event.register(tes3.event.keyDown, Keybinds, {priority = -10000})


---@param e uiActivatedEventData
local function dialogKeybind(e)
    -- if e.element == Dialog:get() then
    --     Dialog:Barter():bs_hotkey(cfg.keybind.barter)
    --     Dialog:Companion():bs_hotkey(cfg.keybind.companion)
    --     Dialog:Enchanting():bs_hotkey(cfg.keybind.enchanting)
    --     Dialog:Persuasion():bs_hotkey(cfg.keybind.persuasion)
    --     Dialog:Repair():bs_hotkey(cfg.keybind.repair)
    --     Dialog:Spells():bs_hotkey(cfg.keybind.spells)
    --     Dialog:Spellmaking():bs_hotkey(cfg.keybind.spellmaking)
    --     Dialog:Training():bs_hotkey(cfg.keybind.training)
    --     Dialog:Travel():bs_hotkey(cfg.keybind.travel)
    -- end
    
end
event.register(tes3.event.uiActivated, dialogKeybind)