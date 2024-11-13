local cfg = require("BeefStranger.UI Tweaks.config")
local bs = require("BeefStranger.UI Tweaks.common")
local id = require("BeefStranger.UI Tweaks.ID")
local prop = require("BeefStranger.UI Tweaks.property").embed
local Dialog = require("BeefStranger.UI Tweaks.menu.MenuDialog")
local Service = require("BeefStranger.UI Tweaks.menu.MenuServices")
local Persuasion = require("BeefStranger.UI Tweaks.menu.MenuPersuasion")
local reg = tes3ui.registerID

local persuade = require("BeefStranger.UI Tweaks.menu.embed.persuade")
local repair = require("BeefStranger.UI Tweaks.menu.embed.repair")
local spells = require("BeefStranger.UI Tweaks.menu.embed.spells")
local train = require("BeefStranger.UI Tweaks.menu.embed.train")
local travel = require("BeefStranger.UI Tweaks.menu.embed.travel")

---@class bs_EmbededServices
local embed = {}

local uid = id.embed ---@type bs_EmbededServices.uid

function embed:get() return Dialog:get() and Dialog:child(uid.top) end
function embed:child(child) return self:get():findChild(child) end

---@param e uiActivatedEventData
function embed.creation(e)
    local menu = Dialog:MainBlock():createBlock({id = uid.top})
    menu.autoWidth = true
    menu.childAlignX = 0.5
    menu.flowDirection = tes3.flowDirection.topToBottom
    menu.heightProportional = 1
    menu.visible = false

    local gold = menu:createLabel({id = uid.embed_gold, text = embed.goldLabel()})

    Dialog:get():registerAfter(tes3.uiEvent.preUpdate, embed.preUpdate, 100)
    Dialog:get():registerBefore(tes3.uiEvent.destroy, embed.destroy)
    Dialog:MainBlock():reorderChildren(1, menu, -1)
end

---@param e tes3uiEventData
function embed.destroy(e)
    local hours = embed:get():getPropertyInt(prop.trainHours)
    if hours > 0 then
        tes3.fadeOut({duration = 0.5})
        tes3.advanceTime({hours = hours * 2})
        tes3.fadeIn{duration = 1.5}
    end
end

---Update Visibility/PlayerGold
---@param e tes3uiEventData
function embed.preUpdate(e)
    local menu = e.source:findChild(uid.top)
    local show = false
    if menu then
        for _, child in ipairs(menu.children) do
            if child:getPropertyBool(prop.visible) then
                show = true
            end
            child:updateLayout()
        end
        menu:updateLayout()
        menu.visible = show
        menu:findChild(uid.embed_gold).text = embed.goldLabel()
    end
end

function embed.goldLabel()
    return bs.GMST(tes3.gmst.sYourGold)..": "..tes3.getPlayerGold()
end

---@param e uiActivatedEventData
local function onDialog(e)
    if cfg.embed.enable and Dialog:get() then
        if e.element == Dialog:get() then
            embed.creation(e)
        end

        if cfg.embed_persuade.enable then
            if e.element == Persuasion:get() then
                e.element:destroy()
                persuade.creation(e)
            end
        end

        if cfg.embed_repair.enable then
            if e.element == Service.Repair:get() then
                Dialog:get().visible = true
                -- e.element:destroy()
                e.element.visible = false ---Dont destroy, causes crashing
                repair.creation(e)
            end
        end

        if cfg.embed_train.enable then
            if e.element == Service.Train:get() then
                e.element:destroy()
                train.creation(e)
            end
        end

        if cfg.embed_travel.enable then
            if e.element == Service.Travel:get() then
                e.element:destroy()
                Dialog:get().visible = true
                travel.creation(e)
            end
        end

        if cfg.embed_spells.enable then
            if e.element == Service.Spells:get() then
                -- e.element:destroy()
                spells.creation(e)
            end
        end

        Dialog:get():updateLayout()
    end
end
event.register(tes3.event.uiActivated, onDialog)

return embed