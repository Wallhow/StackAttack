local ____exports = {}
local ____Buttons = require("game.gui_utility.Buttons")
local Buttons = ____Buttons.Buttons
local ____Tween = require("utils.defoldTweens.Tween")
local tween = ____Tween.tween
local ____utils = require("utils.utils")
local get_nodes = ____utils.get_nodes
function ____exports.SelectPackCountWindow(druid, callback_btns_pressed)
    local close, nodes, blocker
    function close()
        tween(nodes.window_pack_count).opacityTo(0.3, 0).call(function()
            gui.set_enabled(nodes.window_pack_count, false)
            blocker:set_enabled(false)
        end).start()
    end
    local names_node = {
        "pack_1/btn",
        "pack_2/btn",
        "pack_3/btn",
        "close/btn",
        "shadow",
        "window_pack_count"
    }
    nodes = get_nodes(names_node, "")
    blocker = druid:new_blocker(nodes.shadow)
    blocker:set_enabled(false)
    local btns = Buttons(druid, nodes, "/btn", "")
    btns["close/btn"]:on(close)
    for i = 1, 3 do
        local index_btn = i
        local key = ("pack_" .. tostring(i)) .. "/btn"
        btns[key]:on(function()
            callback_btns_pressed(index_btn)
        end)
    end
    local function show()
        gui.set_enabled(nodes.window_pack_count, true)
        blocker:set_enabled(true)
        tween(nodes.window_pack_count).opacityTo(0, 0).start()
        tween(nodes.window_pack_count).opacityTo(0.3, 1).start()
    end
    return {show = show, close = close}
end
return ____exports
