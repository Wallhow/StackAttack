local ____lualib = require("lualib_bundle")
local __TS__StringIncludes = ____lualib.__TS__StringIncludes
local ____exports = {}
____exports.IS_DEBUG_MODE = false
____exports.IS_HUAWEI = sys.get_sys_info().system_name == "Android" and __TS__StringIncludes(
    sys.get_config("android.package"),
    "huawei"
)
local ____IS_HUAWEI_0
if ____exports.IS_HUAWEI then
    ____IS_HUAWEI_0 = false
else
    ____IS_HUAWEI_0 = true
end
____exports.ADS_CONFIG = {
    is_mediation = ____IS_HUAWEI_0,
    id_banners = ____exports.IS_HUAWEI and ({"R-M-2993055-1"}) or ({sys.get_sys_info().system_name == "Android" and "R-M-2362968-1" or "R-M-4647812-1"}),
    id_inters = ____exports.IS_HUAWEI and ({"R-M-2993055-2"}) or ({sys.get_sys_info().system_name == "Android" and "R-M-2362968-2" or "R-M-4647812-2"}),
    id_reward = {},
    banner_on_init = false,
    ads_interval = sys.get_sys_info().system_name == "HTML5" and 3 * 60 or 4 * 60,
    ads_delay = 90
}
____exports.VK_SHARE_URL = "https://vk.com/app51624910"
____exports.OK_SHARE_TEXT = "Разложи пасьянс быстрее всех!"
____exports.ID_YANDEX_METRICA = sys.get_sys_info().system_name == "Android" and (____exports.IS_HUAWEI and "04844682-90a5-4528-9c5d-a23a483ac7f7" or "db7950f6-b07e-44ca-be76-45b03e12bcdc") or "67081ceb-5225-4079-a5d3-d064418193d0"
____exports.RATE_FIRST_SHOW = 24 * 60 * 60
____exports.RATE_SECOND_SHOW = 3 * 24 * 60 * 60
local function _create_game_config()
    local pack_count = 1
    local mast_count = 4
    local debug_is_big_stacks_mode = false
    return {
        GAME_MODE = {pack_count = pack_count, mast_count = mast_count},
        is_portrait = false,
        debug_is_big_stacks_mode = debug_is_big_stacks_mode,
        has_help_buttons = false,
        window_size = {width = 10000, height = 10000}
    }
end
____exports._GAME_CONFIG = _create_game_config()
local function _create_game_consts()
    local bonuses_keys = {"tips"}
    local BonusesCount = {tips = 3}
    local values = {
        stopka_id = 11,
        homes_ids = {12, 13, 14, 15},
        free_cells_ids = {16, 17, 18, 19},
        stack_count = 8,
        max_length_stack = 10
    }
    return {bonuses = {keys = bonuses_keys, BonusesCount = BonusesCount}, values = values}
end
____exports.GAME_CONSTS = _create_game_consts()
____exports._STORAGE_CONFIG = {
    bg_image = 1,
    color_bg = 0,
    rub = 1,
    pack = 1,
    snow = false,
    is_automove = true,
    tips = 3,
    tutorial_done = false
}
return ____exports
