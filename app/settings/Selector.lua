local ____exports = {}
local ____utils = require("utils.utils")
local get_nodes = ____utils.get_nodes
local ____Tween = require("utils.defoldTweens.Tween")
local tween = ____Tween.tween
function ____exports.Selector(druid, template_name, is_bg_off)
    if is_bg_off == nil then
        is_bg_off = false
    end
    local select, is_selected, anim
    function select(enabled)
        is_selected = enabled
        local anim_key = enabled and "select" or "unselect"
        for ____, tween in ipairs(anim[anim_key]) do
            tween.start(false)
        end
    end
    local node_clone = gui.clone_tree(gui.get_node(template_name .. "/btn"))
    local nodes = get_nodes({"bg", "sel", "icon", "btn"}, template_name, node_clone)
    local btns = druid:new_button(
        nodes.btn,
        function() return select(true) end
    )
    is_selected = false
    gui.set_enabled(nodes.btn, true)
    if is_bg_off then
        gui.set_enabled(nodes.bg, false)
    end
    anim = {
        select = {tween(nodes.sel).opacityTo(0, 0).opacityTo(0.1, 1)},
        unselect = {tween(nodes.sel).opacityTo(0.1, 0)}
    }
    return {
        on = function(callback) return btns.on_click:subscribe(callback) end,
        root_node = nodes.btn,
        nodes = nodes,
        select = select,
        druid_node = btns
    }
end
return ____exports
