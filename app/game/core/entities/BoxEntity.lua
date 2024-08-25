local ____exports = {}
local ____ECS = require("ecs.core.ECS")
local ecs = ____ECS.ecs
function ____exports.newBoxEntity(pos)
    local gameObj = ecs.comps.create(
        "GO",
        {hash = factory.create(
            "/prefabs#" .. "test",
            vmath.vector3()
        )}
    )
    local comp = ecs.comps.create("PositionComponent", {x = pos.x, y = pos.y})
    local e = ecs.newEntity()
    local tint = ecs.comps.create(
        "TintComponent",
        {
            x = 1,
            y = 1,
            z = 1,
            spriteUrl = msg.url(nil, gameObj.hash, "sprite")
        }
    )
    local v = ecs.comps.create("VelocityComponent", {x = 0, y = -100})
    ecs.addComponent(e, comp)
    ecs.addComponent(e, gameObj)
    ecs.addComponent(e, tint)
    ecs.addComponent(e, v)
    ecs.pack(e)
end
return ____exports
