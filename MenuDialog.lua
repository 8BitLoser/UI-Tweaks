local cfg = require("BeefStranger.UI Tweaks.config")
local id = require("BeefStranger.UI Tweaks.tes3Menus")
local sf = string.format
local keyName = tes3.getKeyName

---@class bsMenuDialog
local Menu = {}
function Menu:Barter() if not self:get() then return end return self:child("MenuDialog_service_barter") end
function Menu:Bye() if not self:get() then return end return self:child("MenuDialog_button_bye") end
function Menu:child(child) if not self:get() then return end return self.get():findChild(child) end
function Menu:Companion() if not self:get() then return end return self:child("MenuDialog_service_companion") end
function Menu:Enchanting() if not self:get() then return end return self:child("MenuDialog_service_enchanting") end
function Menu:GetService() if not self:get() then return end return self:child("MenuDialog_service_spells").parent end
function Menu:Persuasion() if not self:get() then return end return self:child("MenuDialog_persuasion") end
function Menu:Repair() if not self:get() then return end return self:child("MenuDialog_service_repair") end
function Menu:Spellmaking() if not self:get() then return end return self:child("MenuDialog_service_spellmaking") end
function Menu:Spells() if not self:get() then return end return self:child("MenuDialog_service_spells") end
function Menu:Training() if not self:get() then return end return self:child("MenuDialog_service_training") end
function Menu:Travel() if not self:get() then return end return self:child("MenuDialog_service_travel") end
function Menu.get() return tes3ui.findMenu(id.Dialog) end

---@param child tes3uiElement
function Menu.click(child)
    if not Menu.get() then return end
    child:triggerEvent("mouseClick")
end


---@param e uiActivatedEventData
local function showDialogKey(e)
    if not cfg.showDialogKey then return end
    timer.delayOneFrame(function ()
        if not Menu.get() then return end
        for _, button in pairs(Menu:GetService().children) do
            if button.visible then
                for setting, keybind in pairs(cfg.keybind) do
                    if string.find(button.name , setting, 1, true) then
                        button.text = sf("%s (%s)", button.text, keyName(keybind.keyCode))
                    end
                end
            end
        end
    end, timer.real)
end


event.register(tes3.event.uiActivated, showDialogKey, {filter = id.Dialog})

return Menu