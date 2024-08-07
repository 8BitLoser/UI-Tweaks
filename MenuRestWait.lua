local cfg = require("BeefStranger.UI Tweaks.config")
---MenuRestWait Mapped out because it was fun
local Menu = {}



---@return tes3uiElement? MenuRestWait
function Menu.get()
    -- debug.log(tes3ui.findMenu(tes3ui.registerID("MenuRestWait")))
    return tes3ui.find(tes3ui.registerID("MenuRestWait"))
end

function Menu:Update()
    if not self:get() then return end
    self.get():updateLayout()
end

function Menu:find(child)
    if not self:get() then return end
    return self.get():findChild(child)
end

function Menu:Scrollbar()
    if not self:get() then return end
    return self:find("MenuRestWait_scrollbar")
end

function Menu:ScrollWidget()
    if not self:get() then return end
    return self:Scrollbar().widget ---@type tes3uiSlider
end

function Menu:Buttons()
    if not self:get() then return end
    return self:find("MenuRestWait_buttonlayout" )
end

function Menu:Wait()
    if not self:get() then return end
    return self:find("MenuRestWait_wait_button")
end

function Menu:Rest()
    if not self:get() then return end
    return self:find("MenuRestWait_rest_button")
end

function Menu:UntilHealed()
    if not self:get() then return end
    return self:find("MenuRestWait_untilhealed_button")
end

function Menu:Cancel()
    if not self:get() then return end
    return self:find("MenuRestWait_cancel_button")
end

local function press(button)
    button:triggerEvent("mouseClick")
end

local function triggerWait()
    if Menu:Wait().visible then
        ---If Wait Button is visible click it
        Menu:Wait():triggerEvent(tes3.uiEvent.mouseClick)
    elseif Menu:Rest().visible then
        ---If Rest Button is visible click it
        Menu:Rest():triggerEvent(tes3.uiEvent.mouseClick)
    end
end

---@param e uiActivatedEventData
function Menu.onRestMenu(e)
    if not cfg.enableMenuWaitRest or not cfg.fullRest then return end
    ---Make Button Block Auto Size
    Menu:Buttons().autoWidth = true
    Menu.FullRest = Menu:Buttons():createButton { id = "Full Rest", text = "24 Hours" }
    Menu.FullRest.borderAllSides = 0
    Menu.FullRest:register(tes3.uiEvent.mouseClick, function(e)
        ---Set Wait Time to 24 and Trigger the Event that updates bar
        Menu:ScrollWidget().current = 23
        Menu:Scrollbar():triggerEvent("PartScrollBar_changed")
        triggerWait()
        Menu:Update()
    end)
    ---Reorder Buttons so DayRest is on the Left
    Menu:Buttons():reorderChildren(0, Menu.FullRest, 1)
    Menu:Update()
end
event.register(tes3.event.uiActivated, Menu.onRestMenu, { filter = "MenuRestWait" })

---@param e keyDownEventData
local function keyDown(e)
    if not Menu:get() or not cfg.enableMenuWaitRest then return end
    -- if e.keyCode == cfg.close.keyCode then
    --     press(Menu:Cancel())
    -- end
    if e.keyCode == cfg.wait.keyCode then
        triggerWait()
    end
    if e.keyCode == cfg.day.keyCode then
        press(Menu.FullRest)
    end
end
event.register(tes3.event.keyDown, keyDown, { priority = -9999 })
