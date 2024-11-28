local cfg = require("BeefStranger.UI Tweaks.config")
local id = require("BeefStranger.UI Tweaks.ID")
local bs = require("BeefStranger.UI Tweaks.common")
local Multi = require("BeefStranger.UI Tweaks.menu.MenuMulti")
local uid = id.enemyStats
---@class bsMenuMulti.EnemyStats.Functions
local this = {}

---@class bsMenuMulti.EnemyStats
local Enemy = {}
function Enemy:get() return Multi:child(uid.top) end
function Enemy:child(child) return self:get() and self:get():findChild(child) end
function Enemy:Health() return self:child(uid.health) end
function Enemy:Magicka() return self:child(uid.magicka) end
function Enemy:Fatigue() return self:child(uid.fatigue) end
function Enemy:Name() return self:child(uid.name) end

function this.create()
    if Enemy:get() then
        Enemy:get():destroy()
    end
    local top = Multi:get():createRect({ id = uid.top })
    top.visible = false
    top.flowDirection = tes3.flowDirection.topToBottom
    top.childAlignX = 0.5
    top.absolutePosAlignX = 0.50
    top.absolutePosAlignY = 0.05
    top.alpha = 0
    top:bs_autoSize(true)

    local border = top:createThinBorder({ id = uid.border })
    border:bs_autoSize(true)
    border.widthProportional = 1

    local header = border:createRect({ id = uid.header })
    header.borderAllSides = 2
    header.widthProportional = 1
    header.flowDirection = tes3.flowDirection.topToBottom
    header:bs_autoSize(true)
    header.alpha = 0.40
    header.childAlignX = 0.5

    local name = header:createLabel({ id = uid.name, text = "" })
    name.borderAllSides = 3

    local healthBG = top:createRect({ id = uid.bg })
    healthBG:bs_autoSize(true)
    healthBG.flowDirection = tes3.flowDirection.topToBottom
    healthBG.widthProportional = 1

    local health = healthBG:createFillBar({ id = uid.health })
    health.visible = false

    local magicka = healthBG:createFillBar({ id = uid.magicka })
    magicka.visible = false
    magicka.widget.fillColor = bs.rgb.magicColor

    local fatigue = healthBG:createFillBar({ id = uid.fatigue })
    fatigue.visible = false
    fatigue.widget.fillColor = bs.rgb.fatigueColor
    return top
end

local updateTimer = 0
--- @param e simulateEventData
function this.update(e)
    updateTimer = updateTimer + e.delta
    if updateTimer >= cfg.enemyBars.updateRate and Multi:get() then
        updateTimer = updateTimer - cfg.enemyBars.updateRate
        local enemyStats = Enemy:get()

        if not enemyStats then
            if cfg.enemyBars.enable then
                enemyStats = this.create()
            else
                return
            end
        end

        Enemy:Health().visible = cfg.enemyBars.health
        Enemy:Magicka().visible = cfg.enemyBars.magicka
        Enemy:Fatigue().visible = cfg.enemyBars.fatigue

        local enemy = tes3.mobilePlayer.actionData.hitTarget
        if not enemy then
            local rayCast = tes3.rayTest {
                direction = tes3.getPlayerEyeVector(),
                position = tes3.getPlayerEyePosition(),
                ignore = { tes3.player },
                maxDistance = bs.GMST(tes3.gmst.iMaxActivateDist)
            }
            if rayCast and rayCast.reference then
                local target = rayCast.reference
                if target.mobile and not target.isDead then
                    enemy = target.mobile
                end
            end
        end

        if enemy then
            ---Hide if player leaves cell
            if enemy.cell ~= tes3.player.cell then
                enemyStats.visible = false
                return
            end
            Multi:NPCHealth().visible = false
            enemyStats.visible = true
            this.displayInfo(enemy)
            enemyStats:updateLayout()
        elseif enemyStats then
            enemyStats.visible = false
        end
    end
end

event.register(tes3.event.simulate, this.update)

function this.displayInfo(mobile)
    local health = Enemy:Health()
    local magicka = Enemy:Magicka()
    local fatigue = Enemy:Fatigue()
    local name = Enemy:Name()
    if cfg.enemyBars.health then
        health.visible = true
        health.widget.max = mobile.health.base
        health.widget.current = mobile.health.current
        health.widget.showText = cfg.enemyBars.showText
    end
    if cfg.enemyBars.magicka then
        magicka.visible = true
        magicka.widget.max = mobile.magicka.base
        magicka.widget.current = mobile.magicka.current
        magicka.widget.showText = cfg.enemyBars.showText
    end
    if cfg.enemyBars.fatigue then
        fatigue.visible = true
        fatigue.widget.max = mobile.fatigue.base
        fatigue.widget.current = mobile.fatigue.current
        fatigue.widget.showText = cfg.enemyBars.showText
    end
    if cfg.enemyBars.showLevel then
        name.text = ("%s - Level: %s"):format(mobile.object.name, mobile.object.level)
    else
        name.text = mobile.object.name
    end
end

--- @param e menuEnterEventData
function this.hideOnMenuMode(e)
    local menu = Enemy:get()
    if not cfg.enemyBars.enable then
        if menu then
            menu:destroy()
        end
    end
    if menu then
        menu.visible = false
    end
end

event.register(tes3.event.menuEnter, this.hideOnMenuMode)


return Enemy
