local cfg = require("BeefStranger.UI Tweaks.config")
local id = require("BeefStranger.UI Tweaks.menuID")
local bs = require("BeefStranger.UI Tweaks.common")
local sf = string.format
local keyName = tes3.getKeyName

---@class bsMenuDialog
local Dialog = {}
function Dialog:Barter() if not self:get() then return end return self:child("MenuDialog_service_barter") end
function Dialog:child(child) if not self:get() then return end return self:get():findChild(child) end
function Dialog:Close() if not self:get() then return end return self:child("MenuDialog_button_bye") end
function Dialog:Companion() if not self:get() then return end return self:child("MenuDialog_service_companion") end
function Dialog:Enchanting() if not self:get() then return end return self:child("MenuDialog_service_enchanting") end
function Dialog:get() return tes3ui.findMenu(id.Dialog) end
function Dialog:GetService() if not self:get() then return end return self:child("MenuDialog_service_spells").parent end
function Dialog:Persuasion() if not self:get() then return end return self:child("MenuDialog_persuasion") end
function Dialog:Repair() if not self:get() then return end return self:child("MenuDialog_service_repair") end
function Dialog:Spellmaking() if not self:get() then return end return self:child("MenuDialog_service_spellmaking") end
function Dialog:Spells() if not self:get() then return end return self:child("MenuDialog_service_spells") end
function Dialog:Title() if not self:get() then return end return self:child("PartDragMenu_title_tint") end
function Dialog:TitleText() if not self:get() then return end return self:child("PartDragMenu_title") end
function Dialog:Training() if not self:get() then return end return self:child("MenuDialog_service_training") end
function Dialog:Travel() if not self:get() then return end return self:child("MenuDialog_service_travel") end
function Dialog:Visible() if self:get() then return self:get().visible end end

---@param child tes3uiElement
function Dialog.click(child)
    if not Dialog:get() and not Dialog:get().visible then return end
    child:triggerEvent("mouseClick")
    bs.click()
end

---@param e uiActivatedEventData
local function showDialogKey(e)
    if not cfg.dialog.enable or not cfg.dialog.showKey or not cfg.keybind.enable then return end
    timer.delayOneFrame(function() ---text doesnt update unless you delay it
        if cfg.dialog.showKey and cfg.keybind.enable then
            if not Dialog:get() then return end
            for _, button in pairs(Dialog:GetService().children) do
                if button.visible then
                    for setting, keybind in pairs(cfg.keybind) do
                        if string.find(button.name, setting, 1, true) then
                            button.text = sf("%s (%s)", button.text, keyName(keybind.keyCode))
                        end
                    end
                end
            end
            -- Dialog:get():updateLayout()
        end
    end, timer.real)

    if cfg.dialog.showClass then
        local service = tes3ui.getServiceActor()
        if not service.object.class then return end
        local title = "|  "..service.object.class.name
        local class = Dialog:Title():createLabel({id = "bsTitle_Class", text = title})
        class.borderRight = 10

        Dialog:Title():reorderChildren(2, class, 1)
        Dialog:get():updateLayout()
    end
end
event.register(tes3.event.uiActivated, showDialogKey, {filter = id.Dialog, priority = 1000000})

return Dialog