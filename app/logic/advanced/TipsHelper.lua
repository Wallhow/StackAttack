local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__Spread = ____lualib.__TS__Spread
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayPushArray = ____lualib.__TS__ArrayPushArray
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
local ____array = require("utils.array")
local array = ____array.array
local default_weights = {open_card = 2000, move_card_above = 100, empty_stack = 2500}
function ____exports.TipsHelper(_weight)
    local clear_stupid_moves, evaluate, _ev_is_after_move_open_card, _ev_cards_range, _ev_after_move_card_stack_empty, weight, showed_moves
    function clear_stupid_moves(sm, moves, solver)
        do
            local i = #moves - 1
            while i >= 0 do
                local m = moves[i + 1]
                do
                    local j = #showed_moves - 1
                    while j >= 0 do
                        if showed_moves[j + 1].card_id == m.card_id and showed_moves[j + 1].to_stack_id == m.to_stack_id then
                            __TS__ArraySplice(moves, i, 1)
                        end
                        j = j - 1
                    end
                end
                i = i - 1
            end
        end
        do
            local i = #moves - 1
            while i >= 0 do
                local m = moves[i + 1]
                local stack = sm:find_stack(m.card_id)
                local ____temp_3 = stack:indexOf(m.card_id) == 0
                if ____temp_3 then
                    local ____opt_1 = sm:get_stack(m.to_stack_id)
                    if ____opt_1 ~= nil then
                        ____opt_1 = ____opt_1.length
                    end
                    ____temp_3 = ____opt_1 == 0
                end
                if ____temp_3 then
                    __TS__ArraySplice(moves, i, 1)
                end
                i = i - 1
            end
        end
        do
            local i = #moves - 1
            while i >= 0 do
                local move = moves[i + 1]
                local from_stack = sm:find_stack(move.card_id)
                local card_index = from_stack:indexOf(move.card_id)
                local ____temp_4
                if from_stack[card_index - 1] ~= nil then
                    ____temp_4 = from_stack[card_index - 1]
                else
                    ____temp_4 = move.card_id
                end
                local before_card_index = ____temp_4
                local ____temp_5
                if from_stack[card_index + 1] ~= nil then
                    ____temp_5 = from_stack[card_index + 1]
                else
                    ____temp_5 = move.card_id
                end
                local after_card_index = ____temp_5
                local is_before_valid_range = before_card_index == move.card_id or solver.is_pair_cards_valid_seq(before_card_index, move.card_id)
                local is_after_valid_range = after_card_index == move.card_id or solver.is_pair_cards_valid_seq(move.card_id, after_card_index)
                if is_before_valid_range and is_after_valid_range then
                    __TS__ArraySplice(
                        moves,
                        __TS__ArrayIndexOf(moves, move),
                        1
                    )
                end
                i = i - 1
            end
        end
        return moves
    end
    function evaluate(sm, move)
        local score = 0
        local evaluate_funcs = {}
        evaluate_funcs[#evaluate_funcs + 1] = _ev_cards_range
        evaluate_funcs[#evaluate_funcs + 1] = _ev_is_after_move_open_card
        evaluate_funcs[#evaluate_funcs + 1] = _ev_after_move_card_stack_empty
        for ____, func in ipairs(evaluate_funcs) do
            score = score + func(sm, move)
        end
        return score
    end
    function _ev_is_after_move_open_card(sm, move)
        local from_stack = sm:find_stack(move.card_id)
        local index_cur_card = from_stack:indexOf(move.card_id)
        if index_cur_card > 0 then
            local before_card = from_stack[index_cur_card - 1]
            return not sm:is_open_card(before_card) and weight.open_card or 0
        end
        return 0
    end
    function _ev_cards_range(sm, move)
        local from_stack = sm:find_stack(move.card_id)
        local index_card = from_stack:indexOf(move.card_id)
        local score = index_card ~= 0 and weight.move_card_above * (from_stack.length - index_card) or 0
        return score
    end
    function _ev_after_move_card_stack_empty(sm, move)
        local from_stack = sm:find_stack(move.card_id)
        local index_card = from_stack:indexOf(move.card_id)
        local score = index_card == 0 and weight.empty_stack or 0
        return score
    end
    weight = __TS__ObjectAssign({}, default_weights, _weight)
    showed_moves = {}
    local function find_moves(sm, solver)
        local ____temp_0 = sm:get_game_state()
        local stack_ids = ____temp_0.stack_ids
        local moves = {}
        local moves_with_score = {}
        local src_cards = {}
        for ____, stack in __TS__Iterator(stack_ids) do
            local cards = stack:filter(function(c) return sm:is_open_card(c) end)
            if cards.length > 0 then
                src_cards[#src_cards + 1] = __TS__Spread(cards)
            end
        end
        for ____, c in ipairs(src_cards) do
            if sm:is_open_card(c) then
                local _moves = __TS__ArrayMap(
                    solver.get_moves_for_selected_card(c),
                    function(____, v)
                        return {card_id = c, to_stack_id = v}
                    end
                )
                __TS__ArrayPushArray(moves, _moves)
            end
        end
        moves = clear_stupid_moves(sm, moves, solver)
        for ____, m in ipairs(moves) do
            local score = evaluate(sm, m)
            moves_with_score[#moves_with_score + 1] = __TS__ObjectAssign({}, m, {score = score})
        end
        return moves_with_score
    end
    local function find_best_move(sm, solver, remember_step)
        if remember_step == nil then
            remember_step = true
        end
        local best_score = -math.huge
        local best_move
        local moves = find_moves(sm, solver)
        for ____, move in ipairs(moves) do
            local score = evaluate(sm, move)
            if score > best_score then
                if __TS__ArrayFind(
                    showed_moves,
                    function(____, m) return m.card_id == move.card_id end
                ) == nil then
                    best_score = score
                    best_move = move
                end
            end
        end
        if best_move and remember_step then
            showed_moves[#showed_moves + 1] = best_move
        end
        return best_move
    end
    return {
        find_best_move = find_best_move,
        evaluate = evaluate,
        reset = function() return array.clear(showed_moves) end
    }
end
return ____exports
