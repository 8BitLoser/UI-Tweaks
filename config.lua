local bs = require("BeefStranger.UI Tweaks.common")
local menu = require("BeefStranger.UI Tweaks.tes3Menus")
local configPath = "UI Tweaks"
---@class bsUITweaks<K, V>: { [K]: V }
local defaults = {
    ---MenuWaitRest
    enableMenuWaitRest = true,
        fullRest = true,
        -- close = { keyCode = tes3.scanCode.space, isShiftDown = false, isAltDown = false, isControlDown = false, },
        wait = { keyCode = tes3.scanCode.w, isShiftDown = false, isAltDown = false, isControlDown = false, },
        day = { keyCode = tes3.scanCode.f, isShiftDown = false, isAltDown = false, isControlDown = false, },
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
    enableTake = true,
        take = { keyCode = tes3.scanCode.e, isShiftDown = false, isAltDown = false, isControlDown = false, },
}

local function updateBarter() event.trigger(bs.UpdateBarter) end

---@class bsUITweaks
local config = mwse.loadConfig(configPath, defaults)

local function registerModConfig()
    local template = mwse.mcm.createTemplate({ name = configPath, defaultConfig = defaults, config = config })
        template:saveOnClose(configPath, config)

    local settings = template:createPage({ label = "UI Tweaks Features", showReset = true })
        settings:createYesNoButton { label = "Enable Wait/Rest Tweaks", configKey = "enableMenuWaitRest", }
        settings:createYesNoButton { label = "Enable Barter Tweaks", configKey = "enableMenuBarter", callback = updateBarter }
        settings:createYesNoButton { label = "Enable QuickEsc", configKey = "enableEscape",}
        settings:createYesNoButton { label = "Enable QuickTake", configKey = "enableTake",}

    local waitRest = template:createPage{ label = "Wait/Rest Menu" }
        waitRest:createYesNoButton({ label = "Enable 24 Hour Wait/Rest", configKey = "fullRest", })
        waitRest:createKeyBinder({ label = "Full Rest Shortcut", configKey = "day" })
        waitRest:createKeyBinder({ label = "Wait Shortcut", configKey = "wait" })
        -- waitRest:createKeyBinder({ label = "Close Shortcut", configKey = "close" })

    local barter = template:createPage{ label = "Barter Menu" }
        barter:createYesNoButton { label = "Show Disposition", configKey = "showDisposition", callback = updateBarter }
        barter:createYesNoButton { label = "Show NPC Stats", configKey = "showNpcStats", callback = updateBarter }
        barter:createYesNoButton { label = "Show Player Stats", configKey = "showPlayerStats", callback = updateBarter }

    local take = template:createPage({label = "QuickTake", showReset = true})
        take:createKeyBinder({ label = "QuickTake Shortcut", configKey = "take" })

    local quickEsc = template:createExclusionsPage({
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

    local test = template:createExclusionsPage({
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
    template:register()
end
event.register(tes3.event.modConfigReady, registerModConfig)

-- event.register("keyDown", function (e)
--     tes3.messageBox("Clearing UITweaks Config")
--     config = {}
-- end, {filter = tes3.scanCode.i})
-- event.register("keyDown", function (e)
--     bs.inspect(config.escapeMenus)
-- end, {filter = tes3.scanCode.q})

return config