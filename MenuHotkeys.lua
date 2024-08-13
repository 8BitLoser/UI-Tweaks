local cfg = require("BeefStranger.UI Tweaks.config")
local keybind = cfg.keybind
local dialog = cfg.dialog
local Barter = require("BeefStranger.UI Tweaks.MenuBarter")
local Dialog = require("BeefStranger.UI Tweaks.MenuDialog")
local Persuasion = require("BeefStranger.UI Tweaks.MenuPersuasion")
local RestWait = require("BeefStranger.UI Tweaks.MenuRestWait")
local id = require("BeefStranger.UI Tweaks.menuID")
local find = tes3ui.findMenu
local function key(e, cfgKey) return tes3.isKeyEqual({actual = e, expected = cfgKey}) end
local function keyCode(e, setting) return e.keyCode == setting.keyCode end
local function keyDown(keybind) return tes3.worldController.inputController:isKeyDown(keybind.keyCode) end


local Take = {}
function Take.Book()
    local book = find(tes3ui.registerID("MenuBook"))
    if book then
        book:findChild("MenuBook_button_take"):triggerEvent("mouseClick")
    end
end
function Take.Scroll()
    local scroll = find(tes3ui.registerID("MenuScroll"))
    if scroll then
        scroll:findChild("MenuBook_PickupButton"):triggerEvent("mouseClick")
    end
end

local persuadeTime = os.clock()
---@param e enterFrameEventData
local function buttonHold(e)
    if not cfg.keybind.enable then return end
    -- if not cfg.persuade.enable or not Persuasion:get() or not cfg.persuade.hold then return end
    if Barter:get() then
        if keyDown(cfg.keybind.barterUp) then
            Barter:BarterUp():triggerEvent(tes3.uiEvent.mouseStillPressed)
        elseif keyDown(cfg.keybind.barterDown) then
            Barter:BarterDown():triggerEvent(tes3.uiEvent.mouseStillPressed)
        end
    end

    if cfg.persuade.enable and Persuasion:get() and cfg.persuade.hold then
        if os.clock() - persuadeTime >= cfg.persuade.delay then
            if keyDown(cfg.keybind.admire) then Persuasion:trigger("Admire") end
            if keyDown(cfg.keybind.intimidate) then Persuasion:trigger("Intimidate") end
            if keyDown(cfg.keybind.taunt) then Persuasion:trigger("Taunt") end
            if cfg.persuade.holdBribe then
                if keyDown(cfg.keybind.bribe10) then Persuasion:trigger("Bribe10") end
                if keyDown(cfg.keybind.bribe100) then Persuasion:trigger("Bribe100") end
                if keyDown(cfg.keybind.bribe1000) then Persuasion:trigger("Bribe1000") end
            end
            persuadeTime = os.clock()
        end
    end
end
event.register(tes3.event.enterFrame, buttonHold)


--Lots of hoops to jump through to get bater +/- to work right
---Currently wanting to use Shift to + 100 is breaking with key() check, and bypassing
---lets you do increase even if you arent holding a required key, probably just gonna
---let it be, and move on, take another look later
-- local currentKey = nil
-- local keyDown = false
-- local frame = 0
-- ---@param e keyUpEventData
-- local function keyUp(e)
--     debug.log(keyCode(e, cfg.barterUp))
--     if not Barter:get() then return end
--     if e.isShiftDown then
--         if keyCode(e, cfg.barterUp) then Barter:BarterUp():triggerEvent("pressed") end
--         if keyCode(e, cfg.barterDown) then Barter:BarterDown():triggerEvent("pressed") end
--     else
--         if key(e, cfg.barterUp) then Barter:BarterUp():triggerEvent("pressed") end
--         if key(e, cfg.barterDown) then Barter:BarterDown():triggerEvent("pressed") end
--     end
--     keyDown = false
--     currentKey = nil
-- end
-- event.register(tes3.event.keyUp, keyUp, {priority = -10000})

local disableKeybind = {
    id.Barter,
    id.Enchantment,
    id.Persuasion,
    id.Repair,
    id.ServiceSpells,
    id.ServiceTraining,
    id.ServiceTravel,
    id.Spellmaking,
}



---@param element tes3uiElement
local function click(element)
    if element and Dialog:get().visible then
        Dialog.click(element)
    end
end

---@param e keyDownEventData
local function Keybinds(e)
    if keybind.enable then
        if cfg.take.enable then if key(e, keybind.take) then Take.Scroll() Take.Book() end end

        if dialog.enable and Dialog:Visible() then
            for i, value in ipairs(disableKeybind) do if tes3ui.findMenu(value) then return end end
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


        if cfg.persuade.enable and Persuasion:get() then
            -- if not cfg.persuade.hold then
                if key(e, keybind.admire) then Persuasion:trigger("Admire") end
                if key(e, keybind.intimidate) then Persuasion:trigger("Intimidate") end
                if key(e, keybind.taunt) then Persuasion:trigger("Taunt") end
                if not cfg.persuade.holdBribe then
                    if key(e, keybind.bribe10) then Persuasion:trigger("Bribe10") end
                    if key(e, keybind.bribe100) then Persuasion:trigger("Bribe100") end
                    if key(e, keybind.bribe1000) then Persuasion:trigger("Bribe1000") end
                -- end
            end
        end

        if RestWait.get() then
            if key(e, keybind.waitDown) then RestWait:waitDown() end
            if key(e, keybind.waitUp) then RestWait:waitUp() end
            if key(e, keybind.wait) then RestWait:triggerWait() end
            if key(e, keybind.heal) then RestWait:triggerHeal() end
            if key(e, keybind.day) and cfg.wait.fullRest then RestWait:press(RestWait.FullRest) end
        end

        if Barter:get() then
            if keyDown(keybind.barterDown) then Barter:BarterDown():triggerEvent("pressed") end
            if keyDown(keybind.barterUp) then Barter:BarterUp():triggerEvent("pressed") end
            if key(e, keybind.offer) then Barter:Offer():triggerEvent("mouseClick") end
        end
    end
end
event.register(tes3.event.keyDown, Keybinds, {priority = -10000})


-- local function enterFrame()
--     if keyDown and Barter:get() and currentKey then
--         frame = frame + 1
--         if frame % 2 == 0 then
--             if key(currentKey, cfg.barterUp) then Barter:BarterUp():triggerEvent("still_pressed") end
--             if key(currentKey, cfg.barterDown) then Barter:BarterDown():triggerEvent("still_pressed") end
--         end
--     else
--         frame = 0
--     end
-- end
-- event.register("enterFrame", enterFrame)