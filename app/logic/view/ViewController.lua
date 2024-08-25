local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____state_helper = require("logic_state_machine.state_helper")
local is_flag = ____state_helper.is_flag
local set_flag = ____state_helper.set_flag
local ____GoManager = require("modules.GoManager")
local GoManager = ____GoManager.GoManager
local ____states = require("data_oriented_core.states")
local DcTransitionStates = ____states.DcTransitionStates
local flow = require("ludobits.m.flow")
local ____state_interfaces = require("logic_state_machine.state_interfaces")
local DcTransitionItems = ____state_interfaces.DcTransitionItems
local ____utils = require("utils.utils")
local ____repeat = ____utils["repeat"]
local ____ViewGameStateWrapper = require("data_oriented_core.ViewGameStateWrapper")
local ViewGameStateWrapper = ____ViewGameStateWrapper.ViewGameStateWrapper
local ____GoLayouts = require("logic.view.GoLayouts")
local GoLayouts = ____GoLayouts.GoLayouts
function ____exports.ViewController()
    local init_data, init_view_game_state_wrapper, events_subscribe, init_game_objects, gm, time_moving, goes, get_game_state, view_gs_wrapper
    function init_data(d)
        return __TS__ObjectAssign(
            {},
            d,
            {
                to_pos = vmath.vector3(),
                to_scale = vmath.vector3(960 / 15 / 130, 960 / 15 / 130, 1)
            }
        )
    end
    function init_view_game_state_wrapper()
        local vgs_wrapper = ViewGameStateWrapper(
            init_data,
            get_game_state()
        )
        view_gs_wrapper = vgs_wrapper
        vgs_wrapper.init({boxes = 10})
        vgs_wrapper.override_def_transition(
            DcTransitionStates.RENDER_ORDER,
            function(data, _go, cb_end)
                local ____data_other_1 = data.other
                local ____data_other_z_0 = data.other.z
                if ____data_other_z_0 == nil then
                    ____data_other_z_0 = data.state.index
                end
                ____data_other_1.z = ____data_other_z_0
                gm.set_render_order_hash(_go, data.other.z)
                if data.other.color ~= nil then
                    gm.set_color_hash(_go, data.other.color)
                end
                cb_end()
            end
        )
        vgs_wrapper.override_def_transition(
            DcTransitionStates.POSITION,
            function(data, _go, cb_end)
                local tmp_z = gm.get_render_order_hash(_go)
                log(_go)
                gm.set_render_order_hash(_go, 110 + data.state.index)
                if data.to_scale ~= nil and data.to_scale.x ~= nil then
                    go.set_scale(data.to_scale, _go)
                end
                log(data.to_pos)
                gm.move_to_with_time_hash(
                    _go,
                    data.to_pos,
                    time_moving,
                    function()
                        gm.set_render_order_hash(_go, tmp_z)
                        cb_end()
                    end
                )
            end
        )
        vgs_wrapper.set_update_states({boxes = function(s, other, flag)
            return set_flag(flag, 17, other.id_child % 3 == 0)
        end})
        local acc = 0
        vgs_wrapper.set_handler_state(
            10,
            function(data)
                if is_flag(data.state.mask, 17) then
                    local p = go.get_position(hash("/hand"))
                    p.x = p.x + (960 / 15 / 2 + acc)
                    acc = acc + 960 / 15
                    log("index ", data.state.index)
                    data.to_pos.x = p.x
                    data.to_pos.y = p.y
                else
                    local p = go.get_position(hash("/hand"))
                    p.x = p.x - 200
                    data.to_pos.x = p.x
                    data.to_pos.y = p.y
                end
            end
        )
    end
    function events_subscribe()
    end
    function init_game_objects()
        local pos = go.get_position(hash("/hand"))
        pos.y = pos.y - 200
        ____repeat(
            #get_game_state().boxes,
            function(i)
                local _go = gm.make_go("test", pos)
                goes[#goes + 1] = _go
                log("create")
            end
        )
        pprint(goes)
        view_gs_wrapper.set_go_list(goes)
        view_gs_wrapper.set_order_trasitions({DcTransitionStates.RENDER_ORDER, DcTransitionStates.POSITION})
    end
    gm = GoManager()
    local layouts = GoLayouts({
        y_padding = function() return 28 end,
        dir_cards_home = 1
    })
    local time_opening = 0.1
    time_moving = 0.1
    goes = {}
    local function init()
        init_view_game_state_wrapper()
        init_game_objects()
        events_subscribe()
    end
    local function change_layout(d, is_gameover)
    end
    local function is_animations_done()
        return view_gs_wrapper.is_animations_done()
    end
    local function wait_animations()
        while true do
            if is_animations_done() then
                break
            end
            flow.delay(0.1)
        end
    end
    local function configure_times(t_moving, t_opening)
        time_moving = t_moving
        time_opening = t_opening
    end
    local function apply_state(game_state, wait_applying, is_force_update)
        if wait_applying == nil then
            wait_applying = false
        end
        if is_force_update == nil then
            is_force_update = false
        end
        view_gs_wrapper.update(game_state, is_force_update)
        if wait_applying then
            wait_animations()
        end
    end
    local function refresh_view()
        configure_times(0, 0)
        view_gs_wrapper.configure_seq_list_items(DcTransitionItems.PARALLEL)
        view_gs_wrapper.update(
            get_game_state(),
            true
        )
    end
    local function do_message(message_id, _message, sender)
        gm.do_message(message_id, _message)
    end
    --- Устанавливает функцию для получения StateSchema необходимого для обновления представления
    -- 
    -- @see seq_update_data_view ,
    -- @see par_update_data_view *
    -- @param get_game_state_func
    local function set_get_game_state_func(get_game_state_func)
        get_game_state = get_game_state_func
    end
    local def_opt = {
        open_t = 0.3,
        move_t = 0.3,
        wait_anim = true,
        is_force_update = false,
        complite = function()
        end
    }
    --- Обновляет представление данных (game_state)
    -- 
    -- @param state_edit_func функция в которой проводятся изменения состояния данных
    -- @param transition - последовательное или параллельное изменение состояния
    -- @param opt - доп. опции : 
    -- open_t - время открытие карты, 
    -- move_t продолжительность перемещения карты,
    -- wait_anim - ждать ли завершения анимации, 
    -- complite - функция вызываемая по завершению действия с данными и если указано wait_anim = true, по завершению анимации }
    local function update_data_view(game_state, state_edit_func, transition, opt)
        configure_times(opt.move_t, opt.open_t)
        view_gs_wrapper.configure_seq_list_items(transition)
        if state_edit_func then
            state_edit_func()
        end
        apply_state(game_state, false, opt.is_force_update)
        if opt.wait_anim then
            wait_animations()
        end
        opt.complite()
    end
    --- Обновление представления game_state последовательное
    local function seq_update_data_view(opt, state_edit_func)
        if opt == nil then
            opt = {}
        end
        local game_state = get_game_state()
        update_data_view(
            game_state,
            state_edit_func,
            DcTransitionItems.SEQUENCE,
            __TS__ObjectAssign({}, def_opt, opt)
        )
    end
    --- Обновление представления game_state параллельное
    local function par_update_data_view(opt, state_edit_func)
        if opt == nil then
            opt = {}
        end
        local game_state = get_game_state()
        update_data_view(
            game_state,
            state_edit_func,
            DcTransitionItems.PARALLEL,
            __TS__ObjectAssign({}, def_opt, opt)
        )
    end
    return {
        init = init,
        do_message = do_message,
        apply_state = apply_state,
        configure_times = configure_times,
        wait_animations = wait_animations,
        set_get_game_state_func = set_get_game_state_func,
        seq_update_data_view = seq_update_data_view,
        par_update_data_view = par_update_data_view,
        configure_seq_list_items = function(items)
            view_gs_wrapper.configure_seq_list_items(items)
        end,
        change_layout = change_layout,
        is_animations_done = is_animations_done,
        refresh_view = refresh_view
    }
end
return ____exports
