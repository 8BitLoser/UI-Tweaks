local cfg = require("BeefStranger.UI Tweaks.config")
local bs = require("BeefStranger.UI Tweaks.common")
local Inventory = require("BeefStranger.UI Tweaks.MenuInventory")
local id = require("BeefStranger.UI Tweaks.menuID")
local sf = string.format
local data


---@param id tes3.gmst
local function GMST(id) return tes3.findGMST(id).value end

---MenuBarter Elements Mapped Out. Just cause I wanted to
---@class bsBarterMenu
local Barter = {}
function Barter:BarterBlock() return self:child("MenuBarter_Price").parent end
function Barter:BarterDown() return self:child("MenuBarter_arrowdown") end
function Barter:BarterUp() return self:child("MenuBarter_arrowup") end
function Barter:Buttons() return self:Offer().parent.parent end
function Barter:child(child) if self:get() then return self:get():findChild(child) end end
function Barter:Close() return self:child("MenuBarter_Cancelbutton") end
function Barter:CostSold() return self:Price().children[1].text end
function Barter:get() return tes3ui.findMenu(tes3ui.registerID("MenuBarter")) end
function Barter:getTrader() return tes3ui.getServiceActor() end---@return tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
function Barter:isBuying() return string.find(self:CostSold(), "COST") ~= nil end
function Barter:ItemTileBlock() return self:child("PartScrollPane_pane") end
function Barter:Main() return self:child("PartDragMenu_main") end 
function Barter:MaxSale() return self:child("MenuBarter_Goldbutton") end
function Barter:Offer() return self:child("MenuBarter_Offerbutton") end
function Barter:displayedOffer() return tonumber(self:Price().children[2].text) end
function Barter:Price() return self:child("MenuBarter_Price") end
function Barter:Title() return self:child("PartDragMenu_title_tint") end
function Barter:TitleText() return self:child("PartDragMenu_title") end 
function Barter:UIExpParent() if self:child("UIEXP:FiltersearchBlock") then return self:child("UIEXP:FiltersearchBlock").parent.parent end end
function Barter:Update() if self:get() then return self:get():updateLayout() end end ---Update TopLevelMenu
local merchantOffer = 0
local isBuying ---Needs to be true if the Player is buying anything, irregardless of also selling things

---Calculate Chance of Offer being Accepted: Matching Vanilla Formula
local function barterChance()
    if merchantOffer == 0 and Barter.ChanceValue then Barter.ChanceValue.text = "" return end
    local priceDifference
    local npc = tes3ui.getServiceActor()

    local pc = tes3.mobilePlayer
    local playerOffer = math.abs(Barter:displayedOffer())
    local fDispositionMod = GMST(tes3.gmst.fDispositionMod)
    local fBargainOfferBase = GMST(tes3.gmst.fBargainOfferBase)
    local fBargainOfferMulti = GMST(tes3.gmst.fBargainOfferMulti)
    ---Handles requesting gold when player is buying
    if isBuying and not Barter:isBuying() then playerOffer = -playerOffer end

    ---If Merchant is a Creature
    if npc.objectType == tes3.objectType.mobileCreature then
        Barter.ChanceText.text = "Creatures Don't Haggle."
        Barter.ChanceValue.text = ""
        if playerOffer ~= merchantOffer then
            Barter.ChanceText.color = bs.rgb.bsNiceRed
        else
            Barter.ChanceText.color = bs.rgb.bsPrettyBlue
        end
        return
    end

    if isBuying then priceDifference = math.floor(100 * (merchantOffer - playerOffer) / merchantOffer) end
    if not isBuying then priceDifference = math.floor(100 * (playerOffer - merchantOffer) / playerOffer) end

    local clampedDisposition = math.clamp(npc.object.disposition, 0, 100)
    local dispositionTerm = fDispositionMod * (clampedDisposition - 50)
    local pcTerm = (dispositionTerm + pc.mercantile.current + 0.1 * pc.luck.current + 0.2 * pc.personality.current) * pc:getFatigueTerm()
    local npcTerm = (npc.mercantile.current + 0.1 * npc.luck.current + 0.2 * npc.personality.current) * npc:getFatigueTerm()
    local x = fBargainOfferMulti * priceDifference + fBargainOfferBase

    if isBuying then x = x + math.abs(math.floor(pcTerm - npcTerm)) end
    if not isBuying then x = x + math.abs(math.floor(npcTerm - pcTerm)) end

    if not isBuying and Barter:isBuying() then ---If selling, but offering Drakes
        Barter.ChanceText.text = "Gifting"
        Barter.ChanceValue.text = ""
        if cfg.barter.chanceColor then Barter.ChanceText.color = bs.rgb.bsPrettyBlue end
    else
        Barter.ChanceText.text = "Chance:"
        Barter.ChanceValue.text = tostring(math.floor(x).."%")
        local factor = math.min(math.max(x / 100, 0), 1) ---ChatGPT did math/interpolation for me
        local interpolatedColor = bs.interpolateRGB(bs.rgb.bsNiceRed, bs.rgb.bsPrettyGreen, factor)
        if cfg.barter.chanceColor then
            Barter.ChanceText.color = bs.rgb.normalColor
            Barter.ChanceValue.color = interpolatedColor
        end
    end
