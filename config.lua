local bs = require("BeefStranger.UI Tweaks.common")
local menu = require("BeefStranger.UI Tweaks.menuID")
local configPath = "UI Tweaks"
---@class bsDEBUGUITweaksMCM
local cfg = {}
---@class bsUITweaks<K, V>: { [K]: V }
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
    dialog = { enable = true, showKey = false, showClass = false },
    enchant = { enable = true, showGold = true },
    escape = {
        enable = true,
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
    manualAdd = "",
    multi = { enable = true, },
    persuade = { enable = true, hold = false, holdBribe = false, delay = 0.5, showKey = false },
    repair = { enable = true, duration = 0.1 },
    spellmaking = { enable = true, showGold = true, serviceOnly = true },
    tooltip = { enable = true, charge = true, showDur = true, junk = false, },
    travel = { enable = true, },
    wait = { enable = true, fullRest = true, },
    keybind = {
        enable = true,
        ---Dialogue---
        barter = { keyCode = tes3.scanCode.b, isShiftDown = false, isAltDown = false, isControlDown = false, },
        companion = { keyCode = tes3.scanCode.c, isShiftDown = false, isAltDown = false, isControlDown = false, },
        enchanting = { keyCode = tes3.scanCode.e, isShiftDown = false, isAltDown = false, isControlDown = false, },
        persuasion = { keyCode = tes3.scanCode.p, isShiftDown = false, isAltDown = false, isControlDown = false, },
        repair = { keyCode = tes3.scanCode.r, isShiftDown = false, isAltDown = false, isControlDown = false, },
        spellmaking = { keyCode = tes3.scanCode.v, isShiftDown = false, isAltDown = false, isControlDown = false, },
        spells = { keyCode = tes3.scanCode.s, isShiftDown = false, isAltDown = false, isControlDown = false, },
        training = { keyCode = tes3.scanCode.y, isShiftDown = false, isAltDown = false, isControlDown = false, },
        travel = { keyCode = tes3.scanCode.t, isShiftDown = false, isAltDown = false, isControlDown = false, },
        ---Persuasion---
        admire = { keyCode = tes3.scanCode.a, isShiftDown = false, isAltDown = false, isControlDown = false, },
        intimidate = { keyCode = tes3.scanCode.i, isShiftDown = false, isAltDown = false, isControlDown = false, },
        taunt = { keyCode = tes3.scanCode.t, isShiftDown = false, isAltDown = false, isControlDown = false, },
        bribe10 = { keyCode = tes3.scanCode.numpad1, isShiftDown = false, isAltDown = false, isControlDown = false, },
        bribe100 = { keyCode = tes3.scanCode.numpad2, isShiftDown = false, isAltDown = false, isControlDown = false, },
        bribe1000 = { keyCode = tes3.scanCode.numpad3, isShiftDown = false, isAltDown = false, isControlDown = false, },
        ---Wait/Rest---
        day = { keyCode = tes3.scanCode.f, isShiftDown = false, isAltDown = false, isControlDown = false, },
        heal = { keyCode = tes3.scanCode.h, isShiftDown = false, isAltDown = false, isControlDown = false, },
        wait = { keyCode = tes3.scanCode.w, isShiftDown = false, isAltDown = false, isControlDown = false, },
        waitDown = { keyCode = tes3.scanCode.a, isShiftDown = false, isAltDown = false, isControlDown = false, },
        waitUp = { keyCode = tes3.scanCode.d, isShiftDown = false, isAltDown = false, isControlDown = false, },
        ---Barter---
        barterDown = { keyCode = tes3.scanCode.keyDown, isShiftDown = false, isAltDown = false, isControlDown = false, },
        barterUp = { keyCode = tes3.scanCode.keyUp, isShiftDown = false, isAltDown = false, isControlDown = false, },
        offer = { keyCode = tes3.scanCode.enter, isShiftDown = false, isAltDown = false, isControlDown = false, },

        take = { keyCode = tes3.scanCode.e, isShiftDown = false, isAltDown = false, isControlDown = false, },
    },
    take = { enable = true }
}
local function updateBarter() event.trigger(bs.UpdateBarter) end

