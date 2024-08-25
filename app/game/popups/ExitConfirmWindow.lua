local ____exports = {}
local ____Tween = require("utils.defoldTweens.Tween")
local tween = ____Tween.tween
local ____utils = require("utils.utils")
local get_nodes = ____utils.get_nodes
local set_text = ____utils.set_text
local ____Buttons = require("game.gui_utility.Buttons")
local Buttons = ____Buttons.Buttons
function ____exports.ExitConfirmWindow(druid, close_cb)
    local close, exit, nodes, blocker, is_enabled
    function close()
        tween(nodes.exit_popup).opacityTo(0.3, 0).call(function()
            is_enabled = false
            gui.set_enabled(nodes.exit_popup, false)
            blocker:set_enabled(false)
            gui.set_visible(nodes.center, false)
            close_cb()
        end).start()
    end
    function exit()
        Ads.show_interstitial()
        Scene.load("menu")
    end
    nodes = get_nodes({
        "exit_popup",
        "exit_yes/btn",
        "exit_no/btn",
        "center",
        "exit_txt"
    })
    blocker = druid:new_blocker(nodes.center)
    blocker:set_enabled(false)
    local btns = Buttons(druid, nodes, "/btn")
    is_enabled = false
    local function init()
        btns["exit_no/btn"]:on(close)
        btns["exit_yes/btn"]:on(exit)
    end
    local function show()
        is_enabled = true
        set_text(
            "exit_txt",
            Lang.get_text("exit_txt")
        )
        gui.set_enabled(nodes.exit_popup, true)
        gui.set_visible(nodes.center, true)
        blocker:set_enabled(true)
        tween(nodes.exit_popup).opacityTo(0, 0).start()
        tween(nodes.exit_popup).opacityTo(0.3, 1).start()
    end
    init()
    return {
        show = show,
        close = close,
        is_enable = function() return is_enabled end
    }
end
return ____exports