end

---Get merchantOffer and isBuying
--- @param e calcBarterPriceEventData
local function calcBarterPriceCallback(e)
    if not cfg.barter.showChance then return end
    timer.delayOneFrame(function () ---Needs to be delayed, dont remember why
        isBuying = Barter:isBuying() ---Get isBuying from Cost/Sold Text
        merchantOffer = math.abs(Barter:displayedOffer()) ---calcBarter e.price only updates current item not total
        barterChance()
    end, timer.real)
end

---Show Player/NPC Stats in MenuBarter
function Barter.showStats()
    local trader = Barter:getTrader()
    local player = tes3.mobilePlayer
    debug.log(trader.objectType)
    if trader.objectType == tes3.objectType.mobileCreature then return end
    if cfg.barter.showDisposition and trader.object.disposition then
        ---Update Disposition Real Time
        local function updateDisp() Barter:child("bsTitle_Disp").text = ": "..trader.object.disposition end
        local bsDisp = Barter:Title():createLabel{id = "bsTitle_Disp", text = ": "..trader.object.disposition}
        Barter:TitleText().borderRight = 0
        bsDisp.borderRight = 10
        Barter:Title():reorderChildren(2, bsDisp, 1)
        Barter:Offer():registerAfter("mouseClick", updateDisp)
        Barter:Update()
        updateDisp()
    end

    if cfg.barter.showNpcStats then
        if not Barter:child("NpcStat") then
            local NpcStat = Barter:Main():createBlock({ id = "NpcStat" })
            NpcStat.autoHeight = true
            NpcStat.childAlignX = 0.5
            NpcStat.widthProportional = 1
            NpcStat:createLabel({ id = "bsNPC_Mercantile", text = sf("Mercantile: %s", trader.mercantile.current) })
            local divider = NpcStat:createImage({ id = "bsNPC_Divider", path = "Textures\\menu_head_block_left.dds" })
            divider.borderRight = 10
            divider.borderLeft = 10
            NpcStat:createLabel({ id = "bsNPC_Personality", text = sf("Personality: %s", trader.personality.current) })
            Barter:Main():reorderChildren(0, NpcStat, -1)
            Barter:Update()
        end
    end
    if cfg.barter.showPlayerStats then
        if not Barter:child("PlayerStat") then
            local PlayerStat = Barter:Buttons():createBlock { id = "PlayerStat" }
            PlayerStat.height = 25
            PlayerStat.autoWidth = true
            PlayerStat.absolutePosAlignX = 0.5
            PlayerStat.absolutePosAlignY = 0.5

            PlayerStat:createLabel { id = "bsPlayer_Mercantile", text = "Mercantile: " .. player.mercantile.current }
            local divider = PlayerStat:createImage({ id = "bsPlayer_Divider", path = "Textures\\menu_head_block_left.dds" })
            divider.borderRight = 10
            divider.borderLeft = 10
            PlayerStat:createLabel({ id = "bsPlayer_Personality", text = sf("Personality: %s", player.personality.current) })
            Barter:Buttons():reorderChildren(1, PlayerStat, -1)
            Barter:Update()
        end
    end
end

