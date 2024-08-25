local ____exports = {}
local ____phys = require("utils.phys")
local phys = ____phys.phys
local ____ECS = require("ecs.core.ECS")
local ecs = ____ECS.ecs
function ____exports.PhysicMoveSystem()
    local tmp = vmath.vector3()
    return ecs.systems.create(
        {"PositionComponent", "GO", "VelocityComponent"},
        {
            update = function(____, e)
                for ____, entity in ipairs(e) do
                    local ____entity_components_0 = entity.components
                    local PositionComponent = ____entity_components_0.PositionComponent
                    local GO = ____entity_components_0.GO
                    local VelocityComponent = ____entity_components_0.VelocityComponent
                    local velocity = phys.get_linear_velocity(GO.hash)
                    velocity.x = VelocityComponent.x
                    if math.abs(velocity.y) <= 17 then
                        velocity.y = VelocityComponent.y ~= 0 and VelocityComponent.y or velocity.y
                    end
                    phys.set_linear_velocity(GO.hash, velocity)
                end
            end,
            on_entity_added = function(self, entity)
                pprint(entity)
                local ____entity_components_1 = entity.components
                local PositionComponent = ____entity_components_1.PositionComponent
                local GO = ____entity_components_1.GO
                tmp.x = PositionComponent.x
                tmp.y = PositionComponent.y
                go.set_position(tmp, GO.hash)
            end
        }
    )
end
return ____exports
