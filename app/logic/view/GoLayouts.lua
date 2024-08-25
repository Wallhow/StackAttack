local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____game_config = require("main.game_config")
local GAME_CONSTS = ____game_config.GAME_CONSTS
local ____array = require("utils.array")
local array = ____array.array
--- Объект для работы с лайаутами го и лайаут зависимыми переменными
-- 
-- @param values - объект в котором прописываются лайаут зависимые переменные и их дефолтные значения
-- @returns Объект отвечающий за лайауты у Go объектов, а так же предоставляет хранилище для лайаут зависимых переменных
function ____exports.GoLayouts(values)
    local set_pos_card_counter, set_scale, set_color, goes, gm
    function set_pos_card_counter()
        local p = go.get_position(goes.go_stopka)
        p.x = p.x - 5
        p.y = p.y - 30
    end
    function set_scale(scale)
        go.set_scale(scale, goes.go_stopka)
        for ____, home in ipairs(goes.go_home) do
            go.set_scale(scale, home)
        end
        for ____, free_cell in ipairs(goes.go_free_cells) do
            go.set_scale(scale, free_cell)
        end
        local scale_for_stack_zones = vmath.vector3(scale.x, 3, scale.y)
        for ____, i in ipairs(array.indexes(goes.go_stacks)) do
            local stack_go = goes.go_stacks[i + 1]
            local stack_zone_go = goes.go_stacks_zones[i + 1]
            go.set_scale(scale, stack_go)
            go.set_scale(scale_for_stack_zones, stack_zone_go)
        end
    end
    function set_color(color, alpha)
        gm.set_color_hash(goes.go_stopka, color, alpha)
        for ____, home in ipairs(goes.go_home) do
            gm.set_color_hash(home, color, alpha)
        end
        for ____, free_cell in ipairs(goes.go_free_cells) do
            gm.set_color_hash(free_cell, color, alpha)
        end
        for ____, i in ipairs(array.indexes(goes.go_stacks)) do
            local stack_go = goes.go_stacks[i + 1]
            local stack_zone_go = goes.go_stacks_zones[i + 1]
            gm.set_color_hash(stack_go, color, alpha)
            gm.set_color_hash(stack_zone_go, color, 0)
        end
    end
    local default_values = {
        portrait = __TS__ObjectAssign({}, values),
        landscape = __TS__ObjectAssign({}, values)
    }
    local function rows()
        return GAME_CONFIG.is_portrait and 8 or 10
    end
    local win_width = 960
    local card_width = 195
    local card_height = 289
    local card_offset_x = 10
    goes = {}
    local function init(go_manager, go_list)
        goes = go_list
        gm = go_manager
    end
    local function get_game_sizes(is_portrait)
        local padding = is_portrait and 0 or 2
        local width = 960 / (rows() + padding) - (is_portrait and 0 or card_offset_x)
        local s = width / card_width
        local scale = vmath.vector3(s, s, s)
        local new_card_width = s * card_width
        local new_card_height = s * card_height
        local card_offset_y = new_card_height / 2
        return {
            width = width,
            scale = scale,
            new_card_width = new_card_width,
            new_card_height = new_card_height,
            card_offset_y = card_offset_y
        }
    end
    local function set_portrait_layout(offset_y)
        if offset_y == nil then
            offset_y = 0
        end
        local ____goes_0 = goes
        local go_home = ____goes_0.go_home
        local go_stacks = ____goes_0.go_stacks
        local go_stopka = ____goes_0.go_stopka
        local go_stacks_zones = ____goes_0.go_stacks_zones
        local go_free_cells = ____goes_0.go_free_cells
        local ____get_game_sizes_result_1 = get_game_sizes(true)
        local width = ____get_game_sizes_result_1.width
        local scale = ____get_game_sizes_result_1.scale
        local new_card_height = ____get_game_sizes_result_1.new_card_height
        local card_offset_y = ____get_game_sizes_result_1.card_offset_y
        local pos = vmath.vector3(0, 0, 0)
        local card_offset_x = 0
        local half_width_card = width / 2
        local min_offset_y = 90
        local _first_offset = width * 0.5
        pos.y = -(new_card_height + min_offset_y + offset_y * 40)
        local src_y = pos.y
        pos.y = -new_card_height / 2 - (min_offset_y + offset_y * 40)
        do
            local i = 0
            while i < #go_home do
                pos.x = win_width - half_width_card - (width * i + card_offset_x)
                go.set_position(pos, go_home[i + 1])
                i = i + 1
            end
        end
        do
            local i = 0
            while i < #go_free_cells do
                pos.x = half_width_card + (width * i + card_offset_x)
                go.set_position(pos, go_free_cells[i + 1])
                i = i + 1
            end
        end
        pos.x = win_width + (half_width_card + card_offset_x)
        pos.y = pos.y - (new_card_height + card_offset_x + 10)
        go.set_position(pos, go_stopka)
        local size_card = win_width / GAME_CONSTS.values.stack_count - card_offset_x
        local start_x = win_width / 2 - #go_stacks * (width + card_offset_x) / 2
        pos.y = src_y - size_card - _first_offset
        do
            local x = 0
            while x < #go_stacks do
                pos.x = start_x + width * x + _first_offset
                local g = go_stacks[x + 1]
                local g_zone = go_stacks_zones[x + 1]
                go.set_position(pos, g)
                gm.set_position_xy_hash(
                    g_zone,
                    pos.x,
                    pos.y + new_card_height / 2,
                    0.5,
                    1
                )
                x = x + 1
            end
        end
        set_pos_card_counter()
        set_color("#000", 0.3)
        set_scale(scale)
    end
    local function set_landscape_layout(offset_y)
        if offset_y == nil then
            offset_y = 0
        end
        local ____goes_2 = goes
        local go_home = ____goes_2.go_home
        local go_stacks = ____goes_2.go_stacks
        local go_stopka = ____goes_2.go_stopka
        local go_stacks_zones = ____goes_2.go_stacks_zones
        local go_free_cells = ____goes_2.go_free_cells
        local ____get_game_sizes_result_3 = get_game_sizes(false)
        local width = ____get_game_sizes_result_3.width
        local scale = ____get_game_sizes_result_3.scale
        local new_card_height = ____get_game_sizes_result_3.new_card_height
        local card_offset_y = ____get_game_sizes_result_3.card_offset_y
        local half_width_card = width / 2
        local pos = vmath.vector3(0, 0, 0)
        local card_offset_x = 2
        local min_offset_y = 85
        local _first_offset = (width + card_offset_x) * 0.5
        pos.y = -new_card_height / 2 - (min_offset_y + offset_y * 30)
        local start_x = win_width / 2 - #go_stacks * (width + card_offset_x) / 2
        local card_width = width + card_offset_x
        do
            local x = 0
            while x < #go_stacks do
                pos.x = start_x + card_width * x + _first_offset
                local g = go_stacks[x + 1]
                local g_zone = go_stacks_zones[x + 1]
                go.set_position(pos, g)
                gm.set_position_xy_hash(
                    g_zone,
                    pos.x,
                    pos.y + new_card_height / 2,
                    0.5,
                    1
                )
                x = x + 1
            end
        end
        pos.y = -new_card_height / 2 - (min_offset_y + offset_y * 30)
        pos.x = win_width - half_width_card - card_offset_x
        do
            local i = 0
            while i < #go_home do
                local j = i
                if i >= 2 then
                    pos.x = win_width - half_width_card - card_offset_x - card_width
                    pos.y = -new_card_height / 2 - (min_offset_y + offset_y * 30)
                    j = j - 2
                end
                pos.y = -new_card_height / 2 - (min_offset_y + offset_y * 30) - (new_card_height + offset_y) * j
                go.set_position(pos, go_home[i + 1])
                i = i + 1
            end
        end
        pos.x = half_width_card + card_offset_x
        do
            local i = 0
            while i < #go_free_cells do
                local j = i
                if i >= 2 then
                    pos.x = half_width_card + card_offset_x + card_width
                    pos.y = -new_card_height / 2 - (min_offset_y + offset_y * 30)
                    j = j - 2
                end
                pos.y = -new_card_height / 2 - (min_offset_y + offset_y * 30) - (new_card_height + offset_y) * j
                go.set_position(pos, go_free_cells[i + 1])
                i = i + 1
            end
        end
        pos.x = win_width + (half_width_card + card_offset_x)
        pos.y = pos.y - (new_card_height + card_offset_x + 10)
        go.set_position(pos, go_stopka)
        set_pos_card_counter()
        set_color("#000", 0.3)
        set_scale(scale)
    end
    local function change_layout(is_portret, offset_y)
        if offset_y == nil then
            offset_y = 0
        end
        local ____is_portret_4
        if is_portret then
            ____is_portret_4 = set_portrait_layout(offset_y)
        else
            ____is_portret_4 = set_landscape_layout(offset_y)
        end
    end
    --- В методе указываем к какому лайауту относятся задаваемые значения и переопределяем значения конкретных лайаут зависимых переменных
    -- 
    -- @param is_portrait
    -- @param layout_values
    local function set_values(is_portrait, layout_values)
        default_values[is_portrait and "portrait" or "landscape"] = __TS__ObjectAssign({}, values, layout_values)
    end
    local function get_values(is_portrait)
        return default_values[is_portrait and "portrait" or "landscape"]
    end
    return {
        init = init,
        get_game_sizes = function() return get_game_sizes(GAME_CONFIG.is_portrait) end,
        change_layout = change_layout,
        set_values = set_values,
        get_values = get_values
    }
end
return ____exports
