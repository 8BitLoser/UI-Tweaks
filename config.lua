local bs = require("BeefStranger.UI Tweaks.common")
local menu = require("BeefStranger.UI Tweaks.tes3Menus")
local configPath = "UI Tweaks"
---@class bsDEBUGUITweaks
local cfg = {}
---@class bsUITweaks<K, V>: { [K]: V }
local defaults = {
    ---MenuWaitRest
    enableMenuWaitRest = true,
        fullRest = true,
    ---MenuBarter
    enableMenuBarter = true,
        showDialogKey = true,
        showDisposition = true,
        showNpcStats = true,
        showPlayerStats = true,
    ---QuickESC
    enableEscape = true,
        escapeMenus = {
            bsTransferEnchant = true,
            MenuAlchemy = true,
            MenuBarter = true,
            MenuBook = true,
            MenuDialog = true,
            MenuEnchantment = true,
            MenuInventory = true,
            MenuJournal = true,
            MenuLoad = true,
            MenuPersuasion = true,
            MenuPrefs = true,
            MenuRepair = true,
            MenuRestWait = true,
            MenuSave = true,
            MenuScroll = true,
            MenuServiceRepair = true,
            MenuServiceSpells = true,
            MenuServiceTraining = true,
            MenuServiceTravel = true,
            MenuSpellmaking = true,
        },
        manualAdd = "",
    enableDialog = true,
    enableHotkeys = true,
    keybind = {
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

        barterDown = { keyCode = tes3.scanCode.keyDown, isShiftDown = false, isAltDown = false, isControlDown = false, },
        barterUp = { keyCode = tes3.scanCode.keyUp, isShiftDown = false, isAltDown = false, isControlDown = false, },
        offer = { keyCode = tes3.scanCode.enter, isShiftDown = false, isAltDown = false, isControlDown = false, },
    },
}

local function updateBarter() event.trigger(bs.UpdateBarter) end

---@class bsUITweaks
local config = mwse.loadConfig(configPath, defaults)

