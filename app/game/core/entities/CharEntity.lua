local ____exports = {}
local ____CONSTS = require("ecs.CONSTS")
local ControllableComponentStates = ____CONSTS.ControllableComponentStates
local ____ECS = require("ecs.core.ECS")
local ecs = ____ECS.ecs
function ____exports.newCharEntity(pos)
    local gameObj = ecs.comps.create(
        "GO",
        {hash = factory.create(
            "/prefabs#" .. "player",
            vmath.vector3()
        )}
    )
    local comp = ecs.comps.create("PositionComponent", {x = pos.x, y = pos.y})
    local e = ecs.newEntity()
    local velocity = ecs.comps.create("VelocityComponent", {x = 0, y = 0})
    local tint = ecs.comps.create(
        "TintComponent",
        {
            x = 1,
            y = 1,
            z = 1,
            spriteUrl = msg.url(nil, gameObj.hash, "sprite")
        }
    )
    local controllable = ecs.comps.create("ControllableComponent", {speed = {x = 300, y = 500}, current_state = ControllableComponentStates.IDLE, pre_state = ControllableComponentStates.INITIAL})
    ecs.addComponent(e, comp)
    ecs.addComponent(e, gameObj)
    ecs.addComponent(e, velocity)
    ecs.addComponent(e, controllable)
    ecs.addComponent(e, tint)
    ecs.pack(e)
end
return ____exports
