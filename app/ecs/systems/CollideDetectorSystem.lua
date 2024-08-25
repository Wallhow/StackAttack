local ____exports = {}
local ____ECS = require("ecs.core.ECS")
local ecs = ____ECS.ecs
function ____exports.CollideDetectorSystem()
    local tmp = vmath.vector3()
    return ecs.systems.create(
        {"CollidableComponent", "GO"},
        {
            update = function(____, e)
            end,
            on_entity_added = function(self, entity)
            end
        }
    )
end
return ____exports
