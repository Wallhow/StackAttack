
import { newController } from "../../game/core/input/Controller";
import { ControllableComponentStates, InputKeys } from "../CONSTS";
import { ecs } from "../core/ECS";
import { v2 } from "../core/types";

export function InputListenerSystem() {
    const controller = newController();
    const key_state: Record<typeof InputKeys[number], boolean> = {
        'A': false,
        'W': false,
        'D': false,
        'S': false,
        'SPACE': false,
    };

    for (const key of InputKeys)
        controller.on(key, isPressed => {
            key_state[key] = isPressed;
        });

    function determine_movement(): v2 {
        const dir = { x: 0, y: 0 };

        if (key_state.A && key_state.D)
            dir.x = 0; // стоять на месте если нажаты обе клавиши
        else if (key_state.A)
            dir.x = -1;
        else if (key_state.D)
            dir.x = 1;

        if (key_state.W && key_state.S)
            dir.y = 0;
        else if (key_state.W)
            dir.y = 1;
        else if (key_state.S)
            dir.y = -1;

        return dir;
    }

    function dir_to_state(dir: v2, isJumping: boolean): ControllableComponentStates {
        if (isJumping) return ControllableComponentStates.JUMPING;

        const { x, y } = dir;

        if (x === 0 && y === 0) return ControllableComponentStates.IDLE;
        if (x === -1 && y === 0) return ControllableComponentStates.MOVING_L;
        if (x === 1 && y === 0) return ControllableComponentStates.MOVING_R;
        if (x === 0 && y === 1) return ControllableComponentStates.MOVING_U;
        if (x === 0 && y === -1) return ControllableComponentStates.MOVING_D;
        if (x === -1 && y === 1) return ControllableComponentStates.MOVING_LU;
        if (x === -1 && y === -1) return ControllableComponentStates.MOVING_LD;
        if (x === 1 && y === 1) return ControllableComponentStates.MOVING_RU;
        if (x === 1 && y === -1) return ControllableComponentStates.MOVING_RD;

        return ControllableComponentStates.IDLE; // на всякий случай
    }

    return ecs.systems.create(['ControllableComponent', 'VelocityComponent'], {
        init: () => {
            EventBus.on('RAW_INPUT', ({ action_id, action }) => {
                controller.input(action_id, action);
            });
        },
        update(entities) {
            for (const e of entities) {

                const { VelocityComponent, ControllableComponent } = e.components;
                const movement = determine_movement();
                const isJumping = key_state.SPACE;
                if (isJumping && ControllableComponent.pre_state != ControllableComponentStates.JUMPING) {
                    VelocityComponent.y = 1 * ControllableComponent.speed.y * 1.5;
                } else {
                    VelocityComponent.x = movement.x * ControllableComponent.speed.x;
                    VelocityComponent.y = movement.y * ControllableComponent.speed.y;
                }
                ControllableComponent.pre_state = ControllableComponent.current_state;
                ControllableComponent.current_state = dir_to_state(movement, isJumping);
               
            }
        }
    });
}