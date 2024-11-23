local modules = {
    "BeefStranger.UI Tweaks.common",
    "BeefStranger.UI Tweaks.config",
    "BeefStranger.UI Tweaks.hotkeys",
    "BeefStranger.UI Tweaks.ID",
    "BeefStranger.UI Tweaks.quickEscape",

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
    "BeefStranger.UI Tweaks.modSupport.TransferEnchant",
}
local function requireFiles()
    for _, modname in ipairs(modules) do
        require(modname)
    end
end

requireFiles()

event.register("initialized", function()
    print("[MWSE:UI Tweaks] initialized")
end)
