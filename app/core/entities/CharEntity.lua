local ____exports = {}
local ____ECS = require("ecs.core.ECS")
local ecs = ____ECS.ecs
function ____exports.newCharEntity(pos)
    local gameObj = ecs.comps:create(
        "GO",
        {hash = factory.create(
            "/factories#" .. "character",
            vmath.vector3()
        )}
    )
    local comp = ecs.comps:create("PositionComponent", {x = pos.x, y = pos.y})
    local e = ecs:newEntity()
    local velocity = ecs.comps:create("VelocityComponent", {x = 0, y = 0})
    local tint = ecs.comps:create(
        "TintComponent",
        {
            x = 1,
            y = 1,
            z = 1,
            spriteUrl = msg.url(nil, gameObj.hash, "sprite")
        }
    )
    local controller = ecs.comps:create(
        "InputComponent",
        {init = function(self, controller)
            controller:on(
                "W",
                function(isPressed)
                    velocity.y = isPressed and 10 or 0
                    tint.z = isPressed and 0.5 or 1
                end
            )
            controller:on(
                "S",
                function(isPressed)
                    velocity.y = isPressed and -10 or 0
                    tint.z = isPressed and 0 or 1
                end
            )
            controller:on(
                "A",
                function(isPressed)
                    local ____temp_0 = isPressed and -10 or 0
                    velocity.x = ____temp_0
                    return ____temp_0
                end
            )
            controller:on(
                "D",
                function(isPressed)
                    local ____temp_1 = isPressed and 10 or 0
                    velocity.x = ____temp_1
                    return ____temp_1
                end
            )
        end}
    )
    ecs:addComponent(e, comp)
    ecs:addComponent(e, gameObj)
    ecs:addComponent(e, velocity)
    ecs:addComponent(e, controller)
    ecs:addComponent(e, tint)
end
return ____exports
