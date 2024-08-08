local cfg = require("BeefStranger.UI Tweaks.config")

require("BeefStranger.UI Tweaks.MenuRestWait")
require("BeefStranger.UI Tweaks.MenuBarter")
require("BeefStranger.UI Tweaks.QuickEsc")
require("BeefStranger.UI Tweaks.MenuHotkeys")

event.register("initialized", function()
    print("[MWSE:UI Tweaks] initialized")
end)
