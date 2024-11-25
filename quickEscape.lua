local cfg = require("BeefStranger.UI Tweaks.config")
local bs = require("BeefStranger.UI Tweaks.common")
local id = require("BeefStranger.UI Tweaks.ID")
local Menu = require("BeefStranger.UI Tweaks.menu")
local find = tes3ui.findMenu
local this = {}
local closeButtons = {
    [id.Ctrls] = "MenuCtrls_Okbutton",
    [id.Video] = "MenuVideo_Okbutton",
    [id.Prefs] = "MenuPrefs_Okbutton",
    [id.Audio] = "MenuAudio_Okbutton",
    [id.Options] = "MenuOptions_Return_container",
    [id.Book] = "MenuBook_button_close",
    [id.Scroll] = "MenuScroll_Close",
    [id.Journal] = "MenuBook_button_close",
}

local closeText
--- @param e initializedEventData
local function initializedCallback(e)
    closeText = {
        [bs.GMST(tes3.gmst.sGoodbye)] = true,
        [bs.GMST(tes3.gmst.sCancel)] = true,
        [bs.GMST(tes3.gmst.sClose)] = true,
        [bs.GMST(tes3.gmst.sOK)] = true,
        [bs.GMST(tes3.gmst.sDone)] = true,
    }
end
event.register(tes3.event.initialized, initializedCallback)

---Auto find close button and click it
---@param menu tes3uiElement
---@return boolean success
function this.autoClose(menu)
    if menu then
        for button in table.traverse(menu.children) do
            ---@cast button tes3uiElement
            if button.type == tes3.uiElementType.button then
                if button.visible then
                    if closeText[button.text] then
                        button:bs_click()
                        return true
                    end
                end
            end
        end
    end
    return false
end


--- Close menus on Right click
--- @param e keybindTestedEventData
local function keybindTestedCallback(e)
    if not cfg.escape.enable then return end
    if e.keybind == cfg.escape.keybind and e.result then
        if tes3.isCharGenRunning() then return end
        if tes3ui.menuMode() then
            local menu = tes3ui.getMenuOnTop()
            if cfg.escape.blacklist[menu.name] then
                return false
            end
            ---Menus that dont have "Cancel" buttons
            for menuID, button in pairs(closeButtons) do
                if menuID == menu.name then
                    local child = menu:findChild(button)
                    if child.visible then
                        child:bs_click()
                        return false
                    end
                end
            end

            local closed = this.autoClose(menu)

            if Menu.Barter:get() then
                closed = this.autoClose(Menu.Barter:get())
            end

            if closed then
                return false
            end

            tes3ui.leaveMenuMode()
            return false
        end
    end
end
event.register(tes3.event.keybindTested, keybindTestedCallback)


---NEEDS TO MOVE TO MENUOPTIONS!!!
---@param e uiActivatedEventData
local function uiActivatedCallback(e)
    local width = 400
    local height = 500
    if e.element.name == id.Ctrls then
        e.element.width = width
        e.element.height = height
        for child in table.traverse(e.element:getContentElement().children) do ---@param child tes3uiElement
            if child.type == tes3.uiElementType.button  then
                if child.text == bs.GMST(tes3.gmst.sOK) then
                    child:bs_Rename("MenuCtrls_Okbutton")
                end
            end
        end
        e.element:updateLayout()
    end
end
event.register(tes3.event.uiActivated, uiActivatedCallback)