---@class bsUITweaks
local config = mwse.loadConfig(configPath, defaults)

local function registerModConfig()
    local template = mwse.mcm.createTemplate({ name = configPath, defaultConfig = defaults, config = config })
    template:saveOnClose(configPath, config)

    local settings = template:createPage({ label = "UI Tweaks Features"})
        -- cfg.settings:createYesNoButton { label = "Enable HUD Tweaks", configKey = "enable", config = config.multi}
        settings:createYesNoButton { label = "Enable Barter Tweaks", configKey = "enable", callback = updateBarter, config = config.barter }
        settings:createYesNoButton { label = "Enable Dialogue", configKey = "enable", config = config.dialog}
        settings:createYesNoButton { label = "Enable Enchantment", configKey = "enable", config = config.enchant}
        settings:createYesNoButton { label = "Enable Hotkeys", configKey = "enable", config = config.keybind}
        settings:createYesNoButton { label = "Enable Persuasion", configKey = "enable", config = config.persuade}
        settings:createYesNoButton { label = "Enable QuickEsc", configKey = "enable", config = config.escape}
        settings:createYesNoButton { label = "Enable QuickTake", configKey = "enable", config = config.take}
        settings:createYesNoButton { label = "Enable Repair", configKey = "enable", config = config.repair}
        settings:createYesNoButton { label = "Enable Spellmaking", configKey = "enable", config = config.spellmaking}
        settings:createYesNoButton { label = "Enable Tooltip", configKey = "enable", config = config.tooltip}
        settings:createYesNoButton { label = "Enable Travel", configKey = "enable", config = config.travel}
        settings:createYesNoButton { label = "Enable Wait/Rest", configKey = "enable", config = config.wait }

    local barter = template:createPage{ label = "Barter", config = config.barter }
        local barter_stats = barter:createCategory({label = "Stats"})
            barter_stats:createYesNoButton { label = "Show Barter Chance", configKey = "showChance"}
            barter_stats:createYesNoButton { label = "Change Chance Color Based on Success Chance", configKey = "chanceColor"}
            barter_stats:createYesNoButton { label = "Show Disposition", configKey = "showDisposition", callback = updateBarter }
            barter_stats:createYesNoButton { label = "Show NPC Stats", configKey = "showNpcStats", callback = updateBarter }
            barter_stats:createYesNoButton { label = "Show Player Stats", configKey = "showPlayerStats", callback = updateBarter }
        local barter_junk = barter:createCategory({label = "Junk"})
            barter_junk:createYesNoButton { label = "Enable Sell Junk Button", configKey = "enableJunk"}
            barter_junk:createSlider { label = "Max Amount of Junk to Barter", configKey = "maxSell",
            min = 1, max = 100, step = 1, jump = 1 }

    local dialog = template:createPage{ label = "Dialogue", config = config.dialog }
        dialog:createYesNoButton({label = "Show NPC Class", configKey = "showClass"})
        dialog:createYesNoButton({label = "Show Dialogue Shortcuts", configKey = "showKey"})

    local enchant = template:createPage{ label = "Enchantment", config = config.enchant }
        enchant:createYesNoButton({label = "Show Player Gold", configKey = "showGold"})

    local persuade = template:createPage{ label = "Persuasion", config = config.persuade }
        persuade:createYesNoButton({label = "Show Keybinds", configKey = "showKey"})
        persuade:createYesNoButton({label = "Hold Key to Quickly Persuade", configKey = "hold"})
        persuade:createYesNoButton({label = "Hold Key to Quickly Bribe", configKey = "holdBribe"})
        persuade:createSlider { label = "Hold Persuade Delay", configKey = "delay",
        min = 0.01, max = 1, step = 0.01, jump = 0.01, decimalPlaces = 2 }

    local repair = template:createPage{label = "Repair", config = config.repair}
        repair:createSlider { label = "Hold to Repair Delay", configKey = "duration",
        min = 0.01, max = 1, step = 0.01, jump = 0.1, decimalPlaces = 2 }

    local spellmaking = template:createPage{ label = "Spellmaking", config = config.spellmaking }
        spellmaking:createYesNoButton({label = "Show Gold in NPC Spellmaking only", configKey = "serviceOnly"})
        spellmaking:createYesNoButton({label = "Show Player Gold", configKey = "showGold"})

    local tooltip = template:createPage{ label = "Tooltips", config = config.tooltip }
        tooltip:createYesNoButton({label = "Show Charge Cost of Enchantments", configKey = "charge"})
        tooltip:createYesNoButton({label = "Show Duration on Active Effect Icons", configKey = "showDur"})
        tooltip:createYesNoButton { label = "Show Junk Tooltip", configKey = "junk"}

    local waitRest = template:createPage{ label = "Wait/Rest", config = config.wait }
        waitRest:createYesNoButton({ label = "Enable 24 Hour Wait/Rest", configKey = "fullRest", })

    local hotkeys = template:createPage({label = "Hotkeys", showReset = true, config = config.keybind, defaultConfig = defaults.keybind})
        local barterKey = cfg:newCat(hotkeys, "Barter")
            cfg:keybind(barterKey, "Barter -", "barterDown")
            cfg:keybind(barterKey, "Barter +", "barterUp")
            cfg:keybind(barterKey, "Confirm Offer", "offer")

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


    -- cfg.quickEsc = template:createExclusionsPage({
    --     label = "QuickEsc",
    --     config = config.escape, configKey = "menus",
    --     leftListLabel = "Enabled", rightListLabel = "Disabled",
    --     showReset = true,
    --     filters = {{
    --         label = "Menus", callback = function ()
    --             local menus = {}
    --             for key, value in pairs(defaults.escape.menus) do table.insert(menus, key) end
    --             table.sort(menus)
    --             return menus
    --         end
    --     }},
    -- })

    -- cfg.debug = template:createPage { label = "Advanced" }
    -- cfg.debug:createTextField { label = "Add MenuID", configKey = "manualAdd", callback = function(self)
    --     debug.log(self.variable.value)
    --     config.escape.menus[self.variable.value] = true
    --     tes3.messageBox("%s added to Escape list", self.variable.value)
    --     bs.inspect(config.escape.menus)
    -- end }
    -- cfg.debug:createTextField { label = "Remove MenuID", configKey = "manualAdd", callback = function(self)
    --     debug.log(self.variable.value)
    --     config.escape.menus[self.variable.value] = nil
    --     tes3.messageBox("%s removed from Escape list", self.variable.value)
    --     bs.inspect(config.escape.menus)
    -- end }

    -- cfg.test = template:createExclusionsPage({
    --     label = "Debug Menus",
    --     config = config.escape,
    --     configKey = "menus",
    --     filters = {
    --         {label = "Menus", callback = function ()
    --             local menus = {}
    --             for key, value in pairs(menu) do table.insert(menus, value) end
    --             table.sort(menus)
    --             return menus
    --         end}
    --     },
    --     showReset = true,
    -- })
    template:register()
end
event.register(tes3.event.modConfigReady, registerModConfig)

---@param page mwseMCMExclusionsPage|mwseMCMFilterPage|mwseMCMMouseOverPage|mwseMCMPage|mwseMCMSideBarPage
---@param label string
function cfg:newCat(page, label)
    return page:createCategory({label = label})
end

function cfg:keybind(page, label, key)
    return page:createKeyBinder({ label = label, configKey = key })
end
-- event.register("keyDown", function (e)
--     tes3.messageBox("Clearing UITweaks Config")
--     config = {}
-- end, {filter = tes3.scanCode.i})
-- event.register("keyDown", function (e)
--     bs.inspect(config.escapeMenus)
-- end, {filter = tes3.scanCode.q})

return config