local function registerModConfig()
    cfg.template = mwse.mcm.createTemplate({ name = configPath, defaultConfig = defaults, config = config })
    cfg.template:saveOnClose(configPath, config)

    cfg.settings = cfg.template:createPage({ label = "UI Tweaks Features", showReset = true })
        cfg.settings:createYesNoButton { label = "Enable Wait/Rest Tweaks", configKey = "enableMenuWaitRest" }
        cfg.settings:createYesNoButton { label = "Enable Barter Tweaks", configKey = "enableMenuBarter", callback = updateBarter }
        cfg.settings:createYesNoButton { label = "Enable Dialogue/Persuasion Tweaks", configKey = "enableDialog",}
        cfg.settings:createYesNoButton { label = "Enable QuickTake", configKey = "enableTake",}
        cfg.settings:createYesNoButton { label = "Enable QuickEsc", configKey = "enableEscape",}
        cfg.settings:createYesNoButton { label = "Enable Hotkeys", configKey = "enableHotkeys",}

    cfg.waitRest = cfg.template:createPage{ label = "Wait/Rest Menu" }
        cfg.waitRest:createYesNoButton({ label = "Enable 24 Hour Wait/Rest", configKey = "fullRest", })

    cfg.dialog = cfg.template:createPage{ label = "Dialogue/Persuasion Menu" }
        cfg.dialog:createYesNoButton({label = "Show Dialogue Shortcuts", configKey = "showDialogKey"})

    cfg.barter = cfg.template:createPage{ label = "Barter Menu" }
        cfg.barter:createYesNoButton { label = "Show Disposition", configKey = "showDisposition", callback = updateBarter }
        cfg.barter:createYesNoButton { label = "Show NPC Stats", configKey = "showNpcStats", callback = updateBarter }
        cfg.barter:createYesNoButton { label = "Show Player Stats", configKey = "showPlayerStats", callback = updateBarter }

    cfg.hotkeys = cfg.template:createPage({label = "Hotkeys", showReset = true, config = config.keybind})
        cfg.barterKey = cfg:newCat(cfg.hotkeys, "Barter")
            cfg.barterKey:createKeyBinder{ label = "Confirm Offer", configKey = "offer"}
            -- cfg.barterKey:createKeyBinder{ label = "Barter +", configKey = "barterUp"}
            -- cfg.barterKey:createKeyBinder{ label = "Barter -", configKey = "barterDown"}

        cfg.dialogKey = cfg:newCat(cfg.hotkeys, "Dialogue/Persuasion")
            cfg.dialogKey:createKeyBinder({ label = "Open Barter", configKey = "barter" })
            cfg.dialogKey:createKeyBinder({ label = "Open Companion", configKey = "companion" })
            cfg.dialogKey:createKeyBinder({ label = "Open Enchanting", configKey = "enchanting" })
            cfg.dialogKey:createKeyBinder({ label = "Open Persuasion", configKey = "persuasion" })
            cfg.dialogKey:createKeyBinder({ label = "Open Repair", configKey = "repair" })
            cfg.dialogKey:createKeyBinder({ label = "Open Spellmaking", configKey = "spellmaking" })
            cfg.dialogKey:createKeyBinder({ label = "Open Spells", configKey = "spells" })
            cfg.dialogKey:createKeyBinder({ label = "Open Training", configKey = "training" })
            cfg.dialogKey:createKeyBinder({ label = "Open Travel", configKey = "travel" })
            cfg.dialogKey:createKeyBinder({ label = "Admire", configKey = "admire" })
            cfg.dialogKey:createKeyBinder({ label = "Intimidate", configKey = "intimidate" })
            cfg.dialogKey:createKeyBinder({ label = "Taunt", configKey = "taunt", })

        cfg.takeKey = cfg:newCat(cfg.hotkeys, "Take Book/Scroll")
            cfg.takeKey:createKeyBinder({ label = "Take", configKey = "take" })

        cfg.fullRestKey = cfg:newCat(cfg.hotkeys, "Wait/Rest")
            cfg.fullRestKey:createKeyBinder({ label = "Wait", configKey = "wait" })
            cfg.fullRestKey:createKeyBinder({ label = "Until Healed", configKey = "heal" })
            cfg.fullRestKey:createKeyBinder({ label = "Rest/Wait 24hr", configKey = "day" })


    cfg.quickEsc = cfg.template:createExclusionsPage({
        label = "QuickEsc",
        configKey = "escapeMenus",
        leftListLabel = "Enabled",
        rightListLabel = "Disabled",
        showReset = true,
        filters = {{
            label = "Menus", callback = function ()
                local menus = {}
                for key, value in pairs(defaults.escapeMenus) do table.insert(menus, key) end
                table.sort(menus)
                return menus
            end
        }},
    })

    cfg.debug = cfg.template:createPage{label = "Advanced"}
            cfg.debug:createTextField{label = "Add MenuID", configKey = "manualAdd", callback = function (self)
                debug.log(self.variable.value)
                config.escapeMenus[self.variable.value] = true
                tes3.messageBox("%s added to Escape list", self.variable.value)
                bs.inspect(config.escapeMenus)
            end}
            cfg.debug:createTextField{label = "Remove MenuID", configKey = "manualAdd", callback = function (self)
                debug.log(self.variable.value)
                config.escapeMenus[self.variable.value] = nil
                tes3.messageBox("%s removed from Escape list", self.variable.value)
                bs.inspect(config.escapeMenus)
            end}

    cfg.test = cfg.template:createExclusionsPage({
        label = "Debug Menus",
        configKey = "escapeMenus",
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
-- event.register("keyDown", function (e)
--     tes3.messageBox("Clearing UITweaks Config")
--     config = {}
-- end, {filter = tes3.scanCode.i})
-- event.register("keyDown", function (e)
--     bs.inspect(config.escapeMenus)
-- end, {filter = tes3.scanCode.q})

return config