local cfg = require("BeefStranger.UI Tweaks.config")
local RestWait = require("BeefStranger.UI Tweaks.MenuRestWait")
local Barter = require("BeefStranger.UI Tweaks.MenuBarter")
local Dialog = require("BeefStranger.UI Tweaks.MenuDialog")
local menu = require("BeefStranger.UI Tweaks.tes3Menus")
local find = tes3ui.findMenu


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

local Persuasion = {}
--- @param name "Admire"|"Intimidate"|"Taunt"
function Persuasion.press(name)
    local persuasion = find("MenuPersuasion")
    if persuasion then
        local serviceList = persuasion:findChild("MenuPersuasion_ServiceList")
        for _, element in pairs(serviceList.children) do
            if element.children[1].text == name then
                return element.children[1]:triggerEvent(tes3.uiEvent.mouseClick)
            end
        end
    end
end

local function key(e, cfgKey) return tes3.isKeyEqual({actual = e, expected = cfgKey}) end
local function keyCode(e, setting) return e.keyCode == setting.keyCode end
local function isKeyDown(scanCode) return tes3.worldController.inputController:isKeyDown(scanCode) end

local currentKey = nil
local keyDown = false
local frame = 0

--Lots of hoops to jump through to get bater +/- to work right
---Currently wanting to use Shift to + 100 is breaking with key() check, and bypassing
---lets you do increase even if you arent holding a required key, probably just gonna
---let it be, and move on, take another look later
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
---@param element tes3uiElement
local function click(element)
    if element and element.visible then
        Dialog.click(element)
    end
end

---@param e keyDownEventData
local function Hotkey(e)
    if cfg.enableHotkeys then
        if key(e, cfg.keybind.take) then Take.Scroll() Take.Book() end

        if cfg.enableDialog then
            if key(e, cfg.keybind.barter) then click(Dialog:Barter()) end
            if key(e, cfg.keybind.companion) then click(Dialog:Companion()) end
            if key(e, cfg.keybind.enchanting) then click(Dialog:Enchanting()) end
            if key(e, cfg.keybind.persuasion) then click(Dialog:Persuasion()) end
            if key(e, cfg.keybind.repair) then click(Dialog:Repair()) end
            if key(e, cfg.keybind.spells) then click(Dialog:Spells()) end
            if key(e, cfg.keybind.spellmaking) then click(Dialog:Spellmaking()) end
            if key(e, cfg.keybind.training) then click(Dialog:Training()) end
            if key(e, cfg.keybind.travel) then click(Dialog:Travel()) end
            if key(e, cfg.keybind.admire) then Persuasion.press("Admire") end
            if key(e, cfg.keybind.intimidate) then Persuasion.press("Intimidate") end
            if key(e, cfg.keybind.taunt) then Persuasion.press("Taunt") end
        end

        if key(e, cfg.keybind.wait) then RestWait:triggerWait() end
        if key(e, cfg.keybind.heal) then RestWait:triggerHeal() end
        if key(e, cfg.keybind.day) and cfg.fullRest then RestWait:press(RestWait.FullRest) end

        if Barter:get() then
            -- if keyCode(e, cfg.barterUp) or keyCode(e, cfg.barterDown) then ---Needed to allow Shift to increase 100
            --     if (e.isAltDown or e.isControlDown or e.isShiftDown or e.isSuperDown) then tes3ui.acquireTextInput(nil) end
            --     if e.keyCode == tes3.scanCode.keyDown or e.keyCode == tes3.scanCode.keyUp then tes3ui.acquireTextInput(nil) end
            --     keyDown = true
            --     currentKey = e
            -- end
            if key(e, cfg.keybind.offer) then Barter:Offer():triggerEvent("mouseClick") end
        end
    end
end
event.register(tes3.event.keyDown, Hotkey, {priority = -10000})


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