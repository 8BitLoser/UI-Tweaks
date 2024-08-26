local cfg = require("BeefStranger.UI Tweaks.config")
---MenuRestWait Mapped out because it was fun
---@class bsMenuRestWait
local Rest = {}

function Rest.get() return tes3ui.findMenu(tes3ui.registerID("MenuRestWait")) end---@return tes3uiElement? MenuRestWait
function Rest:Update() if not self:get() then return end self.get():updateLayout() end
function Rest:child(child) if not self:get() then return end return self.get():findChild(child) end
function Rest:Scrollbar() if not self:get() then return end return self:child("MenuRestWait_scrollbar") end
function Rest:ScrollWidget() if not self:get() then return end return self:Scrollbar().widget end---@return tes3uiSlider?
function Rest:Buttons() if not self:get() then return end return self:child("MenuRestWait_buttonlayout" ) end
function Rest:Wait() if not self:get() then return end return self:child("MenuRestWait_wait_button") end
function Rest:Rest() if not self:get() then return end return self:child("MenuRestWait_rest_button") end
function Rest:UntilHealed() if not self:get() then return end return self:child("MenuRestWait_untilhealed_button") end
function Rest:Close() if not self:get() then return end return self:child("MenuRestWait_cancel_button") end
function Rest:press(button) if not self:get() then return end button:triggerEvent("mouseClick") tes3.playSound({sound = "Menu Click"}) end

function Rest:bsFullRest() return self:child("bsFullRest") end

function Rest:waitUp()
    if not self:ScrollWidget() then return end
    self:ScrollWidget().current = math.min((self:ScrollWidget().current + 1), 23)
    self:Scrollbar():triggerEvent("PartScrollBar_changed")
    tes3.playSound({sound = "Menu Click"})
    self:Update()
end
function Rest:waitDown()
    if not self:ScrollWidget() then return end
    self:ScrollWidget().current = math.max((self:ScrollWidget().current - 1), 0)
    self:Scrollbar():triggerEvent("PartScrollBar_changed")
    tes3.playSound({sound = "Menu Click"})
    self:Update()
end
function Rest:triggerHeal()
    if not self:get() then return end
    if self:UntilHealed().visible then
        self:press(self:UntilHealed())
    end
end
function Rest:triggerWait()
    if not self:get() then return end
    if self:Wait().visible then
        self:press(self:Wait())
    elseif self:Rest().visible then
        self:press(self:Rest())
    end
end

---@param e uiActivatedEventData
function Rest.onRestMenu(e)
    if not cfg.wait.enable or not cfg.wait.fullRest then return end
    ---Make Button Block Auto Size
    Rest:Buttons().autoWidth = true
    Rest.FullRest = Rest:Buttons():createButton { id = "bsFullRest", text = "24 Hours" }
    Rest.FullRest.borderAllSides = 0
    Rest.FullRest:register(tes3.uiEvent.mouseClick, function(e)
        ---Set Wait Time to 24 and Trigger the Event that updates bar
        Rest:ScrollWidget().current = 23
        Rest:Scrollbar():triggerEvent("PartScrollBar_changed")
        Rest:triggerWait()
        Rest:Update()
    end)
    ---Reorder Buttons so DayRest is on the Left
    Rest:Buttons():reorderChildren(0, Rest.FullRest, 1)
    Rest:Update()
end
event.register(tes3.event.uiActivated, Rest.onRestMenu, { filter = "MenuRestWait" })

return Rest
