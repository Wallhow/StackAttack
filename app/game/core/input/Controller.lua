local ____lualib = require("lualib_bundle")
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local ____exports = {}
local ____CONSTS = require("ecs.CONSTS")
local InputKeys = ____CONSTS.InputKeys
function ____exports.newController()
    local pressed, listeners, hashesKey
    function pressed(key, isPressed)
        if __TS__ArrayIncludes(hashesKey, key) then
            if listeners[__TS__ArrayIndexOf(hashesKey, key)] ~= nil then
                for ____, listener in ipairs(listeners[__TS__ArrayIndexOf(hashesKey, key)]) do
                    listener(isPressed)
                end
            end
        end
    end
    listeners = {}
    hashesKey = __TS__ArrayMap(
        InputKeys,
        function(____, k) return hash(k) end
    )
    local function input(action_id, action)
        if action_id ~= hash("touch") and (action.pressed or action.released) then
            pressed(action_id, action.pressed ~= nil and action.pressed == true)
        end
    end
    local function on(key, func)
        if listeners[__TS__ArrayIndexOf(InputKeys, key)] == nil then
            listeners[__TS__ArrayIndexOf(InputKeys, key)] = {}
        end
        local ____listeners___TS__ArrayIndexOf_result_0 = listeners[__TS__ArrayIndexOf(InputKeys, key)]
        ____listeners___TS__ArrayIndexOf_result_0[#____listeners___TS__ArrayIndexOf_result_0 + 1] = func
    end
    return {pressed = pressed, input = input, on = on}
end
return ____exports
