local cfg = require("BeefStranger.UI Tweaks.config")
local menu = require("BeefStranger.UI Tweaks.tes3Menus")

local Take = {}
function Take.Book()
    local book = tes3ui.findMenu(tes3ui.registerID("MenuBook"))
    if book then
        book:findChild("MenuBook_button_take"):triggerEvent("mouseClick")
    end
end
function Take.Scroll()
    local scroll = tes3ui.findMenu(tes3ui.registerID("MenuScroll"))
    if scroll then
        scroll:findChild("MenuBook_PickupButton"):triggerEvent("mouseClick")
    end
end

local function pickup()
    if cfg.enableTake and cfg.take.keyCode then
        Take.Scroll()
        Take.Book()
    end
end
event.register(tes3.event.keyDown, pickup)