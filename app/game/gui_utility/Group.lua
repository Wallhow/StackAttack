local ____lualib = require("lualib_bundle")
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
local ____array = require("utils.array")
local array = ____array.array
--- Объект объединяющий в группу ноды, работает примерно так же как друид статик груп
-- 
-- @param root_node
-- @param children Group полностью поддерживает пока только пивоты W, E и Center, c с остальными может вести себя не так как ожидается'
-- @returns
function ____exports.GroupVer(root_node, children)
    local pad, offset, apply, get_total_size, pivot, flat_pivot, padding, start_offset, _this
    function pad(x)
        padding = x
        return _this
    end
    function offset(x)
        start_offset = x
        return _this
    end
    function apply()
        local acc_offset = {start_offset}
        local total_sizes = {}
        for ____, child_index in ipairs(array.indexes(children)) do
            local child_list = children[child_index + 1]
            local total_size = get_total_size(child_list)
            total_sizes[#total_sizes + 1] = total_size
            if #child_list > 1 then
                __TS__ArraySort(
                    child_list,
                    function(____, a, b)
                        local size_a = gui.get_size(a)
                        local size_b = gui.get_size(b)
                        local scale_a = gui.get_scale(a)
                        local scale_b = gui.get_scale(b)
                        local area_a = size_a.x * scale_a.x * (size_a.y * scale_a.y)
                        local area_b = size_b.x * scale_b.x * (size_b.y * scale_b.y)
                        return area_b - area_a > 0 and 1 or -1
                    end
                )
            end
            for ____, child in ipairs(child_list) do
                if gui.get_parent(child) == root_node then
                    local y_offset = gui.get_size(root_node).y / 2
                    if not flat_pivot then
                        y_offset = y_offset * ((pivot == gui.PIVOT_NW or pivot == gui.PIVOT_NW) and 1 or -1)
                    else
                        y_offset = 0
                    end
                    timer.delay(
                        0,
                        false,
                        function() return gui.set_position(
                            child,
                            vmath.vector3(acc_offset[child_index + 1], y_offset, 0)
                        ) end
                    )
                end
            end
            local size_offset = gui.get_size(child_list[1]).x * gui.get_scale(child_list[1]).x
            if pivot ~= gui.PIVOT_CENTER then
                acc_offset[#acc_offset + 1] = array.last(acc_offset) + (size_offset + padding) * (pivot == gui.PIVOT_W and 1 or -1)
            else
                local offset = array.last(acc_offset) - total_sizes[child_index + 1] / 2
                acc_offset[#acc_offset + 1] = offset + size_offset + padding
            end
        end
    end
    function get_total_size(child_list)
        local sum = 0
        for ____, child in ipairs(child_list) do
            local size = gui.get_size(child).x * gui.get_scale(child).x
            sum = sum + size
        end
        return sum
    end
    pivot = gui.get_pivot(root_node)
    flat_pivot = pivot == gui.PIVOT_W or pivot == gui.PIVOT_E or pivot == gui.PIVOT_CENTER
    padding = 0
    start_offset = 0
    _this = {pad = pad, offset = offset, apply = apply}
    return _this
end
return ____exports
