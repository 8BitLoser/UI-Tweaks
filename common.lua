local bs = {
    UpdateBarter = "bsUpdateBarter",
    keyStillDown = "bsKeyStillDown"
}

function bs.inspect(table)
    local inspect = require("inspect").inspect
    local bsF = debug.getinfo(1, "nSl")
    local bsC = debug.getinfo(2, "nSl")
    mwse.log("%s", inspect(table))
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
    activeColor = { 0.376, 0.439, 0.792 },
    activeOverColor = { 0.623, 0.662, 0.874 },
    activePressedColor = { 0.874, 0.886, 0.956 },
    answerColor = { 0.588, 0.196, 0.117 },
    answerPressedColor = { 0.952, 0.929, 0.866 },
    bigAnswerPressedColor = { 0.952, 0.929, 0.086 },
    blackColor = { 0, 0, 0 },
    bsLightGrey = { 0.839, 0.839, 0.839 },
    bsNiceRed = { 0.941, 0.38, 0.38 },
    bsPrettyBlue = { 0.235, 0.616, 0.949 },
    bsPrettyGreen = { 0.38, 0.941, 0.525 },
    bsRoyalPurple = { 0.714, 0.039, 0.902 },
    disabledColor = { 0.701, 0.658, 0.529 },
    fatigueColor = { 0, 0.588, 0.235 },
    focusColor = { 0.313, 0.313, 0.313 },
    healthColor = { 0.784, 0.235, 0.117 },
    healthNpcColor = { 1, 0.729, 0 },
    journalFinishedQuestColor = { 0.235, 0.235, 0.235 },
    journalFinishedQuestOverColor = { 0.392, 0.392, 0.392 },
    journalFinishedQuestPressedColor = { 0.862, 0.862, 0.862 },
    journalLinkColor = { 0.145, 0.192, 0.439 },
    journalTopicOverColor = { 0.227, 0.301, 0.686 },
    linkColor = { 0.439, 0.494, 0.811 },
    linkOverColor = { 0.560, 0.607, 0.854 },
    linkPressedColor = { 0.686, 0.721, 0.894 },
    magicColor = { 0.207, 0.270, 0.623 },
    miscColor = { 0, 0.803, 0.803 },
    normalColor = { 0.792, 0.647, 0.376 },
    positiveColor = { 0.874, 0.788, 0.623 },
    whiteColor = { 1, 1, 1 }
}

return bs
