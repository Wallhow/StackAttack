local ____exports = {}
local ____Controller = require("game.core.input.Controller")
local newController = ____Controller.newController
local ____ECS = require("ecs.core.ECS")
local ecs = ____ECS.ecs
function ____exports.ControllerSystem()
    local controllers = {}
    return ecs.systems.create(
        {"InputComponent"},
        {input = function(____, entities, action_id, action)
            for ____, e in ipairs(entities) do
                if controllers[e.id] == nil then
                    controllers[e.id] = newController()
                    e.components.InputComponent:init(controllers[e.id])
                end
                controllers[e.id].input(action_id, action)
            end
        end}
    )
end
return ____exports
