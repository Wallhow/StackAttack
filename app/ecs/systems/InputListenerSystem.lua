local ____exports = {}
local ____Controller = require("game.core.input.Controller")
local newController = ____Controller.newController
local ____CONSTS = require("ecs.CONSTS")
local ControllableComponentStates = ____CONSTS.ControllableComponentStates
local InputKeys = ____CONSTS.InputKeys
local ____ECS = require("ecs.core.ECS")
local ecs = ____ECS.ecs
function ____exports.InputListenerSystem()
    local controller = newController()
    local key_state = {
        A = false,
        W = false,
        D = false,
        S = false,
        SPACE = false
    }
    for ____, key in ipairs(InputKeys) do
        controller.on(
            key,
            function(isPressed)
                key_state[key] = isPressed
            end
        )
    end
    local function determine_movement()
        local dir = {x = 0, y = 0}
        if key_state.A and key_state.D then
            dir.x = 0
        elseif key_state.A then
            dir.x = -1
        elseif key_state.D then
            dir.x = 1
        end
        if key_state.W and key_state.S then
            dir.y = 0
        elseif key_state.W then
            dir.y = 1
        elseif key_state.S then
            dir.y = -1
        end
        return dir
    end
    local function dir_to_state(dir, isJumping)
        if isJumping then
            return ControllableComponentStates.JUMPING
        end
        local ____dir_0 = dir
        local x = ____dir_0.x
        local y = ____dir_0.y
        if x == 0 and y == 0 then
            return ControllableComponentStates.IDLE
        end
        if x == -1 and y == 0 then
            return ControllableComponentStates.MOVING_L
        end
        if x == 1 and y == 0 then
            return ControllableComponentStates.MOVING_R
        end
        if x == 0 and y == 1 then
            return ControllableComponentStates.MOVING_U
        end
        if x == 0 and y == -1 then
            return ControllableComponentStates.MOVING_D
        end
        if x == -1 and y == 1 then
            return ControllableComponentStates.MOVING_LU
        end
        if x == -1 and y == -1 then
            return ControllableComponentStates.MOVING_LD
        end
        if x == 1 and y == 1 then
            return ControllableComponentStates.MOVING_RU
        end
        if x == 1 and y == -1 then
            return ControllableComponentStates.MOVING_RD
        end
        return ControllableComponentStates.IDLE
    end
    return ecs.systems.create(
        {"ControllableComponent", "VelocityComponent"},
        {
            init = function()
                EventBus.on(
                    "RAW_INPUT",
                    function(____bindingPattern0)
                        local action
                        local action_id
                        action_id = ____bindingPattern0.action_id
                        action = ____bindingPattern0.action
                        controller.input(action_id, action)
                    end
                )
            end,
            update = function(self, entities)
                for ____, e in ipairs(entities) do
                    local ____e_components_1 = e.components
                    local VelocityComponent = ____e_components_1.VelocityComponent
                    local ControllableComponent = ____e_components_1.ControllableComponent
                    local movement = determine_movement()
                    local isJumping = key_state.SPACE
                    if isJumping and ControllableComponent.pre_state ~= ControllableComponentStates.JUMPING then
                        VelocityComponent.y = 1 * ControllableComponent.speed.y * 1.5
                    else
                        VelocityComponent.x = movement.x * ControllableComponent.speed.x
                        VelocityComponent.y = movement.y * ControllableComponent.speed.y
                    end
                    ControllableComponent.pre_state = ControllableComponent.current_state
                    ControllableComponent.current_state = dir_to_state(movement, isJumping)
                end
            end
        }
    )
end
return ____exports
