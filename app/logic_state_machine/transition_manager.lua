local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____state_interfaces = require("logic_state_machine.state_interfaces")
local DcTransitionItems = ____state_interfaces.DcTransitionItems
function ____exports.TransitionManager(get_transitions_cb)
    local get_task_by_id, is_all_done, skip_old_task, add_processing_state, wait_all_trasitions_done, process_task, process_transition, next_task, do_all_processed, on_all_processed, order_item_transitions, transition_mode_one_item, transition_mode_items, process_list, go_list, cb_processed, is_applying, is_processing, current_task_id, id_task_counter
    function get_task_by_id(id)
        do
            local i = 0
            while i < #process_list do
                local task = process_list[i + 1]
                if task.id == id then
                    return task
                end
                i = i + 1
            end
        end
        return nil
    end
    function is_all_done()
        do
            local i = 0
            while i < #process_list do
                local task = process_list[i + 1]
                if task.is_active then
                    return false
                end
                i = i + 1
            end
        end
        return true
    end
    function skip_old_task(task)
        do
            local i = 0
            while i < #process_list do
                local find_task = process_list[i + 1]
                if task.id ~= find_task.id and task.state.id_item == find_task.state.id_item and (transition_mode_items == DcTransitionItems.PARALLEL or transition_mode_items == DcTransitionItems.SEQUENCE and find_task.id < task.id) then
                    find_task.is_active = false
                end
                i = i + 1
            end
        end
    end
    function add_processing_state(state)
        id_task_counter = id_task_counter + 1
        local item = {
            id = id_task_counter,
            is_active = true,
            state = state,
            transitions = get_transitions_cb(state)
        }
        process_list[#process_list + 1] = item
        if transition_mode_items == DcTransitionItems.PARALLEL then
            process_task(item)
        elseif transition_mode_items == DcTransitionItems.SEQUENCE then
            if current_task_id == 0 then
                current_task_id = id_task_counter
                process_task(item)
            end
        end
    end
    function wait_all_trasitions_done(task, cb_end)
        local all = #order_item_transitions
        local cnt = 0
        do
            local i = 0
            while i < #order_item_transitions do
                local id_trasition = order_item_transitions[i + 1]
                process_transition(
                    task,
                    id_trasition,
                    function()
                        cnt = cnt + 1
                        if cnt == all then
                            cb_end()
                        end
                    end
                )
                i = i + 1
            end
        end
    end
    function process_task(task, cur_index)
        if cur_index == nil then
            cur_index = 0
        end
        if cur_index > #order_item_transitions - 1 then
            next_task(task)
            return
        end
        if cur_index == 0 then
            skip_old_task(task)
        end
        local id_trasition = order_item_transitions[cur_index + 1]
        if transition_mode_one_item == DcTransitionItems.SEQUENCE then
            process_transition(
                task,
                id_trasition,
                function() return process_task(task, cur_index + 1) end
            )
        elseif transition_mode_one_item == DcTransitionItems.PARALLEL then
            wait_all_trasitions_done(
                task,
                function() return next_task(task) end
            )
        end
    end
    function process_transition(task, id_trasition, cb_end)
        do
            local i = 0
            while i < #task.transitions do
                local task_trasition, task_fnc = unpack(task.transitions[i + 1])
                if task_trasition == id_trasition then
                    local _go = go_list[task.state.id_item + 1]
                    task_fnc(
                        _go,
                        function() return cb_end() end
                    )
                    return true
                end
                i = i + 1
            end
        end
        Log.error("run_transition не найден переход", id_trasition, task)
        cb_end()
        return false
    end
    function next_task(cur_task)
        cur_task.is_active = false
        if transition_mode_items == DcTransitionItems.SEQUENCE then
            local next_id = current_task_id + 1
            local next_t = get_task_by_id(next_id)
            if next_t ~= nil then
                current_task_id = next_id
                process_task(next_t)
            else
                do_all_processed()
            end
        elseif transition_mode_items == DcTransitionItems.PARALLEL then
            if is_all_done() then
                do_all_processed()
            end
        end
    end
    function do_all_processed()
        current_task_id = 0
        if not is_applying then
            on_all_processed()
        end
    end
    function on_all_processed()
        if not is_processing then
            return
        end
        is_processing = false
        log("all task processed")
        if cb_processed ~= nil then
            cb_processed()
        end
    end
    order_item_transitions = {}
    transition_mode_one_item = DcTransitionItems.SEQUENCE
    transition_mode_items = DcTransitionItems.SEQUENCE
    process_list = {}
    is_applying = false
    is_processing = false
    current_task_id = 0
    id_task_counter = 0
    local function set_go_list(list)
        go_list = list
    end
    local function set_order_trasitions(list)
        order_item_transitions = list
    end
    local function set_transition_mode_items(mode)
        transition_mode_items = mode
    end
    local function set_transition_mode_one_item(mode)
        transition_mode_one_item = mode
    end
    local function clear_processing_list()
        do
            local i = #process_list - 1
            while i >= 0 do
                local task = process_list[i + 1]
                if not task.is_active then
                    __TS__ArraySplice(process_list, i, 1)
                end
                i = i - 1
            end
        end
    end
    local function apply_states(states)
        clear_processing_list()
        is_processing = true
        is_applying = true
        do
            local i = 0
            while i < #states do
                add_processing_state(states[i + 1])
                i = i + 1
            end
        end
        is_applying = false
        if is_all_done() then
            do_all_processed()
        end
    end
    local function is_all_processed()
        return not is_processing
    end
    local function set_callback_processed(cb)
        cb_processed = cb
    end
    return {
        apply_states = apply_states,
        set_order_trasitions = set_order_trasitions,
        set_transition_mode_items = set_transition_mode_items,
        set_transition_mode_one_item = set_transition_mode_one_item,
        is_all_processed = is_all_processed,
        set_callback_processed = set_callback_processed,
        set_go_list = set_go_list
    }
end
return ____exports
