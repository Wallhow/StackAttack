local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArrayReverse = ____lualib.__TS__ArrayReverse
local __TS__ArrayForEach = ____lualib.__TS__ArrayForEach
local __TS__ArrayConcat = ____lualib.__TS__ArrayConcat
local __TS__ArrayEvery = ____lualib.__TS__ArrayEvery
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local ____exports = {}
local ____game_config = require("main.game_config")
local GAME_CONSTS = ____game_config.GAME_CONSTS
local ____array = require("utils.array")
local array = ____array.array
local ____card = require("logic.card")
local DcNums = ____card.DcNums
--- Отвечает за логику правил игры и перемещения карт по игровому полю на основе этих правил
-- 
-- @return
function ____exports.Solver()
    local get_valid_masts, get_pre_nom, _check_valid_order_card, is_movable, is_valid_move, get_moves_for_selected_card, is_pair_cards_valid_seq, _is_move_on_joker, _iterate_stacks, dc, sm, selected_card, movable_cards, move_validator
    function get_valid_masts(card_id)
        local red_group = {"b", "c"}
        local black_group = {"k", "p"}
        local opposite_mast_groups = {c = black_group, b = black_group, p = red_group, k = red_group}
        return opposite_mast_groups[dc[card_id + 1].mast]
    end
    function get_pre_nom(card_id)
        local dc_card = dc[card_id + 1]
        local nom = dc_card.nom
        local valid_nom = DcNums[__TS__ArrayIndexOf(DcNums, nom) + 1 + 1]
        return valid_nom
    end
    function _check_valid_order_card(card_index, stack)
        local splice_stack = __TS__ArraySplice(
            __TS__ArrayConcat(stack),
            card_index,
            #stack
        )
        local free_cell_count = sm:get_empty_free_cells_count()
        local is_valid_count_move_card = free_cell_count + 1 >= #stack - card_index
        local ____temp_0
        if not is_valid_count_move_card then
            ____temp_0 = false
        else
            ____temp_0 = __TS__ArrayEvery(
                splice_stack,
                function(____, card_id, index)
                    local next_card = splice_stack[index + 1 + 1]
                    if next_card ~= nil then
                        return is_pair_cards_valid_seq(card_id, next_card)
                    else
                        return true
                    end
                end
            )
        end
        return ____temp_0
    end
    function is_movable(card)
        return movable_cards[card]
    end
    function is_valid_move(to, card)
        if card == nil then
            card = selected_card
        end
        if card == -1 then
            return false
        end
        if not GameStorage.get("tutorial_done") then
            return move_validator.tutorial(to, card)
        end
        if __TS__ArrayIncludes(GAME_CONSTS.values.homes_ids, to) then
            return move_validator.to_home(to, card)
        end
        if __TS__ArrayIncludes(GAME_CONSTS.values.free_cells_ids, to) then
            return move_validator.to_free_cells(to, card)
        else
            if _is_move_on_joker(to) then
                return true
            end
            if dc[card + 1].is_joker then
                return true
            end
            return move_validator.to_stack(to, card)
        end
    end
    function get_moves_for_selected_card(card)
        if card == nil then
            card = selected_card
        end
        if card == -1 then
            return {}
        end
        local to_stacks = {}
        _iterate_stacks(function(i, stack)
            if is_valid_move(i + 1, card) and is_movable(card) then
                to_stacks[#to_stacks + 1] = i + 1
            end
        end)
        return to_stacks
    end
    function is_pair_cards_valid_seq(card_1, card_2)
        local valid_nom = get_pre_nom(card_2)
        local valid_masts = get_valid_masts(card_2)
        local mast_result = __TS__ArrayIncludes(valid_masts, dc[card_1 + 1].mast)
        return dc[card_1 + 1].nom == valid_nom and mast_result
    end
    function _is_move_on_joker(to_stack)
        local stack = sm:get_stack(to_stack)
        local last_card = array.last(stack)
        if last_card == nil then
            return false
        end
        local last_card_data = dc[last_card]
        return last_card_data.is_joker
    end
    function _iterate_stacks(action)
        local ____temp_3 = sm:get_game_state()
        local stack_ids = ____temp_3.stack_ids
        for ____, stack_index in ipairs(array.indexes(stack_ids)) do
            action(stack_index, stack_ids[stack_index])
        end
    end
    selected_card = -1
    movable_cards = {}
    local tutorial_valid_moves = nil
    local function init(game_state_manager)
        dc = game_state_manager.dc_card_list
        sm = game_state_manager
    end
    local function select_card(card_id)
        selected_card = card_id
    end
    local function reset_selected_card()
        selected_card = -1
    end
    local function get_selected_card()
        return selected_card
    end
    local function get_selected_stack()
        return sm:find_stack(selected_card)
    end
    local function get_automove()
        local move = nil
        for ____, stack in __TS__Iterator(sm:get_game_state().stack_ids) do
            if stack.length > 0 then
                local last_card = array.last(stack)
                for index = 0, 3 do
                    local home_id = GAME_CONSTS.values.homes_ids[1] + index
                    if is_valid_move(home_id, last_card) then
                        move = {stack = stack, first_card_index = stack.length - 1, home_id = home_id}
                        break
                    end
                end
            end
        end
        for ____, fc in __TS__Iterator(sm:get_game_state().free_cells) do
            if fc.length > 0 then
                local last_card = fc[0]
                for index = 0, 3 do
                    local home_id = GAME_CONSTS.values.homes_ids[1] + index
                    if is_valid_move(home_id, last_card) then
                        move = {stack = fc, first_card_index = 0, home_id = home_id}
                        break
                    end
                end
            end
        end
        return move
    end
    --- Перемещает последовательность карт в дом
    -- 
    -- @param sequence
    -- @param cbk колбек в котором необходимо передать функцию с изменениями стейта для того чтобы эти изменения сразу отображались
    local function move_sequence_to_home(sequence, cbk)
        local from_stack = sm:get_stack(sequence.stack + 1)
        local cards = __TS__ArraySplice(
            array.indexes(from_stack),
            sequence.first_card_index,
            13
        )
        for ____, card in ipairs(__TS__ArrayReverse(cards)) do
            cbk(function() return sm:move(
                from_stack,
                sm:get_game_state().home[0],
                {card}
            ) end)
        end
    end
    --- Перебирает стаки на поле и устанавливает для карт возможность перемещения в соответствии с правилами 
    -- . Работает в совокупности с методом 
    -- is_movable(card_id:number)
    local function calculate_movable_cards()
        movable_cards = {}
        _iterate_stacks(function(i, stack)
            for ____, card_index in ipairs(array.indexes(stack)) do
                local card = stack[card_index + 1]
                if sm:is_open_card(card) then
                    movable_cards[card] = _check_valid_order_card(card_index, stack)
                else
                    movable_cards[card] = false
                end
                sm:get_game_state().cards[card].is_movable = movable_cards[card]
            end
        end)
        local free_cells = sm:get_game_state().free_cells
        for ____, fc in __TS__Iterator(free_cells) do
            if fc.length > 0 then
                movable_cards[fc[0]] = true
                sm:get_game_state().cards[fc[0]].is_movable = true
            end
        end
    end
    local function block_all_cards()
        sm:get_game_state().cards:forEach(function(card)
            card.is_movable = false
            return false
        end)
    end
    local function unblock_cards(cards)
        __TS__ArrayForEach(
            cards,
            function(____, card)
                sm:get_game_state().cards[card].is_movable = true
                movable_cards[card] = true
            end
        )
    end
    move_validator = {
        to_home = function(to, card)
            local home_index = to - GAME_CONSTS.values.homes_ids[1]
            local home = sm:get_game_state().home[home_index]
            if home.length > 0 then
                local is_mast_valid = dc[home[0]].mast == dc[card + 1].mast
                local is_num_valid = DcNums[__TS__ArrayIndexOf(
                    DcNums,
                    dc[array.last(home)].nom
                ) + 1 + 1] == dc[card + 1].nom
                return is_mast_valid and is_num_valid
            else
                return dc[card + 1].nom == "t"
            end
        end,
        to_free_cells = function(to, card)
            local last_card_in_to_stack = array.last(sm:get_stack(to))
            local from = sm:find_stack(card)
            local is_to_stack_empty = last_card_in_to_stack == nil
            local is_moving_last_card = from:indexOf(card) == from.length - 1
            return is_to_stack_empty and is_moving_last_card
        end,
        to_stack = function(to, card)
            local last_card_in_to_stack = array.last(sm:get_stack(to))
            local is_to_stack_empty = last_card_in_to_stack == nil
            local ____is_to_stack_empty_1
            if is_to_stack_empty then
                ____is_to_stack_empty_1 = is_movable(card)
            else
                ____is_to_stack_empty_1 = is_pair_cards_valid_seq(last_card_in_to_stack, card)
            end
            return ____is_to_stack_empty_1
        end,
        tutorial = function(to, card)
            if tutorial_valid_moves ~= nil then
                local is_card_valid = tutorial_valid_moves.move_card == card
                return is_card_valid and __TS__ArraySome(
                    tutorial_valid_moves.to,
                    function(____, v) return v == to end
                )
            else
                return false
            end
        end
    }
    local function move_selected_card_to(to_stack_id)
        if selected_card == -1 then
            return
        end
        local from = get_selected_stack()
        sm:move_card_to_stack(to_stack_id, selected_card, from)
    end
    local function is_can_take_cards_from_reserve()
        local ____temp_2 = sm:get_game_state()
        local stack_ids = ____temp_2.stack_ids
        local stopka = ____temp_2.stopka
        return stopka.length > 0
    end
    local function take_cards_from_reserve(apply_state_cbk)
        local state = sm:get_game_state()
        local stack_ids = state.stack_ids
        local stopka = state.stopka
        for ____, stack in __TS__Iterator(stack_ids) do
            local card_id = array.random_element(stopka)
            sm:open_card(card_id, true)
            sm:move(
                stopka,
                stack,
                {stopka:indexOf(card_id)}
            )
            apply_state_cbk()
        end
    end
    local function set_valid_moves(move_card, to)
        tutorial_valid_moves = {move_card = move_card, to = to}
    end
    --- Отдает случайное возможное перемещение для выбранной карты
    local function get_move_for_selected_card(card)
        if card == nil then
            card = selected_card
        end
        if card == -1 then
            return nil
        end
        local moves = get_moves_for_selected_card(card)
        local true_moves = {}
        if moves ~= nil and #moves > 0 then
            true_moves = __TS__ArrayFilter(
                moves,
                function(____, idx)
                    local stack = sm:get_stack(idx)
                    return stack.length > 0 and not sm:get_dc_card(array.last(stack)).is_joker
                end
            )
        end
        if #true_moves > 0 then
            return array.random_element(true_moves)
        end
        return moves ~= nil and #moves > 0 and array.random_element(moves) or nil
    end
    local function is_gameover()
        return sm:get_game_state().home:every(function(s, i)
            return s.length == 13
        end)
    end
    return {
        init = init,
        get_valid_masts = get_valid_masts,
        get_pre_nom = get_pre_nom,
        is_valid_move = is_valid_move,
        calculate_movable_cards = calculate_movable_cards,
        is_movable = is_movable,
        get_automove = get_automove,
        move_sequence_to_home = move_sequence_to_home,
        move_selected_card_to = move_selected_card_to,
        get_move_for_selected_card = get_move_for_selected_card,
        get_moves_for_selected_card = get_moves_for_selected_card,
        get_selected_stack = get_selected_stack,
        select_card = select_card,
        get_selected_card = get_selected_card,
        reset_selected_card = reset_selected_card,
        is_can_take_cards_from_reserve = is_can_take_cards_from_reserve,
        take_cards_from_reserve = take_cards_from_reserve,
        is_gameover = is_gameover,
        is_pair_cards_valid_seq = is_pair_cards_valid_seq,
        set_valid_moves = set_valid_moves,
        move_to_home = function(from_stack, to_stack_index, card_index)
            sm:move_one_card(from_stack, to_stack_index - 1, card_index)
        end,
        block_all_cards = block_all_cards,
        unblock_cards = unblock_cards
    }
end
return ____exports
