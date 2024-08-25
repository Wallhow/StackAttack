local ____exports = {}
local _DailyBonuses
local ____game_config = require("main.game_config")
local GAME_CONSTS = ____game_config.GAME_CONSTS
function _DailyBonuses()
    local init_bonuses, load_bonuses, get_key, update_storage, call_listener, bonuses, change_listeners, bonuses_used
    function init_bonuses()
        for ____, k in ipairs(GAME_CONSTS.bonuses.keys) do
            bonuses[k] = GameStorage.get(k)
            if bonuses[k] < 2 then
                bonuses[k] = GAME_CONSTS.bonuses.BonusesCount[k]
            end
            bonuses_used[k] = 0
            call_listener(k)
        end
        update_storage()
    end
    function load_bonuses()
        for ____, k in ipairs(GAME_CONSTS.bonuses.keys) do
            bonuses[k] = GameStorage.get(k)
            bonuses_used[k] = 0
            call_listener(k)
        end
    end
    function get_key(date)
        return (((tostring(date.day) .. "|") .. tostring(date.month)) .. "|") .. tostring(date.year)
    end
    function update_storage()
        for ____, k in ipairs(GAME_CONSTS.bonuses.keys) do
            GameStorage.set(k, bonuses[k])
        end
    end
    function call_listener(bonus)
        if change_listeners[bonus] ~= nil then
            for ____, listener in ipairs(change_listeners[bonus]) do
                listener(bonuses[bonus])
            end
        end
    end
    bonuses = {}
    change_listeners = {}
    bonuses_used = {}
    local date = os.date("*t")
    local last_entry_date = Storage.get("last_entry_date")
    if last_entry_date == nil or last_entry_date ~= get_key(date) then
        init_bonuses()
        Storage.set(
            "last_entry_date",
            get_key(date)
        )
    else
        load_bonuses()
    end
    local function use_bonus(bonus)
        bonuses[bonus] = bonuses[bonus] - 1
        bonuses_used[bonus] = bonuses_used[bonus] + 1
        update_storage()
        call_listener(bonus)
    end
    local function add_bonus(bonus, count, is_update_storage)
        if count == nil then
            count = 1
        end
        if is_update_storage == nil then
            is_update_storage = true
        end
        bonuses[bonus] = bonuses[bonus] + count
        if is_update_storage then
            update_storage()
        end
        call_listener(bonus)
    end
    local function get_count(key)
        local count = GameStorage.get(key)
        return count
    end
    local function on(bonus, listener)
        if change_listeners[bonus] == nil then
            change_listeners[bonus] = {}
        end
        local ____change_listeners_bonus_0 = change_listeners[bonus]
        ____change_listeners_bonus_0[#____change_listeners_bonus_0 + 1] = listener
    end
    local function clear_listeners()
        for ____, k in ipairs(GAME_CONSTS.bonuses.keys) do
            change_listeners[k] = {}
        end
    end
    local function clear_used()
        for ____, k in ipairs(GAME_CONSTS.bonuses.keys) do
            bonuses_used[k] = 0
        end
    end
    local function get_count_used(bonus)
        return bonuses_used[bonus]
    end
    local function final()
        clear_listeners()
        clear_used()
    end
    return {
        get_count = get_count,
        use_bonus = use_bonus,
        add_bonus = add_bonus,
        on = on,
        update = load_bonuses,
        clear_listeners = clear_listeners,
        clear_used = clear_used,
        get_count_used = get_count_used,
        final = final
    }
end
____exports.DailyBonuses = _DailyBonuses()
return ____exports
