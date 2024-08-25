import { ControllableComponentStates } from "../../../ecs/CONSTS";
import { ecs } from "../../../ecs/core/ECS";

export function newCharEntity(pos: { x: number, y: number }) {
    const gameObj = ecs.comps.create('GO', { hash: factory.create("/prefabs#" + 'player', vmath.vector3()) });
    const comp = ecs.comps.create('PositionComponent', { x: pos.x, y: pos.y });


    const e = ecs.newEntity();
    const velocity = ecs.comps.create('VelocityComponent', { x: 0, y: 0 });
    const tint = ecs.comps.create('TintComponent', { x: 1, y: 1, z: 1, spriteUrl: msg.url(undefined, gameObj.hash, 'sprite') });
    const controllable = ecs.comps.create('ControllableComponent', {
        speed: { x: 300, y: 500 },
        current_state: ControllableComponentStates.IDLE,
        pre_state: ControllableComponentStates.INITIAL
    });


    ecs.addComponent(e, comp);
    ecs.addComponent(e, gameObj);
    ecs.addComponent(e, velocity);
    //ecs.addComponent(e, controller);
    ecs.addComponent(e, controllable);
    ecs.addComponent(e, tint);

    ecs.pack(e);
}