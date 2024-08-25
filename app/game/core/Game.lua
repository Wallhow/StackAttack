local ____exports = {}
local ____GoSetPositionSystem = require("ecs.systems.GoSetPositionSystem")
local GoSetPositionSystem = ____GoSetPositionSystem.GoSetPositionSystem
local ____InputListenerSystem = require("ecs.systems.InputListenerSystem")
local InputListenerSystem = ____InputListenerSystem.InputListenerSystem
local ____MoveSystem = require("ecs.systems.MoveSystem")
local MoveSystem = ____MoveSystem.MoveSystem
local ____PhysicMoveSystem = require("ecs.systems.PhysicMoveSystem")
local PhysicMoveSystem = ____PhysicMoveSystem.PhysicMoveSystem
local ____TintSystem = require("ecs.systems.TintSystem")
local TintSystem = ____TintSystem.TintSystem
local ____BoxEntity = require("game.core.entities.BoxEntity")
local newBoxEntity = ____BoxEntity.newBoxEntity
local ____CharEntity = require("game.core.entities.CharEntity")
local newCharEntity = ____CharEntity.newCharEntity
function ____exports.Game()
    local function register_ecs_systems()
        return {
            TintSystem,
            InputListenerSystem,
            MoveSystem,
            GoSetPositionSystem,
            PhysicMoveSystem
        }
    end
    local function init()
        newCharEntity({x = 480, y = 270})
        newBoxEntity({
            x = math.random(10, 950),
            y = 540
        })
        timer.delay(
            3,
            true,
            function()
                newBoxEntity({
                    x = math.random(10, 950),
                    y = 540
                })
            end
        )
    end
    return {register_ecs_systems = register_ecs_systems, init = init}
end
return ____exports
