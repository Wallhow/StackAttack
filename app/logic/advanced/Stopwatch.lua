local ____exports = {}
local ____utils = require("utils.utils")
local parse_time = ____utils.parse_time
function ____exports.Stopwatch(start_time, step_in_sec)
    if start_time == nil then
        start_time = 0
    end
    if step_in_sec == nil then
        step_in_sec = 1
    end
    local on_tick, c_time, tick_callback
    function on_tick(_, h, t)
        c_time = c_time + step_in_sec
        if tick_callback ~= nil then
            tick_callback(c_time)
        end
    end
    c_time = start_time
    local timer_handler
    local function start()
        if timer_handler == nil then
            timer_handler = timer.delay(step_in_sec, true, on_tick)
        end
    end
    local function stop()
        if timer_handler ~= nil then
            timer.cancel(timer_handler)
            timer_handler = nil
        end
    end
    local function is_active()
        return timer_handler ~= nil
    end
    local function reset()
        c_time = start_time
    end
    local function to_string()
        return parse_time(c_time)
    end
    local function get_time()
        return c_time
    end
    return {
        start = start,
        stop = stop,
        is_active = is_active,
        reset = reset,
        to_string = to_string,
        on_tick = function(callback)
            tick_callback = callback
            return tick_callback
        end,
        get_time = get_time,
        refresh = function() return tick_callback(c_time) end
    }
end
return ____exports
