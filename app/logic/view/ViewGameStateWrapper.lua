local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayIsArray = ____lualib.__TS__ArrayIsArray
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local ____exports = {}
local ____state_helper = require("logic_state_machine.state_helper")
local is_flag = ____state_helper.is_flag
local set_flag = ____state_helper.set_flag
local ____state_manager = require("logic_state_machine.state_manager")
local StateManager = ____state_manager.StateManager
local ____array = require("utils.array")
local array = ____array.array
local ____states = require("logic.data_oriented_core.states")
local DcCardStates = ____states.DcCardStates
local DcTransitionStates = ____states.DcTransitionStates
local ____utils = require("logic.utils")
local is_equal_pos = ____utils.is_equal_pos
--- Объект обертка для работы со стейт менеджером и транзишенами
-- 
-- @param data_init_func - Функция инициализирующая дополнительное хранилище для цикла "обновление -> обработка" game_state.
-- @returns
function ____exports.ViewGameStateWrapper(data_init_func)
    local _get_transition_set, _update_state_general, _configure_mask, _create_default_update_state, _create_default_transition, overrided_def_transitions, handlers_state, default_transitions
    function _get_transition_set(state_info)
        local data = data_init_func({
            state = state_info.state,
            id_item = state_info.id_item,
            other = {},
            to_pos = vmath.vector3()
        })
        for handler_key in pairs(DcCardStates) do
            local k = DcCardStates[handler_key]
            if handlers_state[k] ~= nil then
                if is_flag(state_info.state.mask, k) then
                    handlers_state[k](data)
                end
            end
        end
        return {
            default_transitions[DcTransitionStates.RENDER_ORDER](data),
            default_transitions[DcTransitionStates.OPENED](data),
            default_transitions[DcTransitionStates.POSITION](data)
        }
    end
    function _update_state_general(state, key, flag, upd, force_update)
        if force_update == nil then
            force_update = false
        end
        local calculate_mask_and_update
        function calculate_mask_and_update(item_state, initial_mask)
            for ____, i in ipairs(array.indexes(item_state)) do
                local id = item_state[i + 1]
                local mask = set_flag(0, initial_mask, true)
                mask = _configure_mask(state, id, mask)
                upd(id, mask, i, item_state)
            end
        end
        local item_state = state[key]
        if type(item_state) == "table" then
            if __TS__ArrayIsArray(item_state) and type(item_state[1]) == "number" then
                calculate_mask_and_update(item_state, flag)
            else
                local keys = __TS__ObjectKeys(item_state)
                for ____, i in ipairs(array.indexes(keys)) do
                    local sub_key = keys[i + 1]
                    calculate_mask_and_update(item_state[sub_key], flag + i)
                end
            end
        end
    end
    function _configure_mask(game_state, cardId, initial_mask)
        local is_open = game_state.cards[cardId + 1].is_open
        local mask = set_flag(initial_mask, DcCardStates.OPENED, is_open)
        return mask
    end
    function _create_default_update_state(game_state)
        local default_update_states = {}
        for k in pairs(game_state) do
            default_update_states[k] = function(_, __, mask) return mask end
        end
        return default_update_states
    end
    function _create_default_transition()
        return {
            [DcTransitionStates.RENDER_ORDER] = function(data)
                return {
                    DcTransitionStates.RENDER_ORDER,
                    function(_go, cb_end)
                        if overrided_def_transitions[DcTransitionStates.RENDER_ORDER] ~= nil then
                            overrided_def_transitions[DcTransitionStates.RENDER_ORDER](data, _go, cb_end)
                        end
                    end
                }
            end,
            [DcTransitionStates.OPENED] = function(data)
                return {
                    DcTransitionStates.OPENED,
                    function(_go, cb_end)
                        if overrided_def_transitions[DcTransitionStates.OPENED] ~= nil then
                            overrided_def_transitions[DcTransitionStates.OPENED](data, _go, cb_end)
                        end
                    end
                }
            end,
            [DcTransitionStates.POSITION] = function(data)
                return {
                    DcTransitionStates.POSITION,
                    function(_go, cb_end)
                        local cur_pos = go.get_position(_go)
                        if is_equal_pos(cur_pos, data.to_pos) then
                            cb_end()
                        elseif overrided_def_transitions[DcTransitionStates.POSITION] ~= nil then
                            overrided_def_transitions[DcTransitionStates.POSITION](data, _go, cb_end)
                        end
                    end
                }
            end
        }
    end
    local state_manager = StateManager(_get_transition_set)
    overrided_def_transitions = {}
    local update_states
    default_transitions = _create_default_transition()
    local function init(game_state)
        update_states = _create_default_update_state(game_state)
        handlers_state = {}
    end
    --- Устанавливает функцию обновления для состояния, вызывается для каждого корневого поля GameState,
    -- в поле state в функции обработчике будет возвращать либо само поле из GameState либо его дочерние эллементы, как в случае со stack_ids
    -- 
    -- @param handlers
    local function set_update_states(handlers)
        update_states = __TS__ObjectAssign({}, update_states, handlers)
    end
    --- Устанавливает функцию обработчик для конкретного состояния.
    -- 
    -- @param card_state - состояние карты от DcCardStates
    -- @param handler - функция обработчик состояния карты
    local function set_handler_state(card_state, handler)
        handlers_state[card_state] = handler
    end
    local updatable_states_map
    --- Устанавливает то какие поля состояния необходимо обрабатывать, а так же с каким enam из DcCardStates соотносится поле из GameState
    -- 
    -- @param updatable_states
    local function set_updatable_state(updatable_states)
        updatable_states_map = updatable_states
    end
    --- Обновляет состояние игры, применяя функции обновления для каждого обновляемого состояния.
    -- 
    -- @param state - текущее состояние игры
    -- @param force_update - флаг принудительного обновления
    local function update(state, force_update)
        if force_update == nil then
            force_update = false
        end
        for key_state in pairs(state) do
            local other = {force_update = force_update, game_state = state, id_card = -1, index = -1}
            local key = key_state
            if updatable_states_map[key] ~= nil then
                local dc_type = updatable_states_map[key]
                local update_state_function = update_states[key]
                _update_state_general(
                    state,
                    key,
                    dc_type,
                    function(id, mask, index, sub_state)
                        local ____temp_0
                        if sub_state ~= nil then
                            ____temp_0 = sub_state
                        else
                            ____temp_0 = state[key]
                        end
                        local _state = ____temp_0
                        other.id_card = id
                        other.index = index
                        local new_mask = update_state_function(_state, other, mask)
                        force_update = force_update or other.force_update
                        state_manager.update_states(id, new_mask, index, force_update)
                    end,
                    force_update
                )
            end
        end
        state_manager.apply_state()
    end
    --- Перегружает стандартный переход, заменяя его пользовательским действием.
    -- 
    -- @param transition - тип перехода
    -- @param action - функция действия для перехода
    local function override_def_transition(transition, action)
        overrided_def_transitions[transition] = action
    end
    return {
        set_update_states = set_update_states,
        set_handler_state = set_handler_state,
        set_updatable_state = set_updatable_state,
        update = update,
        init = init,
        get_state_manager = function() return state_manager end,
        override_def_transition = override_def_transition,
        set_go_list = state_manager.set_go_list,
        set_order_trasitions = state_manager.transition_manager.set_order_trasitions,
        is_animations_done = state_manager.transition_manager.is_all_processed,
        configure_seq_list_items = state_manager.configure_seq_list_items
    }
end
return ____exports
