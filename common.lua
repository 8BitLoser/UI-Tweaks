---@diagnostic disable: duplicate-set-field, duplicate-doc-field
---@class bs_UITweaks_Common
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

---===================================
---===========tes3uiElement===========
---===================================

-------------------
---createPinButton
-------------------

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
-------------------
---savePos
-------------------

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

  save[params.id] = {menu.positionX, menu.positionY,  menu.width,  menu.height, pinned }
end
-------------------
---loadPos
-------------------

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
-------------------
---holdClick
-------------------

---@class bs_tes3ui.holdClick.params
---@field triggerClick boolean? *Default `false`*: If `true` will trigger source mouseClick event
---@field playSound boolean? *Default `false`*: If `true` will play the tes3.worldController.menuClickSound sound
---@field skipFirstClick boolean? *Default `false`*: If `true` will skip first mouseClick trigger. Useful if interacting with mouse buttons
---@field startInterval number? *Default `0.5`*
---@field minInterval number? *Default `0.08`*
---@field accelerate boolean? *Default `true`*
---@field acceleration number? *Default `0.90`*. `1` if `accelerate` = `false`. Lower is faster
---@field keyControl boolean? *Default `false`*. If `true` registers a keyDown event for then skipFirstClick param. Unregisters on Element Destruction
---@field callback fun(e: tes3uiEventData)? *Optional* For if you want something to happen in the mouseStillPressed Event

---Registers a mouseStillPressed event that behaves similiarly to vanilla, where holding a button causes it to ramp up speed to a set limit
---@param params bs_tes3ui.holdClick.params
function tes3uiElement:bs_holdClick(params)
  params = params or {}
  params.keyControl = params.keyControl or false
  params.triggerClick = params.triggerClick or false
  params.skipFirstClick = params.skipFirstClick or false
  params.startInterval = params.startInterval or 0.5
  params.minInterval = params.minInterval or 0.08
  params.playSound = params.playSound or false
  params.accelerate = params.accelerate or (params.accelerate == nil and true)
  params.acceleration = (params.accelerate and (params.acceleration or 0.90)) or 1

  local startTime = os.clock()
  local clickInterval = params.startInterval -- Initial interval (in seconds).
  local minInterval = params.minInterval     -- Minimum interval for maximum speed.
  local accelerationFactor = params.acceleration
  local currentInterval = clickInterval
  local firstClick = true

  if params.keyControl then
    local function keyDown()
      currentInterval = params.startInterval
      firstClick = true
    end
    event.register(tes3.event.keyDown, keyDown)

    self:registerAfter(tes3.uiEvent.destroy, function(e) event.unregister(tes3.event.keyDown, keyDown) end)
  end

  self:registerAfter(tes3.uiEvent.mouseDown, function(e) currentInterval = params.startInterval end)

  local function stillPressed(e)
    if os.clock() - startTime >= currentInterval then
      currentInterval = math.max(currentInterval * accelerationFactor, minInterval)
      startTime = os.clock()
      if params.triggerClick then
        if (params.skipFirstClick and not firstClick) or not params.skipFirstClick then
          self:triggerEvent(tes3.uiEvent.mouseClick)
        end
      end

      if params.playSound then tes3.playSound({ sound = tes3.worldController.menuClickSound }) end
      if params.callback then params.callback(e) end
      firstClick = false
    end
  end
  self:registerAfter(tes3.uiEvent.mouseStillPressed, stillPressed)
end
-------------------
---createClose
-------------------

---@class bs_tes3ui.createClose.param
---@field id string|number? Default: "Button_Close"
---@field text string? Default: "Cancel" `tes3.gmst.sCancel`
---@field leave boolean? Default: false. If true button will also leaveMenuMode

---Creates a `Close Button`. Registers the `mouseClick` event to destroy its topLevelMenu and optionally leaveMenuMode
---@param params bs_tes3ui.createClose.param
function tes3uiElement:bs_createClose(params)
  params = params or {}
  params.id = params.id or "Button_Close"
  params.text = params.text or tes3.findGMST(tes3.gmst.sCancel).value
  params.leave = params.leave or false

  local button = self:createButton({ id = params.id, text = params.text })

  button:registerAfter(tes3.uiEvent.mouseClick, function(e)
    e.source:getTopLevelMenu():destroy()
    if params.leave then tes3ui.leaveMenuMode() end
  end)

  return button
end
-------------------
---click
-------------------

---@class bs_tes3ui.click.params
---@field playSound boolean? `Default: true` Whether or not to play the menuClickSound
---@field sound string|tes3sound? *Optional*. Play a specific sound

---Triggers the mouseClick Event
---@param params bs_tes3ui.click.params?
function tes3uiElement:bs_click(params)
  params = params or {}
  -- debug.log(params.playSound)
  params.playSound = params.playSound or (params.playSound == nil and true)
  -- debug.log(params.playSound)
  if params.playSound then
      if params.sound then
          tes3.playSound({sound = params.sound})
      else
          tes3.playSound({sound = tes3.worldController.menuClickSound})
      end
  end
  self:triggerEvent(tes3.uiEvent.mouseClick)
end
-------------------
---autoSize
-------------------

