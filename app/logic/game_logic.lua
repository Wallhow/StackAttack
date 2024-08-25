local ____lualib = require("lualib_bundle")
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ArrayFindIndex = ____lualib.__TS__ArrayFindIndex
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local ____exports = {}
local flow = require("ludobits.m.flow")
local ____ViewController = require("logic.view.ViewController")
local ViewController = ____ViewController.ViewController
local ____array = require("utils.array")
local array = ____array.array
local ____game_state_manager = require("logic.game_state_manager")
local GameStateManager = ____game_state_manager.GameStateManager
local ____FieldGenerator = require("logic.advanced.FieldGenerator")
local FieldGenerator = ____FieldGenerator.FieldGenerator
local ____StatsRecorder = require("stats.StatsRecorder")
local StatsRecorder = ____StatsRecorder.StatsRecorder
local ____TipsHelper = require("logic.advanced.TipsHelper")
local TipsHelper = ____TipsHelper.TipsHelper
local ____game_config = require("main.game_config")
local GAME_CONSTS = ____game_config.GAME_CONSTS
local ____Solver = require("logic.advanced.Solver")
local Solver = ____Solver.Solver
local ____utils = require("utils.utils")
local ____repeat = ____utils["repeat"]
local ____TutorialManager = require("game.TutorialManager")
local TutorialManager = ____TutorialManager.TutorialManager
local ____GameState = require("data_oriented_core.GameState")
local GameState = ____GameState.GameState
function ____exports.Game()
    local new_game, restart, events_init, wait_event, handle_click_card, handle_drop_on_stack, handle_fast_click, move_card, use_tips, undo_step, check_valid_automove_to_home_and_check_gameover, end_game, is_can_use_bonus, check_bonuse_and_action, view, gsm, solver, field_gen, tutorial_manager, is_tutorial, tips_utils, is_gameover, using_bonuses, bonuses, dragging_block, counter_tips
    function new_game()
        gsm.stopka.init()
        view.par_update_data_view(
            {move_t = 0, open_t = 0, wait_anim = true},
            function()
            end
        )
        Sound.play("rasklad", 0.7)
        if not is_tutorial then
            view.seq_update_data_view(
                {move_t = 0.03 - 1 / 100, open_t = 0},
                function()
                    field_gen.generate()
                    gsm.record_cur_state()
                end
            )
        end
    end
    function restart(is_tutorial)
        if is_tutorial == nil then
            is_tutorial = false
        end
        view.par_update_data_view(
            {move_t = 0.1, open_t = 0, wait_anim = true},
            function()
                ____repeat(
                    #gsm.get_game_state().stack_ids,
                    function(i) return gsm.move_to_reserve(gsm.get_game_state().stack_ids[i + 1]) end
                )
                ____repeat(
                    #gsm.get_game_state().home,
                    function(i) return gsm.move_to_reserve(gsm.get_game_state().home[i + 1]) end
                )
                ____repeat(
                    #gsm.get_game_state().free_cells,
                    function(i) return gsm.move_to_reserve(gsm.get_game_state().free_cells[i + 1]) end
                )
            end
        )
        Sound.play("rasklad", 0.7)
        if not is_tutorial then
            solver.calculate_movable_cards()
            view.seq_update_data_view(
                {move_t = 0.03 - 1 / 100, open_t = 0, wait_anim = true},
                function()
                    field_gen.generate()
                    gsm.record_cur_state()
                end
            )
            solver.calculate_movable_cards()
            view.refresh_view()
            EventBus.trigger("STOPWATCH", {action = "go"})
            gsm.clear_state_history()
            gsm.record_cur_state()
            check_valid_automove_to_home_and_check_gameover()
        end
    end
    function events_init()
        EventBus.on(
            "REPLAY",
            function()
                EventBus.trigger("STOPWATCH", {action = "stop"})
                EventBus.trigger("STOPWATCH", {action = "reset"})
                flow.delay(0.1)
                restart()
            end,
            true
        )
        EventBus.on("FAST_CLICK_CARD", handle_fast_click, true)
        EventBus.on("CLICK_CARD", handle_click_card, true)
        EventBus.on("DROP_STACK", handle_drop_on_stack, true)
        EventBus.on(
            "LAYOUT_CHANGED",
            function(d)
                view.change_layout(d, is_gameover)
            end,
            true
        )
        EventBus.on(
            "SAVE_RECORD",
            function(____bindingPattern0)
                local time
                time = ____bindingPattern0.time
                StatsRecorder.push({
                    time = time,
                    date = (((tostring(os.date("*t").day) .. ".") .. tostring(os.date("*t").month)) .. ".") .. tostring(os.date("*t").year)
                })
            end
        )
        EventBus.on("IS_CAN_USE_BONUS", is_can_use_bonus, true)
        EventBus.on("UNDO", undo_step, true)
        EventBus.on(
            "USE_BONUS",
            function(____bindingPattern0)
                local bonus
                bonus = ____bindingPattern0.bonus
                return bonuses[bonus]()
            end,
            true
        )
        EventBus.on(
            "RESET_TIPS",
            function() return tips_utils.reset() end,
            true
        )
    end
    function wait_event()
        while true do
            local message_id, _message, sender = flow.until_any_message()
            view.do_message(message_id, _message, sender)
            EventBus.on_message(nil, message_id, _message, sender)
        end
    end
    function handle_click_card(message)
        if not dragging_block then
            dragging_block = true
            local id_card = message.id
            if solver.is_movable(id_card) then
                solver.select_card(id_card)
                local stack = gsm.find_stack(id_card)
                if stack ~= nil and __TS__ArrayIncludes(stack, id_card) then
                    solver.select_card(id_card)
                    local tmp = {}
                    local start = false
                    do
                        local i = 0
                        while i < #stack do
                            local card = stack[i + 1]
                            if card == id_card then
                                start = true
                            end
                            if start and gsm.is_open_card(card) then
                                tmp[#tmp + 1] = card
                            end
                            i = i + 1
                        end
                    end
                    view.start_drag(tmp)
                end
            end
        end
    end
    function handle_drop_on_stack(message)
        local is_skip = false
        local stack_id = message.id
        local def_check = stack_id == -1 or solver.get_selected_card() == -1
        if solver.get_selected_card() == -1 then
            dragging_block = false
        end
        is_skip = def_check
        if is_skip or not solver.is_valid_move(stack_id) then
            solver.select_card(-1)
            view.stop_drag(function()
                dragging_block = false
                return dragging_block
            end)
            return
        end
        move_card(stack_id)
        view.stop_drag(function()
            dragging_block = false
            return dragging_block
        end)
        solver.select_card(-1)
    end
    function handle_fast_click()
        local to_stack = solver.get_move_for_selected_card()
        if to_stack ~= nil then
            move_card(to_stack)
        else
            if __TS__ArrayFind(
                gsm.get_game_state().free_cells,
                function(____, v) return #v == 0 end
            ) ~= nil and array.last(solver.get_selected_stack()) == solver.get_selected_card() then
                local idx_free_cell = __TS__ArrayFindIndex(
                    gsm.get_game_state().free_cells,
                    function(____, v) return #v == 0 end
                )
                move_card(GAME_CONSTS.values.free_cells_ids[idx_free_cell + 1])
            end
            view.stop_drag()
            dragging_block = false
        end
        solver.select_card(-1)
    end
    function move_card(to_stack_id)
        local selected_card = solver.get_selected_card()
        view.par_update_data_view(
            {
                open_t = 0.05,
                move_t = 0.1,
                complite = function()
                    check_valid_automove_to_home_and_check_gameover()
                    EventBus.trigger("SHOW_ADS", {}, false)
                end
            },
            function()
                dragging_block = false
                view.reset_drag()
                solver.move_selected_card_to(to_stack_id)
                Sound.play("card_move")
                tips_utils.reset()
                if not is_tutorial then
                    solver.calculate_movable_cards()
                    gsm.record_cur_state()
                end
                solver.select_card(-1)
            end
        )
        if is_tutorial then
            tutorial_manager.move_card(to_stack_id, selected_card)
        end
        check_valid_automove_to_home_and_check_gameover()
    end
    function use_tips()
        local best_move = tips_utils.find_best_move(gsm, solver)
        if best_move ~= nil then
            view.indicate_tips(best_move.card_id)
            using_bonuses.tips = false
        else
            if #gsm.get_game_state().stopka > 0 then
                view.indicate_tips(gsm.stopka.get_last_closed_card_idx())
                using_bonuses.tips = false
            end
        end
    end
    function undo_step()
        if not is_tutorial then
            if #gsm.get_states_history() > 1 then
                table.remove(gsm.get_states_history())
                local new_state = array.last(gsm.get_states_history())
                gsm.set_state(new_state)
                solver.calculate_movable_cards()
                view.par_update_data_view({open_t = 0.1, move_t = 0.1})
                view.wait_animations()
            end
        end
    end
    function check_valid_automove_to_home_and_check_gameover()
        if GameStorage.get("is_automove") then
            local move = solver.get_automove()
            while move ~= nil do
                move = solver.get_automove()
                if move ~= nil then
                    view.par_update_data_view(
                        {move_t = 0.06, open_t = 0.02, wait_anim = true},
                        function()
                            if move ~= nil then
                                solver.move_to_home(move.stack, move.home_id, move.first_card_index)
                                Sound.play("card_move_to_home")
                            end
                        end
                    )
                    gsm.record_cur_state()
                    if not is_tutorial then
                        solver.calculate_movable_cards()
                    end
                    view.par_update_data_view({move_t = 0, open_t = 0, is_force_update = true})
                end
            end
        end
        if solver.is_gameover() and not is_gameover then
            end_game()
        end
    end
    function end_game()
        is_gameover = true
        local effects = {}
        effects[1] = function()
            for ____, home in ipairs(gsm.get_game_state().home) do
                view.effects().do_effect_2(home)
            end
        end
        effects[2] = function() return view.effects().do_effect_1() end
        effects[3] = function() return view.effects().do_effect_3() end
        effects[4] = function()
            for ____, home in ipairs(gsm.get_game_state().home) do
                view.effects().do_effect_4(home)
            end
        end
        local rnd = math.random(1, 4)
        effects[rnd]()
        flow.delay(rnd ~= 3 and 5 or 1)
        Sound.play("vic")
        EventBus.trigger(
            "GAME_OVER",
            {step = #gsm.get_states_history()}
        )
    end
    function is_can_use_bonus(data)
        local tips_condition
        function tips_condition()
            local best_move = tips_utils.find_best_move(gsm, solver, false)
            if best_move ~= nil then
                local idx_in_open = __TS__ArrayIndexOf(
                    gsm.get_game_state().stopka,
                    best_move.card_id
                )
                local is_hidden_card_open_stopka = idx_in_open ~= -1 and idx_in_open < #gsm.get_game_state().stopka - 1
                local carnd_in_closed_stopka = __TS__ArrayIndexOf(
                    gsm.get_game_state().stopka,
                    best_move.card_id
                ) ~= -1
                if carnd_in_closed_stopka or is_hidden_card_open_stopka then
                    counter_tips = counter_tips + 1
                end
                return true
            else
                return false
            end
        end
        local condition = {tips = tips_condition() and view.tips_animation_done() or #gsm.get_game_state().stopka > 0}
        check_bonuse_and_action(data.bonus, condition[data.bonus])
    end
    function check_bonuse_and_action(bonus, first_flag)
        local is_can = first_flag and not using_bonuses[bonus]
        using_bonuses[bonus] = is_can
        EventBus.trigger("CAN_USE_BONUS", {bonus = bonus, is_can = is_can})
    end
    view = ViewController()
    local game_state = GameState({
        stack_ids = {},
        home = {{}, {}, {}, {}},
        stopka = {},
        cards = {},
        free_cells = {{}, {}, {}, {}}
    })
    gsm = GameStateManager(game_state.get())
    solver = Solver()
    field_gen = FieldGenerator(gsm)
    tutorial_manager = TutorialManager(
        gsm,
        view,
        solver,
        field_gen,
        function() return restart(true) end
    )
    is_tutorial = not GameStorage.get("tutorial_done")
    is_gameover = false
    using_bonuses = {}
    using_bonuses.tips = false
    bonuses = {tips = use_tips}
    events_init()
    local function init()
        flow.delay(0.02)
        GAME_CONSTS.values.stack_count = 8
        gsm.init_cards()
        view.set_get_game_state_func(gsm.get_game_state)
        view.init(gsm.dc_card_list)
        solver.init(gsm)
        EventBus.trigger("STOPWATCH", {action = "reset"})
        new_game()
        if not is_tutorial then
            solver.calculate_movable_cards()
        end
        view.refresh_view()
        if not is_tutorial then
            EventBus.trigger("STOPWATCH", {action = "go"})
            check_valid_automove_to_home_and_check_gameover()
            gsm.record_cur_state()
        end
        tips_utils = TipsHelper()
        if is_tutorial then
            tutorial_manager.init()
            tutorial_manager.next_step()
        end
        wait_event()
    end
    dragging_block = false
    counter_tips = 1
    init()
    return {}
end
return ____exports
