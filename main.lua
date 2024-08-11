local cfg = require("BeefStranger.UI Tweaks.config")

require("BeefStranger.UI Tweaks.HelpMenu")
require("BeefStranger.UI Tweaks.MenuBarter")
require("BeefStranger.UI Tweaks.MenuDialog")
require("BeefStranger.UI Tweaks.MenuHotkeys")
-- require("BeefStranger.UI Tweaks.MenuMulti")
require("BeefStranger.UI Tweaks.MenuRepair")
require("BeefStranger.UI Tweaks.MenuRestWait")
require("BeefStranger.UI Tweaks.QuickEsc")

event.register("initialized", function()
    print("[MWSE:UI Tweaks] initialized")
end)
