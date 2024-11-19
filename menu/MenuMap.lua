local cfg = require("BeefStranger.UI Tweaks.config")
local bs = require("BeefStranger.UI Tweaks.common")
local id = require("BeefStranger.UI Tweaks.ID")

---@class bsMenuMap
local Map = {}

function Map:get() return tes3ui.findMenu(id.Map) end
function Map:child(child) return self:get() and self:get():findChild(child) end
function Map:focus() return self:get() and self:get():triggerEvent(tes3.uiEvent.focus) end

return Map