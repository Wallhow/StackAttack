local ____exports = {}
local ____ECS = require("ecs.core.ECS")
local ecs = ____ECS.ecs
function ____exports.MoveSystem()
    return ecs.systems.create(
        {"PositionComponent", "VelocityComponent"},
        {update = function(____, e, dt)
            for ____, entity in ipairs(e) do
                local ____entity_components_0 = entity.components
                local PositionComponent = ____entity_components_0.PositionComponent
                local VelocityComponent = ____entity_components_0.VelocityComponent
                local is_diagonaled_move = VelocityComponent.x ~= 0 and VelocityComponent.y ~= 0
                PositionComponent.y = PositionComponent.y + VelocityComponent.y / (is_diagonaled_move and 2 or 1) * dt
                PositionComponent.x = PositionComponent.x + VelocityComponent.x / (is_diagonaled_move and 2 or 1) * dt
            end
        end}
    )
end
return ____exports
