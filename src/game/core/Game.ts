import { ecs } from "../../ecs/core/ECS";
import { GoSetPositionSystem } from "../../ecs/systems/GoSetPositionSystem";
import { InputListenerSystem } from "../../ecs/systems/InputListenerSystem";
import { MoveSystem } from "../../ecs/systems/MoveSystem";
import { PhysicMoveSystem } from "../../ecs/systems/PhysicMoveSystem";
import { TintSystem } from "../../ecs/systems/TintSystem";
import { newBoxEntity } from "./entities/BoxEntity";
import { newCharEntity } from "./entities/CharEntity";

export function Game() {
    function register_ecs_systems() {
        return [
            TintSystem,
            InputListenerSystem,
            MoveSystem,
            GoSetPositionSystem,
            PhysicMoveSystem,
        ];
    }

    function init() {
        newCharEntity({ x: 480, y: 270 });

        newBoxEntity({ x: math.random(10, 950), y: 540 });

        timer.delay(3, true, () => {
            newBoxEntity({ x: math.random(10, 950), y: 540 });
        });
    }



    return {
        register_ecs_systems, init

    };
}