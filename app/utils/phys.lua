local ____exports = {}
____exports.phys = {}
local phys = ____exports.phys
do
    function phys.set_linear_velocity(go_hash, vel, collision_object_name)
        if collision_object_name == nil then
            collision_object_name = "collisionobject"
        end
        go.set(
            msg.url(nil, go_hash, collision_object_name),
            "linear_velocity",
            vel
        )
    end
    function phys.get_linear_velocity(go_hash, collision_object_name)
        if collision_object_name == nil then
            collision_object_name = "collisionobject"
        end
        return go.get(
            msg.url(nil, go_hash, collision_object_name),
            "linear_velocity"
        )
    end
end
return ____exports
