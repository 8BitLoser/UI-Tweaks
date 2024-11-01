---@diagnostic disable: duplicate-set-field, duplicate-doc-field
local bs = {
    UpdateBarter = "bsUpdateBarter",
    keyStillDown = "bsKeyStillDown"
}
---@return bsUITweaksPData playerData
function bs.initData()
    local data = tes3.player.data
    ---@class bsUITweaksPData
    data.UITweaks = data.UITweaks or {}
    data.UITweaks.lookedAt = data.UITweaks.lookedAt or {}
    return tes3.player.data.UITweaks
end

function bs.findText(element, string)
    for _, child in pairs(element.children) do
        local childText = child.text or ""
        if childText:lower():find(string:lower(), 1, true) then
            return child
        else
            if #child.children > 0 then
                local found = child:findText(string)
                if found then
                    return found
                end
            end
        end
    end
    return nil
end

---@class bs_tes3ui.createPinButton.params
---@field property string|nil? The Name of the Pinned Property (Defaults to "Menu_Pinned")
---Create a Pin/Unpin Button that toggles a Pinned Boolean Property
---@param params bs_tes3ui.createPinButton.params?
function tes3uiElement:bs_createPinButton(params)
    params = params or {}
    assert(type(params) == "table", "Invalid parameters provided.")
    local topLevel = self:getTopLevelMenu()
    local title = topLevel:findChild("PartDragMenu_title_tint")
  
    if not title then
      error("PartDragMenu_title_tint not found. This should be used on a dragFrame Menu.")
    end
  
    local property = params.property or "Menu_Pinned"
  
    ---Default to false
    topLevel:setPropertyBool(property, false)
  
    local button = title:createBlock({id = "Pin"})
    button.width = 16
    button.height = 16
    button.absolutePosAlignX = 0.99
    button.absolutePosAlignY = 0.50
  
    local pin = button:createNif({ id = "Pin_Button", path = "menu_rightbuttonup.NIF" })
  
    local unpin = button:createNif({ id = "Unpin_Button", path = "menu_rightbuttondown.NIF" })
    unpin.visible = false
  
    --- @param e tes3uiEventData
    local function onPinClick(e)
      e.source.visible = false
      unpin.visible = true
      topLevel:setPropertyBool(property, true)
    end
  
    --- @param e tes3uiEventData
    local function onUnpinClick(e)
      e.source.visible = false
      pin.visible = true
      topLevel:setPropertyBool(property, false)
    end
  
    pin:registerAfter(tes3.uiEvent.mouseClick, onPinClick)
    unpin:registerAfter(tes3.uiEvent.mouseClick, onUnpinClick)
  
    return button
  end
  
---@class bs_tes3ui.savePos.params
---@field id string|number? The id to save position under (Default: menu.name)
---@field pinProperty string|nil? The Name of the Pinned Property if it exists (Default: "Menu_Pinned")
---An alternate to saveMenuPosition as it doesn't work on menu creation
---@param params bs_tes3ui.savePos.params?
function tes3uiElement:bs_savePos(params)
    local menu = self:getTopLevelMenu()
    params = params or {}
    params.id = params.id or menu.name
    params.pinProperty = params.pinProperty or "Menu_Pinned"
    -- pinProperty = pinProperty or "Menu_Pinned"
    local data = tes3.player.data
    data.bsMenuSave = data.bsMenuSave or {}
    local save = data.bsMenuSave
    local pinned = menu:getPropertyBool(params.pinProperty)

    save[params.id] = { menu.positionX, menu.positionY, menu.width, menu.height, pinned }
