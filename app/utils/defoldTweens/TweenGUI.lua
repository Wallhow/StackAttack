local ____lualib = require("lualib_bundle")
local __TS__ArrayReduce = ____lualib.__TS__ArrayReduce
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__StringIncludes = ____lualib.__TS__StringIncludes
local __TS__StringReplace = ____lualib.__TS__StringReplace
local ____exports = {}
local flow = require("ludobits.m.flow")
local _defaultGUIOpationsMap = {easing = "EASING_LINEAR", playback = "PLAYBACK_ONCE_FORWARD", delay = 0, compliteFunc = nil}
function ____exports._newTweensForNode(obj)
    local runByOrToTween, _isBy, _getOtherOpt, _getValue, _getAxis, _getClearProp, _getNodeProp, _setNodeProp, _getGetGUIOtherOpt, currentNode, isParallelMode, tweensForNode
    function runByOrToTween(tween, tweenIdx)
        local ____tween_2 = tween
        local duration = ____tween_2.duration
        local delay = ____tween_2.delay
        local node = ____tween_2.node
        local prop = ____tween_2.prop
        local value = ____tween_2.value
        local compliteFunc = ____tween_2.compliteFunc
        local playback = ____tween_2.playback
        local easing = ____tween_2.easing
        local isNeedInstantSet = tweenIdx == 0 and delay == 0 and duration == 0
        local val = _isBy(tween) and tween:getValueFun() or value
        if not isNeedInstantSet then
            if isParallelMode then
                local parallelCoroutine
                parallelCoroutine = flow.start(
                    function()
                        flow.gui_animate(
                            node,
                            prop,
                            playback,
                            val,
                            easing,
                            duration,
                            delay
                        )
                        flow.stop(parallelCoroutine)
                    end,
                    {parallel = true}
                )
            else
                flow.gui_animate(
                    node,
                    prop,
                    playback,
                    val,
                    easing,
                    duration,
                    delay
                )
            end
        else
            _setNodeProp(tween.prop, val)
        end
        if compliteFunc ~= nil then
            compliteFunc()
        end
    end
    function _isBy(tween)
        return tween.key == "BY"
    end
    function _getOtherOpt(otherOpt)
        local easing = gui[_getGetGUIOtherOpt(otherOpt, "easing")]
        local playback = gui[_getGetGUIOtherOpt(otherOpt, "playback")]
        local delay = _getGetGUIOtherOpt(otherOpt, "delay")
        local compliteFunc = _getGetGUIOtherOpt(otherOpt, "compliteFunc")
        return {easing = easing, playback = playback, delay = delay, compliteFunc = compliteFunc}
    end
    function _getValue(prop, value)
        local axis = _getAxis(prop)
        return axis ~= nil and value[axis] or value[prop]
    end
    function _getAxis(prop)
        if __TS__StringIncludes(prop, ".") then
            local axis = string.sub(
                prop,
                (string.find(prop, ".", nil, true) or 0) - 1 + 2,
                #prop
            )
            return axis
        else
            return nil
        end
    end
    function _getClearProp(prop)
        local axis = _getAxis(prop)
        return axis ~= nil and __TS__StringReplace(prop, "." .. axis, "") or prop
    end
    function _getNodeProp(prop)
        local prop_key = _getClearProp(prop)
        local axis = _getAxis(prop) ~= nil and _getAxis(prop) or ""
        local key = "get_" .. prop_key
        local callableFun = gui[key]
        local returnValue = callableFun(currentNode)
        local ____prop_includes_result_3
        if __TS__StringIncludes(prop, ".") then
            ____prop_includes_result_3 = returnValue[axis]
        else
            ____prop_includes_result_3 = returnValue
        end
        return ____prop_includes_result_3
    end
    function _setNodeProp(prop, value)
        local prop_key = _getClearProp(prop)
        local axis = _getAxis(prop) ~= nil and _getAxis(prop) or ""
        local key = "set_" .. prop_key
        local setFunc = gui[key]
        if axis ~= "" then
            local curPropValue = _getNodeProp(_getClearProp(prop))
            local newValue = value
            curPropValue[axis] = newValue
            setFunc(currentNode, curPropValue)
        else
            setFunc(currentNode, value)
        end
    end
    function _getGetGUIOtherOpt(opt, key)
        if opt == nil then
            return _defaultGUIOpationsMap[key]
        end
        if opt[key] == nil then
            return _defaultGUIOpationsMap[key]
        else
            return opt[key]
        end
    end
    assert(flow ~= nil, "ludobits.m.flow is not defined, please add it to your project this library")
    currentNode = type(obj) == "string" and gui.get_node(obj) or obj
    local sequence = {}
    isParallelMode = false
    local function to(duration, prop, value, otherOpt)
        local ____getOtherOpt_result_0 = _getOtherOpt(otherOpt)
        local easing = ____getOtherOpt_result_0.easing
        local playback = ____getOtherOpt_result_0.playback
        local delay = ____getOtherOpt_result_0.delay
        local compliteFunc = ____getOtherOpt_result_0.compliteFunc
        sequence[#sequence + 1] = {
            key = "TO",
            node = currentNode,
            prop = prop,
            value = _getValue(prop, value),
            duration = duration,
            delay = delay,
            compliteFunc = compliteFunc,
            playback = playback,
            easing = easing
        }
        return tweensForNode
    end
    local function by(duration, prop, value, otherOpt)
        local function getValueFun()
            local curPropValue = _getNodeProp(prop)
            local newValue = _getValue(prop, value)
            return curPropValue + newValue
        end
        local ____getOtherOpt_result_1 = _getOtherOpt(otherOpt)
        local easing = ____getOtherOpt_result_1.easing
        local playback = ____getOtherOpt_result_1.playback
        local delay = ____getOtherOpt_result_1.delay
        local compliteFunc = ____getOtherOpt_result_1.compliteFunc
        sequence[#sequence + 1] = {
            key = "BY",
            getValueFun = getValueFun,
            node = currentNode,
            prop = prop,
            value = 0,
            duration = duration,
            delay = delay,
            compliteFunc = compliteFunc,
            playback = playback,
            easing = easing
        }
        return tweensForNode
    end
    local function call(func)
        sequence[#sequence + 1] = {key = "CALLABLE", func = func}
        return tweensForNode
    end
    local function delay(duration)
        sequence[#sequence + 1] = {key = "DELAY", delay = duration}
        return tweensForNode
    end
    local function parallel()
        sequence[#sequence + 1] = {key = "PARALLEL"}
        return tweensForNode
    end
    local function opacityTo(duration, opacity, otherOpt)
        return to(duration, "color.w", {w = opacity}, otherOpt)
    end
    local function opacityBy(duration, opacity, otherOpt)
        return by(duration, "color.w", {w = opacity}, otherOpt)
    end
    local function moveBy(duration, positionBy, otherOpt)
        return by(
            duration,
            "position",
            {position = vmath.vector3(positionBy.x ~= nil and positionBy.x or 0, positionBy.y ~= nil and positionBy.y or 0, 0)},
            otherOpt
        )
    end
    local function moveTo(duration, positionTo, otherOpt)
        return to(
            duration,
            "position",
            {position = vmath.vector3(positionTo.x ~= nil and positionTo.x or 0, positionTo.y ~= nil and positionTo.y or 0, 0)},
            otherOpt
        )
    end
    local function scaleTo(duration, scaleBy, otherOpt)
        if scaleBy.x == nil or scaleBy.y == nil then
            if scaleBy.x ~= nil then
                return to(duration, "scale.x", {x = scaleBy.x}, otherOpt)
            else
                return to(duration, "scale.y", {y = scaleBy.y}, otherOpt)
            end
        else
            return to(
                duration,
                "scale",
                {scale = vmath.vector3(scaleBy.x ~= nil and scaleBy.x or 0, scaleBy.y ~= nil and scaleBy.y or 0, 1)},
                otherOpt
            )
        end
    end
    local function start(isRemoveTweenOnEnd)
        if isRemoveTweenOnEnd == nil then
            isRemoveTweenOnEnd = true
        end
        if #sequence > 0 then
            local tweenFlow
            tweenFlow = flow.start(
                function()
                    __TS__ArrayReduce(
                        sequence,
                        function(____, acc, tween, tweenIdx)
                            if tween.key == "BY" or tween.key == "TO" then
                                runByOrToTween(tween, tweenIdx)
                            end
                            if tween.key == "CALLABLE" then
                                tween:func()
                            end
                            if tween.key == "DELAY" then
                                flow.delay(tween.delay)
                            end
                            if tween.key == "PARALLEL" then
                                isParallelMode = true
                            end
                            return acc
                        end,
                        0
                    )
                    if isRemoveTweenOnEnd then
                        __TS__ArraySplice(sequence, 0, #sequence)
                    end
                    isParallelMode = false
                    flow.stop(tweenFlow)
                end,
                {parallel = true}
            )
            return tweenFlow
        end
    end
    local function stop(descr)
        flow.stop(descr)
    end
    tweensForNode = {
        to = to,
        by = by,
        opacityBy = opacityBy,
        opacityTo = opacityTo,
        moveBy = moveBy,
        moveTo = moveTo,
        call = call,
        delay = delay,
        start = start,
        parallel = parallel,
        stop = stop,
        scaleTo = scaleTo
    }
    return tweensForNode
end
return ____exports
