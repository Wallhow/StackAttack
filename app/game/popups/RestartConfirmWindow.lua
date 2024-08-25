local ____exports = {}
local ____Tween = require("utils.defoldTweens.Tween")
local tween = ____Tween.tween
local ____utils = require("utils.utils")
local get_nodes = ____utils.get_nodes
local ____Buttons = require("game.gui_utility.Buttons")
local Buttons = ____Buttons.Buttons
function ____exports.RestartConfirmWindow(druid, close_cb)
    local no, yes, nodes, blocker, is_enabled
    function no(is_call_cb)
        if is_call_cb == nil then
            is_call_cb = true
        end
        tween(nodes.restart_popup).opacityTo(0.3, 0).call(function()
            is_enabled = false
            gui.set_enabled(nodes.restart_popup, false)
            blocker:set_enabled(false)
            gui.set_visible(nodes.center, false)
            if is_call_cb then
                close_cb()
            end
        end).start()
    end
    function yes()
        if GameStorage.get("tutorial_done") then
            EventBus.trigger("REPLAY")
            no(false)
        end
    end
    nodes = get_nodes({
        "restart_popup",
        "restart_yes/btn",
        "restart_no/btn",
        "center",
        "restart_text"
    })
    blocker = druid:new_blocker(nodes.center)
    blocker:set_enabled(false)
    local btns = Buttons(druid, nodes, "/btn")
    is_enabled = false
    local function init()
        btns["restart_no/btn"]:on(no)
        btns["restart_yes/btn"]:on(yes)
    end
    local function show()
        is_enabled = true
        gui.set_enabled(nodes.restart_popup, true)
        gui.set_visible(nodes.center, true)
        blocker:set_enabled(true)
        tween(nodes.restart_popup).opacityTo(0, 0).start()
        tween(nodes.restart_popup).opacityTo(0.3, 1).start()
    end
    init()
    return {
        show = show,
        close = no,
        is_enable = function() return is_enabled end
    }
end
return ____exports
