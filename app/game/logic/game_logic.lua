local ____exports = {}
local flow = require("ludobits.m.flow")
local ____ViewController = require("logic.view.ViewController")
local ViewController = ____ViewController.ViewController
local ____GameState = require("data_oriented_core.GameState")
local GameState = ____GameState.GameState
local ____utils = require("utils.utils")
local ____repeat = ____utils["repeat"]
function ____exports.Game()
    local new_game, subscribe_events, wait_event, view
    function new_game()
    end
    function subscribe_events()
        EventBus.on(
            "LAYOUT_CHANGED",
            function(d)
            end,
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
    local game_state = GameState({boxes = {}, field = {}, reserve = {}})
    local win_width = 960
    local rows = win_width / 64
    ____repeat(
        rows,
        function(i)
            game_state.get().boxes[i + 1] = i
        end
    )
    view = ViewController()
    subscribe_events()
    local function init()
        new_game()
        view.set_get_game_state_func(game_state.get)
        view.init()
        view.seq_update_data_view(
            {move_t = 1},
            function()
            end
        )
        wait_event()
    end
    init()
    return {}
end
return ____exports
