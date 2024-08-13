local bs = require("BeefStranger.UI Tweaks.common")
local menu = require("BeefStranger.UI Tweaks.menuID")
local configPath = "UI Tweaks"
---@class bsDEBUGUITweaksMCM
local cfg = {}
---@class bsUITweaks<K, V>: { [K]: V }
local defaults = {
    wait = { enable = true, fullRest = true, },
    barter = {
        enable = true,
        hold = true,
        showDisposition = true,
        showNpcStats = true,
        showPlayerStats = true,
    },
    enchant = {
        enable = true,
        showGold = true
    },
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
    dialog = { enable = true, showKey = true, },
    repair = { enable = true, duration = 0.1 },
    multi = {
        enable = true,
    },
    persuade = {
        enable = true,
        hold = true,
        holdBribe = false,
        delay = 0.5,
    },
    tooltip = {
        enable = true,
        charge = true,
        showDur = true,
    },
    keybind = {
        enable = true,
        ---Dialogue
        barter = { keyCode = tes3.scanCode.b, isShiftDown = false, isAltDown = false, isControlDown = false, },
        companion = { keyCode = tes3.scanCode.c, isShiftDown = false, isAltDown = false, isControlDown = false, },
        enchanting = { keyCode = tes3.scanCode.e, isShiftDown = false, isAltDown = false, isControlDown = false, },
        persuasion = { keyCode = tes3.scanCode.p, isShiftDown = false, isAltDown = false, isControlDown = false, },
        repair = { keyCode = tes3.scanCode.r, isShiftDown = false, isAltDown = false, isControlDown = false, },
        spellmaking = { keyCode = tes3.scanCode.v, isShiftDown = false, isAltDown = false, isControlDown = false, },
        spells = { keyCode = tes3.scanCode.s, isShiftDown = false, isAltDown = false, isControlDown = false, },
        training = { keyCode = tes3.scanCode.y, isShiftDown = false, isAltDown = false, isControlDown = false, },
        travel = { keyCode = tes3.scanCode.t, isShiftDown = false, isAltDown = false, isControlDown = false, },
        ---Persuasion
        admire = { keyCode = tes3.scanCode.a, isShiftDown = false, isAltDown = false, isControlDown = false, },
        intimidate = { keyCode = tes3.scanCode.i, isShiftDown = false, isAltDown = false, isControlDown = false, },
        taunt = { keyCode = tes3.scanCode.t, isShiftDown = false, isAltDown = false, isControlDown = false, },
        bribe10 = { keyCode = tes3.scanCode.numpad1, isShiftDown = false, isAltDown = false, isControlDown = false, },
        bribe100 = { keyCode = tes3.scanCode.numpad2, isShiftDown = false, isAltDown = false, isControlDown = false, },
        bribe1000 = { keyCode = tes3.scanCode.numpad3, isShiftDown = false, isAltDown = false, isControlDown = false, },
        ---Wait/Rest
        day = { keyCode = tes3.scanCode.f, isShiftDown = false, isAltDown = false, isControlDown = false, },
        heal = { keyCode = tes3.scanCode.h, isShiftDown = false, isAltDown = false, isControlDown = false, },
        wait = { keyCode = tes3.scanCode.w, isShiftDown = false, isAltDown = false, isControlDown = false, },
        waitDown = { keyCode = tes3.scanCode.a, isShiftDown = false, isAltDown = false, isControlDown = false, },
        waitUp = { keyCode = tes3.scanCode.d, isShiftDown = false, isAltDown = false, isControlDown = false, },
        ---Barter
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
    cfg.template = mwse.mcm.createTemplate({ name = configPath, defaultConfig = defaults, config = config })
    cfg.template:saveOnClose(configPath, config)

    cfg.settings = cfg.template:createPage({ label = "UI Tweaks Features"})
        -- cfg.settings:createYesNoButton { label = "Enable HUD Tweaks", configKey = "enable", config = config.multi}
        cfg.settings:createYesNoButton { label = "Enable Barter Tweaks", configKey = "enable", callback = updateBarter, config = config.barter }
        cfg.settings:createYesNoButton { label = "Enable Dialogue", configKey = "enable", config = config.dialog}
        cfg.settings:createYesNoButton { label = "Enable Enchantment", configKey = "enable", config = config.enchant}
        cfg.settings:createYesNoButton { label = "Enable Hotkeys", configKey = "enable", config = config.keybind}
        cfg.settings:createYesNoButton { label = "Enable Persuasion", configKey = "enable", config = config.persuade}
        cfg.settings:createYesNoButton { label = "Enable QuickEsc", configKey = "enable", config = config.escape}
        cfg.settings:createYesNoButton { label = "Enable QuickTake", configKey = "enable", config = config.take}
        cfg.settings:createYesNoButton { label = "Enable Repair Tweaks", configKey = "enable", config = config.repair}
        cfg.settings:createYesNoButton { label = "Enable Tooltip Tweaks", configKey = "enable", config = config.tooltip}
        cfg.settings:createYesNoButton { label = "Enable Wait/Rest Tweaks", configKey = "enable", config = config.wait }

    cfg.barter = cfg.template:createPage{ label = "Barter", config = config.barter }
        -- cfg.barter:createYesNoButton { label = "Show Disposition", configKey = "hold" }
        cfg.barter:createYesNoButton { label = "Show Disposition", configKey = "showDisposition", callback = updateBarter }
        cfg.barter:createYesNoButton { label = "Show NPC Stats", configKey = "showNpcStats", callback = updateBarter }
        cfg.barter:createYesNoButton { label = "Show Player Stats", configKey = "showPlayerStats", callback = updateBarter }

        cfg.dialog = cfg.template:createPage{ label = "Dialogue", config = config.dialog }
            cfg.dialog:createYesNoButton({label = "Show Dialogue Shortcuts", configKey = "showKey"})

        cfg.enchant = cfg.template:createPage{ label = "Enchantment", config = config.enchant }
            cfg.enchant:createYesNoButton({label = "Show Player Gold", configKey = "showGold"})

        cfg.persuade = cfg.template:createPage{ label = "Persuasion", config = config.persuade }
            cfg.persuade:createYesNoButton({label = "Hold Key to Quickly Persuade", configKey = "hold"})
            cfg.persuade:createYesNoButton({label = "Hold Key to Quickly Bribe", configKey = "holdBribe"})
            cfg.persuade:createSlider { label = "Hold Persuade Delay", configKey = "delay",
            min = 0.01, max = 1, step = 0.01, jump = 0.01, decimalPlaces = 2 }

    -- cfg.hud = cfg.template:createPage{ label = "HUD Menu", config = config.multi }
    --     cfg.hud:createYesNoButton({label = "Show Duration on Active Effect Icons", configKey = "showDur"})

    cfg.repair = cfg.template:createPage{label = "Repair", config = config.repair}
        cfg.repair:createSlider { label = "Hold to Repair Delay", configKey = "duration",
        min = 0.01, max = 1, step = 0.01, jump = 0.1, decimalPlaces = 2 }

    cfg.tooltip = cfg.template:createPage{ label = "Tooltips", config = config.tooltip }
        cfg.tooltip:createYesNoButton({label = "Show Charge Cost of Enchantments", configKey = "charge"})
        cfg.tooltip:createYesNoButton({label = "Show Duration on Active Effect Icons", configKey = "showDur"})

    cfg.waitRest = cfg.template:createPage{ label = "Wait/Rest", config = config.wait }
        cfg.waitRest:createYesNoButton({ label = "Enable 24 Hour Wait/Rest", configKey = "fullRest", })

    cfg.hotkeys = cfg.template:createPage({label = "Hotkeys", showReset = true, config = config.keybind, defaultConfig = defaults.keybind})
        cfg.barterKey = cfg:newCat(cfg.hotkeys, "Barter")
            cfg:keybind(cfg.barterKey, "Barter -", "barterDown")
            cfg:keybind(cfg.barterKey, "Barter +", "barterUp")
            cfg:keybind(cfg.barterKey, "Confirm Offer", "offer")

        cfg.dialogKey = cfg:newCat(cfg.hotkeys, "Dialogue")
            cfg:keybind(cfg.dialogKey, "Open Barter", "barter")
            cfg:keybind(cfg.dialogKey, "Open Companion", "companion")
            cfg:keybind(cfg.dialogKey, "Open Enchanting", "enchanting")
            cfg:keybind(cfg.dialogKey, "Open Persuasion", "persuasion")
            cfg:keybind(cfg.dialogKey, "Open Repair", "repair")
            cfg:keybind(cfg.dialogKey, "Open Spellmaking", "spellmaking")
            cfg:keybind(cfg.dialogKey, "Open Spells", "spells")
            cfg:keybind(cfg.dialogKey, "Open Training", "training")
            cfg:keybind(cfg.dialogKey, "Open Travel", "travel")

        cfg.persuadeKey = cfg:newCat(cfg.hotkeys, "Persuasion")
            cfg:keybind(cfg.persuadeKey, "Admire", "admire")
            cfg:keybind(cfg.persuadeKey, "Intimidate", "intimidate")
            cfg:keybind(cfg.persuadeKey, "Taunt", "taunt")
            cfg:keybind(cfg.persuadeKey, "Bribe 10", "bribe10")
            cfg:keybind(cfg.persuadeKey, "Bribe 100", "bribe100")
            cfg:keybind(cfg.persuadeKey, "Bribe 1000", "bribe1000")

        cfg.takeKey = cfg:newCat(cfg.hotkeys, "Take Book/Scroll")
            cfg:keybind(cfg.takeKey, "Take", "take")

        cfg.fullRestKey = cfg:newCat(cfg.hotkeys, "Wait/Rest")
            cfg:keybind(cfg.fullRestKey, "Wait/Rest", "wait")
            cfg:keybind(cfg.fullRestKey, "Wait/Rest - 1hr", "waitDown")
            cfg:keybind(cfg.fullRestKey, "Wait/Rest + 1hr", "waitUp")
            cfg:keybind(cfg.fullRestKey, "Until Healed", "heal")
            cfg:keybind(cfg.fullRestKey, "Rest/Wait 24hr", "day")


    cfg.quickEsc = cfg.template:createExclusionsPage({
        label = "QuickEsc",
        config = config.escape,
        configKey = "menus",
        leftListLabel = "Enabled",
        rightListLabel = "Disabled",
        showReset = true,
        filters = {{
            label = "Menus", callback = function ()
                local menus = {}
                for key, value in pairs(defaults.escape.menus) do table.insert(menus, key) end
                table.sort(menus)
                return menus
            end
        }},
    })

    cfg.debug = cfg.template:createPage{label = "Advanced"}
            cfg.debug:createTextField{label = "Add MenuID", configKey = "manualAdd", callback = function (self)
                debug.log(self.variable.value)
                config.escape.menus[self.variable.value] = true
                tes3.messageBox("%s added to Escape list", self.variable.value)
                bs.inspect(config.escape.menus)
            end}
            cfg.debug:createTextField{label = "Remove MenuID", configKey = "manualAdd", callback = function (self)
                debug.log(self.variable.value)
                config.escape.menus[self.variable.value] = nil
                tes3.messageBox("%s removed from Escape list", self.variable.value)
                bs.inspect(config.escape.menus)
            end}

    -- cfg.test = cfg.template:createExclusionsPage({
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
    cfg.template:register()
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