---Show % Chance of Successful Barter
function Barter.showBarterChance()
    ---Barter Offer Success Chance
    if cfg.barter.showChance then
        Barter.ChanceBlock = Barter:BarterBlock():createThinBorder({id = "bsChanceBlock"})
            Barter.ChanceBlock.positionY = 0
            Barter.ChanceBlock.borderLeft = 20
            Barter.ChanceBlock.paddingAllSides = 5
            Barter.ChanceBlock.autoHeight = true
            Barter.ChanceBlock.autoWidth = true
        Barter.ChanceText = Barter.ChanceBlock:createLabel{id = "Chance", text = "Chance:"}
        Barter.ChanceValue = Barter.ChanceBlock:createLabel{id = "ChanceValue", text = ""}
            Barter.ChanceValue.borderLeft = 5
        Barter:Offer():registerAfter("mouseClick", barterChance)
        Barter:BarterUp():registerAfter(tes3.uiEvent.mouseStillPressed, barterChance)
        Barter:BarterDown():registerAfter(tes3.uiEvent.mouseStillPressed, barterChance)
        Barter:MaxSale():registerAfter("mouseClick", barterChance)
        Barter:get():registerAfter(tes3.uiEvent.destroy, function() merchantOffer = 0 isBuying = false end) ---Make sure offer gets reset
        Barter:BarterBlock():reorderChildren(2, Barter.ChanceBlock, -1)

        if Barter:getTrader().objectType == tes3.objectType.mobileCreature then
            Barter.ChanceText.text = "Creatures Don't Haggle."
            Barter.ChanceValue.text = ""
            Barter.ChanceText.color = bs.rgb.bsNiceRed
            return
        end
        Barter:get():updateLayout()
    end
end


function Barter.sellJunk()
    if not cfg.barter.enableJunk then return end
    Barter.SellJunk = Barter:Buttons():createButton{id = "bsJunkButton", text = "Sell Junk"}
    Barter.SellJunk:register("mouseClick", function (e)
        local cycle = 0
        while Inventory:child("bsJunkMarker") and cycle < cfg.barter.maxSell do
            cycle = cycle + 1
            Inventory:child("bsJunkMarker").parent:triggerEvent("click")
        end
    end)
    Barter:Buttons():reorderChildren(2, Barter.SellJunk, -1)
end

--- @param e itemTileUpdatedEventData
local function markJunk(e)
    if not cfg.barter.enableJunk then return end
    data = tes3.player.data
    data.bsJunk = data.bsJunk or {}
    if data.bsJunk[e.item.id] then
        e.element.contentPath = "Textures\\menu_icon_select_magic.tga"
        e.element:createBlock{id = "bsJunkMarker"}
    end
    e.element:registerBefore("mouseClick", function (ui)
        if bs.isKeyDown(tes3.scanCode.lAlt) then
            if data.bsJunk[e.item.id] then
                data.bsJunk[e.item.id] = nil
                e.element.contentPath = "Textures\\menu_icon_none.tga"
            else
                data.bsJunk[e.item.id] = true
                debug.log(e.element.contentPath)
                e.element.contentPath = "Textures\\menu_icon_select_magic.tga"
            end
            e.element:getTopLevelMenu():updateLayout()
            tes3ui.forcePlayerInventoryUpdate()
            return false
        end
    end)
end

--- @param e uiObjectTooltipEventData
local function junkTooltip(e)
    if not cfg.barter.enableJunk then return end
    if data.bsJunk[e.object] then
        local junk = e.tooltip:createBlock{id = "bsJunk"}
        junk:autoSize(true)
        local label = junk:createLabel{id = "JunkLabel", text = "Junk"}
        label.color = bs.rgb.bsRoyalPurple
    end
end

--- @param e uiActivatedEventData
local function BarterActivated(e)
    if not cfg.barter.enable then return end
    Barter.showStats()
    Barter.showBarterChance()
    Barter.sellJunk()
    Barter:Update()
end


-- --- @param e loadedEventData
-- local function loadedCallback(e)
--     data = tes3.player.data
--     data.bsJunk = data.bsJunk or {}
-- end
-- event.register(tes3.event.loaded, loadedCallback)

event.register(tes3.event.uiActivated, BarterActivated, { filter = "MenuBarter", priority = -1000 })
event.register(tes3.event.calcBarterPrice, calcBarterPriceCallback, {priority = 10000})
event.register(bs.UpdateBarter, BarterActivated, { priority = -1000 })
event.register(tes3.event.uiObjectTooltip, junkTooltip)
event.register(tes3.event.itemTileUpdated, markJunk, { filter = id.Inventory})

return Barter