---Quickly set autoHeight and autoWidth
---@param bool boolean true/false
function tes3uiElement:bs_autoSize(bool) self.autoHeight = bool self.autoWidth = bool end
-------------------
---Update
-------------------

---Updates the topLevelMenu
function tes3uiElement:bs_Update() self:getTopLevelMenu():updateLayout() end
-------------------
---isOnTop
-------------------

---Returns if menu is onTop, auto calls getTopLevelMenu()
---@return boolean isOnTop
function tes3uiElement:bs_isOnTop() return tes3ui.getMenuOnTop() == self:getTopLevelMenu() end
-------------------
---mouseDown
-------------------

---Triggers the mouseDown Event
function tes3uiElement:bs_mouseDown() self:triggerEvent(tes3.uiEvent.mouseDown) end
-------------------
---scrollChanged
-------------------

---Triggers the PartScrollBar_changed Event
function tes3uiElement:bs_scrollChanged() self:triggerEvent(tes3.uiEvent.partScrollBarChanged) end
-------------------
---triggerHold
-------------------

---Trigger mouseStillPressed
function tes3uiElement:bs_triggerHold() self:triggerEvent(tes3.uiEvent.mouseStillPressed) end




---@class bs_tes3ui.setObj.params
---@field id string|number? *Optional* `Default: 'topLevelMenu.name'_Object`
---@field object tes3object

---@param params bs_tes3ui.setObj.params
function tes3uiElement:bs_setObj(params)
  params = params or {}
  params.id = params.id or self:getTopLevelMenu().name.."_Object"
  self:setPropertyObject(params.id, params.object)
end

---@class bs_tes3ui.setData.params
---@field id string|number? *Optional* `Default: 'topLevelMenu.name'_extra`
---@field data tes3itemData

---@param params bs_tes3ui.setData.params
function tes3uiElement:bs_setData(params)
  params = params or {}
  params.id = params.id or self:getTopLevelMenu().name.."_extra"
  self:setPropertyObject(params.id, params.data)
end

---Returns Object of supplied propertyId. `Default ID: "'Menu.name'_Object"
---@param id string|number?
---@return tes3alchemy|tes3apparatus|tes3armor|tes3book|tes3clothing|tes3ingredient|tes3light|tes3lockpick|tes3misc|tes3probe|tes3repairTool|tes3weapon
function tes3uiElement:bs_getObj(id)
  id = id or self:getTopLevelMenu().name.."_Object"
  return self:getPropertyObject(id)
end

---Returns itemData of supplied propertyId. `Default ID: "'Menu.name'_extra"
---@param id string|number?
---@return tes3itemData itemData
function tes3uiElement:bs_getItemData(id)
  id = id or self:getTopLevelMenu().name.."_extra"
  return self:getPropertyObject(id, "tes3itemData")
end

