local cfg = require("BeefStranger.UI Tweaks.config")
local RestWait = require("BeefStranger.UI Tweaks.MenuRestWait")
local Barter = require("BeefStranger.UI Tweaks.MenuBarter")
local menu = require("BeefStranger.UI Tweaks.tes3Menus")

local keyDown = false
local frame = 0


local Take = {}
function Take.Book()
    local book = tes3ui.findMenu(tes3ui.registerID("MenuBook"))
    if book then
        book:findChild("MenuBook_button_take"):triggerEvent("mouseClick")
    end
end
function Take.Scroll()
    local scroll = tes3ui.findMenu(tes3ui.registerID("MenuScroll"))
    if scroll then
        scroll:findChild("MenuBook_PickupButton"):triggerEvent("mouseClick")
    end
end

local Persuasion = {}
function Persuasion.open()
    local dialogue = tes3ui.findMenu("MenuDialog")
    if dialogue then
        dialogue:findChild("MenuDialog_persuasion"):triggerEvent(tes3.uiEvent.mouseClick)
    -- else
    --     return
    end
end

--- @param name "Admire"|"Intimidate"|"Taunt"
function Persuasion.press(name)
    local persuasion = tes3ui.findMenu("MenuPersuasion")
    if persuasion then
        local serviceList = persuasion:findChild("MenuPersuasion_ServiceList")
        for _, element in pairs(serviceList.children) do
            if element.children[1].text == name then
                return element.children[1]:triggerEvent(tes3.uiEvent.mouseClick)
            end
        end
    -- else
    --     return
    end
end

local function key(e, cfgKey) return tes3.isKeyEqual({actual = e, expected = cfgKey}) end
local function keyCode(e, setting) return e.keyCode == setting.keyCode end
local function isKeyDown(scanCode) return tes3.worldController.inputController:isKeyDown(scanCode) end

local currentKey = nil


--Lots of hoops to jump through to get bater +/- to work right
---Currently wanting to use Shift to + 100 is breaking with key() check, and bypassing
---lets you do increase even if you arent holding a required key, probably just gonna
---let it be, and move on, take another look later

---@param e keyUpEventData
local function keyUp(e)
    debug.log(keyCode(e, cfg.barterUp))
    if not Barter:get() then return end
    if e.isShiftDown then
        if keyCode(e, cfg.barterUp) then Barter:BarterUp():triggerEvent("pressed") end
        if keyCode(e, cfg.barterDown) then Barter:BarterDown():triggerEvent("pressed") end
    else
        if key(e, cfg.barterUp) then Barter:BarterUp():triggerEvent("pressed") end
        if key(e, cfg.barterDown) then Barter:BarterDown():triggerEvent("pressed") end
    end
    keyDown = false
    currentKey = nil
end
event.register(tes3.event.keyUp, keyUp, {priority = -10000})

---@param e keyDownEventData
local function Hotkey(e)
    if cfg.enableHotkeys then
        if key(e, cfg.take) then Take.Scroll() Take.Book() end

        if key(e, cfg.persuade) then Persuasion.open() end
        if key(e, cfg.admire) then Persuasion.press("Admire") end
        if key(e, cfg.intimidate) then Persuasion.press("Intimidate") end
        if key(e, cfg.taunt) then Persuasion.press("Taunt") end

        if key(e, cfg.wait) then RestWait:triggerWait() end
        if key(e, cfg.heal) then RestWait:triggerHeal() end
        if key(e, cfg.day) and cfg.fullRest then RestWait:press(RestWait.FullRest) end

        if Barter:get() then
            if keyCode(e, cfg.barterUp) or keyCode(e, cfg.barterDown) then ---Needed to allow Shift to increase 100
                if (e.isAltDown or e.isControlDown or e.isShiftDown or e.isSuperDown) then tes3ui.acquireTextInput(nil) end
                if e.keyCode == tes3.scanCode.keyDown or e.keyCode == tes3.scanCode.keyUp then tes3ui.acquireTextInput(nil) end
                keyDown = true
                currentKey = e
            end
            if key(e, cfg.offer) then Barter:Offer():triggerEvent("mouseClick") end
        end
    end
end
event.register(tes3.event.keyDown, Hotkey, {priority = -10000})


local function enterFrame()
    if keyDown and Barter:get() and currentKey then
        frame = frame + 1
        if frame % 2 == 0 then
            if key(currentKey, cfg.barterUp) then Barter:BarterUp():triggerEvent("still_pressed") end
            if key(currentKey, cfg.barterDown) then Barter:BarterDown():triggerEvent("still_pressed") end
        end
    else
        frame = 0
    end
end
event.register("enterFrame", enterFrame)