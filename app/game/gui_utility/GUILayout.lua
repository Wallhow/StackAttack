local ____lualib = require("lualib_bundle")
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
function ____exports.GUILayout(names_layout)
    local apply, resize, apply_layout_funcs, layouts_conditions_list, previous_layout, current_layout
    function apply(layout, ____type)
        if ____type == nil then
            ____type = 0
        end
        local width, height = window.get_size()
        if current_layout == nil then
            current_layout = {name = layout, type = ____type}
        else
            previous_layout = current_layout
            current_layout = {name = layout, type = ____type}
        end
        local apply_func = apply_layout_funcs[current_layout.name][current_layout.type]
        if apply_func ~= nil then
            apply_func(width, height)
        end
    end
    function resize(width, height)
        local condition = __TS__ArrayFind(
            layouts_conditions_list,
            function(____, val) return val.condition(width, height, current_layout, previous_layout) end
        )
        if condition ~= nil then
            if condition.layout.name ~= current_layout.name or condition.layout.type ~= current_layout.type then
                apply(condition.layout.name, condition.layout.type)
            end
        end
    end
    apply_layout_funcs = {}
    layouts_conditions_list = {}
    previous_layout = {}
    current_layout = {}
    local function set_apply_func(name_layout, func, ____type)
        if ____type == nil then
            ____type = 0
        end
        if apply_layout_funcs[name_layout] == nil then
            apply_layout_funcs[name_layout] = {}
        end
        apply_layout_funcs[name_layout][____type] = func
    end
    local function layout_changed(data)
        local width, height = window.get_size()
        resize(width, height)
    end
    local function set_layout_condition(layout, condition)
        layouts_conditions_list[#layouts_conditions_list + 1] = {layout = layout, condition = condition}
    end
    return {
        set_apply_func = set_apply_func,
        resize = resize,
        layout_changed = layout_changed,
        set_layout_condition = set_layout_condition,
        apply = apply
    }
end
return ____exports
