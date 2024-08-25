
import { newController } from "../../game/core/input/Controller";
import { ecs } from "../core/ECS";

export function ControllerSystem() {
    const controllers: { [id: number]: ReturnType<typeof newController> } = {};
    return ecs.systems.create(['InputComponent'], {
        input: (entities, action_id, action) => {
            for (const e of entities) {
                if (controllers[e.id] == undefined) {
                    controllers[e.id] = newController();
                    e.components.InputComponent.init(controllers[e.id]);
                }
                controllers[e.id].input(action_id, action);
            }
        }
    });
}