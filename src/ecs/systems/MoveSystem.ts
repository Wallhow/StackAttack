import { ecs } from "../core/ECS";

export function MoveSystem() {
    return ecs.systems.create(['PositionComponent', 'VelocityComponent'], {
        update: (e, dt) => {
            for (const entity of e) {
                const { PositionComponent, VelocityComponent } = entity.components;
                const is_diagonaled_move = VelocityComponent.x != 0 && VelocityComponent.y != 0;
                PositionComponent.y += VelocityComponent.y / (is_diagonaled_move ? 2 : 1) * dt;
                PositionComponent.x += VelocityComponent.x / (is_diagonaled_move ? 2 : 1) * dt;
            }

        }
    });
}