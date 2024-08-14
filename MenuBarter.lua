local cfg = require("BeefStranger.UI Tweaks.config")
local bs = require("BeefStranger.UI Tweaks.common")
local sf = string.format
---MenuBarter Elements Mapped Out. Just cause I wanted to
---@class bsBarterMenu
local Barter = {}
function Barter:get() return tes3ui.findMenu(tes3ui.registerID("MenuBarter")) end
function Barter:find(name) if self:get() then return self:get():findChild(name) end end
function Barter:Main() if self:get() then return self:find("PartDragMenu_main") end end
function Barter:Title() if self:get() then return Barter:find("PartDragMenu_title") end end
function Barter:ItemTileBlock() if self:get() then return self:find("PartScrollPane_pane") end end
function Barter:UIExpParent() if self:find("UIEXP:FiltersearchBlock") then return self:find("UIEXP:FiltersearchBlock").parent.parent end end
function Barter:BarterBlock() if self:Price() then return self:find("MenuBarter_Price").parent end end
function Barter:Price() return self:find("MenuBarter_Price") end
function Barter:BarterUp() return self:find("MenuBarter_arrowup") end
function Barter:BarterDown() return self:find("MenuBarter_arrowdown") end
function Barter:Buttons() if self:Offer() then return self:Offer().parent.parent end end
function Barter:MaxSale() return self:find("MenuBarter_Goldbutton") end
function Barter:Offer() return self:find("MenuBarter_Offerbutton") end
function Barter:Close() return self:find("MenuBarter_Cancelbutton") end
function Barter:getTrader() if self:get() then return tes3ui.getServiceActor() end end---@type tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer

--- @param e uiActivatedEventData
local function BarterInfo(e)
    if not Barter:get() or not cfg.barter.enable then return end
    local trader = Barter:getTrader()

    if cfg.barter.showDisposition then
        Barter:Title().text = sf("%s: %s", trader.object.name, trader.object.disposition)
    else ---Whole mods breaks without this line
        Barter:Title().text = trader.object.name
    end

    if cfg.barter.showNpcStats then
        if not Barter:find("NpcStat") then
            local npcText = sf("Mercantile: %s | Personality: %s", trader.mercantile.current, trader.personality.current)
            NpcStat = Barter:Main():createLabel({ id = "NpcStat", text = npcText })
            NpcStat.wrapText = true
            NpcStat.justifyText = tes3.justifyText.center
            Barter:Main():reorderChildren(0, NpcStat, 1)
        end
    elseif Barter:find("NpcStat") then ---Destroy Element if Disabled in MCM
        Barter:find("NpcStat"):destroy()
    end
    if cfg.barter.showPlayerStats then
        if not Barter:find("PlayerStat") then
            local playerText = sf("Mercantile: %s | Personality: %s", tes3.mobilePlayer.mercantile.current, tes3.mobilePlayer.personality.current)
            PlayerStat = Barter:Buttons():createLabel({ id = "PlayerStat", text = playerText })
            PlayerStat.absolutePosAlignX = 0.5
            PlayerStat.absolutePosAlignY = 0.5
            Barter:Buttons():reorderChildren(1, PlayerStat, 1)
        end
    elseif Barter:find("PlayerStat") then
        Barter:find("PlayerStat"):destroy()
    end
    Barter:get():updateLayout()
end
event.register(tes3.event.uiActivated, BarterInfo, { filter = "MenuBarter", priority = -1000 })
event.register(bs.UpdateBarter, BarterInfo, { priority = -1000 })

return Barter