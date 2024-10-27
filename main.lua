local cfg = require("BeefStranger.UI Tweaks.config")

-- require("BeefStranger.UI Tweaks.HelpMenu")
-- require("BeefStranger.UI Tweaks.MenuBarter")
-- require("BeefStranger.UI Tweaks.MenuDialog")
-- require("BeefStranger.UI Tweaks.MenuEnchantment")
-- require("BeefStranger.UI Tweaks.MenuHitChance")
-- require("BeefStranger.UI Tweaks.MenuHotkeys")
-- require("BeefStranger.UI Tweaks.MenuMagic")
-- require("BeefStranger.UI Tweaks.MenuRepair")
-- require("BeefStranger.UI Tweaks.MenuRestWait")
-- require("BeefStranger.UI Tweaks.MenuServices")
-- require("BeefStranger.UI Tweaks.MenuSpellmaking")
-- require("BeefStranger.UI Tweaks.QuickEsc")
-- require("BeefStranger.UI Tweaks.tes3uiElementExt")

-- require("BeefStranger.UI Tweaks.MenuAlchemy")
-- require("BeefStranger.UI Tweaks.MenuAttributes")
-- require("BeefStranger.UI Tweaks.MenuAttributesList")
-- require("BeefStranger.UI Tweaks.MenuAudio")
-- require("BeefStranger.UI Tweaks.MenuBarter")
-- require("BeefStranger.UI Tweaks.MenuBirthSign")
-- require("BeefStranger.UI Tweaks.MenuBook")
-- require("BeefStranger.UI Tweaks.MenuChooseClass")
-- require("BeefStranger.UI Tweaks.MenuClassChoice")
-- require("BeefStranger.UI Tweaks.MenuClassMessage")
-- require("BeefStranger.UI Tweaks.MenuConsole")
-- require("BeefStranger.UI Tweaks.MenuContents")
-- require("BeefStranger.UI Tweaks.MenuCreateClass")
-- require("BeefStranger.UI Tweaks.MenuCtrls")
-- require("BeefStranger.UI Tweaks.MenuDialog")
-- require("BeefStranger.UI Tweaks.MenuEnchantment")
-- require("BeefStranger.UI Tweaks.HelpMenu")
-- require("BeefStranger.UI Tweaks.MenuInput")
-- require("BeefStranger.UI Tweaks.MenuInputSave")
-- require("BeefStranger.UI Tweaks.MenuInventory")
-- require("BeefStranger.UI Tweaks.MenuInventorySelect")
-- require("BeefStranger.UI Tweaks.MenuJournal")
-- require("BeefStranger.UI Tweaks.MenuLevelUp")
-- require("BeefStranger.UI Tweaks.MenuLoad")
-- require("BeefStranger.UI Tweaks.MenuLoading")
-- require("BeefStranger.UI Tweaks.MenuMagic")
-- require("BeefStranger.UI Tweaks.MenuMagicSelect")
-- require("BeefStranger.UI Tweaks.MenuMap")
-- require("BeefStranger.UI Tweaks.MenuMapNoteEdit")
-- require("BeefStranger.UI Tweaks.MenuMessage")
-- require("BeefStranger.UI Tweaks.MenuMulti")
-- require("BeefStranger.UI Tweaks.MenuName")
-- require("BeefStranger.UI Tweaks.MenuNotify1")
-- require("BeefStranger.UI Tweaks.MenuNotify2")
-- require("BeefStranger.UI Tweaks.MenuNotify3")
-- require("BeefStranger.UI Tweaks.MenuOptions")
-- require("BeefStranger.UI Tweaks.MenuPersuasion")
-- require("BeefStranger.UI Tweaks.MenuPrefs")
-- require("BeefStranger.UI Tweaks.MenuQuantity")
-- require("BeefStranger.UI Tweaks.MenuQuick")
-- require("BeefStranger.UI Tweaks.MenuRaceSex")
-- require("BeefStranger.UI Tweaks.MenuRepair")
-- require("BeefStranger.UI Tweaks.MenuRestWait")
-- require("BeefStranger.UI Tweaks.MenuSave")
-- require("BeefStranger.UI Tweaks.MenuScroll")
-- require("BeefStranger.UI Tweaks.MenuServices")
-- require("BeefStranger.UI Tweaks.MenuSetValues")
-- require("BeefStranger.UI Tweaks.MenuSkills")
-- require("BeefStranger.UI Tweaks.MenuSkillsList")
-- require("BeefStranger.UI Tweaks.MenuSpecialization")
-- require("BeefStranger.UI Tweaks.MenuSpellmaking")
-- require("BeefStranger.UI Tweaks.MenuStat")
-- require("BeefStranger.UI Tweaks.MenuStatReview")
-- require("BeefStranger.UI Tweaks.MenuSwimFillBar")
-- require("BeefStranger.UI Tweaks.MenuTimePass")
-- require("BeefStranger.UI Tweaks.MenuTopic")
-- require("BeefStranger.UI Tweaks.MenuVideo")

local modules = {
    "BeefStranger.UI Tweaks.common",
    "BeefStranger.UI Tweaks.config",
    "BeefStranger.UI Tweaks.ID",
    "BeefStranger.UI Tweaks.menu.HelpMenu",
    "BeefStranger.UI Tweaks.menu.MenuBarter",
    "BeefStranger.UI Tweaks.menu.MenuBook",
    "BeefStranger.UI Tweaks.menu.MenuContents",
    "BeefStranger.UI Tweaks.menu.MenuDialog",
    "BeefStranger.UI Tweaks.menu.MenuEnchantment",
    "BeefStranger.UI Tweaks.menu.MenuEnchanted",
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

-- local function requireMenu(path)
--     for file in lfs.dir("Data Files/MWSE/mods/BeefStranger/UI Tweaks/menu") do
--         if file ~= "." and file ~= ".." then
--             local moduleName = string.format("BeefStranger.UI Tweaks.menu.%s", file:match("(.+)%..+$"))
--             debug.log(moduleName)
--         end
--     end
-- end

-- requireMenu()

-- local function reloadFiles()
--     for _, modname in ipairs(modules) do
--         package.loaded[string.lower(modname)] = nil
--         require(string.lower(modname))
--     end
--     tes3.messageBox("UI Tweaks: Files Reloading:")
-- end
-- event.register("UITweaksReloadFile", reloadFiles)

-- ---@param e keyDownEventData
-- local function onKeyDownAltU(e)
--     if e.isAltDown then
--         reloadFiles()
--         tes3.saveGame({file = "UITweaksReload", name = "UITweaksReload"})
--         tes3.loadGame("UITweaksReload.ess")
--         return false
--     end
-- end
-- event.register("keyDown", onKeyDownAltU, {filter=tes3.scanCode.u})

requireFiles()

event.register("initialized", function()
    print("[MWSE:UI Tweaks] initialized")
    -- if mwse.buildNumber < 4147 then
    --     tes3.messageBox { message = "MWSE: Out of Date",
    --         buttons = { "Ok" } }
    --     -- error("MWSE Build Too Old")
    -- end
end)
