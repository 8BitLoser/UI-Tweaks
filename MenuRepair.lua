local cfg = require("BeefStranger.UI Tweaks.config")
local id = require("BeefStranger.UI Tweaks.menuID")
local startTime = os.clock()

---@class bsDebugRepair
local Repair = {}
function Repair:get() return tes3ui.findMenu(id.Repair) end
function Repair:Items() if not self:get() then return end return self:get():findChild("PartScrollPane_pane") end
function Repair:Close() if not self:get() then return end return self:get():findChild("MenuRepair_Okbutton") end

-- local repairTimer ---@type mwseTimer|nil?
-- ---@param e uiActivatedEventData
-- local function repair(e)
--     if not cfg.repair.enable then return end
--     for key, value in pairs(Repair:Items().children) do
--         local item = value.children[2].children[1]
--         if item.type == "image" then
--             item:register(tes3.uiEvent.mouseStillPressed, function(e)
--                 if repairTimer and repairTimer.state == timer.active then return end
--                 repairTimer = timer.start {
--                     duration = cfg.repair.duration, type = timer.real,
--                     callback = function(te)
--                         if Repair:get() and tes3.worldController.inputController:isMouseButtonDown(0) then
--                             item:triggerEvent("mouseClick")
--                         else
--                             te.timer:cancel()
--                         end
--                     end,
--                 }
--             end)
--         end
--     end
-- end

---@param e uiActivatedEventData
local function repair(e)
    if not cfg.repair.enable then return end
    for _, value in pairs(Repair:Items().children) do
        local item = value.children[2].children[1]
        if item.type == "image" then
            item:register(tes3.uiEvent.mouseStillPressed, function()
                if os.clock() - startTime >= cfg.repair.duration then
                    if Repair:get() and tes3.worldController.inputController:isMouseButtonDown(0) then
                        item:triggerEvent("mouseClick")
                        startTime = os.clock()
                    end
                end
            end)
        end
    end
end
event.register(tes3.event.uiActivated, repair, {filter = id.Repair})

return Repair