---===================================
---===========tes3uiElement===========
---===================================



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

  bs.textures = {
    amulet_heartfire = "Textures\\amulet_heartfire.tga",
    compass = "Textures\\compass.tga",
    cursor_drop = "Textures\\cursor_drop.tga",
    cursor_drop_ground = "Textures\\cursor_drop_ground.tga",
    detect_animal_icon = "Textures\\detect_animal_icon.tga",
    detect_enchantment_icon = "Textures\\detect_enchantment_icon.tga",
    detect_key_icon = "Textures\\detect_key_icon.tga",
    door_icon = "Textures\\door_icon.tga",
    ["enviro 01"] = "Textures\\enviro 01.tga",
    mapfowtexture = "Textures\\mapfowtexture.tga",
    menu_bar_blue = "Textures\\menu_bar_blue.tga",
    menu_bar_gray = "Textures\\menu_bar_gray.tga",
    menu_bar_green = "Textures\\menu_bar_green.tga",
    menu_bar_red = "Textures\\menu_bar_red.tga",
    menu_bar_yellow = "Textures\\menu_bar_yellow.tga",
    menu_button_frame_bottom = "Textures\\menu_button_frame_bottom.tga",
    menu_button_frame_bottom_left_corner = "Textures\\menu_button_frame_bottom_left_corner.tga",
    menu_button_frame_bottom_right_corner = "Textures\\menu_button_frame_bottom_right_corner.tga",
    menu_button_frame_left = "Textures\\menu_button_frame_left.tga",
    menu_button_frame_right = "Textures\\menu_button_frame_right.tga",
    menu_button_frame_top = "Textures\\menu_button_frame_top.tga",
    menu_button_frame_top_left_corner = "Textures\\menu_button_frame_top_left_corner.tga",
    menu_button_frame_top_right_corner = "Textures\\menu_button_frame_top_right_corner.tga",
    menu_compass_large = "Textures\\menu_compass_large.tga",
    menu_credits = "Textures\\menu_credits.tga",
    menu_credits_over = "Textures\\menu_credits_over.tga",
    menu_credits_pressed = "Textures\\menu_credits_pressed.tga",
    menu_divider = "Textures\\menu_divider.tga",
    menu_exitgame = "Textures\\menu_exitgame.tga",
    menu_exitgame_over = "Textures\\menu_exitgame_over.tga",
    menu_exitgame_pressed = "Textures\\menu_exitgame_pressed.tga",
    menu_head_block_bottom = "Textures\\menu_head_block_bottom.tga",
    menu_head_block_bottom_left_corner = "Textures\\menu_head_block_bottom_left_corner.tga",
    menu_head_block_bottom_right_corner = "Textures\\menu_head_block_bottom_right_corner.tga",
    menu_head_block_left = "Textures\\menu_head_block_left.tga",
    menu_head_block_middle = "Textures\\menu_head_block_middle.tga",
    menu_head_block_right = "Textures\\menu_head_block_right.tga",
    menu_head_block_top = "Textures\\menu_head_block_top.tga",
    menu_head_block_top_left_corner = "Textures\\menu_head_block_top_left_corner.tga",
    menu_head_block_top_right_corner = "Textures\\menu_head_block_top_right_corner.tga",
    menu_icon_barter = "Textures\\menu_icon_barter.tga",
    menu_icon_equip = "Textures\\menu_icon_equip.tga",
    menu_icon_frame_bottom = "Textures\\menu_icon_frame_bottom.tga",
    menu_icon_frame_left = "Textures\\menu_icon_frame_left.tga",
    menu_icon_frame_right = "Textures\\menu_icon_frame_right.tga",
    menu_icon_frame_top = "Textures\\menu_icon_frame_top.tga",
    menu_icon_magic = "Textures\\menu_icon_magic.tga",
    menu_icon_magic_barter = "Textures\\menu_icon_magic_barter.tga",
    menu_icon_magic_equip = "Textures\\menu_icon_magic_equip.tga",
    menu_icon_magic_mini = "Textures\\menu_icon_magic_mini.tga",
    menu_icon_none = "Textures\\menu_icon_none.tga",
    menu_icon_select_magic = "Textures\\menu_icon_select_magic.tga",
    menu_icon_select_magic_magic = "Textures\\menu_icon_select_magic_magic.tga",
    menu_loadgame = "Textures\\menu_loadgame.tga",
    menu_loadgame_over = "Textures\\menu_loadgame_over.tga",
    menu_loadgame_pressed = "Textures\\menu_loadgame_pressed.tga",
    menu_map_dcreature = "Textures\\menu_map_dcreature.tga",
    menu_map_dkey = "Textures\\menu_map_dkey.tga",
    menu_map_dmagic = "Textures\\menu_map_dmagic.tga",
    menu_map_smark = "Textures\\menu_map_smark.tga",
    menu_morrowind = "Textures\\menu_morrowind.tga",
    menu_newgame = "Textures\\menu_newgame.tga",
    menu_newgame_over = "Textures\\menu_newgame_over.tga",
    menu_newgame_pressed = "Textures\\menu_newgame_pressed.tga",
    menu_number_dec = "Textures\\menu_number_dec.tga",
    menu_number_inc = "Textures\\menu_number_inc.tga",
    menu_off_dot = "Textures\\menu_off_dot.tga",
    menu_on_dot = "Textures\\menu_on_dot.tga",
    menu_options = "Textures\\menu_options.tga",
    menu_options_over = "Textures\\menu_options_over.tga",
    menu_options_pressed = "Textures\\menu_options_pressed.tga",
    menu_return = "Textures\\menu_return.tga",
    menu_return_over = "Textures\\menu_return_over.tga",
    menu_return_pressed = "Textures\\menu_return_pressed.tga",
    menu_rightbuttondown_bottom = "Textures\\menu_rightbuttondown_bottom.tga",
    menu_rightbuttondown_bottom_left = "Textures\\menu_rightbuttondown_bottom_left.tga",
    menu_rightbuttondown_bottom_right = "Textures\\menu_rightbuttondown_bottom_right.tga",
    menu_rightbuttondown_center = "Textures\\menu_rightbuttondown_center.tga",
    menu_rightbuttondown_left = "Textures\\menu_rightbuttondown_left.tga",
    menu_rightbuttondown_right = "Textures\\menu_rightbuttondown_right.tga",
    menu_rightbuttondown_top = "Textures\\menu_rightbuttondown_top.tga",
    menu_rightbuttondown_top_left = "Textures\\menu_rightbuttondown_top_left.tga",
    menu_rightbuttondown_top_right = "Textures\\menu_rightbuttondown_top_right.tga",
    menu_rightbuttonup_bottom = "Textures\\menu_rightbuttonup_bottom.tga",
    menu_rightbuttonup_bottom_left = "Textures\\menu_rightbuttonup_bottom_left.tga",
    menu_rightbuttonup_bottom_right = "Textures\\menu_rightbuttonup_bottom_right.tga",
    menu_rightbuttonup_center = "Textures\\menu_rightbuttonup_center.tga",
    menu_rightbuttonup_left = "Textures\\menu_rightbuttonup_left.tga",
    menu_rightbuttonup_right = "Textures\\menu_rightbuttonup_right.tga",
    menu_rightbuttonup_top = "Textures\\menu_rightbuttonup_top.tga",
    menu_rightbuttonup_top_left = "Textures\\menu_rightbuttonup_top_left.tga",
    menu_rightbuttonup_top_right = "Textures\\menu_rightbuttonup_top_right.tga",
    menu_savegame = "Textures\\menu_savegame.tga",
    menu_savegame_over = "Textures\\menu_savegame_over.tga",
    menu_savegame_pressed = "Textures\\menu_savegame_pressed.tga",
    menu_scroll_arrow = "Textures\\menu_scroll_arrow.tga",
    menu_scroll_bar_hor = "Textures\\menu_scroll_bar_hor.tga",
    menu_scroll_bar_vert = "Textures\\menu_scroll_bar_vert.tga",
    menu_scroll_button_bottom = "Textures\\menu_scroll_button_bottom.tga",
    menu_scroll_button_top = "Textures\\menu_scroll_button_top.tga",
    menu_scroll_button_vert = "Textures\\menu_scroll_button_vert.tga",
    menu_scroll_down = "Textures\\menu_scroll_down.tga",
    menu_scroll_elevator = "Textures\\menu_scroll_elevator.tga",
    menu_scroll_hortbar_bottom = "Textures\\menu_scroll_hortbar_bottom.tga",
    menu_scroll_hortbar_top = "Textures\\menu_scroll_hortbar_top.tga",
    menu_scroll_hortbar_vert = "Textures\\menu_scroll_hortbar_vert.tga",
    menu_scroll_left = "Textures\\menu_scroll_left.tga",
    menu_scroll_right = "Textures\\menu_scroll_right.tga",
    menu_scroll_scroller_bottom = "Textures\\menu_scroll_scroller_bottom.tga",
    menu_scroll_scroller_middle = "Textures\\menu_scroll_scroller_middle.tga",
    menu_scroll_scroller_top = "Textures\\menu_scroll_scroller_top.tga",
    menu_scroll_up = "Textures\\menu_scroll_up.tga",
    menu_scroll_vertbar_bottom = "Textures\\menu_scroll_vertbar_bottom.tga",
    menu_scroll_vertbar_top = "Textures\\menu_scroll_vertbar_top.tga",
    menu_scroll_vertbar_vert = "Textures\\menu_scroll_vertbar_vert.tga",
    menu_size_button = "Textures\\menu_size_button.tga",
    menu_small_energy_bar_bottom = "Textures\\menu_small_energy_bar_bottom.tga",
    menu_small_energy_bar_top = "Textures\\menu_small_energy_bar_top.tga",
    menu_small_energy_bar_vert = "Textures\\menu_small_energy_bar_vert.tga",
    menu_thick_border_bottom = "Textures\\menu_thick_border_bottom.tga",
    menu_thick_border_bottom_left_corner = "Textures\\menu_thick_border_bottom_left_corner.tga",
    menu_thick_border_bottom_right_corner = "Textures\\menu_thick_border_bottom_right_corner.tga",
    menu_thick_border_left = "Textures\\menu_thick_border_left.tga",
    menu_thick_border_right = "Textures\\menu_thick_border_right.tga",
    menu_thick_border_top = "Textures\\menu_thick_border_top.tga",
    menu_thick_border_top_left_corner = "Textures\\menu_thick_border_top_left_corner.tga",
    menu_thick_border_top_right_corner = "Textures\\menu_thick_border_top_right_corner.tga",
    menu_thin_border_bottom = "Textures\\menu_thin_border_bottom.tga",
    menu_thin_border_bottom_left_corner = "Textures\\menu_thin_border_bottom_left_corner.tga",
    menu_thin_border_bottom_right_corner = "Textures\\menu_thin_border_bottom_right_corner.tga",
    menu_thin_border_left = "Textures\\menu_thin_border_left.tga",
    menu_thin_border_right = "Textures\\menu_thin_border_right.tga",
    menu_thin_border_top = "Textures\\menu_thin_border_top.tga",
    menu_thin_border_top_left_corner = "Textures\\menu_thin_border_top_left_corner.tga",
    menu_thin_border_top_right_corner = "Textures\\menu_thin_border_top_right_corner.tga",
    scroll = "Textures\\scroll.tga",
    target = "Textures\\target.tga",
    tx_a_glass_emerald = "Textures\\tx_a_glass_emerald.tga",
    tx_ashl_lantern_01 = "Textures\\tx_ashl_lantern_01.tga",
    tx_ashl_lantern_02 = "Textures\\tx_ashl_lantern_02.tga",
    tx_ashl_lantern_03 = "Textures\\tx_ashl_lantern_03.tga",
    tx_ashl_lantern_04 = "Textures\\tx_ashl_lantern_04.tga",
    tx_ashl_lantern_05 = "Textures\\tx_ashl_lantern_05.tga",
    tx_ashl_lantern_06 = "Textures\\tx_ashl_lantern_06.tga",
    tx_ashl_lantern_07 = "Textures\\tx_ashl_lantern_07.tga",
    tx_banner_hlaalu_01 = "Textures\\tx_banner_hlaalu_01.tga",
    tx_banner_redoran_01 = "Textures\\tx_banner_redoran_01.tga",
    tx_banner_temple_01 = "Textures\\tx_banner_temple_01.tga",
    tx_banner_temple_02 = "Textures\\tx_banner_temple_02.tga",
    tx_banner_temple_03 = "Textures\\tx_banner_temple_03.tga",
    tx_bannerd_alchemy_01 = "Textures\\tx_bannerd_alchemy_01.tga",
    tx_bannerd_clothing_01 = "Textures\\tx_bannerd_clothing_01.tga",
    tx_bannerd_danger_01 = "Textures\\tx_bannerd_danger_01.tga",
    tx_bannerd_goods_01 = "Textures\\tx_bannerd_goods_01.tga",
    tx_bannerd_tavern_01 = "Textures\\tx_bannerd_tavern_01.tga",
    tx_bannerd_w_a_shop_01 = "Textures\\tx_bannerd_w_a_shop_01.tga",
    tx_bannerd_welcome_01 = "Textures\\tx_bannerd_welcome_01.tga",
    tx_block_adobe_brown_02 = "Textures\\tx_block_adobe_brown_02.tga",
    tx_block_adobe_redbrown_01 = "Textures\\tx_block_adobe_redbrown_01.tga",
    tx_block_adobe_white_01 = "Textures\\tx_block_adobe_white_01.tga",
    tx_block_metal_gold_01 = "Textures\\tx_block_metal_gold_01.tga",
    tx_c_robecommon03a_c_beltbutton = "Textures\\tx_c_robecommon03a_c_beltbutton.tga",
    tx_c_robecommon03b_c_jewel = "Textures\\tx_c_robecommon03b_c_jewel.tga",
    tx_c_robeextra01_c_jewel = "Textures\\tx_c_robeextra01_c_jewel.tga",
    tx_c_robeextra01r_c_jewel = "Textures\\tx_c_robeextra01r_c_jewel.tga",
    tx_c_robeextra01t_c_jewel = "Textures\\tx_c_robeextra01t_c_jewel.tga",
    tx_c_t_akatosh_01 = "Textures\\tx_c_t_akatosh_01.tga",
    tx_c_t_apprentice_01 = "Textures\\tx_c_t_apprentice_01.tga",
    tx_c_t_arkay_01 = "Textures\\tx_c_t_arkay_01.tga",
    tx_c_t_dibella_01 = "Textures\\tx_c_t_dibella_01.tga",
    tx_c_t_golem_01 = "Textures\\tx_c_t_golem_01.tga",
    tx_c_t_julianos_01 = "Textures\\tx_c_t_julianos_01.tga",
    tx_c_t_kynareth_01 = "Textures\\tx_c_t_kynareth_01.tga",
    tx_c_t_lady_01 = "Textures\\tx_c_t_lady_01.tga",
    tx_c_t_lord_01 = "Textures\\tx_c_t_lord_01.tga",
    tx_c_t_lover_01 = "Textures\\tx_c_t_lover_01.tga",
    tx_c_t_mara_01 = "Textures\\tx_c_t_mara_01.tga",
    tx_c_t_ritual_01 = "Textures\\tx_c_t_ritual_01.tga",
    tx_c_t_shadow_01 = "Textures\\tx_c_t_shadow_01.tga",
    tx_c_t_steed_01 = "Textures\\tx_c_t_steed_01.tga",
    tx_c_t_stendarr_01 = "Textures\\tx_c_t_stendarr_01.tga",
    tx_c_t_thief_01 = "Textures\\tx_c_t_thief_01.tga",
    tx_c_t_tower_01 = "Textures\\tx_c_t_tower_01.tga",
    tx_c_t_warrior_01 = "Textures\\tx_c_t_warrior_01.tga",
    tx_c_t_wizard_01 = "Textures\\tx_c_t_wizard_01.tga",
    tx_c_t_zenithar_01 = "Textures\\tx_c_t_zenithar_01.tga",
    tx_creature_goldsipder04 = "Textures\\tx_creature_goldsipder04.tga",
    tx_crystal_01 = "Textures\\tx_crystal_01.tga",
    tx_crystal_02 = "Textures\\tx_crystal_02.tga",
    tx_crystal_03 = "Textures\\tx_crystal_03.tga",
    tx_de_banner_ald_velothi = "Textures\\tx_de_banner_ald_velothi.tga",
    tx_de_banner_book_01 = "Textures\\tx_de_banner_book_01.tga",
    tx_de_banner_gnaar_mok = "Textures\\tx_de_banner_gnaar_mok.tga",
    tx_de_banner_hla_oad = "Textures\\tx_de_banner_hla_oad.tga",
    tx_de_banner_khull = "Textures\\tx_de_banner_khull.tga",
    tx_de_banner_pawn_01 = "Textures\\tx_de_banner_pawn_01.tga",
    tx_de_banner_sadrith_mora = "Textures\\tx_de_banner_sadrith_mora.tga",
    tx_de_banner_tel_aruhn = "Textures\\tx_de_banner_tel_aruhn.tga",
    tx_de_banner_tel_branora = "Textures\\tx_de_banner_tel_branora.tga",
    tx_de_banner_tel_fyr = "Textures\\tx_de_banner_tel_fyr.tga",
    tx_de_banner_tel_mora = "Textures\\tx_de_banner_tel_mora.tga",
    tx_de_banner_tel_vos = "Textures\\tx_de_banner_tel_vos.tga",
    tx_de_banner_telvani_01 = "Textures\\tx_de_banner_telvani_01.tga",
    tx_de_banner_vos = "Textures\\tx_de_banner_vos.tga",
    tx_default = "Textures\\tx_default.tga",
    tx_dwrv_golem10 = "Textures\\tx_dwrv_golem10.tga",
    tx_dwrv_golem20 = "Textures\\tx_dwrv_golem20.tga",
    tx_dwrv_obs_sky00 = "Textures\\tx_dwrv_obs_sky00.tga",
    tx_emerald00 = "Textures\\tx_emerald00.tga",
    tx_fabric_tapestry = "Textures\\tx_fabric_tapestry.tga",
    tx_fabric_tapestry_01 = "Textures\\tx_fabric_tapestry_01.tga",
    tx_fabric_tapestry_02 = "Textures\\tx_fabric_tapestry_02.tga",
    tx_fabric_tapestry_03 = "Textures\\tx_fabric_tapestry_03.tga",
    tx_fabric_tapestry_04 = "Textures\\tx_fabric_tapestry_04.tga",
    tx_flag_imp_01 = "Textures\\tx_flag_imp_01.tga",
    tx_fresco_exodus_01 = "Textures\\tx_fresco_exodus_01.tga",
    tx_fresco_newtribunal_01 = "Textures\\tx_fresco_newtribunal_01.tga",
    tx_frost_salt_01 = "Textures\\tx_frost_salt_01.tga",
    tx_gem_diamond_01 = "Textures\\tx_gem_diamond_01.tga",
    tx_gem_emerald_01 = "Textures\\tx_gem_emerald_01.tga",
    tx_gem_pearl_01 = "Textures\\tx_gem_pearl_01.tga",
    tx_gem_rawebony = "Textures\\tx_gem_rawebony.tga",
    tx_gem_ruby_01 = "Textures\\tx_gem_ruby_01.tga",
    tx_gg_fence_01 = "Textures\\tx_gg_fence_01.tga",
    tx_gg_fence_02 = "Textures\\tx_gg_fence_02.tga",
    tx_longboatsail02 = "Textures\\tx_longboatsail02.tga",
    tx_menu_4x4white = "Textures\\tx_menu_4x4white.tga",
    tx_menu_8x8black = "Textures\\tx_menu_8x8black.tga",
    tx_menu_8x8grad = "Textures\\tx_menu_8x8grad.tga",
    tx_menubook = "Textures\\tx_menubook.tga",
    tx_menubook_bookmark = "Textures\\tx_menubook_bookmark.tga",
    tx_menubook_cancel_idle = "Textures\\tx_menubook_cancel_idle.tga",
    tx_menubook_cancel_over = "Textures\\tx_menubook_cancel_over.tga",
    tx_menubook_cancel_pressed = "Textures\\tx_menubook_cancel_pressed.tga",
    tx_menubook_close_idle = "Textures\\tx_menubook_close_idle.tga",
    tx_menubook_close_over = "Textures\\tx_menubook_close_over.tga",
    tx_menubook_close_pressed = "Textures\\tx_menubook_close_pressed.tga",
    tx_menubook_journal_idle = "Textures\\tx_menubook_journal_idle.tga",
    tx_menubook_journal_over = "Textures\\tx_menubook_journal_over.tga",
    tx_menubook_journal_pressed = "Textures\\tx_menubook_journal_pressed.tga",
    tx_menubook_next_idle = "Textures\\tx_menubook_next_idle.tga",
    tx_menubook_next_over = "Textures\\tx_menubook_next_over.tga",
    tx_menubook_next_pressed = "Textures\\tx_menubook_next_pressed.tga",
    tx_menubook_options_idle = "Textures\\tx_menubook_options_idle.tga",
    tx_menubook_options_over = "Textures\\tx_menubook_options_over.tga",
    tx_menubook_options_pressed = "Textures\\tx_menubook_options_pressed.tga",
    tx_menubook_prev_idle = "Textures\\tx_menubook_prev_idle.tga",
    tx_menubook_prev_over = "Textures\\tx_menubook_prev_over.tga",
    tx_menubook_prev_pressed = "Textures\\tx_menubook_prev_pressed.tga",
    tx_menubook_quests_active_idle = "Textures\\tx_menubook_quests_active_idle.tga",
    tx_menubook_quests_active_over = "Textures\\tx_menubook_quests_active_over.tga",
    tx_menubook_quests_active_pressed = "Textures\\tx_menubook_quests_active_pressed.tga",
    tx_menubook_quests_all_idle = "Textures\\tx_menubook_quests_all_idle.tga",
    tx_menubook_quests_all_over = "Textures\\tx_menubook_quests_all_over.tga",
    tx_menubook_quests_all_pressed = "Textures\\tx_menubook_quests_all_pressed.tga",
    tx_menubook_quests_idle = "Textures\\tx_menubook_quests_idle.tga",
    tx_menubook_quests_over = "Textures\\tx_menubook_quests_over.tga",
    tx_menubook_quests_pressed = "Textures\\tx_menubook_quests_pressed.tga",
    tx_menubook_take_idle = "Textures\\tx_menubook_take_idle.tga",
    tx_menubook_take_over = "Textures\\tx_menubook_take_over.tga",
    tx_menubook_take_pressed = "Textures\\tx_menubook_take_pressed.tga",
    tx_menubook_topics_idle = "Textures\\tx_menubook_topics_idle.tga",
    tx_menubook_topics_over = "Textures\\tx_menubook_topics_over.tga",
    tx_menubook_topics_pressed = "Textures\\tx_menubook_topics_pressed.tga",
    tx_misc_lantern_paper_01 = "Textures\\tx_misc_lantern_paper_01.tga",
    tx_misc_lantern_paper_02 = "Textures\\tx_misc_lantern_paper_02.tga",
    tx_misc_lantern_paper_03 = "Textures\\tx_misc_lantern_paper_03.tga",
    tx_misc_lantern_paper_04 = "Textures\\tx_misc_lantern_paper_04.tga",
    tx_misc_lantern_paper_05 = "Textures\\tx_misc_lantern_paper_05.tga",
    tx_mooncircle_full_m = "Textures\\tx_mooncircle_full_m.tga",
    tx_mooncircle_full_s = "Textures\\tx_mooncircle_full_s.tga",
    tx_mooncircle_half_wan_m = "Textures\\tx_mooncircle_half_wan_m.tga",
    tx_mooncircle_half_wan_s = "Textures\\tx_mooncircle_half_wan_s.tga",
    tx_mooncircle_half_wax_m = "Textures\\tx_mooncircle_half_wax_m.tga",
    tx_mooncircle_half_wax_s = "Textures\\tx_mooncircle_half_wax_s.tga",
    tx_mooncircle_new = "Textures\\tx_mooncircle_new.tga",
    tx_mooncircle_one_wan_m = "Textures\\tx_mooncircle_one_wan_m.tga",
    tx_mooncircle_one_wan_s = "Textures\\tx_mooncircle_one_wan_s.tga",
    tx_mooncircle_one_wax_m = "Textures\\tx_mooncircle_one_wax_m.tga",
    tx_mooncircle_one_wax_s = "Textures\\tx_mooncircle_one_wax_s.tga",
    tx_mooncircle_three_wan_m = "Textures\\tx_mooncircle_three_wan_m.tga",
    tx_mooncircle_three_wan_s = "Textures\\tx_mooncircle_three_wan_s.tga",
    tx_mooncircle_three_wax_m = "Textures\\tx_mooncircle_three_wax_m.tga",
    tx_mooncircle_three_wax_s = "Textures\\tx_mooncircle_three_wax_s.tga",
    tx_redoran_floor_01 = "Textures\\tx_redoran_floor_01.tga",
    tx_redoran_hut_00 = "Textures\\tx_redoran_hut_00.tga",
    tx_redoran_marble_red = "Textures\\tx_redoran_marble_red.tga",
    tx_redoran_marble_white = "Textures\\tx_redoran_marble_white.tga",
    tx_ring00 = "Textures\\tx_ring00.tga",
    tx_ring10 = "Textures\\tx_ring10.tga",
    tx_saint_aralor_01 = "Textures\\tx_saint_aralor_01.tga",
    tx_saint_deyln_01 = "Textures\\tx_saint_deyln_01.tga",
    tx_saint_felms_01 = "Textures\\tx_saint_felms_01.tga",
    tx_saint_llothis_01 = "Textures\\tx_saint_llothis_01.tga",
    tx_saint_meris_01 = "Textures\\tx_saint_meris_01.tga",
    tx_saint_nerevar_01 = "Textures\\tx_saint_nerevar_01.tga",
    tx_saint_olms_01 = "Textures\\tx_saint_olms_01.tga",
    tx_saint_relms_01 = "Textures\\tx_saint_relms_01.tga",
    tx_saint_rilms_01 = "Textures\\tx_saint_rilms_01.tga",
    tx_saint_roris_01 = "Textures\\tx_saint_roris_01.tga",
    tx_saint_seryn_01 = "Textures\\tx_saint_seryn_01.tga",
    tx_saint_veloth_01 = "Textures\\tx_saint_veloth_01.tga",
    tx_saint_vivec_01 = "Textures\\tx_saint_vivec_01.tga",
    tx_scroll_bar = "Textures\\tx_scroll_bar.tga",
    tx_scroll_button = "Textures\\tx_scroll_button.tga",
    tx_scroll_close = "Textures\\tx_scroll_close.tga",
    tx_scroll_fleur = "Textures\\tx_scroll_fleur.tga",
    tx_scroll_take = "Textures\\tx_scroll_take.tga",
    tx_sign_alchemy_01 = "Textures\\tx_sign_alchemy_01.tga",
    tx_sign_arms_01 = "Textures\\tx_sign_arms_01.tga",
    tx_sign_clothing_01 = "Textures\\tx_sign_clothing_01.tga",
    tx_sign_goods_01 = "Textures\\tx_sign_goods_01.tga",
    tx_sign_guild_fight_01 = "Textures\\tx_sign_guild_fight_01.tga",
    tx_sign_guild_mage_01 = "Textures\\tx_sign_guild_mage_01.tga",
    tx_sign_inn_01 = "Textures\\tx_sign_inn_01.tga",
    tx_sign_pawn_01 = "Textures\\tx_sign_pawn_01.tga",
    tx_signpost_wood_01 = "Textures\\tx_signpost_wood_01.tga",
    tx_soulgem_common = "Textures\\tx_soulgem_common.tga",
    tx_soulgem_grand = "Textures\\tx_soulgem_grand.tga",
    tx_soulgem_greater = "Textures\\tx_soulgem_greater.tga",
    tx_soulgem_lesser = "Textures\\tx_soulgem_lesser.tga",
    tx_soulgem_petty = "Textures\\tx_soulgem_petty.tga",
    tx_stars = "Textures\\tx_stars.tga",
    tx_stars_mage = "Textures\\tx_stars_mage.tga",
    tx_stars_nebula = "Textures\\tx_stars_nebula.tga",
    tx_stars_nebula2 = "Textures\\tx_stars_nebula2.tga",
    tx_stars_nebula3 = "Textures\\tx_stars_nebula3.tga",
    tx_stars_thief = "Textures\\tx_stars_thief.tga",
    tx_stars_warrior = "Textures\\tx_stars_warrior.tga",
    tx_steam_centurions_35 = "Textures\\tx_steam_centurions_35.tga",
    tx_sun_05 = "Textures\\tx_sun_05.tga",
    tx_sun_flash_grey_05 = "Textures\\tx_sun_flash_grey_05.tga",
    tx_w_crystal_blade = "Textures\\tx_w_crystal_blade.tga",
    tx_w_dwemer_deco = "Textures\\tx_w_dwemer_deco.tga",
    tx_w_magnus03 = "Textures\\tx_w_magnus03.tga",
    tx_wall_workedstone_01 = "Textures\\tx_wall_workedstone_01.tga",
    tx_wax_aqua_02 = "Textures\\tx_wax_aqua_02.tga",
    tx_wax_black_01 = "Textures\\tx_wax_black_01.tga",
    tx_wax_green_01 = "Textures\\tx_wax_green_01.tga",
    tx_wax_green_02 = "Textures\\tx_wax_green_02.tga",
    tx_wax_green_03 = "Textures\\tx_wax_green_03.tga",
    tx_wax_purple_01 = "Textures\\tx_wax_purple_01.tga",
    tx_wax_red_02 = "Textures\\tx_wax_red_02.tga",
    tx_wg_cobblestones_01 = "Textures\\tx_wg_cobblestones_01.tga",
    tx_wg_road_01 = "Textures\\tx_wg_road_01.tga",
    tx_wheat00 = "Textures\\tx_wheat00.tga",
    tx_wood_cherry = "Textures\\tx_wood_cherry.tga",
    tx_wood_cherryfaded = "Textures\\tx_wood_cherryfaded.tga",
    tx_wood_cherryplanks = "Textures\\tx_wood_cherryplanks.tga",
    tx_wood_wethered = "Textures\\tx_wood_wethered.tga",
    tx_wood_wormridden = "Textures\\tx_wood_wormridden.tga",
    tx_wood_wornfloor_01 = "Textures\\tx_wood_wornfloor_01.tga",
    tx_woodfloor_brown = "Textures\\tx_woodfloor_brown.tga",
    vfx_crystal = "Textures\\vfx_crystal.tga",
    vfx_icecrystal02 = "Textures\\vfx_icecrystal02.tga",
    vfx_icestar = "Textures\\vfx_icestar.tga",
    vfx_ill_flare01 = "Textures\\vfx_ill_flare01.tga",
    vfx_lightningrod = "Textures\\vfx_lightningrod.tga",
    vfx_lightningrod02 = "Textures\\vfx_lightningrod02.tga",
    vfx_lightningrod03 = "Textures\\vfx_lightningrod03.tga",
    vfx_lightningrod04 = "Textures\\vfx_lightningrod04.tga",
    vfx_lightningrod05 = "Textures\\vfx_lightningrod05.tga",
    vfx_myst_glow = "Textures\\vfx_myst_glow.tga",
    vfx_rest_glow = "Textures\\vfx_rest_glow.tga",
    vfx_restbolt = "Textures\\vfx_restbolt.tga",
    vfx_restore_glow = "Textures\\vfx_restore_glow.tga",
    vfx_spark = "Textures\\vfx_spark.tga",
    vfx_star02 = "Textures\\vfx_star02.tga",
    vfx_star_blue = "Textures\\vfx_star_blue.tga",
    vfx_starglow = "Textures\\vfx_starglow.tga",
    vfx_starspike = "Textures\\vfx_starspike.tga",
    vfx_summon = "Textures\\vfx_summon.tga",
    vfx_summon_glow = "Textures\\vfx_summon_glow.tga",
    vfx_tgtdmg = "Textures\\vfx_tgtdmg.tga",
    vfx_whitestar = "Textures\\vfx_whitestar.tga",
    vfx_whitestar02 = "Textures\\vfx_whitestar02.tga"
  }

return bs
