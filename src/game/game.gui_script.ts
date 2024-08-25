/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import * as druid from 'druid.druid';
import { DailyBonuses } from '../logic/advanced/DailyBonuses';

interface props {
    druid: DruidClass;
    update_ui: () => void;
}

export function init(_this: props): void {
    Manager.init_script();
    _this.druid = druid.new(_this);
    const node_names = [
    ] as const;


}


export function on_input(this: props, action_id: string | hash, action: any) {
    Camera.transform_input_action(action);
    return this.druid.on_input(action_id, action);
}

export function update(this: props, dt: number): void {
    this.druid.update(dt);
}

export function on_message(this: props, message_id: string | hash, message: any, sender: string | hash | url): void {
    this.druid.on_message(message_id, message, sender);
}

export function final(this: props): void {
    DailyBonuses.final();
    Manager.final_script();
    Camera.set_gui_projection(false);
    this.druid.final();
}