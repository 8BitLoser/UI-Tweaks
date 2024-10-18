local id = require("BeefStranger.UI Tweaks.ID")
local find = tes3ui.findMenu
local reg = tes3ui.registerID

---@class bsMenuScroll
local Scroll = {}
function Scroll:get() return find(reg(id.Scroll)) end
function Scroll:child(child) if self:get() then return self:get():findChild(child) end end
function Scroll:Close() if self:get() then return self:child("MenuScroll_Close") end end
function Scroll:Take() if self:get() then return self:child("MenuBook_PickupButton") end end

return Scroll