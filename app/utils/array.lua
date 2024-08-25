local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArrayReduce = ____lualib.__TS__ArrayReduce
local __TS__ArrayFindIndex = ____lualib.__TS__ArrayFindIndex
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayReverse = ____lualib.__TS__ArrayReverse
local __TS__ArrayConcat = ____lualib.__TS__ArrayConcat
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local ____exports = {}
____exports.array = {}
local array = ____exports.array
do
    local _popEl
    function array.iterate_back(arr, handler)
        do
            local i = #arr - 1
            while i >= 0 do
                handler(arr[i + 1], i)
                i = i - 1
            end
        end
    end
    function _popEl(arr, idx)
        local element = arr[idx + 1]
        __TS__ArraySplice(arr, idx, 1)
        return element
    end
    function array.random_element(arr)
        local ____temp_0
        if #arr > 1 then
            ____temp_0 = arr[math.random(0, #arr - 1) + 1]
        else
            ____temp_0 = arr[1]
        end
        return ____temp_0
    end
    function array.clear(arr, callback_befor_remove)
        if callback_befor_remove then
            for ____, el in ipairs(arr) do
                callback_befor_remove(el)
            end
        end
        __TS__ArraySplice(arr, 0, #arr)
    end
    function array.sum(arr)
        return #arr > 1 and __TS__ArrayReduce(
            arr,
            function(____, acc, cur) return acc + cur end,
            0
        ) or arr[1]
    end
    function array.remove(arr, par)
        if type(par) == "function" then
            local index = __TS__ArrayFindIndex(
                arr,
                function(____, v) return par(v) end
            )
            if index ~= -1 then
                __TS__ArraySplice(arr, index, 1)
            end
        else
            local index = __TS__ArrayIndexOf(arr, par)
            if index ~= -1 then
                __TS__ArraySplice(arr, index, 1)
            end
        end
    end
    function array.removeIndex(arr, index)
        if index ~= -1 then
            __TS__ArraySplice(arr, index, 1)
        end
    end
    function array.removeIndexes(arr, indexes)
        array.iterate_back(
            indexes,
            function(i) return __TS__ArraySplice(arr, i, 1) end
        )
    end
    function array.exclude(arr, condition)
        return __TS__ArrayFilter(
            arr,
            function(____, el) return not condition(el) end
        )
    end
    function array.pop(arr, idx)
        local ____temp_1
        if idx == nil then
            ____temp_1 = table.remove(arr)
        else
            ____temp_1 = _popEl(arr, idx)
        end
        local element = ____temp_1
        return element
    end
    function array.first(arr)
        return arr[1]
    end
    function array.last(arr)
        local ____temp_2
        if #arr > 1 then
            ____temp_2 = arr[#arr]
        else
            ____temp_2 = array.first(arr)
        end
        return ____temp_2
    end
    function array.shuffle(arr)
        math.randomseed(os.time())
        do
            local i = #arr - 1
            while i > 0 do
                local j = math.floor(math.random() * (i + 1))
                local ____temp_3 = {arr[j + 1], arr[i + 1]}
                arr[i + 1] = ____temp_3[1]
                arr[j + 1] = ____temp_3[2]
                i = i - 1
            end
        end
    end
    function array.inverse(arr)
        return __TS__ArrayReverse(arr)
    end
    --- Добавляет элемент в начало массива, возвращая новый массив
    function array.push_begin(arr, el)
        return __TS__ArrayConcat({el}, arr)
    end
    function array.indexes(arr)
        return __TS__ArrayMap(
            arr,
            function(____, e, i) return i end
        )
    end
end
return ____exports
