local ____lualib = require("lualib_bundle")
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local ____game_config = require("main.game_config")
local GAME_CONSTS = ____game_config.GAME_CONSTS
local ____array = require("utils.array")
local array = ____array.array
local ____FieldGenerator = require("logic.advanced.FieldGenerator")
local make_card_list = ____FieldGenerator.make_card_list
local ____utils = require("logic.utils")
local deep_copy = ____utils.deep_copy
local get_random_numbers = ____utils.get_random_numbers
function ____exports.GameStateManager(_state)
    local open_card, is_home, set_open_card, state, is_open_card, stopka
    function open_card(card_idx, is_open)
        if state.cards[card_idx] ~= nil then
            state.cards[card_idx].is_open = is_open
        end
    end
    function is_home(stack_id)
        return __TS__ArrayIncludes(GAME_CONSTS.values.homes_ids, stack_id)
    end
    function set_open_card(card_id, is_open)
        if is_open == nil then
            is_open = true
        end
        open_card(card_id, is_open)
    end
    local dc_card_list = {}
    state = _state
    local states_history = {}
    local function set_state(_state)
        state = deep_copy(_state)
    end
    local function init_cards(init_stacks)
        if init_stacks == nil then
            init_stacks = true
        end
        if #dc_card_list > 0 then
            array.clear(dc_card_list)
        end
        local cards = make_card_list()
        for ____, card in ipairs(cards) do
            dc_card_list[#dc_card_list + 1] = card
        end
        if init_stacks then
            do
                local i = 0
                while i < GAME_CONSTS.values.stack_count do
                    state.stack_ids:push({})
                    i = i + 1
                end
            end
            state.home = {{}, {}, {}, {}}
            state.free_cells = {{}, {}, {}, {}}
        end
    end
    local function add_to_stack(id_stack, id_card)
        state.stack_ids[id_stack]:push(id_card)
    end
    local function open_last_card(stack)
        if #stack > 0 and stack ~= state.stopka then
            local card_id = array.last(stack)
            state.cards[card_id].is_open = true
        end
    end
    --- Двигает карты по стекам
    local function move(from, _to, card_indexes)
        local is_to_id_stack = type(_to) == "number"
        local is_move_to_home = is_to_id_stack and is_home(_to + 1)
        local function to_stack()
            local stack = {}
            if is_to_id_stack then
                if __TS__ArrayIncludes(GAME_CONSTS.values.free_cells_ids, _to + 1) then
                    stack = state.free_cells[_to + 1 - GAME_CONSTS.values.free_cells_ids[1]]
                elseif is_move_to_home then
                    stack = state.home[_to + 1 - GAME_CONSTS.values.homes_ids[1]]
                elseif GAME_CONSTS.values.stopka_id == _to + 1 then
                    stack = state.stopka
                else
                    stack = state.stack_ids[_to]
                end
            else
                stack = _to
            end
            return stack
        end
        local to_array = to_stack()
        for ____, card_idx in ipairs(card_indexes) do
            to_array:push(from[card_idx + 1])
        end
        array.removeIndexes(from, card_indexes)
    end
    local function move_one_card(from_stack, to_stack_id, card_idx)
        move(from_stack, to_stack_id, {card_idx})
    end
    local function move_cards_to_stack(from_stack, to_stack_id, card_id)
        if card_id == nil then
            card_id = array.last(from_stack)
        end
        local card_indexes = {}
        for i = __TS__ArrayIndexOf(from_stack, card_id), #from_stack - 1 do
            if is_open_card(from_stack[i + 1]) then
                card_indexes[#card_indexes + 1] = i
            end
        end
        move(from_stack, to_stack_id, card_indexes)
    end
    local function move_to_reserve(from_stack)
        while #from_stack > 0 do
            if from_stack[#from_stack] ~= nil then
                state.cards[from_stack[#from_stack]].is_movable = false
            end
            move_one_card(from_stack, GAME_CONSTS.values.stopka_id - 1, #from_stack - 1)
        end
    end
    is_open_card = function(card_id)
        local ____temp_0
        if card_id == -1 then
            ____temp_0 = false
        else
            ____temp_0 = state.cards[card_id].is_open
        end
        return ____temp_0
    end
    local function get_stack(stack_id)
        local _stack_id = stack_id - 1
        if state.stack_ids[_stack_id] ~= nil then
            return state.stack_ids[_stack_id]
        end
        if __TS__ArrayIncludes(GAME_CONSTS.values.homes_ids, stack_id) then
            return state.home[stack_id - GAME_CONSTS.values.homes_ids[1]]
        end
        if __TS__ArrayIncludes(GAME_CONSTS.values.free_cells_ids, stack_id) then
            return state.free_cells[stack_id - GAME_CONSTS.values.free_cells_ids[1]]
        end
        if stack_id == GAME_CONSTS.values.stopka_id then
            return state.stopka
        end
    end
    local function find_stack_id(card_id)
        do
            local i = 0
            while i < state.stack_ids.length do
                local cards = state.stack_ids[i]
                if cards:includes(card_id) then
                    return i
                end
                i = i + 1
            end
        end
        return -1
    end
    local function find_stack(card_id, find_in_homes)
        if find_in_homes == nil then
            find_in_homes = true
        end
        do
            local i = 0
            while i < state.stack_ids.length do
                local cards = state.stack_ids[i]
                if cards:includes(card_id) then
                    return cards
                end
                i = i + 1
            end
        end
        for ____, fc in __TS__Iterator(state.free_cells) do
            if fc:includes(card_id) then
                return fc
            end
        end
        if find_in_homes then
            local filtered_home = state.home:filter(function(h) return h:includes(card_id) end)
            local is_in_home = filtered_home ~= nil
            if is_in_home then
                return filtered_home
            end
        end
        if state.stopka:find(function(c) return c == card_id end) ~= nil then
            return state.stopka
        end
        return nil
    end
    local function get_homes()
        return state.home
    end
    local function get_empty_free_cells_count()
        return state.free_cells:filter(function(c) return c.length == 0 end).length
    end
    local function get_dc_card(id)
        return dc_card_list[id + 1]
    end
    local function record_cur_state()
        local _state = deep_copy(state)
        states_history[#states_history + 1] = _state
    end
    local function clear_state_history()
        array.clear(states_history)
    end
    local function move_card_to_stack(to_stack_idx, card_id, from)
        local to_stack_id = to_stack_idx - 1
        local from_stack = from ~= nil and from or find_stack(card_id)
        if from_stack ~= nil then
            move_cards_to_stack(from_stack, to_stack_id, card_id)
        end
    end
    local function is_A(card_id)
        return get_dc_card(card_id).nom == "t"
    end
    local function get_last_closed_card_idx()
        return array.last(state.stopka)
    end
    local function close_all()
        for ____, id in __TS__Iterator(state.stopka:concat()) do
            set_open_card(id, false)
        end
        state.stopka:reverse()
    end
    local function is_all_opened()
        return state.stopka.length == 0
    end
    local function add_card(id)
        state.stopka:push(id)
    end
    local function take_card()
        local card_id = array.pop(state.stopka)
        return card_id
    end
    local function take_card_id(id)
        local idx = state.stopka:indexOf(id)
        state.stopka:splice(idx, 1)
        return id
    end
    local function stopka_init()
        local id_cards = get_random_numbers(#dc_card_list)
        for ____, i in ipairs(id_cards) do
            state.cards:push({is_open = false, is_movable = false})
            local id = id_cards[i + 1]
            stopka.add_card(id)
        end
    end
    stopka = {
        get_last_closed_card_idx = get_last_closed_card_idx,
        set_open_card = set_open_card,
        take_card_id = take_card_id,
        add_card = add_card,
        take_card = take_card,
        is_all_opened = is_all_opened,
        close_all = close_all,
        init = stopka_init
    }
    return {
        move = move,
        stopka = stopka,
        dc_card_list = dc_card_list,
        get_game_state = function() return state end,
        get_states_history = function() return states_history end,
        init_cards = init_cards,
        set_state = set_state,
        open_card = open_card,
        get_dc_card = get_dc_card,
        open_last_card = open_last_card,
        move_cards_to_stack = move_cards_to_stack,
        find_stack = find_stack,
        is_home = is_home,
        get_stack = get_stack,
        is_open_card = is_open_card,
        add_to_stack = add_to_stack,
        move_one_card = move_one_card,
        record_cur_state = record_cur_state,
        clear_state_history = clear_state_history,
        move_card_to_stack = move_card_to_stack,
        get_homes = get_homes,
        get_empty_free_cells_count = get_empty_free_cells_count,
        move_to_reserve = move_to_reserve,
        is_A = is_A,
        find_stack_id = find_stack_id
    }
end
return ____exports
