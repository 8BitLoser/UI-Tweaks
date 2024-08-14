local cfg = require("BeefStranger.UI Tweaks.config")
local id = require("BeefStranger.UI Tweaks.menuID")
local find = tes3ui.findMenu
local reg = tes3ui.registerID

---@class bsMenuBook
local Book = {}
function Book:get() return find(reg(id.Book)) end
function Book:child(child) if self:get() then return self:get():findChild(child) end end
function Book:Close() if self:get() then return self:child("MenuBook_button_close") end end
function Book:Take() if self:get() then return self:child("MenuBook_button_take") end end


return Book