end
  
  ---@class bs_tes3ui.loadPos.params
  ---@field id string|number? The id to save position under (Default: menu.name)
  ---@field pinProperty string|nil? The Name of the Pinned Property if it exists (Default: "Menu_Pinned")
  ---An alternate to loadMenuPosition as it doesn't work on menu creation
  ---@param params bs_tes3ui.loadPos.params?
  function tes3uiElement:bs_loadPos(params)
    -- pinProperty = pinProperty or "Menu_Pinned"
    local menu = self:getTopLevelMenu()
    params = params or {}
    params.id = params.id or menu.name
    params.pinProperty = params.pinProperty or "Menu_Pinned"
    if tes3.player.data.bsMenuSave then
      local save = tes3.player.data.bsMenuSave[params.id]
      if save then
        local x, y, w, h, p = table.unpack(save)
        menu.positionX = x
        menu.positionY = y
        menu.width = w
        menu.height = h
        if p then
          menu:setPropertyBool(params.pinProperty, p)
          menu:findChild("Pin").children[1].visible = false
          menu:findChild("Pin").children[2].visible = true
        end
      end
    end
  end
  
  ---Quickyl set autoHeight and autoWidth
  ---@param bool boolean true/false
  function tes3uiElement:bs_autoSize(bool)
    self.autoHeight = bool
    self.autoWidth = bool
  end
  
  
  ---@class bs_tes3ui.createClose.param
  ---@field id string|number? Default:  "Button_Close"
  ---@field text string? Default:  "Cancel"
  ---@field leave boolean? Default: false. If true button will also leaveMenuMode
  ---Creates a `Close Button`. Registers the `mouseClick` event to destroy its topLevelMenu and optionally leaveMenuMode
  ---@param params bs_tes3ui.createClose.param
  function tes3uiElement:bs_createClose(params)
    params = params or {}
    params.id = params.id or "Button_Close"
    params.text = params.text or "Cancel"
    params.leave = params.leave or false
  
    local button = self:createButton({ id = params.id, text = params.text })
  
    button:registerAfter(tes3.uiEvent.mouseClick, function(e)
      e.source:getTopLevelMenu():destroy()
      if params.leave then
        tes3ui.leaveMenuMode()
      end
    end)
  
    return button
  end
  
  ---Updates the topLevelMenu
  function tes3uiElement:bs_Update()
    self:getTopLevelMenu():updateLayout()
  end

---@param id tes3.gmst
function bs.GMST(id)
    return tes3.findGMST(id).value
end

function bs.inspect(table)
    local inspect = require("inspect").inspect
    mwse.log("%s", inspect(table))
end

---@param colorATable mwseColorATable
---@return number[] rgb
---@return number alpha
function bs.color(colorATable)
    return {colorATable.r,colorATable.g,colorATable.b}, colorATable.a
end

---@param color number[]
---@param alpha number
---@return mwseColorATable
function bs.colorTable(color, alpha)
    return {r = color[1], g = color[2], b = color[3], a = alpha}
end

function bs.click()
    tes3.worldController.menuClickSound:play()
end

-- bs.menuClick = tes3.worldController.menuClickSound:play()

function bs.interpolateRGB(color1, color2, factor)
    local r = color1[1] + (color2[1] - color1[1]) * factor
    local g = color1[2] + (color2[2] - color1[2]) * factor
    local b = color1[3] + (color2[3] - color1[3]) * factor
    return { r, g, b }
end

function bs.keybind(keybind) return tes3.worldController.inputController:isKeyDown(keybind.keyCode) end

---@param scanCode tes3.scanCode
function bs.isKeyDown(scanCode) return tes3.worldController.inputController:isKeyDown(scanCode) end

