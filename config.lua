local bs = require("BeefStranger.UI Tweaks.common")
local menu = require("BeefStranger.UI Tweaks.tes3Menus")
local configPath = "UI Tweaks"
local cfg = {}
---@class bsUITweaks<K, V>: { [K]: V }
local defaults = {
    ---MenuWaitRest
    enableMenuWaitRest = true,
        fullRest = true,
    ---MenuBarter
    enableMenuBarter = true,
        showDisposition = true,
        showNpcStats = true,
        showPlayerStats = true,
    ---QuickESC
    enableEscape = true,
        escapeMenus = {
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
    enableHotkeys = true,
        take = { keyCode = tes3.scanCode.e, isShiftDown = false, isAltDown = false, isControlDown = false, },
        persuade = { keyCode = tes3.scanCode.p, isShiftDown = false, isAltDown = false, isControlDown = false, },
        admire = { keyCode = tes3.scanCode.a, isShiftDown = false, isAltDown = false, isControlDown = false, },
        intimidate = { keyCode = tes3.scanCode.i, isShiftDown = false, isAltDown = false, isControlDown = false, },
        taunt = { keyCode = tes3.scanCode.t, isShiftDown = false, isAltDown = false, isControlDown = false, },
        wait = { keyCode = tes3.scanCode.w, isShiftDown = false, isAltDown = false, isControlDown = false, },
        heal = { keyCode = tes3.scanCode.h, isShiftDown = false, isAltDown = false, isControlDown = false, },
        day = { keyCode = tes3.scanCode.f, isShiftDown = false, isAltDown = false, isControlDown = false, },
        barterUp = { keyCode = tes3.scanCode.keyUp, isShiftDown = false, isAltDown = false, isControlDown = false, },
        barterDown = { keyCode = tes3.scanCode.keyDown, isShiftDown = false, isAltDown = false, isControlDown = false, },
        offer = { keyCode = tes3.scanCode.enter, isShiftDown = false, isAltDown = false, isControlDown = false, },
}

local function updateBarter() event.trigger(bs.UpdateBarter) end

---@class bsUITweaks
local config = mwse.loadConfig(configPath, defaults)

local function registerModConfig()
    cfg.template = mwse.mcm.createTemplate({ name = configPath, defaultConfig = defaults, config = config })
    cfg.template:saveOnClose(configPath, config)

    cfg.settings = cfg.template:createPage({ label = "UI Tweaks Features", showReset = true })
        cfg.enableWait = cfg.settings:createYesNoButton { label = "Enable Wait/Rest Tweaks", configKey = "enableMenuWaitRest" }
        cfg.settings:createYesNoButton { label = "Enable Barter Tweaks", configKey = "enableMenuBarter", callback = updateBarter }
        cfg.settings:createYesNoButton { label = "Enable QuickTake", configKey = "enableTake",}
        cfg.settings:createYesNoButton { label = "Enable QuickEsc", configKey = "enableEscape",}
        cfg.settings:createYesNoButton { label = "Enable Hotkeys", configKey = "enableHotkeys",}

    cfg.waitRest = cfg.template:createPage{ label = "Wait/Rest Menu" }
        cfg.waitRest:createYesNoButton({ label = "Enable 24 Hour Wait/Rest", configKey = "fullRest", })
        cfg.waitRest:createKeyBinder({ label = "Full Rest Shortcut", configKey = "day" })
        cfg.waitRest:createKeyBinder({ label = "Wait Shortcut", configKey = "wait" })

    cfg.barter = cfg.template:createPage{ label = "Barter Menu" }
        cfg.barter:createYesNoButton { label = "Show Disposition", configKey = "showDisposition", callback = updateBarter }
        cfg.barter:createYesNoButton { label = "Show NPC Stats", configKey = "showNpcStats", callback = updateBarter }
        cfg.barter:createYesNoButton { label = "Show Player Stats", configKey = "showPlayerStats", callback = updateBarter }
        -- cfg.barter:createYesNoButton { label = "Barter +", configKey = "barterUp"}
        -- cfg.barter:createYesNoButton { label = "Barter -", configKey = "barterDown"}
        -- cfg.barter:createYesNoButton { label = "Confirm Offer", configKey = "offer"}

    cfg.hotkeys = cfg.template:createPage({label = "Hotkeys", showReset = true})
        cfg.barterKey = cfg:newCat(cfg.hotkeys, "Barter")
            cfg.barterKey:createKeyBinder{ label = "Barter +", configKey = "barterUp"}
           cfg.barterKey:createKeyBinder{ label = "Barter -", configKey = "barterDown"}
           cfg.barterKey:createKeyBinder{ label = "Confirm Offer", configKey = "offer"}

        cfg.persuasion = cfg.hotkeys:createCategory({label = "Persuasion"})
        cfg.persuasion:createKeyBinder({ label = "Open Persuasion", configKey = "persuade" })
        cfg.persuasion:createKeyBinder({ label = "Admire", configKey = "admire" })
        cfg.persuasion:createKeyBinder({ label = "Intimidate", configKey = "intimidate" })
        cfg.persuasion:createKeyBinder({ label = "Taunt", configKey = "taunt", })

        cfg.take = cfg.hotkeys:createCategory({label = "Take Book/Scroll"})
        cfg.take:createKeyBinder({ label = "Take", configKey = "take" })

        cfg.fullRest = cfg:newCat(cfg.hotkeys, "FullRest")
        cfg.fullRest:createKeyBinder({ label = "Wait", configKey = "wait" })
        cfg.fullRest:createKeyBinder({ label = "Until Healed", configKey = "heal" })
        cfg.fullRest:createKeyBinder({ label = "Rest/Wait 24hr", configKey = "day" })


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