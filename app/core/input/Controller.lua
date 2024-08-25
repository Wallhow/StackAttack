local ____exports = {}
local ____CONSTS = require("ecs.CONSTS")
local InputKeys = ____CONSTS.InputKeys
function ____exports.newController()
    local pressed, listeners, hashesKey
    function pressed(key, isPressed)
        if hashesKey:includes(key) then
            if listeners[hashesKey:indexOf(key)] ~= nil then
                for ____, listener in ipairs(listeners[hashesKey:indexOf(key)]) do
                    listener(isPressed)
                end
            end
        end
    end
    listeners = {}
    hashesKey = InputKeys:map(function(k) return hash(k) end)
    local function input(action_id, action)
        if action_id ~= hash("touch") and (action.pressed or action.released) then
            pressed(action_id, action.pressed ~= nil and action.pressed == true)
        end
    end
    local function on(key, func)
        if listeners[InputKeys:indexOf(key)] == nil then
            listeners[InputKeys:indexOf(key)] = {}
        end
        local ____listeners_index_0 = listeners[InputKeys:indexOf(key)]
        ____listeners_index_0[#____listeners_index_0 + 1] = func
    end
    return {pressed = pressed, input = input, on = on}
end
return ____exports
