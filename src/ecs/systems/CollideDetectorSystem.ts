import { ecs } from "../core/ECS";
export function CollideDetectorSystem() {
    const tmp = vmath.vector3();
    return ecs.systems.create(['CollidableComponent', 'GO'], {
        update: (e) => {

        },

        on_entity_added(entity) {

        },
    });
}