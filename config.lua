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
    manualAdd = "",
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
    take = { enable = true },
    DEBUG = false
}
local function updateBarter() event.trigger(bs.UpdateBarter) end

---@class bsUITweaks.cfg
local config = mwse.loadConfig(configPath, defaults)

local templates = {}

local function registerModConfig()
---==========================================================Main=============================================================================
templates.main = mwse.mcm.createTemplate({ name = configPath, defaultConfig = defaults, config = config })
templates.main:saveOnClose(configPath, config)

local settings = templates.main:createPage({ label = "UI Tweaks Features"})
-- local DEBUG = settings:createButton{buttonText = "Reload", label ="[DEBUG]Reload Files BEE"}
-- DEBUG.callback = function (self) event.trigger("UITweaksReloadFile") end
-- cfg.settings:createYesNoButton { label = "Enable HUD Tweaks", configKey = "enable", config = config.multi}
settings:createYesNoButton { label = "Enable Barter", configKey = "enable", callback = updateBarter, config = config.barter }
settings:createYesNoButton { label = "Enable Contents", configKey = "enable", config = config.contents }
settings:createYesNoButton { label = "Enable Dialogue", configKey = "enable", config = config.dialog }
settings:createYesNoButton { label = "Enable Active Effects", configKey = "enable", config = config.effects }
settings:createYesNoButton { label = "Enable Enchantment", configKey = "enable", config = config.enchant }
settings:createYesNoButton { label = "Enable Enchanted Gear", configKey = "enable", config = config.enchantedGear }
settings:createYesNoButton { label = "Enable Embedded Services", configKey = "enable", config = config.embed }
settings:createYesNoButton { label = "Enable Hit Chance", configKey = "enable", config = config.hitChance }
settings:createYesNoButton { label = "Enable Hotkeys", configKey = "enable", config = config.keybind }
settings:createYesNoButton { label = "Enable Persuasion", configKey = "enable", config = config.persuade }
settings:createYesNoButton { label = "Enable Magic", configKey = "enable", config = config.magic }
settings:createYesNoButton { label = "Enable QuickEsc", configKey = "enable", config = config.escape }
settings:createYesNoButton { label = "Enable QuickTake", configKey = "enable", config = config.take }
settings:createYesNoButton { label = "Enable Repair", configKey = "enable", config = config.repair }
settings:createYesNoButton { label = "Enable Spell Barter", configKey = "enable", config = config.spellBarter }
settings:createYesNoButton { label = "Enable Spellmaking", configKey = "enable", config = config.spellmaking }
settings:createYesNoButton { label = "Enable Tooltip", configKey = "enable", config = config.tooltip }
settings:createYesNoButton { label = "Enable Travel", configKey = "enable", config = config.travel }
settings:createYesNoButton { label = "Enable Wait/Rest", configKey = "enable", config = config.wait }

local hotkeys = templates.main:createPage({label = "Hotkeys", showReset = true, config = config.keybind, defaultConfig = defaults.keybind})
local barterKey = cfg:newCat(hotkeys, "Barter")
    cfg:keybind(barterKey, "Barter -", "barterDown")
    cfg:keybind(barterKey, "Barter +", "barterUp")
    cfg:keybind(barterKey, "Barter -100", "barterDown100")
    cfg:keybind(barterKey, "Barter +100", "barterUp100")
    cfg:keybind(barterKey, "Confirm Offer", "offer")
    cfg:keybind(barterKey, "Mark Junk", "markJunk")

local dialogKey = cfg:newCat(hotkeys, "Dialogue")
    cfg:keybind(dialogKey, "Open Barter", "barter")
    cfg:keybind(dialogKey, "Open Companion", "companion")
    cfg:keybind(dialogKey, "Open Enchanting", "enchanting")
    cfg:keybind(dialogKey, "Open Persuasion", "persuasion")
    cfg:keybind(dialogKey, "Open Repair", "repair")
    cfg:keybind(dialogKey, "Open Spellmaking", "spellmaking")
    cfg:keybind(dialogKey, "Open Spells", "spells")
    cfg:keybind(dialogKey, "Open Training", "training")
    cfg:keybind(dialogKey, "Open Travel", "travel")

local persuadeKey = cfg:newCat(hotkeys, "Persuasion")
    cfg:keybind(persuadeKey, "Admire", "admire")
    cfg:keybind(persuadeKey, "Intimidate", "intimidate")
    cfg:keybind(persuadeKey, "Taunt", "taunt")
    cfg:keybind(persuadeKey, "Bribe 10", "bribe10")
    cfg:keybind(persuadeKey, "Bribe 100", "bribe100")
    cfg:keybind(persuadeKey, "Bribe 1000", "bribe1000")

