/* eslint-disable no-constant-condition */
/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-empty-interface */

import { ecs } from "../ecs/core/ECS";
import * as ortho_cam from 'orthographic.camera';

import * as flow from 'ludobits.m.flow';
import { Game } from "./core/Game";

interface props {
    is_visible: boolean
    main_thread: Coroutine;
    game: ReturnType<typeof Game>
}

export function init(this: props) {

    msg.post("@system:", "toggle_physics_debug");

    Manager.init_script();
    msg.post('.', 'acquire_input_focus');


    this.game = Game();

    ecs.systems.init(ecs, this.game.register_ecs_systems());

    this.main_thread = flow.start(() => {
        this.game.init();
        EventBus.on('RAW_INPUT', ({ action_id, action }) => ecs.input(action_id, action));
        EventBus.on('UPDATE', ({ dt }) => ecs.update(dt));
        while (true) {
            const [message_id, _message, sender] = flow.until_any_message();
            EventBus.on_message(null, message_id, _message, sender);
        }
    }, {});

}



export function on_message(this: props, message_id: hash, message: any, sender: any): void {
    flow.on_message(message_id, message, sender);
}
export function update(this: props, dt: number) {
    EventBus.trigger('UPDATE', { dt });
}
export function on_input(this: props, action_id: string | hash, action: any): void {
    if (action_id == ID_MESSAGES.MSG_TOUCH)
        msg.post('.', action_id, action);

    EventBus.trigger('RAW_INPUT', { action_id, action });
}


export function final(this: props) {
    Manager.final_script();
    flow.stop();
}

