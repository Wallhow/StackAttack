local ____exports = {}
local ____ECS = require("ecs.core.ECS")
local ecs = ____ECS.ecs
local ____ControllerSystem = require("ecs.systems.ControllerSystem")
local ControllerSystem = ____ControllerSystem.ControllerSystem
local ____GoSetPositionSystem = require("ecs.systems.GoSetPositionSystem")
local GoSetPositionSystem = ____GoSetPositionSystem.GoSetPositionSystem
local ____MoveSystem = require("ecs.systems.MoveSystem")
local MoveSystem = ____MoveSystem.MoveSystem
local ____TintSystem = require("ecs.systems.TintSystem")
local TintSystem = ____TintSystem.TintSystem
local ____CharEntity = require("game.core.entities.CharEntity")
local newCharEntity = ____CharEntity.newCharEntity
function ____exports.MainLoop()
    newCharEntity({x = 0, y = 0})
    ecs.systems.init(ecs, {ControllerSystem, MoveSystem, GoSetPositionSystem, TintSystem})
end
return ____exports