local takeKey = cfg:newCat(hotkeys, "Take Book/Scroll")
    cfg:keybind(takeKey, "Take", "take")

local fullRestKey = cfg:newCat(hotkeys, "Wait/Rest")
    cfg:keybind(fullRestKey, "Wait/Rest", "wait")
    cfg:keybind(fullRestKey, "Wait/Rest - 1hr", "waitDown")
    cfg:keybind(fullRestKey, "Wait/Rest + 1hr", "waitUp")
    cfg:keybind(fullRestKey, "Until Healed", "heal")
    cfg:keybind(fullRestKey, "Rest/Wait 24hr", "day")
---==========================================================Inventory=============================================================================
-- local inventory = mwse.mcm.createTemplate({ name = configPath..": Inventory", defaultConfig = defaults, config = config })
templates.inventory = mwse.mcm.createTemplate({ name = configPath..": Inventory", defaultConfig = defaults, config = config })
templates.inventory:saveOnClose(configPath, config)

local active = templates.inventory:createPage({label = "Active Effects", config = config.effects, showReset = true, defaultConfig = defaults.effects})
    active:createDropdown({
        label = "Pinned Active Effects Border Type", configKey = "borderMode",
        options = { {label = "Thin Border", value = 1}, {label = "Background", value = 2}, {label = "None", value = 3}, },
        callback = function (self) event.trigger("bs_MenuEffects_Update") end,
    })

    active:createSlider{label = "Menu Alpha in MenuMode", min = 0, max = 1, configKey = "menuModeAlpha", step = 0.05, jump = 0.1, decimalPlaces = 2}
    active:createSlider{label = "Menu Alpha when Pinned", min = 0, max = 1, configKey = "pinnedAlpha", step = 0.05, jump = 0.1, decimalPlaces = 2}
    active:createSlider{label = "Effect Duration Threshold", min = 0, max = 30, configKey = "durationThreshold"}
    active:createSlider{label = "Update Rate", min = 0.05, max = 1, configKey = "updateRate", step = 0.1, jump = 0.1, decimalPlaces = 2}

local barter = templates.inventory:createPage{ label = "Barter", config = config.barter, showReset = true, defaultConfig = defaults.barter }
    local barter_stats = barter:createCategory({label = "Stats"})
        barter_stats:createYesNoButton { label = "Show Barter Chance", configKey = "showChance"}
        barter_stats:createYesNoButton { label = "Change Chance Color Based on Success Chance", configKey = "chanceColor"}
        barter_stats:createYesNoButton { label = "Show Disposition", configKey = "showDisposition", callback = updateBarter }
        barter_stats:createYesNoButton { label = "Show NPC Stats", configKey = "showNpcStats", callback = updateBarter }
        barter_stats:createYesNoButton { label = "Show Player Stats", configKey = "showPlayerStats", callback = updateBarter }
    local barter_junk = barter:createCategory({label = "Junk"})
        barter_junk:createYesNoButton { label = "Enable Sell Junk Button", configKey = "enableJunk"}
        barter_junk:createSlider { label = "Max Amount of Junk to Barter", configKey = "maxSell", min = 1, max = 100, step = 1, jump = 1 }

local contents = templates.inventory:createPage({label = "Contents", config = config.contents, showReset = true, defaultConfig = defaults.contents})
    contents:createYesNoButton({label = "Show Total Value of Containers Contents", configKey = "totalValue"})
    contents:createYesNoButton({label = "Show Owner and Ownership Access in Title Bar", configKey = "showOwner"})

local gear = templates.inventory:createPage{label = "Enchanted Gear", config = config.enchantedGear, showReset = true, defaultConfig = defaults.enchantedGear}
    gear:createYesNoButton({label = "Highlight New Enchants/Scrolls", configKey = "highlightNew"})
    gear:createYesNoButton({label = "Hide Vanilla Enchantments/Scrolls", configKey = "hideVanilla"})
    gear:createYesNoButton({label = "Show Vanilla Enchantments/Scrolls When Enchanted Gear Window Hidden", configKey = "showVanillaOnHide"})
    gear:createYesNoButton({label = "Match Enchanted Gear Visibility with Vanilla Magic Menu", configKey = "matchMagicVis"})

local inv = templates.inventory:createPage{label = "Inventory", config = config.inv, showReset = true, defaultConfig = defaults.inv}
    inv:createYesNoButton({label = "Hightlight Potions by Type", configKey = "potionHighlight"})

local magic = templates.inventory:createPage{label = "Magic", config = config.magic, showReset = true, defaultConfig = defaults.magic}
    magic:createYesNoButton({label = "Highlight New Spells/Enchants", configKey = "highlightNew"})
    -- magic:createColorPicker({label = "New Spell/Enchant Hightlight Color", configKey = "highlightColor", alpha = true})
    magic:createButton({label = "Reset New Magic List", inGameOnly = true, buttonText = "Reset", callback =
        function (self)
            bs.initData().lookedAt = {}
            tes3.messageBox("New Spell/Enchant List Reset")
        end})
