/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable @typescript-eslint/ban-types */
/* eslint-disable @typescript-eslint/no-empty-function */

/**
 * @noSelfInFile
*/

import { ControllableComponentStates, InputKeys } from "../ecs/CONSTS";
import { newController } from "../game/core/input/Controller";
import { v2 } from "./core/types";

export const UserComponentsIDs = [
    'UserComponent', 'GO', 'InputComponent', 'VelocityComponent', 'TintComponent', 'ControllableComponent', 'CollidableComponent'
] satisfies (Required<keyof UserComps>)[];

export type UserComps = {
    UserComponent: {
        name: string,
        UUID: 'UserComponent'
    },

    GO: { hash: hash },


    CollidableComponent: { collide_info: any | null };
    VelocityComponent: v2,
    TintComponent: v2 & { z: number } & { spriteUrl: url },

    InputComponent: {
        init: (controller: ReturnType<typeof newController>) => void
    },

    ControllableComponent: {
        speed: v2,
        current_state: ControllableComponentStates
        pre_state: ControllableComponentStates
    }
};




