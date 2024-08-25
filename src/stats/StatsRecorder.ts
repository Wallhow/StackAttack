import { repeat } from "../utils/utils";

export const StatsRecorder = _initStatsRecorder();

type StateItem = { date: string, time: number };


function _initStatsRecorder() {
    const empty = '---';
    // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
    let stats: StateItem[] = [];
    const name_state = 'stats_v2';
    load();

    function push(state: StateItem) {
        stats.push(state);
        Storage.set_data(name_state, stats);
    }


    function load() {
        const _stats = Storage.get_data(name_state) as StateItem[];
        stats = _stats ?? create_stats();
        if (stats.length < 10) {
            repeat(4, () => stats.push({ date: empty, time: 0 }));
            Storage.set_data(name_state, stats);
        }
    }



    function create_stats() {
        const stats: StateItem[] = [];
        repeat(10, () => stats.push({ date: empty, time: 0 }));

        Storage.set_data(name_state, stats);
        return stats;

    }

    function get_sorted() {
        return sort(stats);
    }

    function sort(arr: StateItem[]): StateItem[] {
        return arr.sort((a, b) => {
            if (a.time === 0) {
                return 1;
            } else if (b.time === 0) {
                return -1;
            } else {
                return a.time - b.time;
            }

        });
    }

    return {
        push, get_sorted,
    };
}