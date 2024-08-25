local ____exports = {}
local ____transition_manager = require("logic_state_machine.transition_manager")
local TransitionManager = ____transition_manager.TransitionManager
function ____exports.StateManager(transition_info_cb)
    local on_state_changed, states_changed_list
    function on_state_changed(id_item, old_state, new_state)
        states_changed_list[#states_changed_list + 1] = {id_item = id_item, state = new_state, old_state = old_state}
    end
    local states_set = {}
    local transition_manager = TransitionManager(transition_info_cb)
    states_changed_list = {}
    local function set_go_list(list)
        transition_manager.set_go_list(list)
    end
    local function configure_seq_item(mode)
        transition_manager.set_transition_mode_one_item(mode)
    end
    local function configure_seq_list_items(mode)
        transition_manager.set_transition_mode_items(mode)
    end
    local function update_states(id, mask, index, force_update)
        if force_update == nil then
            force_update = false
        end
        local old_state = nil
        if states_set[id] ~= nil then
            old_state = states_set[id]
        end
        local new_state = {mask = mask, index = index}
        states_set[id] = new_state
        if old_state == nil or (old_state.index ~= new_state.index or old_state.mask ~= new_state.mask) or force_update then
            on_state_changed(id, old_state, new_state)
        end
    end
    local function apply_state()
        if #states_changed_list > 0 then
            transition_manager.apply_states(states_changed_list)
        end
        states_changed_list = {}
    end
    return {
        set_go_list = set_go_list,
        update_states = update_states,
        apply_state = apply_state,
        configure_seq_item = configure_seq_item,
        configure_seq_list_items = configure_seq_list_items,
        transition_manager = transition_manager
    }
end
return ____exports
