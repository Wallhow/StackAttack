local ____exports = {}
local ____Tween = require("utils.defoldTweens.Tween")
local tween = ____Tween.tween
local ____utils = require("utils.utils")
local get_nodes = ____utils.get_nodes
local ____Buttons = require("game.gui_utility.Buttons")
local Buttons = ____Buttons.Buttons
function ____exports.TutorialWindow(____type, druid, close_cb)
    local close, nodes, blocker
    function close()
        tween(nodes.joker_tutorial).opacityTo(0.3, 0).call(function()
            gui.set_enabled(nodes.joker_tutorial, false)
            blocker:set_enabled(false)
            gui.set_visible(nodes.center, false)
            close_cb()
        end).start()
    end
    nodes = get_nodes({"close_tutorial/btn", "joker_tutorial", "center", "joker_tutorial_txt"})
    blocker = druid:new_blocker(nodes.center)
    blocker:set_enabled(false)
    local btns = Buttons(druid, nodes, "/btn")
    local function init()
        gui.set_text(
            nodes.joker_tutorial_txt,
            ____type == "joker" and Lang.get_text("joker_tutorial_txt") or Lang.get_text("magick_stick_tutorial_txt")
        )
        btns["close_tutorial/btn"]:on(close)
    end
    local function show()
        gui.set_enabled(nodes.joker_tutorial, true)
        gui.set_visible(nodes.center, true)
        blocker:set_enabled(true)
        tween(nodes.joker_tutorial).opacityTo(0, 0).start()
        tween(nodes.joker_tutorial).opacityTo(0.3, 1).start()
    end
    init()
    return {show = show, close = close}
end
return ____exports
