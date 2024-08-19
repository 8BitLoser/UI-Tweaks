local cfg = require("BeefStranger.UI Tweaks.config")
local bs = require("BeefStranger.UI Tweaks.common")
local sf = string.format

---@param id tes3.gmst
local function GMST(id) return tes3.findGMST(id).value end

---MenuBarter Elements Mapped Out. Just cause I wanted to
---@class bsBarterMenu
local Barter = {}
function Barter:BarterBlock() if self:Price() then return self:child("MenuBarter_Price").parent end end
function Barter:BarterDown() return self:child("MenuBarter_arrowdown") end
function Barter:BarterUp() return self:child("MenuBarter_arrowup") end
function Barter:Buttons() if self:Offer() then return self:Offer().parent.parent end end
function Barter:Close() return self:child("MenuBarter_Cancelbutton") end
function Barter:child(child) if self:get() then return self:get():findChild(child) end end
function Barter:get() return tes3ui.findMenu(tes3ui.registerID("MenuBarter")) end
function Barter:getTrader() if self:get() then return tes3ui.getServiceActor() end end---@type tes3mobileCreature|tes3mobileNPC|tes3mobilePlayer
function Barter:ItemTileBlock() if self:get() then return self:child("PartScrollPane_pane") end end
function Barter:Main() if self:get() then return self:child("PartDragMenu_main") end end
function Barter:MaxSale() return self:child("MenuBarter_Goldbutton") end
function Barter:playerOffer() return tonumber(self:child("MenuBarter_Price").children[2].text) end
function Barter:Offer() return self:child("MenuBarter_Offerbutton") end
function Barter:Price() return self:child("MenuBarter_Price") end
function Barter:Title() if self:get() then return Barter:child("PartDragMenu_title_tint") end end
function Barter:TitleText() if self:get() then return Barter:child("PartDragMenu_title") end end
function Barter:Update() if self:get() then return self:get():updateLayout() end end
function Barter:UIExpParent() if self:child("UIEXP:FiltersearchBlock") then return self:child("UIEXP:FiltersearchBlock").parent.parent end end

local merchantOffer = 0
local isBuying

---Calculate Chance of Offer being Accepted: Matching Vanilla Formula
local function barterChance()
    if merchantOffer == 0 and Barter:child("Chance") then Barter:child("Chance").text = "Chance: 0%" return end
    local fDispositionMod = GMST(tes3.gmst.fDispositionMod)
    local fBargainOfferBase = GMST(tes3.gmst.fBargainOfferBase)
    local fBargainOfferMulti = GMST(tes3.gmst.fBargainOfferMulti)
    local priceDifference
    local npc = tes3ui.getServiceActor()
    local pc = tes3.mobilePlayer
    local playerOffer = math.abs(Barter:playerOffer())

    if isBuying then priceDifference = math.floor(100 * (merchantOffer - playerOffer) / merchantOffer) end
    if not isBuying then priceDifference = math.floor(100 * (playerOffer - merchantOffer) / playerOffer) end

    local clampedDisposition = math.clamp(npc.object.disposition, 0, 100)
    local dispositionTerm = fDispositionMod * (clampedDisposition - 50)
    local pcTerm = (dispositionTerm + pc.mercantile.current + 0.1 * pc.luck.current + 0.2 * pc.personality.current) * pc:getFatigueTerm()
    local npcTerm = (npc.mercantile.current + 0.1 * npc.luck.current + 0.2 * npc.personality.current) * npc:getFatigueTerm()
    local x = fBargainOfferMulti * priceDifference + fBargainOfferBase

    if isBuying then x = x + math.abs(math.floor(pcTerm - npcTerm)) end
    if not isBuying then x = x + math.abs(math.floor(npcTerm - pcTerm)) end

    if Barter:child("Chance") then
        Barter:child("Chance").text = "Chance: ".. tostring(math.round(x, 2).."%")
    end
end

---Get merchantOffer and isBuying
--- @param e calcBarterPriceEventData
local function calcBarterPriceCallback(e)
    if not cfg.barter.showChance then return end
    timer.delayOneFrame(function ()
        if e.buying then
            isBuying = true
        end
        merchantOffer = math.abs(Barter:playerOffer()) ---calcBarter e.price only updates current item not total
        barterChance()
    end, timer.real)
end
event.register(tes3.event.calcBarterPrice, calcBarterPriceCallback, {priority = 10000})


--- @param e uiActivatedEventData
local function BarterInfo(e)
    if not cfg.barter.enable then return end
    local trader = Barter:getTrader()
    local player = tes3.mobilePlayer

    if cfg.barter.showDisposition then
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

    ---Barter Offer Success Chance
    if cfg.barter.showChance then
        local box = Barter:BarterBlock():createThinBorder({id = "chanceBlock"})
        box:createLabel{id = "Chance", text = "Chance: 0%"}
        box.positionY = 0
        box.borderLeft = 20
        box.paddingAllSides = 5
        box.autoHeight = true
        box.autoWidth = true
        Barter:Offer():registerAfter("mouseClick", barterChance)
        -- Barter:Offer():registerAfter(tes3.uiEvent.mouseStillPressed, function () Barter:Offer():triggerEvent("mouseClick") end)
        Barter:BarterUp():registerAfter(tes3.uiEvent.mouseStillPressed, barterChance)
        Barter:BarterDown():registerAfter(tes3.uiEvent.mouseStillPressed, barterChance)
        Barter:MaxSale():registerAfter("mouseClick", barterChance)
        Barter:get():registerAfter(tes3.uiEvent.destroy, function() merchantOffer = 0 isBuying = false end) ---Make sure offer gets reset
        Barter:BarterBlock():reorderChildren(2, box, -1)
        Barter:get():updateLayout()
    end

    Barter:Update()
end
event.register(tes3.event.uiActivated, BarterInfo, { filter = "MenuBarter", priority = -1000 })
event.register(bs.UpdateBarter, BarterInfo, { priority = -1000 })

return Barter