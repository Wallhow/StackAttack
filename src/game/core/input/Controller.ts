/* eslint-disable @typescript-eslint/no-unsafe-member-access */

import { InputKeys } from "../../../ecs/CONSTS";


export function newController() {
    const listeners: { [key: number]: ((isPressed: boolean) => void)[] } = {} as { [key in typeof InputKeys[number]]: ((isPressed: boolean) => void)[] };
    const hashesKey = InputKeys.map(k => hash(k));
    function input(action_id: hash, action: any) {
        if (action_id != hash('touch') && (action.pressed || action.released))
            pressed(action_id, action.pressed != undefined && action.pressed == true);
    }

    function on(key: typeof InputKeys[number], func: (isPressed: boolean) => void) {
        if (listeners[InputKeys.indexOf(key)] == undefined)
            listeners[InputKeys.indexOf(key)] = [];
        listeners[InputKeys.indexOf(key)].push(func);
    }


    function pressed(key: hash, isPressed: boolean) {
        if (hashesKey.includes(key)) {
            if (listeners[hashesKey.indexOf(key)] != undefined) {
                for (const listener of listeners[hashesKey.indexOf(key)])
                    listener(isPressed);
            }
        }

    }

    return {
        pressed, input, on
    };
}