local cfg = require("BeefStranger.UI Tweaks.config")

local modules = {
    "BeefStranger.UI Tweaks.common",
    "BeefStranger.UI Tweaks.config",
    "BeefStranger.UI Tweaks.ID",
    "BeefStranger.UI Tweaks.menu.HelpMenu",
    "BeefStranger.UI Tweaks.menu.MenuBarter",
    "BeefStranger.UI Tweaks.menu.MenuBook",
    "BeefStranger.UI Tweaks.menu.MenuContents",
    "BeefStranger.UI Tweaks.menu.MenuDialog",
    "BeefStranger.UI Tweaks.menu.MenuEffects",
    "BeefStranger.UI Tweaks.menu.MenuEnchantment",
    "BeefStranger.UI Tweaks.menu.MenuEnchantedGear",
    "BeefStranger.UI Tweaks.menu.EmbeddedServices",
    "BeefStranger.UI Tweaks.menu.MenuHitChance",
    "BeefStranger.UI Tweaks.menu.MenuHotkeys",
    "BeefStranger.UI Tweaks.menu.MenuMagic",
    "BeefStranger.UI Tweaks.menu.MenuInventory",
    "BeefStranger.UI Tweaks.menu.MenuJournal",
    "BeefStranger.UI Tweaks.menu.MenuMagic",
    "BeefStranger.UI Tweaks.menu.MenuPersuasion",
    "BeefStranger.UI Tweaks.menu.MenuRepair",
    "BeefStranger.UI Tweaks.menu.MenuRestWait",
    "BeefStranger.UI Tweaks.menu.MenuScroll",
    "BeefStranger.UI Tweaks.menu.MenuServices",
    "BeefStranger.UI Tweaks.menu.MenuSpellmaking",
    "BeefStranger.UI Tweaks.menu.QuickEsc",
    "BeefStranger.UI Tweaks.modSupport.TransferEnchant",
}
local function requireFiles()
    for _, modname in ipairs(modules) do
        require(modname)
    end
end

-- -- -- local function requireMenu(path)
-- -- --     for file in lfs.dir("Data Files/MWSE/mods/BeefStranger/UI Tweaks/menu") do
-- -- --         if file ~= "." and file ~= ".." then
-- -- --             local moduleName = string.format("BeefStranger.UI Tweaks.menu.%s", file:match("(.+)%..+$"))
-- -- --             debug.log(moduleName)
-- -- --         end
-- -- --     end
-- -- -- end

-- -- -- requireMenu()

-- -- -- local function reloadFiles()
-- -- --     for _, modname in ipairs(modules) do
-- -- --         package.loaded[string.lower(modname)] = nil
-- -- --         require(string.lower(modname))
-- -- --     end
-- -- --     tes3.messageBox("UI Tweaks: Files Reloading:")
-- -- -- end
-- -- -- event.register("UITweaksReloadFile", reloadFiles)

-- -- -- ---@param e keyDownEventData
-- -- -- local function onKeyDownAltU(e)
-- -- --     if e.isAltDown then
-- -- --         reloadFiles()
-- -- --         tes3.saveGame({file = "UITweaksReload", name = "UITweaksReload"})
-- -- --         tes3.loadGame("UITweaksReload.ess")
-- -- --         return false
-- -- --     end
-- -- -- end
-- -- -- event.register("keyDown", onKeyDownAltU, {filter=tes3.scanCode.u})

requireFiles()

event.register("initialized", function()
    print("[MWSE:UI Tweaks] initialized")
end)
