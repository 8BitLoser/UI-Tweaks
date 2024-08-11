local cfg = require("BeefStranger.UI Tweaks.config")

---@class bsMenuPersuasion
local Persuasion = {}
function Persuasion:get() return tes3ui.findMenu("MenuPersuasion") end
function Persuasion:child(child) if not self:get() then return end return self:get():findChild(child) end
function Persuasion:ServiceList() if not self:get() then return end return self:child("MenuPersuasion_ServiceList") end
function Persuasion:Admire() if not self:get() then return end return self:ServiceList().children[1].children[1] end
function Persuasion:Intimidate() if not self:get() then return end return self:ServiceList().children[2].children[1] end
function Persuasion:Taunt() if not self:get() then return end return self:ServiceList().children[3].children[1] end
function Persuasion:Bribe10() if not self:get() then return end return self:ServiceList().children[4].children[1] end
function Persuasion:Bribe100() if not self:get() then return end return self:ServiceList().children[5].children[1] end
function Persuasion:Bribe1000() if not self:get() then return end return self:ServiceList().children[6].children[1] end

--- @param name "Admire"|"Intimidate"|"Taunt"|"Bribe10"|"Bribe100"|"Bribe1000"
function Persuasion:trigger(name)
    if not self:get() then return end
    if name == "Admire" then self:Admire():triggerEvent("mouseClick") end
    if name == "Intimidate" then self:Intimidate():triggerEvent("mouseClick") end
    if name == "Taunt" then self:Taunt():triggerEvent("mouseClick") end
    if name == "Bribe10" then self:Bribe10():triggerEvent("mouseClick") end
    if name == "Bribe100" then self:Bribe100():triggerEvent("mouseClick") end
    if name == "Bribe1000" then self:Bribe1000():triggerEvent("mouseClick") end
    tes3.playSound({sound = "Menu Click"})
end

return Persuasion