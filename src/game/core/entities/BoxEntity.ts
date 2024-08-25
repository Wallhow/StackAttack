
import { ecs } from "../../../ecs/core/ECS";
import { phys } from "../../../utils/phys";

export function newBoxEntity(pos: { x: number, y: number }) {
    const gameObj = ecs.comps.create('GO', { hash: factory.create("/prefabs#" + 'test', vmath.vector3()) });
    const comp = ecs.comps.create('PositionComponent', { x: pos.x, y: pos.y });


    const e = ecs.newEntity();
    const tint = ecs.comps.create('TintComponent', { x: 1, y: 1, z: 1, spriteUrl: msg.url(undefined, gameObj.hash, 'sprite') });
    const v = ecs.comps.create('VelocityComponent', { x: 0, y: -100 });
    ecs.addComponent(e, comp);
    ecs.addComponent(e, gameObj);
    ecs.addComponent(e, tint);
    ecs.addComponent(e, v);




    ecs.pack(e);
}