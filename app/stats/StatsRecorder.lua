local ____lualib = require("lualib_bundle")
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
local _initStatsRecorder
local ____utils = require("utils.utils")
local ____repeat = ____utils["repeat"]
function _initStatsRecorder()
    local load, create_stats, sort, empty, stats, name_state
    function load()
        local _stats = Storage.get_data(name_state)
        stats = _stats or create_stats()
        if #stats < 10 then
            ____repeat(
                4,
                function()
                    local ____temp_0 = #stats + 1
                    stats[____temp_0] = {date = empty, time = 0}
                    return ____temp_0
                end
            )
            Storage.set_data(name_state, stats)
        end
    end
    function create_stats()
        local stats = {}
        ____repeat(
            10,
            function()
                local ____temp_1 = #stats + 1
                stats[____temp_1] = {date = empty, time = 0}
                return ____temp_1
            end
        )
        Storage.set_data(name_state, stats)
        return stats
    end
    function sort(arr)
        return __TS__ArraySort(
            arr,
            function(____, a, b)
                if a.time == 0 then
                    return 1
                elseif b.time == 0 then
                    return -1
                else
                    return a.time - b.time
                end
            end
        )
    end
    empty = "---"
    stats = {}
    name_state = "stats_v2"
    load()
    local function push(state)
        stats[#stats + 1] = state
        Storage.set_data(name_state, stats)
    end
    local function get_sorted()
        return sort(stats)
    end
    return {push = push, get_sorted = get_sorted}
end
____exports.StatsRecorder = _initStatsRecorder()
return ____exports
