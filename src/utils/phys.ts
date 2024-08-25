/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable @typescript-eslint/no-namespace */

export namespace phys {
    export function set_linear_velocity(go_hash: hash, vel: vmath.vector3, collision_object_name = 'collisionobject') {
        go.set(msg.url(undefined, go_hash, collision_object_name), 'linear_velocity', vel);
    }

    export function get_linear_velocity(go_hash: hash, collision_object_name = 'collisionobject'): vmath.vector3 {
        return go.get(msg.url(undefined, go_hash, collision_object_name), 'linear_velocity');
    }

  
}