local cfg = require("BeefStranger.UI Tweaks.config")
local id = require("BeefStranger.UI Tweaks.ID")
local find = tes3ui.findMenu
local reg = tes3ui.registerID

---@class bsTransferEnchant
local TransferEnchant = {}
function TransferEnchant:get() return find(reg("bsTransferEnchant")) end
function TransferEnchant:child(child) if self:get() then return self:get():findChild(child) end end
function TransferEnchant:Close() if self:get() then return self:child("close") end end

TransferEnchant.Select = {}
function TransferEnchant.Select:get() return find(reg("bsItemSelect")) end
function TransferEnchant.Select:child(child) if self:get() then return self:get():findChild(child) end end
function TransferEnchant.Select:Close() if self:get() then return self:child("close") end end



return TransferEnchant