---==========================================================Service=============================================================================
-- local service = mwse.mcm.createTemplate({ name = configPath .. ": Services", defaultConfig = defaults, config = config })
templates.service = mwse.mcm.createTemplate({ name = configPath .. ": Services", defaultConfig = defaults, config = config })
templates.service:saveOnClose(configPath, config)

local enchant = templates.service:createPage{ label = "Enchantment", config = config.enchant, showReset = true, defaultConfig = defaults.enchant }
enchant:createYesNoButton({label = "Show Player Gold", configKey = "showGold"})

local repair = templates.service:createPage{label = "Repair", config = config.repair, showReset = true, defaultConfig = defaults.repair}
    repair:createYesNoButton({label = "Repair Tool Selection", configKey = "select"})
    repair:createYesNoButton({label = "Hold to Repair", configKey = "hold"})
    repair:createSlider { label = "Hold to Repair Interval", configKey = "interval", min = 0.01, max = 1, step = 0.01, jump = 0.1, decimalPlaces = 2 }

local spellBarter = templates.service:createPage{ label = "Spell Bartering", config = config.spellBarter, showReset = true, defaultConfig = defaults.spellmaking }
    spellBarter:createYesNoButton({label = "Highlight Uncastable Spells", configKey = "showCantCast"})

local spellmaking = templates.service:createPage{ label = "Spellmaking", config = config.spellmaking, showReset = true, defaultConfig = defaults.spellmaking }
    spellmaking:createYesNoButton({label = "Show Gold in NPC Spellmaking only", configKey = "serviceOnly"})
    spellmaking:createYesNoButton({label = "Show Player Gold", configKey = "showGold"})

local travel = templates.service:createPage{ label = "Travel", config = config.travel, showReset = true, defaultConfig = defaults.travel }
    travel:createYesNoButton{label = "Show Hotkeys", configKey = "showKey"}
---==========================================================EmbeddedService=============================================================================
    -- local embed = mwse.mcm.createTemplate({ name = configPath .. ": Embedded", defaultConfig = defaults, config = config })
templates.embed = mwse.mcm.createTemplate({ name = configPath .. ": Embedded", defaultConfig = defaults, config = config })
templates.embed:saveOnClose(configPath, config)

local embedMain = templates.embed:createPage { label = "Embedded Services", config = config.embed, showReset = true, defaultConfig = defaults.embed }
    embedMain:createYesNoButton({ label = "Enable Service Button Notify", configKey = "notify" })
    embedMain:createYesNoButton({ label = "Enable Embedded Persuasion", config = config.embed_persuade, configKey = "enable" })
    embedMain:createYesNoButton({ label = "Enable Embedded Repair", config = config.embed_repair, configKey = "enable" })
    embedMain:createYesNoButton({ label = "Enable Embedded Spells", config = config.embed_spells, configKey = "enable" })
    embedMain:createYesNoButton({ label = "Enable Embedded Training", config = config.embed_train, configKey = "enable" })
    embedMain:createYesNoButton({ label = "Enable Embedded Travel", config = config.embed_travel, configKey = "enable" })

local embedPersuade = templates.embed:createPage{label = "Persuasion", config = config.embed_persuade, showReset = true, defaultConfig = defaults.embed_persuade}
    -- embedPersuade:createYesNoButton({label = "Enable Embedded Persuadion", configKey = "enable"})
    embedPersuade:createYesNoButton({label = "Instantly Start Combat on Successful Taunting", configKey = "instantFight"})
    embedPersuade:createYesNoButton({label = "Hold to Persuade", configKey = "hold"})
    embedPersuade:createYesNoButton({label = "Hold to Bribe", configKey = "holdBribe"})

    -- local embedRepair = embed:createPage{label = "Repair", config = config.embed_repair, showReset = true, defaultConfig = defaults.embed_repair}

    -- local embedSpells = embed:createPage{label = "Spells", config = config.embed_spells, showReset = true, defaultConfig = defaults.embed_spells}

    -- local embedTrain = embed:createPage{label = "Training", config = config.embed_train, showReset = true, defaultConfig = defaults.embed_train}

    -- local embedTravel = embed:createPage{label = "Travel", config = config.embed_travel, showReset = true, defaultConfig = defaults.embed_travel}
---==========================================================Tooltips=============================================================================
    -- local tooltips = mwse.mcm.createTemplate({ name = configPath .. ": Tooltips", defaultConfig = defaults, config = config })
templates.tooltips = mwse.mcm.createTemplate({ name = configPath .. ": Tooltips", defaultConfig = defaults, config = config })
templates.tooltips:saveOnClose(configPath, config)

