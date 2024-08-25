local ____lualib = require("lualib_bundle")
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayForEach = ____lualib.__TS__ArrayForEach
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____Selector = require("settings.Selector")
local Selector = ____Selector.Selector
local ____utils = require("utils.utils")
local hex2rgba = ____utils.hex2rgba
function ____exports.SelectorGroup(druid, setting_key, setting_values, icons, other)
    local bind_setting
    function bind_setting(setting, selector_item, value)
        selector_item.on(function()
            GameStorage.set(setting, value)
        end)
        if value == GameStorage.get(setting) then
            selector_item.select(true)
        end
    end
    local selectable_items_count = #setting_values
    local grid = druid:new_static_grid(setting_key .. "/item_container", "selectable_item/btn", selectable_items_count)
    local items = {}
    local function any_change_clbk()
    end
    for idx = 1, selectable_items_count do
        local sel_item = Selector(druid, "selectable_item", other and other.is_bg_disabled)
        local i = idx - 1
        if other ~= nil then
            if other.icon_scale ~= nil then
                gui.set_scale(
                    sel_item.nodes.icon,
                    vmath.vector3(other.icon_scale, other.icon_scale, other.icon_scale)
                )
            end
            if other.icon_colors ~= nil then
                gui.set_color(
                    sel_item.nodes.icon,
                    hex2rgba(other.icon_colors[i + 1])
                )
            end
        end
        if icons ~= nil then
            local icon = icons[i + 1]
            gui.play_flipbook(sel_item.nodes.icon, icon)
        end
        grid:add(sel_item.root_node, idx)
        bind_setting(setting_key, sel_item, setting_values[i + 1])
        items[#items + 1] = sel_item
        sel_item.on(function()
            any_change_clbk()
            local f = __TS__ArrayFilter(
                items,
                function(____, item) return item ~= sel_item end
            )
            __TS__ArrayForEach(
                f,
                function(____, item) return item.select(false) end
            )
        end)
    end
    local function on(callback)
        any_change_clbk = callback
    end
    local ____on_3 = on
    local ____array_2 = __TS__SparseArrayNew(unpack(__TS__ArrayMap(
        items,
        function(____, item) return item.druid_node end
    )))
    __TS__SparseArrayPush(____array_2, grid)
    return {
        on = ____on_3,
        druid_nodes = {__TS__SparseArraySpread(____array_2)},
        nodes = grid.nodes
    }
end
return ____exports
