local cfg = require("BeefStranger.UI Tweaks.config")
local bs = require("BeefStranger.UI Tweaks.common")
local id = require("BeefStranger.UI Tweaks.ID")

---@class bsMenuMagic
local Magic = {}
function Magic:get() return tes3ui.findMenu(id.Magic) end
function Magic:child(child) return self:get() and self:get():findChild(child) end
function Magic:EffectBlock() return self:child("MagicMenu_icons_list_inner") end
function Magic:EffectRow(rowNumber) return self:child("MagicMenu_t_icon_row_"..rowNumber) end
function Magic:EffectRow1() return self:child("MagicMenu_t_icon_row_1") end
function Magic:EffectRow2() return self:child("MagicMenu_t_icon_row_2") end
function Magic:EffectRow3() return self:child("MagicMenu_t_icon_row_3") end
function Magic:EnchantNameIndex(index) return self:EnchantNames().children[index] end
function Magic:EnchantNames() return self:child("MagicMenu_item_names") end
function Magic:Enchants() return self:child("MagicMenu_item_layout") end
function Magic:SpellScrollPane() return self:child("MagicMenu_spells_list") end
function Magic:getObject(index) return self:EnchantNames().children[index]:getPropertyObject("MagicMenu_object") end
function Magic:getObjectData(index) return self:EnchantNames().children[index]:getPropertyObject("MagicMenu_extra", "tes3itemData") end
function Magic:Spells() return self:child("MagicMenu_spell_names") end
function Magic:EnchantTitle() return self:child("MagicMenu_item_title").parent end
function Magic:visible() return self:get() and self:get().visible or false end
function Magic:focus() return self:get() and self:get():triggerEvent(tes3.uiEvent.focus) end


--- @param e menuEnterEventData
local function magicHighlight(e)
    if not cfg.magic.enable then return end
    if Magic:get() then
        Magic:get():registerAfter(tes3.uiEvent.preUpdate, function ()
            local lookedAt = bs.initData().lookedAt
            for i, spellLabel in ipairs(Magic:Spells().children) do
                local spell = spellLabel:getPropertyObject("MagicMenu_Spell") ---@type tes3spell
                if not lookedAt[spell.id] then
                    spellLabel.color = bs.color(cfg.magic.highlightColor)
                end
            end
            for i, enchantLabel in ipairs(Magic:EnchantNames().children) do
                local object = enchantLabel:getPropertyObject("MagicMenu_object") ---@type tes3object
                if not lookedAt[object.id] then
                    enchantLabel.color = bs.color(cfg.magic.highlightColor)
                end
            end
        end)
    end
end
event.register(tes3.event.menuEnter, magicHighlight)

--- @param e uiSpellTooltipEventData
local function markSpells(e)
    if not cfg.magic.enable then return end
    if Magic:get().visible then
        bs.initData().lookedAt[e.spell.id] = true
    end
end
event.register(tes3.event.uiSpellTooltip, markSpells)

--- @param e uiObjectTooltipEventData
local function markEnchants(e)
    if not cfg.magic.enable then return end
    if e.object.enchantment and Magic:visible() then
        bs.initData().lookedAt[e.object.id] = true
    end
end
event.register(tes3.event.uiObjectTooltip, markEnchants)




return Magic