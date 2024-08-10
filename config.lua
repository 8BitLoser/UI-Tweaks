local bs = require("BeefStranger.UI Tweaks.common")
local menu = require("BeefStranger.UI Tweaks.tes3Menus")
local configPath = "UI Tweaks"
---@class bsDEBUGUITweaks
local cfg = {}
---@class bsUITweaks<K, V>: { [K]: V }
local defaults = {
    wait = { enable = true, fullRest = true, },
    menuBarter = {
        enable = true,
        showDisposition = true,
        showNpcStats = true,
        showPlayerStats = true,
    },
    escape = {
        enable = true,
        menus = {
            bsTransferEnchant = true, MenuAlchemy = true,
            MenuBarter = true, MenuBook = true, MenuDialog = true,
            MenuEnchantment = true, MenuInventory = true, MenuJournal = true,
            MenuLoad = true, MenuPersuasion = true, MenuPrefs = true,
            MenuRepair = true, MenuRestWait = true, MenuSave = true,
            MenuScroll = true, MenuServiceRepair = true, MenuServiceSpells = true,
            MenuServiceTraining = true, MenuServiceTravel = true, MenuSpellmaking = true,
        },
    },
    manualAdd = "",
    dialog = { enable = true, showKey = true, },
    repair = { enable = true, duration = 0.1 },

    keybind = {
        enable = true,

        admire = { keyCode = tes3.scanCode.a, isShiftDown = false, isAltDown = false, isControlDown = false, },
        barter = { keyCode = tes3.scanCode.b, isShiftDown = false, isAltDown = false, isControlDown = false, },
        companion = { keyCode = tes3.scanCode.c, isShiftDown = false, isAltDown = false, isControlDown = false, },
        enchanting = { keyCode = tes3.scanCode.e, isShiftDown = false, isAltDown = false, isControlDown = false, },
        intimidate = { keyCode = tes3.scanCode.i, isShiftDown = false, isAltDown = false, isControlDown = false, },
        persuasion = { keyCode = tes3.scanCode.p, isShiftDown = false, isAltDown = false, isControlDown = false, },
        repair = { keyCode = tes3.scanCode.r, isShiftDown = false, isAltDown = false, isControlDown = false, },
        spellmaking = { keyCode = tes3.scanCode.v, isShiftDown = false, isAltDown = false, isControlDown = false, },
        spells = { keyCode = tes3.scanCode.s, isShiftDown = false, isAltDown = false, isControlDown = false, },
        take = { keyCode = tes3.scanCode.e, isShiftDown = false, isAltDown = false, isControlDown = false, },
        taunt = { keyCode = tes3.scanCode.t, isShiftDown = false, isAltDown = false, isControlDown = false, },
        training = { keyCode = tes3.scanCode.y, isShiftDown = false, isAltDown = false, isControlDown = false, },
        travel = { keyCode = tes3.scanCode.t, isShiftDown = false, isAltDown = false, isControlDown = false, },

        day = { keyCode = tes3.scanCode.f, isShiftDown = false, isAltDown = false, isControlDown = false, },
        heal = { keyCode = tes3.scanCode.h, isShiftDown = false, isAltDown = false, isControlDown = false, },
        wait = { keyCode = tes3.scanCode.w, isShiftDown = false, isAltDown = false, isControlDown = false, },
        waitDown = { keyCode = tes3.scanCode.a, isShiftDown = false, isAltDown = false, isControlDown = false, },
        waitUp = { keyCode = tes3.scanCode.d, isShiftDown = false, isAltDown = false, isControlDown = false, },

        barterDown = { keyCode = tes3.scanCode.keyDown, isShiftDown = false, isAltDown = false, isControlDown = false, },
        barterUp = { keyCode = tes3.scanCode.keyUp, isShiftDown = false, isAltDown = false, isControlDown = false, },
        offer = { keyCode = tes3.scanCode.enter, isShiftDown = false, isAltDown = false, isControlDown = false, },
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
        cfg.settings:createYesNoButton { label = "Enable Wait/Rest Tweaks", configKey = "enable", config = config.wait }
        cfg.settings:createYesNoButton { label = "Enable Barter Tweaks", configKey = "enable", callback = updateBarter, config = config.menuBarter }
        cfg.settings:createYesNoButton { label = "Enable Dialogue/Persuasion Tweaks", configKey = "enable", config = config.dialog}
        cfg.settings:createYesNoButton { label = "Enable Repair Tweaks", configKey = "enable", config = config.repair}
        cfg.settings:createYesNoButton { label = "Enable QuickTake", configKey = "enable", config = config.take}
        cfg.settings:createYesNoButton { label = "Enable QuickEsc", configKey = "enable", config = config.escape}
        cfg.settings:createYesNoButton { label = "Enable Hotkeys", configKey = "enable", config = config.keybind}

    cfg.barter = cfg.template:createPage{ label = "Barter Menu", config = config.menuBarter }
        cfg.barter:createYesNoButton { label = "Show Disposition", configKey = "showDisposition", callback = updateBarter }
        cfg.barter:createYesNoButton { label = "Show NPC Stats", configKey = "showNpcStats", callback = updateBarter }
        cfg.barter:createYesNoButton { label = "Show Player Stats", configKey = "showPlayerStats", callback = updateBarter }

    cfg.dialog = cfg.template:createPage{ label = "Dialogue/Persuasion Menu", config = config.dialog }
        cfg.dialog:createYesNoButton({label = "Show Dialogue Shortcuts", configKey = "showKey"})

    cfg.repair = cfg.template:createPage{label = "Repair Menu", config = config.repair}
        cfg.repair:createSlider{label = "Auto Repair Delay", 
        min = 0.01, max = 1, step = 0.01,jump = 0.1, decimalPlaces = 2, configKey = "duration"}

    cfg.waitRest = cfg.template:createPage{ label = "Wait/Rest Menu", config = config.wait }
        cfg.waitRest:createYesNoButton({ label = "Enable 24 Hour Wait/Rest", configKey = "fullRest", })

    cfg.hotkeys = cfg.template:createPage({label = "Hotkeys", showReset = true, config = config.keybind, defaultConfig = defaults.keybind})
        cfg.barterKey = cfg:newCat(cfg.hotkeys, "Barter")
            cfg:keybind(cfg.barterKey, "Confirm Offer", "offer")
            -- cfg:keybind(cfg.barterKey, "Barter +", "barterUp")
            -- cfg:keybind(cfg.barterKey, "Barter -", "barterDown")

        cfg.dialogKey = cfg:newCat(cfg.hotkeys, "Dialogue/Persuasion")
            cfg:keybind(cfg.dialogKey, "Open Barter", "barter")
            cfg:keybind(cfg.dialogKey, "Open Companion", "companion")
            cfg:keybind(cfg.dialogKey, "Open Enchanting", "enchanting")
            cfg:keybind(cfg.dialogKey, "Open Persuasion", "persuasion")
            cfg:keybind(cfg.dialogKey, "Open Repair", "repair")
            cfg:keybind(cfg.dialogKey, "Open Spellmaking", "spellmaking")
            cfg:keybind(cfg.dialogKey, "Open Spells", "spells")
            cfg:keybind(cfg.dialogKey, "Open Training", "training")
            cfg:keybind(cfg.dialogKey, "Open Travel", "travel")
            cfg:keybind(cfg.dialogKey, "Admire", "admire")
            cfg:keybind(cfg.dialogKey, "Intimidate", "intimidate")
            cfg:keybind(cfg.dialogKey, "Taunt", "taunt")

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

    cfg.test = cfg.template:createExclusionsPage({
        label = "Debug Menus",
        config = config.escape,
        configKey = "menus",
        filters = {
            {label = "Menus", callback = function ()
                local menus = {}
                for key, value in pairs(menu) do table.insert(menus, value) end
                table.sort(menus)
                return menus
            end}
        },
        showReset = true,
    })
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