bs.rgb = {
    bsPrettyBlue = {0.235, 0.616, 0.949},
    bsNiceRed = {0.941, 0.38, 0.38},
    bsPrettyGreen = { 0.38, 0.941, 0.525 },
    bsLightGrey = { 0.839, 0.839, 0.839 },
    bsRoyalPurple = {0.714, 0.039, 0.902},
    activeColor = { 0.37647062540054, 0.43921571969986, 0.79215693473816 },
    activeOverColor = { 0.6235294342041, 0.66274511814117, 0.87450987100601 },
    activePressedColor = { 0.87450987100601, 0.88627457618713, 0.95686280727386 },
    answerColor = { 0.58823531866074, 0.19607844948769, 0.11764706671238 },
    answerOverColor = { 0.87450987100601, 0.78823536634445, 0.6235294342041 },
    answerPressedColor = { 0.95294123888016, 0.92941182851791, 0.8666667342186 },
    backgroundColor = { 0, 0, 0 },
    bigAnswerColor = { 0.58823531866074, 0.19607844948769, 0.11764706671238 },
    bigAnswerOverColor = { 0.87450987100601, 0.78823536634445, 0.6235294342041 },
    bigAnswerPressedColor = { 0.95294123888016, 0.92941182851791, 0.086274512112141 },
    bigHeaderColor = { 0.87450987100601, 0.78823536634445, 0.6235294342041 },
    bigLinkColor = { 0.43921571969986, 0.49411767721176, 0.8117647767067 },
    bigLinkOverColor = { 0.56078433990479, 0.60784316062927, 0.85490202903748 },
    bigLinkPressedColor = { 0.68627452850342, 0.72156864404678, 0.89411771297455 },
    bigNormalColor = { 0.79215693473816, 0.64705884456635, 0.37647062540054 },
    bigNormalOverColor = { 0.87450987100601, 0.78823536634445, 0.6235294342041 },
    bigNormalPressedColor = { 0.95294123888016, 0.92941182851791, 0.8666667342186 },
    bigNotifyColor = { 0.87450987100601, 0.78823536634445, 0.6235294342041 },
    blackColor = { 0, 0, 0 },
    countColor = { 0.87450987100601, 0.78823536634445, 0.6235294342041 },
    disabledColor = { 0.70196080207825, 0.65882354974747, 0.52941179275513 },
    disabledOverColor = { 0.87450987100601, 0.78823536634445, 0.6235294342041 },
    disabledPressedColor = { 0.95294123888016, 0.92941182851791, 0.8666667342186 },
    fatigueColor = { 0, 0.58823531866074, 0.23529413342476 },
    focusColor = { 0.3137255012989, 0.3137255012989, 0.3137255012989 },
    headerColor = { 0.87450987100601, 0.78823536634445, 0.6235294342041 },
    healthColor = { 0.78431379795074, 0.23529413342476, 0.11764706671238 },
    healthNpcColor = { 1, 0.7294117808342, 0 },
    journalFinishedQuestColor = { 0.23529413342476, 0.23529413342476, 0.23529413342476 },
    journalFinishedQuestOverColor = { 0.39215689897537, 0.39215689897537, 0.39215689897537 },
    journalFinishedQuestPressedColor = { 0.86274516582489, 0.86274516582489, 0.86274516582489 },
    journalLinkColor = { 0.14509804546833, 0.19215688109398, 0.43921571969986 },
    journalLinkOverColor = { 0.22745099663734, 0.30196079611778, 0.68627452850342 },
    journalLinkPressedColor = { 0.43921571969986, 0.49411767721176, 0.8117647767067 },
    journalTopicColor = { 0, 0, 0 },
    journalTopicOverColor = { 0.22745099663734, 0.30196079611778, 0.68627452850342 },
    journalTopicPressedColor = { 0.43921571969986, 0.49411767721176, 0.8117647767067 },
    linkColor = { 0.43921571969986, 0.49411767721176, 0.8117647767067 },
    linkOverColor = { 0.56078433990479, 0.60784316062927, 0.85490202903748 },
    linkPressedColor = { 0.68627452850342, 0.72156864404678, 0.89411771297455 },
    magicColor = { 0.20784315466881, 0.27058824896812, 0.6235294342041 },
    magicFillColor = { 0.78431379795074, 0.23529413342476, 0.11764706671238 },
    miscColor = { 0, 0.80392163991928, 0.80392163991928 },
    negativeColor = { 0.78431379795074, 0.23529413342476, 0.11764706671238 },
    normalColor = { 0.79215693473816, 0.64705884456635, 0.37647062540054 },
    normalOverColor = { 0.87450987100601, 0.78823536634445, 0.6235294342041 },
    normalPressedColor = { 0.95294123888016, 0.92941182851791, 0.8666667342186 },
    notifyColor = { 0.87450987100601, 0.78823536634445, 0.6235294342041 },
    positiveColor = { 0.87450987100601, 0.78823536634445, 0.6235294342041 },
    weaponFillColor = { 0.78431379795074, 0.23529413342476, 0.11764706671238 },
    whiteColor = { 1, 1, 1 }
  }

return bs
