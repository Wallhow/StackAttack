/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable no-constant-condition */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable no-empty */
/* eslint-disable @typescript-eslint/no-non-null-assertion */
/* eslint-disable prefer-const */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
/* eslint-disable @typescript-eslint/no-empty-function */

import * as flow from 'ludobits.m.flow';
import { ViewController } from '../../logic/view/ViewController';
import { GameState, StateSchema } from '../../data_oriented_core/GameState';
import { repeat } from '../../utils/utils';


export function Game() {



    const game_state = GameState({
        boxes: [],
        field: [],
        reserve: [],
    });

    const win_width = 960;
    const rows = win_width / 64;


    repeat(rows, (i) => {
        game_state.get().boxes[i] = i;
    });


    const view = ViewController();

    subscribe_events();

    function init() {
        new_game();
        view.set_get_game_state_func(game_state.get);
        view.init();

        view.seq_update_data_view({ move_t: 1 }, () => {

        });

        wait_event();
    }

    function new_game() {


    }


    function subscribe_events() {
        EventBus.on('LAYOUT_CHANGED', (d) => {
            // view.change_layout(d, is_gameover);
        }, true);
    }

    function wait_event() {
        while (true) {
            const [message_id, _message, sender] = flow.until_any_message();
            view.do_message(message_id, _message, sender);
            EventBus.on_message(null, message_id, _message, sender);
        }
    }


    init();
    return {};
}







