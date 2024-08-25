local ____lualib = require("lualib_bundle")
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local ____exports = {}
local ____FieldGenerator = require("logic.advanced.FieldGenerator")
local get_card_id = ____FieldGenerator.get_card_id
local ____game_config = require("main.game_config")
local GAME_CONSTS = ____game_config.GAME_CONSTS
local ____array = require("utils.array")
local array = ____array.array
local flow = require("ludobits.m.flow")
function ____exports.TutorialManager(gsm, view, solver, field_gen, restart_func)
    local move_card, next_step, show_window, tutorial_texts, current_step, step_actions
    function move_card(to_stack, card)
        if current_step == 0 then
            if to_stack == 8 then
                show_window()
            end
        end
        if current_step == 1 then
            if __TS__ArrayIncludes(GAME_CONSTS.values.free_cells_ids, to_stack) then
                show_window()
            end
        end
        if current_step == 2 then
            if to_stack == 8 then
                show_window()
            end
        end
        if current_step == 3 then
            if to_stack == 6 then
                show_window()
            end
        end
        if current_step == 4 then
            if to_stack == 6 then
                show_window()
            end
        end
    end
    function next_step()
        current_step = current_step + 1
        if current_step == 0 then
            view.seq_update_data_view(
                {move_t = 0.03, open_t = 0},
                function()
                    field_gen:generate_tutorial(1)
                    gsm:record_cur_state()
                end
            )
        elseif current_step == 1 then
            view.seq_update_data_view(
                {move_t = 0.03, open_t = 0},
                function()
                    field_gen:generate_tutorial(2)
                    gsm:record_cur_state()
                end
            )
        end
        step_actions[current_step + 1]()
    end
    function show_window()
        EventBus.trigger("SHOW_TUTORIAL_STEP", {text = tutorial_texts[current_step + 1]})
    end
    tutorial_texts = {
        Lang.get_text("tutorial_step_0"),
        Lang.get_text("tutorial_step_1"),
        Lang.get_text("tutorial_step_2"),
        Lang.get_text("tutorial_step_3"),
        Lang.get_text("tutorial_step_4")
    }
    current_step = -1
    local timer_desc = nil
    step_actions = {}
    local function init()
        local move_hand_on_stack, move_hand_from_stack_to_freecell, _move_hands, animation_break, refresh_view, hand, go_cards, go_free_cells, gm
        function move_hand_on_stack(from_card, to_card)
            local card_hash = go_cards[from_card]
            local start_pos = go.get_position(card_hash)
            local to_pos = go.get_position(go_cards[to_card])
            _move_hands(start_pos, to_pos)
        end
        function move_hand_from_stack_to_freecell(from_card, to_free_cells)
            local card_hash = go_cards[from_card]
            local start_pos = go.get_position(card_hash)
            local to_pos = go.get_position(go_free_cells[to_free_cells])
            _move_hands(start_pos, to_pos)
        end
        function _move_hands(from_pos, to_pos)
            local function action()
                from_pos.z = 0.9
                go.set_position(from_pos, "hand")
                gm:do_fade_anim_hash(hand, 1, 0.3)
                gm:do_move_anim_hash(
                    hand,
                    to_pos,
                    1,
                    0.3,
                    function()
                        gm:do_move_anim_hash(hand, from_pos, 0.7, 0.3)
                        gm:do_fade_anim_hash(hand, 0, 1, 1)
                    end
                )
            end
            action()
            timer_desc = timer.delay(3.3, true, action)
        end
        function animation_break()
            if timer_desc ~= nil then
                go.cancel_animations(hand)
                gm:do_fade_anim_hash(hand, 0, 0.05)
                timer.cancel(timer_desc)
                timer_desc = nil
            end
        end
        function refresh_view()
            view.refresh_view()
        end
        EventBus.on("MSG_ON_DOWN_HASHES", animation_break)
        EventBus.on(
            "LAYOUT_CHANGED",
            function()
                animation_break()
                flow.delay(0.1)
                step_actions[current_step + 1]()
            end,
            true
        )
        EventBus.on(
            "PRESS_OK_TUTORIAL",
            function()
                if current_step == 0 then
                    restart_func()
                    next_step()
                elseif current_step == 1 then
                    next_step()
                elseif current_step == 2 then
                    next_step()
                elseif current_step == 3 then
                    next_step()
                elseif current_step == 4 then
                    GameStorage.set("tutorial_done", true)
                    Scene.restart()
                end
            end,
            true
        )
        EventBus.trigger("TUTORIAL_INIT")
        hand = hash("/hand")
        local ____view_data_0 = view.data
        go_cards = ____view_data_0.go_cards
        go_free_cells = ____view_data_0.go_free_cells
        local go_home = ____view_data_0.go_home
        gm = ____view_data_0.gm
        step_actions[#step_actions + 1] = function()
            move_hand_on_stack(
                array.last(gsm:get_game_state().stack_ids[6]),
                array.last(gsm:get_game_state().stack_ids[7])
            )
            solver:set_valid_moves(
                get_card_id("b5"),
                {8}
            )
            solver:block_all_cards()
            solver:unblock_cards({get_card_id("b5")})
            refresh_view()
        end
        step_actions[#step_actions + 1] = function()
            solver:set_valid_moves(
                get_card_id("b2"),
                GAME_CONSTS.values.free_cells_ids
            )
            solver:block_all_cards()
            solver:unblock_cards({get_card_id("b2")})
            refresh_view()
            move_hand_from_stack_to_freecell(
                array.last(gsm:get_game_state().stack_ids[6]),
                0
            )
        end
        step_actions[#step_actions + 1] = function()
            solver:block_all_cards()
            solver:set_valid_moves(
                get_card_id("p3"),
                {8}
            )
            solver:unblock_cards({get_card_id("p3")})
            refresh_view()
            move_hand_on_stack(
                array.last(gsm:get_game_state().stack_ids[6]),
                array.last(gsm:get_game_state().stack_ids[7])
            )
        end
        step_actions[#step_actions + 1] = function()
            solver:block_all_cards()
            solver:set_valid_moves(
                get_card_id("b8"),
                {6}
            )
            solver:unblock_cards({get_card_id("b8")})
            refresh_view()
            move_hand_on_stack(
                array.last(gsm:get_game_state().stack_ids[6]),
                array.last(gsm:get_game_state().stack_ids[5])
            )
        end
        step_actions[#step_actions + 1] = function()
            solver:block_all_cards()
            solver:set_valid_moves(
                get_card_id("p7"),
                {6}
            )
            solver:unblock_cards({
                get_card_id("p7"),
                get_card_id("b6"),
                get_card_id("p5"),
                get_card_id("b4"),
                get_card_id("p3")
            })
            refresh_view()
            move_hand_on_stack(
                gsm:get_game_state().stack_ids[7][1],
                array.last(gsm:get_game_state().stack_ids[5])
            )
        end
    end
    local _this = {init = init, show_window = show_window, next_step = next_step, move_card = move_card}
    return _this
end
return ____exports