local hitChance = templates.tooltips:createPage { label = "Hit Chance", config = config.hitChance, showReset = true, defaultConfig = defaults.hitChance }
hitChance:createYesNoButton({label = "Show Hit Chance", configKey = "enable"})
    hitChance:createSlider({ label = "Update Rate", min = 0.01, max = 5, configKey = "updateRate", decimalPlaces = 2, step = 0.01, jump = 0.1 })
    hitChance:createCategory({ label = "Position: X: 0 is Left Edge, Y: 0 is Top Edge" })
    hitChance:createSlider({ label = "Position X", configKey = "posX", min = 0, max = 1, decimalPlaces = 2, step = 0.01, jump = 0.1 })
    hitChance:createSlider({ label = "Position Y", configKey = "posY", min = 0, max = 1, decimalPlaces = 2, step = 0.01, jump = 0.1 })

-- local color = hitChance:createColorPicker({ label = "Background Color", configKey = "color", alpha = true })
--     color.indent = 0

local tooltip = templates.tooltips:createPage { label = "Tooltips", config = config.tooltip, showReset = true, defaultConfig = defaults.tooltip }
    tooltip:createYesNoButton({ label = "Show Charge Cost of Enchantments", configKey = "charge" })
    tooltip:createYesNoButton({ label = "Show Duration on Active Effect Icons", configKey = "showDur" })
    tooltip:createYesNoButton { label = "Show Junk Tooltip", configKey = "junk" }
    tooltip:createYesNoButton { label = "Show Stacks Total Weight", configKey = "totalWeight" }
    tooltip:createSlider { label = "Digits in Seconds remaining", configKey = "durationDigits", min = 0, max = 5, step = 1, jump = 1 }
---==========================================================Dialogue=============================================================================
-- local dialogue = mwse.mcm.createTemplate({ name = configPath .. ": Dialogue", defaultConfig = defaults, config = config })
templates.dialogue = mwse.mcm.createTemplate({ name = configPath .. ": Dialogue", defaultConfig = defaults, config = config })
templates.dialogue:saveOnClose(configPath, config)

local dialog = templates.dialogue:createPage{ label = "Dialogue", config = config.dialog, showReset = true, defaultConfig = defaults.dialog }
    dialog:createYesNoButton({label = "Show NPC Class", configKey = "showClass"})
    dialog:createYesNoButton({label = "Show Dialogue Shortcuts", configKey = "showKey"})

local persuade = templates.dialogue:createPage{ label = "Persuasion", config = config.persuade, showReset = true, defaultConfig = defaults.persuade }
    persuade:createYesNoButton({label = "Show Keybinds", configKey = "showKey"})
    persuade:createYesNoButton({label = "Hold Key to Quickly Persuade", configKey = "hold"})
    persuade:createYesNoButton({label = "Hold Key to Quickly Bribe", configKey = "holdBribe"})
    persuade:createSlider { label = "Hold Persuade Delay", configKey = "delay",
    min = 0.01, max = 1, step = 0.01, jump = 0.01, decimalPlaces = 2 }
---==========================================================Misc=============================================================================
templates.misc = mwse.mcm.createTemplate({ name = configPath .. ": Miscellaneous", defaultConfig = defaults, config = config })
templates.misc:saveOnClose(configPath, config)

local waitRest = templates.misc:createPage{ label = "Wait/Rest", config = config.wait }
    waitRest:createYesNoButton({ label = "Enable 24 Hour Wait/Rest", configKey = "fullRest", })


local escape = templates.misc:createPage{label = "Quick Escape", config = config.escape}
    escape:createDropdown({
        label = "Escape Keybind",
        configKey = "keybind",
        options = {
            {label = "MenuMode: Right-Click", value = tes3.keybind.menuMode},
            {label = "Escape: Escape", value = tes3.keybind.escape}
        }
    })

    templates.misc:createExclusionsPage({
        label = "Quick Escape Blacklist",
        leftListLabel = "Disabled Menus",
        rightListLabel = "Enabled Menus",
        config = config.escape,
        defaultConfig = defaults.escape,
        showReset = true,
        configKey = "blacklist",
        filters = { {
            label = "Ingredients",
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

---==========================================================Multi=============================================================================
    -- templates.multi = mwse.mcm.createTemplate({ name = configPath .. ": HUD", defaultConfig = defaults, config = config })
    -- templates.multi:saveOnClose(configPath, config)
---========================================================== =============================================================================

    for k, v in pairs(templates) do
        v:register()
    end


    -- templates.dialogue:register()
    -- templates.inventory:register()
    -- templates.main:register()
    -- templates.misc:register()
    -- templates.embed:register()
    -- templates.service:register()
    -- templates.tooltips:register()
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