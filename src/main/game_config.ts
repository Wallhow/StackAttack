/* eslint-disable @typescript-eslint/ban-types */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */

import { TNom } from "../logic/card";

export const IS_DEBUG_MODE = false;
export const IS_HUAWEI = sys.get_sys_info().system_name == 'Android' && sys.get_config("android.package").includes('huawei');

// параметры инициализации для ADS
export const ADS_CONFIG = {
    is_mediation: IS_HUAWEI ? false : true,
    id_banners: IS_HUAWEI ? ["R-M-2993055-1"] : [sys.get_sys_info().system_name == 'Android' ? "R-M-2362968-1" : 'R-M-4647812-1'],
    id_inters: IS_HUAWEI ? ["R-M-2993055-2"] : [sys.get_sys_info().system_name == 'Android' ? "R-M-2362968-2" : 'R-M-4647812-2'],
    id_reward: [],
    banner_on_init: false,
    ads_interval: sys.get_sys_info().system_name == "HTML5" ? 3 * 60 : 4 * 60,
    ads_delay: 90,
};

// для вк
export const VK_SHARE_URL = 'https://vk.com/app51624910';
export const OK_SHARE_TEXT = 'Разложи пасьянс быстрее всех!';
// для андроида метрика
export const ID_YANDEX_METRICA = sys.get_sys_info().system_name == 'Android' ? (IS_HUAWEI ? "04844682-90a5-4528-9c5d-a23a483ac7f7" : "db7950f6-b07e-44ca-be76-45b03e12bcdc") : '67081ceb-5225-4079-a5d3-d064418193d0';
// через сколько показать первое окно оценки
export const RATE_FIRST_SHOW = 24 * 60 * 60;
// через сколько второй раз показать 
export const RATE_SECOND_SHOW = 3 * 24 * 60 * 60;

// игровой конфиг (сюда не пишем/не читаем если предполагается сохранение после выхода из игры)
// все обращения через глобальную переменную GAME_CONFIG

function _create_game_config() {
    const pack_count = 1;
    const mast_count = 4;
    const debug_is_big_stacks_mode = false;
    return {
        GAME_MODE: { pack_count, mast_count },
        is_portrait: false,
        debug_is_big_stacks_mode,

        has_help_buttons: false,
        window_size: { width: 10000, height: 10000 },
    };
}
export const _GAME_CONFIG = _create_game_config();


function _create_game_consts() {
    const bonuses_keys = ['tips'] as const;

    const BonusesCount: { [k in typeof bonuses_keys[number]]: number } = {
        'tips': 3
    };

    const values = {
        stopka_id: 11,
        homes_ids: [12, 13, 14, 15],
        free_cells_ids: [16, 17, 18, 19],
        stack_count: 8,

        //максимальная длинна стака при которой карты не поджимаются
        max_length_stack: 10
    };
    return {
        bonuses: {
            keys: bonuses_keys, BonusesCount
        },
        values
    };
}
export const GAME_CONSTS = _create_game_consts();

// конфиг с хранилищем  (отсюда не читаем/не пишем, все запрашивается/меняется через GameStorage)
export const _STORAGE_CONFIG = {
    bg_image: 1,
    color_bg: 0,
    rub: 1,
    pack: 1,
    snow: false,
    is_automove: true,
    tips: 3,
    tutorial_done: false,
};


// пользовательские сообщения под конкретный проект, доступны типы через глобальную тип-переменную UserMessages
export type _UserMessages = {
    MY_SHOW_HIDE_GO: {}

    CLICK_CARD: { id: number }
    DROP_STACK: { id: number },

    REPLAY: {},
    FAST_CLICK_CARD: {},

    LAYOUT_CHANGED: { layout: 'portrait' | 'landscape' }
    GAME_OVER: { step: number },

    SAVE_RECORD: { time: number, is_online: boolean, is_fail?: boolean }
    PLAYER_HAS_MADE_STEP: { homes: TNom[][] }

    IS_CAN_USE_BONUS: { bonus: typeof GAME_CONSTS.bonuses.keys[number] },
    CAN_USE_BONUS: { bonus: typeof GAME_CONSTS.bonuses.keys[number], is_can: boolean }
    USE_BONUS: { bonus: typeof GAME_CONSTS.bonuses.keys[number] },

    UNDO: {},
    RESET_TIPS: {},
    RESIZE: {},
    RESIZE_DONE: {},

    STOPWATCH: { action: 'stop' | 'restart' | 'go' | 'reset' },

    TUTORIAL_INIT: {},
    SHOW_TUTORIAL_STEP: { text: string },
    PRESS_OK_TUTORIAL: {},
    SHOW_ADS: {}

    RAW_INPUT: { action_id: string | hash, action: any }
    UPDATE: { dt: number }
};
