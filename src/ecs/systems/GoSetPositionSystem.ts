import { ecs } from "../core/ECS";

export function GoSetPositionSystem() {
    const tmp = vmath.vector3();
    return ecs.systems.create(['PositionComponent', 'GO'], {
        update: (e) => {

            for (const entity of e) {

                const { PositionComponent, GO } = entity.components;
                tmp.x = PositionComponent.x;
                tmp.y = PositionComponent.y;
                go.set_position(tmp, GO.hash);
            }
        },

        on_entity_added(entity) {
            pprint(entity);
            const { PositionComponent, GO } = entity.components;
            tmp.x = PositionComponent.x;
            tmp.y = PositionComponent.y;
            go.set_position(tmp, GO.hash);
        },
    }, ['ControllableComponent']);
}