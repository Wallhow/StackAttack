import { ecs } from "../core/ECS";

export function TintSystem() {
    return ecs.systems.create(['GO', 'TintComponent'], {
        update: (e, dt) => {
            for (const entity of e) {
                const { GO, TintComponent } = entity.components;
                TintComponent.x += (10 * dt);
                TintComponent.y -= (10 * dt);
                if (TintComponent.x >= 1) TintComponent.x = 0;
                if (TintComponent.y <= 0) TintComponent.y = 1;
                go.set(TintComponent.spriteUrl, 'tint', vmath.vector4(TintComponent.x, TintComponent.y, TintComponent.z, 1));
            }
        }
    });
}