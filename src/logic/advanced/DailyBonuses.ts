/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/restrict-template-expressions */

import { GAME_CONSTS } from "../../main/game_config";

export const DailyBonuses = _DailyBonuses();
function _DailyBonuses() {
    type Bonuses = typeof GAME_CONSTS.bonuses.keys[number];
    type BonusesMap = { [key in Bonuses]: number };

    const bonuses: BonusesMap = {} as BonusesMap;
    const change_listeners: { [key in Bonuses]: ((count: number) => void)[] } = {} as { [key in Bonuses]: ((count: number) => void)[] };
    const bonuses_used: BonusesMap = {} as BonusesMap;
    const date = os.date('*t');

    const last_entry_date = Storage.get('last_entry_date');

    if (last_entry_date == undefined || last_entry_date != get_key(date)) {
        init_bonuses();
        Storage.set('last_entry_date', get_key(date));
    } else {
        load_bonuses();
    }

    function init_bonuses() {

        for (const k of GAME_CONSTS.bonuses.keys) {

            bonuses[k] = GameStorage.get(k);
            if (bonuses[k] < 2)
                bonuses[k] = GAME_CONSTS.bonuses.BonusesCount[k];

            bonuses_used[k] = 0;
            call_listener(k);
        }

        update_storage();
    }

    function load_bonuses() {
        for (const k of GAME_CONSTS.bonuses.keys) {
            // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
            bonuses[k] = GameStorage.get(k);
            bonuses_used[k] = 0;
            call_listener(k);
        }

    }

    function use_bonus(bonus: Bonuses) {
        bonuses[bonus] -= 1;
        bonuses_used[bonus] += 1;
        update_storage();
        call_listener(bonus);
    }

    function add_bonus(bonus: Bonuses, count = 1, is_update_storage = true) {
        bonuses[bonus] += count;
        if (is_update_storage)
            update_storage();
        call_listener(bonus);
    }
    function get_key(date: AnyTable) {
        return `${date.day}|${date.month}|${date.year}`;
    }

    function update_storage() {
        for (const k of GAME_CONSTS.bonuses.keys)
            GameStorage.set(k, bonuses[k]);
    }

    function call_listener(bonus: Bonuses) {
        if (change_listeners[bonus] != undefined)
            for (const listener of change_listeners[bonus])
                listener(bonuses[bonus]);
    }

    function get_count(key: Bonuses) {
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
        const count = GameStorage.get(key);
        // eslint-disable-next-line @typescript-eslint/no-unnecessary-type-assertion
        return count as number;
    }

    function on(bonus: Bonuses, listener: (count: number) => void) {
        if (change_listeners[bonus] == undefined)
            change_listeners[bonus] = [];
        change_listeners[bonus].push(listener);
    }

    function clear_listeners() {
        for (const k of GAME_CONSTS.bonuses.keys)
            change_listeners[k] = [];
    }

    function clear_used() {
        for (const k of GAME_CONSTS.bonuses.keys)
            bonuses_used[k] = 0;
    }

    function get_count_used(bonus: Bonuses) {
        return bonuses_used[bonus];
    }

    function final() {
        clear_listeners();
        clear_used();
    }

    return {
        get_count, use_bonus, add_bonus, on, update: load_bonuses, clear_listeners, clear_used, get_count_used, final
    };
}