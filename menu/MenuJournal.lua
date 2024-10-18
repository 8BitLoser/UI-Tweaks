local cfg = require("BeefStranger.UI Tweaks.config")
local id = require("BeefStranger.UI Tweaks.ID")
local find = tes3ui.findMenu
local reg = tes3ui.registerID


---@class bsMenuJournal
local Journal = {}
function Journal:get() return find(reg(id.Journal)) end
function Journal:child(child) if self:get() then return self:get():findChild(child) end end
function Journal:Close() if self:get() then return self:child("MenuBook_button_close") end end

return Journal