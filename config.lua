local bs = require("BeefStranger.UI Tweaks.common")
local configPath = "UI Tweaks"
---@class bsDEBUGUITweaksMCM
local cfg = {}

---@class bsUITweaks.cfg<K, V>: { [K]: V }
local defaults = {
    barter = {
        enable = true,
        chanceColor = true,
        hold = true,
        showChance = false,
        showDisposition = true,
        showNpcStats = false,
        showPlayerStats = false,
        enableJunk = true,
        maxSell = 30,
    },
    contents = { enable = true, totalValue = false, showOwner = false },
    dialog = { enable = true, showKey = false, showClass = false },
    effects = { enable = false, menuModeAlpha = 0.5, updateRate = 0.2, borderMode = 3, durationThreshold = 2, pinnedAlpha = 0 },
    enchant = { enable = true, showGold = true },

    ---@class bsUITweaks.cfg.gear
    enchantedGear = {enable = true, highlightNew = true, hideVanilla = true, showVanillaOnHide = true, matchMagicVis = true},

    ---@class bsUITweaks.cfg.embed<K, V>: { [K]: V }
    embed = { enable = false, notify = true, }, 
    ---@class bsUITweaks.cfg.embed.persuade<K, V>: { [K]: V }
    embed_persuade = { enable = true, instantFight = false, hold = true, holdBribe = false },
    ---@class bsUITweaks.cfg.embed.repair<K, V>: { [K]: V }
    embed_repair = { enable = true },
    ---@class bsUITweaks.cfg.embed.spells<K, V>: { [K]: V }
    embed_spells = { enable = true },
    ---@class bsUITweaks.cfg.embed.train<K, V>: { [K]: V }
    embed_train = { enable = true },
    ---@class bsUITweaks.cfg.embed.travel<K, V>: { [K]: V }
    embed_travel = { enable = true, keybind = true },

    ---@class bsUITweaks.cfg.enemyBars<K, V>: { [K]: V }
    enemyBars = {enable = false, health = true, magicka = true, fatigue = true, showLevel = true, showText = true, updateRate = 0.01},

    escape = {
        enable = true,
        keybind = tes3.keybind.menuMode,
        blacklist = {
            MenuName = true,
            MenuRaceSex = true,
            MenuCreateClass = true,
            MenuBirthSign = true,
            MenuStatReview = true,
            MenuSetValues = true,
        },
        menus = {
            bsItemSelect = true,
            bsTransferEnchant = true, MenuAlchemy = true,
            MenuBarter = true, MenuBook = true, MenuDialog = true,
            MenuEnchantment = true, MenuInventory = true, MenuInventorySelect = true,
            MenuJournal = true, MenuLoad = true, MenuPersuasion = true, MenuPrefs = true,
            MenuRepair = true, MenuRestWait = true, MenuSave = true,
            MenuScroll = true, MenuServiceRepair = true, MenuServiceSpells = true,
            MenuServiceTraining = true, MenuServiceTravel = true, MenuSpellmaking = true,
        },
    },
    hitChance = {enable = true, updateRate = 0.25, posX = 0.35, posY = 0.65, color = bs.colorTable(bs.rgb.blackColor, 0.8)},
    inv = {enable = true, potionHighlight = true},
    -- junk = {enable = true, maxSell = 20},
    magic = {enable = true, highlightNew = true, highlightColor = bs.colorTable(bs.rgb.bsPrettyGreen, 1)},
    multi = { enable = true, },
    persuade = { enable = true, hold = false, holdBribe = false, delay = 0.5, showKey = false },
    repair = { enable = true, interval = 0.1, select = true, hold = true },
    spellBarter = {enable = true, showCantCast = true},
    spellmaking = { enable = true, showGold = true, serviceOnly = true },
    tooltip = { enable = true, charge = true, showDur = true, junk = false, durationDigits = 0, totalWeight = true, totalValue = true },
    travel = { enable = true, showKey = true },
    wait = { enable = true, fullRest = true, },
    keybind = { ---@class bsUITweaks.cfg.keybind
        enable = true,
        ---Dialogue---
        barter = { keyCode = tes3.scanCode.b, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        companion = { keyCode = tes3.scanCode.c, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        enchanting = { keyCode = tes3.scanCode.e, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        persuasion = { keyCode = tes3.scanCode.p, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        repair = { keyCode = tes3.scanCode.r, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        spellmaking = { keyCode = tes3.scanCode.v, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        spells = { keyCode = tes3.scanCode.s, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        training = { keyCode = tes3.scanCode.y, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        travel = { keyCode = tes3.scanCode.t, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        ---Persuasion---
        admire = { keyCode = tes3.scanCode.a, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        intimidate = { keyCode = tes3.scanCode.i, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        taunt = { keyCode = tes3.scanCode.t, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        bribe10 = { keyCode = tes3.scanCode.numpad1, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        bribe100 = { keyCode = tes3.scanCode.numpad2, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        bribe1000 = { keyCode = tes3.scanCode.numpad3, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        ---Wait/Rest---
        day = { keyCode = tes3.scanCode.f, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        heal = { keyCode = tes3.scanCode.h, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        wait = { keyCode = tes3.scanCode.w, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        waitDown = { keyCode = tes3.scanCode.a, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        waitUp = { keyCode = tes3.scanCode.d, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        ---Barter---
        barterDown = { keyCode = tes3.scanCode.keyDown, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        barterUp = { keyCode = tes3.scanCode.keyUp, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        barterUp100 = { keyCode = tes3.scanCode.keyRight, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        barterDown100 = { keyCode = tes3.scanCode.keyLeft, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        offer = { keyCode = tes3.scanCode.enter, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
        markJunk = { keyCode = tes3.scanCode.lAlt, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},


        take = { keyCode = tes3.scanCode.e, isShiftDown = false, isAltDown = false, isControlDown = false, configPath = configPath},
    },
    ---@class bsUITweaks.cfg.quickLoot<K, V>: { [K]: V }
    quickLoot = {enable = false, posX = 155, showCount = 8 },
    take = { enable = true },

    debug = {logLevel = "NONE"}
}
local function updateBarter() event.trigger(bs.UpdateBarter) end

---@class bsUITweaks.cfg
local config = mwse.loadConfig(configPath, defaults)

local templates = {}

local function registerModConfig()
---==========================================================Main=============================================================================
templates.main = mwse.mcm.createTemplate({ name = configPath, defaultConfig = defaults, config = config })
templates.main:saveOnClose(configPath, config)

local text = require("BeefStranger.UI Tweaks.i18n.eng")

local settings = templates.main:createPage({ label = "UI Tweaks Features"})
-- local DEBUG = settings:createButton{buttonText = "Reload", label ="[DEBUG]Reload Files BEE"}
-- DEBUG.callback = function (self) event.trigger("UITweaksReloadFile") end
-- cfg.settings:createYesNoButton { label = "Enable HUD Tweaks", configKey = "enable", config = config.multi}

-- for key, value in pairs(defaults) do
--     if value.enable or value.enable == false then
--         debug.log(key)
--         debug.log(bs.i18n("mcm."..key..".enable"))
--     end
-- end

settings:createYesNoButton { label = bs.tl("mcm.barter.enable"), configKey = "enable", callback = updateBarter, config = config.barter }
settings:createYesNoButton { label = bs.tl("mcm.contents.enable"), configKey = "enable", config = config.contents }
settings:createYesNoButton { label = bs.tl("mcm.dialog.enable"), configKey = "enable", config = config.dialog }
settings:createYesNoButton { label = bs.tl("mcm.effects.enable"), configKey = "enable", config = config.effects }
settings:createYesNoButton { label = bs.tl("mcm.enchant.enable"), configKey = "enable", config = config.enchant }
settings:createYesNoButton { label = bs.tl("mcm.enchantedGear.enable"), configKey = "enable", config = config.enchantedGear }
settings:createYesNoButton { label = bs.tl("mcm.embed.enable"), configKey = "enable", config = config.embed }
settings:createYesNoButton { label = bs.tl("mcm.enemyBars.enable"), configKey = "enable", config = config.enemyBars }
settings:createYesNoButton { label = bs.tl("mcm.hitChance.enable"), configKey = "enable", config = config.hitChance }
settings:createYesNoButton { label = bs.tl("mcm.keybind.enable"), configKey = "enable", config = config.keybind }
settings:createYesNoButton { label = bs.tl("mcm.persuade.enable"), configKey = "enable", config = config.persuade }
settings:createYesNoButton { label = bs.tl("mcm.magic.enable"), configKey = "enable", config = config.magic }
settings:createYesNoButton { label = bs.tl("mcm.escape.enable"), configKey = "enable", config = config.escape }
settings:createYesNoButton { label = bs.tl("mcm.take.enable"), configKey = "enable", config = config.take }
settings:createYesNoButton { label = bs.tl("mcm.repair.enable"), configKey = "enable", config = config.repair }
settings:createYesNoButton { label = bs.tl("mcm.spellBarter.enable"), configKey = "enable", config = config.spellBarter }
settings:createYesNoButton { label = bs.tl("mcm.spellmaking.enable"), configKey = "enable", config = config.spellmaking }
settings:createYesNoButton { label = bs.tl("mcm.tooltip.enable"), configKey = "enable", config = config.tooltip }
settings:createYesNoButton { label = bs.tl("mcm.travel.enable"), configKey = "enable", config = config.travel }
settings:createYesNoButton { label = bs.tl("mcm.wait.enable"), configKey = "enable", config = config.wait }


local hotkeys = templates.main:createPage({label = "Hotkeys", showReset = true, config = config.keybind, defaultConfig = defaults.keybind})
local barterKey = cfg:newCat(hotkeys, "Barter")
    cfg:keybind(barterKey, bs.tl("mcm.keybind.barterUp"), "barterUp")
    cfg:keybind(barterKey, bs.tl("mcm.keybind.barterDown"), "barterDown")
    cfg:keybind(barterKey, bs.tl("mcm.keybind.barterUp100"), "barterUp100")
    cfg:keybind(barterKey, bs.tl("mcm.keybind.barterDown100"), "barterDown100")
    cfg:keybind(barterKey, bs.tl("mcm.keybind.offer"), "offer")
    cfg:keybind(barterKey, bs.tl("mcm.keybind.markJunk"), "markJunk")

local dialogKey = cfg:newCat(hotkeys, "Dialogue")
    cfg:keybind(dialogKey, bs.tl("mcm.keybind.barter"), "barter")
    cfg:keybind(dialogKey, bs.tl("mcm.keybind.companion"), "companion")
    cfg:keybind(dialogKey, bs.tl("mcm.keybind.enchanting"), "enchanting")
    cfg:keybind(dialogKey, bs.tl("mcm.keybind.persuasion"), "persuasion")
    cfg:keybind(dialogKey, bs.tl("mcm.keybind.repair"), "repair")
    cfg:keybind(dialogKey, bs.tl("mcm.keybind.spellmaking"), "spellmaking")
    cfg:keybind(dialogKey, bs.tl("mcm.keybind.spells"), "spells")
    cfg:keybind(dialogKey, bs.tl("mcm.keybind.training"), "training")
    cfg:keybind(dialogKey, bs.tl("mcm.keybind.travel"), "travel")

local persuadeKey = cfg:newCat(hotkeys, "Persuasion")
    cfg:keybind(persuadeKey, bs.tl("mcm.keybind.admire"), "admire")
    cfg:keybind(persuadeKey, bs.tl("mcm.keybind.intimidate"), "intimidate")
    cfg:keybind(persuadeKey, bs.tl("mcm.keybind.taunt"), "taunt")
    cfg:keybind(persuadeKey, bs.tl("mcm.keybind.bribe10"), "bribe10") 
    cfg:keybind(persuadeKey, bs.tl("mcm.keybind.bribe100"), "bribe100")
    cfg:keybind(persuadeKey, bs.tl("mcm.keybind.bribe1000"), "bribe1000")

local takeKey = cfg:newCat(hotkeys, "Take Book/Scroll")
    cfg:keybind(takeKey, bs.tl("mcm.keybind.take"), "take")

local fullRestKey = cfg:newCat(hotkeys, "Wait/Rest")
    cfg:keybind(fullRestKey, bs.tl("mcm.keybind.wait"), "wait")
    cfg:keybind(fullRestKey, bs.tl("mcm.keybind.waitDown"), "waitDown")
    cfg:keybind(fullRestKey, bs.tl("mcm.keybind.waitUp"), "waitUp")
    cfg:keybind(fullRestKey, bs.tl("mcm.keybind.heal"), "heal")
    cfg:keybind(fullRestKey, bs.tl("mcm.keybind.day"), "day")

local debug = templates.main:createPage({label = "Debug", showReset = true, config = config.debug, defaultConfig = defaults.debug})
    debug:createDropdown{
        label = "Logging Level",
        description = "Set the log level.",
        options = {
            { label = "TRACE", value = "TRACE"},
            { label = "DEBUG", value = "DEBUG"},
            { label = "INFO", value = "INFO"},
            { label = "WARN", value = "WARN"},
            { label = "ERROR", value = "ERROR"},
            { label = "NONE", value = "NONE"},
        },
        configKey = "logLevel",
        callback = function(self)
            bs.log():setLogLevel(self.variable.value)
        end
    }
---==========================================================Inventory=============================================================================
templates.inventory = mwse.mcm.createTemplate({ name = configPath..": Inventory", defaultConfig = defaults, config = config })
templates.inventory:saveOnClose(configPath, config)

local effects = templates.inventory:createPage({label = bs.tl("mcm.effects.name"), config = config.effects, showReset = true, defaultConfig = defaults.effects})
    effects:createDropdown({
        label = bs.tl("mcm.effects.borderMode"), configKey = "borderMode",
        options = { {label = bs.tl("mcm.effects.borderThin"), value = 1}, {label = bs.tl("mcm.effects.borderBG"), value = 2}, {label = bs.tl("mcm.effects.borderNone"), value = 3}, },
        callback = function (self) event.trigger("bs_MenuEffects_Update") end,
    })

    effects:createSlider{label = bs.tl("mcm.effects.menuModeAlpha"), min = 0, max = 1, configKey = "menuModeAlpha", step = 0.05, jump = 0.1, decimalPlaces = 2}
    effects:createSlider{label = bs.tl("mcm.effects.pinnedAlpha"), min = 0, max = 1, configKey = "pinnedAlpha", step = 0.05, jump = 0.1, decimalPlaces = 2} 
    effects:createSlider{label = bs.tl("mcm.effects.durationThreshold"), min = 0, max = 30, configKey = "durationThreshold"}
    effects:createSlider{label = bs.tl("mcm.effects.updateRate"), min = 0.05, max = 1, configKey = "updateRate", step = 0.1, jump = 0.1, decimalPlaces = 2}

local barter = templates.inventory:createPage{ label = bs.tl("mcm.barter.name"), config = config.barter, showReset = true, defaultConfig = defaults.barter }
    local barter_stats = barter:createCategory({label = bs.tl("mcm.barter.catStats")})
        barter_stats:createYesNoButton { label = bs.tl("mcm.barter.showChance"), configKey = "showChance"}
        barter_stats:createYesNoButton { label = bs.tl("mcm.barter.chanceColor"), configKey = "chanceColor"}
        barter_stats:createYesNoButton { label = bs.tl("mcm.barter.showDisposition"), configKey = "showDisposition", callback = updateBarter }
        barter_stats:createYesNoButton { label = bs.tl("mcm.barter.showNpcStats"), configKey = "showNpcStats", callback = updateBarter }
        barter_stats:createYesNoButton { label = bs.tl("mcm.barter.showPlayerStats"), configKey = "showPlayerStats", callback = updateBarter }
    local barter_junk = barter:createCategory({label = bs.tl("mcm.barter.catJunk")})
        barter_junk:createYesNoButton { label = bs.tl("mcm.barter.enableJunk"), configKey = "enableJunk"}
        barter_junk:createSlider { label = bs.tl("mcm.barter.maxSell"), configKey = "maxSell", min = 1, max = 100, step = 1, jump = 1 }

local contents = templates.inventory:createPage({label = bs.tl("mcm.contents.name"), config = config.contents, showReset = true, defaultConfig = defaults.contents})
    contents:createYesNoButton({label = bs.tl("mcm.contents.totalValue"), configKey = "totalValue"})
    contents:createYesNoButton({label = bs.tl("mcm.contents.showOwner"), configKey = "showOwner"})

local gear = templates.inventory:createPage{label = bs.tl("mcm.enchantedGear.name"), config = config.enchantedGear, showReset = true, defaultConfig = defaults.enchantedGear}
    gear:createYesNoButton({label = bs.tl("mcm.enchantedGear.highlightNew"), configKey = "highlightNew"})
    gear:createYesNoButton({label = bs.tl("mcm.enchantedGear.hideVanilla"), configKey = "hideVanilla"})
    gear:createYesNoButton({label = bs.tl("mcm.enchantedGear.showVanillaOnHide"), configKey = "showVanillaOnHide"})
    gear:createYesNoButton({label = bs.tl("mcm.enchantedGear.matchMagicVis"), configKey = "matchMagicVis"})

local inv = templates.inventory:createPage{label = bs.tl("mcm.inv.name"), config = config.inv, showReset = true, defaultConfig = defaults.inv}
    inv:createYesNoButton({label = bs.tl("mcm.inv.potionHighlight"), configKey = "potionHighlight"})

local magic = templates.inventory:createPage{label = bs.tl("mcm.magic.name"), config = config.magic, showReset = true, defaultConfig = defaults.magic}
    magic:createYesNoButton({label = bs.tl("mcm.magic.highlightNew"), configKey = "highlightNew"})
    -- magic:createColorPicker({label = bs.tl("mcm.magic.highlightColor"), configKey = "highlightColor", alpha = true})
    magic:createButton({label = bs.tl("mcm.magic.reset"), inGameOnly = true, buttonText = bs.tl("mcm.magic.resetButton"), callback =
        function (self)
            bs.initData().lookedAt = {}
            tes3.messageBox(bs.tl("mcm.magic.resetMessage"))
        end})
---==========================================================Service=============================================================================
-- local service = mwse.mcm.createTemplate({ name = configPath .. ": Services", defaultConfig = defaults, config = config })
templates.service = mwse.mcm.createTemplate({ name = configPath .. ": Services", defaultConfig = defaults, config = config })
templates.service:saveOnClose(configPath, config)

local enchant = templates.service:createPage{ label = bs.tl("mcm.enchant.name"), config = config.enchant, showReset = true, defaultConfig = defaults.enchant }
enchant:createYesNoButton({label = bs.tl("mcm.enchant.showGold"), configKey = "showGold"})

local repair = templates.service:createPage{label = bs.tl("mcm.repair.name"), config = config.repair, showReset = true, defaultConfig = defaults.repair}
    repair:createYesNoButton({label = bs.tl("mcm.repair.select"), configKey = "select"})
    repair:createYesNoButton({label = bs.tl("mcm.repair.hold"), configKey = "hold"})
    repair:createSlider { label = bs.tl("mcm.repair.interval"), configKey = "interval", min = 0.01, max = 1, step = 0.01, jump = 0.1, decimalPlaces = 2 }

local spellBarter = templates.service:createPage{ label = bs.tl("mcm.spellBarter.name"), config = config.spellBarter, showReset = true, defaultConfig = defaults.spellmaking }
    spellBarter:createYesNoButton({label = bs.tl("mcm.spellBarter.showCantCast"), configKey = "showCantCast"})

local spellmaking = templates.service:createPage{ label = bs.tl("mcm.spellmaking.name"), config = config.spellmaking, showReset = true, defaultConfig = defaults.spellmaking }
    spellmaking:createYesNoButton({label = bs.tl("mcm.spellmaking.serviceOnly"), configKey = "serviceOnly"})
    spellmaking:createYesNoButton({label = bs.tl("mcm.spellmaking.showGold"), configKey = "showGold"})

local travel = templates.service:createPage{ label = bs.tl("mcm.travel.name"), config = config.travel, showReset = true, defaultConfig = defaults.travel }
    travel:createYesNoButton{label = bs.tl("mcm.travel.showKey"), configKey = "showKey"}
---==========================================================EmbeddedService=============================================================================
    -- local embed = mwse.mcm.createTemplate({ name = configPath .. ": Embedded", defaultConfig = defaults, config = config })
templates.embed = mwse.mcm.createTemplate({ name = configPath .. ": Embedded", defaultConfig = defaults, config = config })
templates.embed:saveOnClose(configPath, config)

local embedMain = templates.embed:createPage { label = bs.tl("mcm.embed.name"), config = config.embed, showReset = true, defaultConfig = defaults.embed }
    embedMain:createYesNoButton({ label = bs.tl("mcm.embed.notify"), configKey = "notify" })
    embedMain:createYesNoButton({ label = bs.tl("mcm.embed_persuade.enable"), config = config.embed_persuade, configKey = "enable" })
    embedMain:createYesNoButton({ label = bs.tl("mcm.embed_repair.enable"), config = config.embed_repair, configKey = "enable" })
    embedMain:createYesNoButton({ label = bs.tl("mcm.embed_spells.enable"), config = config.embed_spells, configKey = "enable" })
    embedMain:createYesNoButton({ label = bs.tl("mcm.embed_train.enable"), config = config.embed_train, configKey = "enable" })
    embedMain:createYesNoButton({ label = bs.tl("mcm.embed_travel.enable"), config = config.embed_travel, configKey = "enable" })

local embedPersuade = templates.embed:createPage{label = bs.tl("mcm.embed_persuade.name"), config = config.embed_persuade, showReset = true, defaultConfig = defaults.embed_persuade}
    embedPersuade:createYesNoButton({label = bs.tl("mcm.embed_persuade.instantFight"), configKey = "instantFight"})
    embedPersuade:createYesNoButton({label = bs.tl("mcm.embed_persuade.hold"), configKey = "hold"})
    embedPersuade:createYesNoButton({label = bs.tl("mcm.embed_persuade.holdBribe"), configKey = "holdBribe"})

    -- local embedRepair = embed:createPage{label = "Repair", config = config.embed_repair, showReset = true, defaultConfig = defaults.embed_repair}

    -- local embedSpells = embed:createPage{label = "Spells", config = config.embed_spells, showReset = true, defaultConfig = defaults.embed_spells}

    -- local embedTrain = embed:createPage{label = "Training", config = config.embed_train, showReset = true, defaultConfig = defaults.embed_train}

    -- local embedTravel = embed:createPage{label = "Travel", config = config.embed_travel, showReset = true, defaultConfig = defaults.embed_travel}
---==========================================================Tooltips=============================================================================
    -- local tooltips = mwse.mcm.createTemplate({ name = configPath .. ": Tooltips", defaultConfig = defaults, config = config })
templates.tooltips = mwse.mcm.createTemplate({ name = configPath .. ": Tooltips", defaultConfig = defaults, config = config })
templates.tooltips:saveOnClose(configPath, config)

-- local color = hitChance:createColorPicker({ label = "Background Color", configKey = "color", alpha = true })
--     color.indent = 0



local tooltip = templates.tooltips:createPage { label = bs.tl("mcm.tooltip.name"), config = config.tooltip, showReset = true, defaultConfig = defaults.tooltip }
    tooltip:createYesNoButton({ label = bs.tl("mcm.tooltip.charge"), configKey = "charge" })
    tooltip:createYesNoButton({ label = bs.tl("mcm.tooltip.showDur"), configKey = "showDur" })
    tooltip:createYesNoButton { label = bs.tl("mcm.tooltip.junk"), configKey = "junk" }
    tooltip:createYesNoButton { label = bs.tl("mcm.tooltip.totalWeight"), configKey = "totalWeight" }
    tooltip:createSlider { label = bs.tl("mcm.tooltip.durationDigits"), configKey = "durationDigits", min = 0, max = 5, step = 1, jump = 1 }
---==========================================================Dialogue=============================================================================
templates.dialogue = mwse.mcm.createTemplate({ name = configPath .. ": Dialogue", defaultConfig = defaults, config = config })
templates.dialogue:saveOnClose(configPath, config)

local dialog = templates.dialogue:createPage{ label = bs.tl("mcm.dialog.name"), config = config.dialog, showReset = true, defaultConfig = defaults.dialog }
    dialog:createYesNoButton({label = bs.tl("mcm.dialog.showClass"), configKey = "showClass"})
    dialog:createYesNoButton({label = bs.tl("mcm.dialog.showKey"), configKey = "showKey"})

local persuade = templates.dialogue:createPage{ label = bs.tl("mcm.persuade.name"), config = config.persuade, showReset = true, defaultConfig = defaults.persuade }
    persuade:createYesNoButton({label = bs.tl("mcm.persuade.showKey"), configKey = "showKey"})
    persuade:createYesNoButton({label = bs.tl("mcm.persuade.hold"), configKey = "hold"})
    persuade:createYesNoButton({label = bs.tl("mcm.persuade.holdBribe"), configKey = "holdBribe"})
    persuade:createSlider { label = bs.tl("mcm.persuade.delay"), configKey = "delay",
    min = 0.01, max = 1, step = 0.01, jump = 0.01, decimalPlaces = 2 }
---==========================================================HUD=============================================================================
templates.hud = mwse.mcm.createTemplate({ name = configPath .. ": HUD", defaultConfig = defaults, config = config })
templates.hud:saveOnClose(configPath, config)

local enemyBars = templates.hud:createPage({ label = "Enemy Stat Bars", config = config.enemyBars })
    -- cfg.YN(enemyBars, "mcm.enemyBars.health", "health")
    enemyBars:createYesNoButton({label = bs.tl("mcm.enemyBars.health"), configKey = "health"})
    enemyBars:createYesNoButton({label = bs.tl("mcm.enemyBars.magicka"), configKey = "magicka"})
    enemyBars:createYesNoButton({label = bs.tl("mcm.enemyBars.fatigue"), configKey = "fatigue"})
    enemyBars:createYesNoButton({label = bs.tl("mcm.enemyBars.showLevel"), configKey = "showLevel"})
    enemyBars:createYesNoButton({label = bs.tl("mcm.enemyBars.showText"), configKey = "showText"})

local hitChance = templates.hud:createPage { label = bs.tl("mcm.hitChance.name"), config = config.hitChance, showReset = true, defaultConfig = defaults.hitChance }
    hitChance:createYesNoButton({ label = bs.tl("mcm.hitChance.enable"), configKey = "enable" })
    hitChance:createSlider({ label = bs.tl("mcm.hitChance.updateRate"), min = 0.01, max = 5, configKey = "updateRate", decimalPlaces = 2, step = 0.01, jump = 0.1 })
    hitChance:createCategory({ label = bs.tl("mcm.hitChance.catPos") })
    hitChance:createSlider({ label = bs.tl("mcm.hitChance.posX"), configKey = "posX", min = 0, max = 1, decimalPlaces = 2, step = 0.01, jump = 0.1 })
    hitChance:createSlider({ label = bs.tl("mcm.hitChance.posY"), configKey = "posY", min = 0, max = 1, decimalPlaces = 2, step = 0.01, jump = 0.1 })

local quickLoot = templates.hud:createPage { label = bs.tl("mcm.quickLoot.name"), config = config.quickLoot, showReset = true, defaultConfig = defaults.quickLoot }
    quickLoot:createSlider({label = bs.tl("mcm.quickLoot.posX"), configKey = "posX", min = -tes3ui.getViewportSize(), max = tes3ui.getViewportSize(),step = 1, jump = 50})
    quickLoot:createSlider({label = bs.tl("mcm.quickLoot.showCount"), configKey = "showCount", min = 1, max = 14, step = 1, jump = 1})

-- --- @param e keyDownEventData
-- local function keyDownCallback(e)
--     if e.keyCode == tes3.scanCode.v then
--         -- bs.inspect(config)
--         bs.inspect(config.enemyBars)
--     end
-- end
-- event.register(tes3.event.keyDown, keyDownCallback)

---@param page mwseMCMExclusionsPage|mwseMCMFilterPage|mwseMCMMouseOverPage|mwseMCMPage|mwseMCMSideBarPage
---@param tl bs_UITweaks_i18n_Translation
---@param configKey string
---@return mwseMCMYesNoButton
function cfg.YN(page, tl, configKey)
    return page:createYesNoButton({label = bs.tl(tl), configKey = configKey})
end


---==========================================================Misc=============================================================================
templates.misc = mwse.mcm.createTemplate({ name = configPath .. ": Miscellaneous", defaultConfig = defaults, config = config })
templates.misc:saveOnClose(configPath, config)

local waitRest = templates.misc:createPage{ label = bs.tl("mcm.wait.name"), config = config.wait }
    waitRest:createYesNoButton({ label = bs.tl("mcm.wait.fullRest"), configKey = "fullRest", })

local escape = templates.misc:createPage{label = bs.tl("mcm.escape.name"), config = config.escape}
    escape:createDropdown({
        label = bs.tl("mcm.escape.keybind"),
        configKey = "keybind",
        options = {
            {label = bs.tl("mcm.escape.rightClick"), value = tes3.keybind.menuMode},
            {label = bs.tl("mcm.escape.esc"), value = tes3.keybind.escape}
        }
    })

    templates.misc:createExclusionsPage({
        label = bs.tl("mcm.escape.blacklist"),
        leftListLabel = bs.tl("mcm.escape.disabledMenus"),
        rightListLabel = bs.tl("mcm.escape.enabledMenus"),
        config = config.escape,
        defaultConfig = defaults.escape,
        showReset = true,
        configKey = "blacklist",
        filters = { {
            label = bs.tl("mcm.escape.menus"),
            callback = function()
                local menu = {}
                for index, value in pairs(bs.menus) do
                    if type(value) == "string" then
                        table.insert(menu, value)
                    end
                end
                table.sort(menu)
                return menu
            end
        }, },
    })

    for k, v in pairs(templates) do
        v:register()
    end

end
event.register(tes3.event.modConfigReady, registerModConfig)

---@param page mwseMCMExclusionsPage|mwseMCMFilterPage|mwseMCMMouseOverPage|mwseMCMPage|mwseMCMSideBarPage
---@param label string
function cfg:newCat(page, label)
    return page:createCategory({label = label})
end

---comments
---@param page mwseMCMExclusionsPage|mwseMCMFilterPage|mwseMCMMouseOverPage|mwseMCMPage|mwseMCMSideBarPage
---@param label string
---@param key string
---@return mwseMCMKeyBinder
function cfg:keybind(page, label, key)
    return page:createKeyBinder({ label = label, configKey = key })
end

return config