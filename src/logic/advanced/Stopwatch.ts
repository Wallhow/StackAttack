import { parse_time } from '../../utils/utils';

export function Stopwatch(start_time = 0, step_in_sec = 1) {
    let c_time = start_time;
    let timer_handler: hash | undefined;
    let tick_callback: (time: number) => void;

    function start() {
        if (timer_handler == undefined) {
            timer_handler = timer.delay(step_in_sec, true, on_tick);
        }
    }

    function on_tick(_: any, h: hash, t: number) {
        c_time += step_in_sec;
        if (tick_callback != undefined)
            tick_callback(c_time);
    }

    function stop() {
        if (timer_handler != undefined) {
            timer.cancel(timer_handler);
            timer_handler = undefined;
        }
    }

    function is_active() {
        return timer_handler != undefined;
    }

    function reset() {
        c_time = start_time;
    }

    function to_string() {
        return parse_time(c_time);
    }

    function get_time() {
        return c_time;
    }

    return {
        start,
        stop,
        is_active,
        reset,
        to_string,
        on_tick: (callback: (time: number) => void) => tick_callback = callback,
        get_time,
        refresh: () => tick_callback(c_time)
    };
}
