local cfg = require("BeefStranger.UI Tweaks.config")
local bs = require("BeefStranger.UI Tweaks.common")
local sf = string.format
---MenuBarter Elements Mapped Out. Just cause I wanted to
local Menu = {}

---Find Child of MenuBarter
function Menu:find(name)
    if self.get() then
        return self.get():findChild(name)
    end
end
---MenuBarter Menu
function Menu.get()
    return tes3ui.findMenu(tes3ui.registerID("MenuBarter"))
end
---Where MenuBarter Shunts Children `PartDragMenu_main`
function Menu:Main()
    if self.get() then
        return self:find("PartDragMenu_main")
    end
end
---Title Element
function Menu:Title()
    if self.get() then
        return Menu:find("PartDragMenu_title")
    end
end
---Merchant Inventory Block
function Menu:ItemTileBlock()
    if self.get() then
        return self:find("PartScrollPane_pane")
    end
end
---null parent of UIEXP Filter elements
function Menu:UIExpParent()
    if self:find("UIEXP:FiltersearchBlock") then
        return self:find("UIEXP:FiltersearchBlock").parent.parent
    end
end
---Parent of Haggle/Cost
function Menu:BarterBlock()
    if self:Price() then
        return self:find("MenuBarter_Price").parent
    end
end
---Cost Block
function Menu:Price()
    return self:find("MenuBarter_Price")
end
---Haggle + Button
function Menu:BarterUp()
    return self:find("MenuBarter_arrowup")
end
---Haggle - Button
function Menu:BarterDown()
    return self:find("MenuBarter_arrowdown")
end
---Parent of Offer/Cancel/Max Sale
function Menu:Buttons()
    if self:Offer() then
        return self:Offer().parent.parent
    end
end
---MaxSale Button
function Menu:MaxSale()
    return self:find("MenuBarter_Goldbutton")
end
---Offer Button
function Menu:Offer()
    return self:find("MenuBarter_Offerbutton")
end
---Cancel Button
function Menu:Cancel()
    return self:find("MenuBarter_Cancelbutton")
end
---Get NPC Mobile MenuBarter is Associated with
function Menu:getTrader()
    if self:get() then
        return tes3ui.getServiceActor() ---@type tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
    end
end

--- @param e uiActivatedEventData
local function BarterInfo(e)
    if not Menu:get() or not cfg.enableMenuBarter then return end
    local trader = Menu:getTrader()

    if cfg.showDisposition then
        Menu:Title().text = sf("%s: %s", trader.object.name, trader.object.disposition)
    else ---Whole mods breaks without this line
        Menu:Title().text = trader.object.name
    end

    if cfg.showNpcStats then
        if not Menu:find("NpcStat") then
            local npcText = sf("Mercantile: %s | Personality: %s", trader.mercantile.current, trader.personality.current)
            NpcStat = Menu:Main():createLabel({ id = "NpcStat", text = npcText })
            NpcStat.wrapText = true
            NpcStat.justifyText = tes3.justifyText.center
            Menu:Main():reorderChildren(0, NpcStat, 1)
        end
    elseif Menu:find("NpcStat") then ---Destroy Element if Disabled in MCM
        Menu:find("NpcStat"):destroy()
    end

    if cfg.showPlayerStats then
        if not Menu:find("PlayerStat") then
            local playerText = sf("Mercantile: %s | Personality: %s", tes3.mobilePlayer.mercantile.current,
                tes3.mobilePlayer.personality.current)
            PlayerStat = Menu:Buttons():createLabel({ id = "PlayerStat", text = playerText })
            PlayerStat.absolutePosAlignX = 0.5
            PlayerStat.absolutePosAlignY = 0.5
            Menu:Buttons():reorderChildren(1, PlayerStat, 1)
        end
    elseif Menu:find("PlayerStat") then
        Menu:find("PlayerStat"):destroy()
    end
    Menu:get():updateLayout()
end
event.register(tes3.event.uiActivated, BarterInfo, { filter = "MenuBarter", priority = -1000 })
event.register(bs.UpdateBarter, BarterInfo, { priority = -1000 })

return Menu