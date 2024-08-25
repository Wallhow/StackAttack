import { phys } from "../../utils/phys";
import { ecs } from "../core/ECS";

export function PhysicMoveSystem() {
    const tmp = vmath.vector3();
    return ecs.systems.create(['PositionComponent', 'GO', 'VelocityComponent'
    ], {
        update: (e) => {

            for (const entity of e) {
                const { PositionComponent, GO, VelocityComponent } = entity.components;

                const velocity = phys.get_linear_velocity(GO.hash);
                velocity.x = VelocityComponent.x;

                if (math.abs(velocity.y) <= 17)
                    velocity.y = VelocityComponent.y != 0 ? VelocityComponent.y : velocity.y;
                phys.set_linear_velocity(GO.hash, velocity);

            }
        },

        on_entity_added(entity) {
            pprint(entity);
            const { PositionComponent, GO } = entity.components;
            tmp.x = PositionComponent.x;
            tmp.y = PositionComponent.y;
            go.set_position(tmp, GO.hash);
        },
    });
}