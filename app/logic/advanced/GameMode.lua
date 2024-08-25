local ____exports = {}
local ____game_config = require("main.game_config")
local GAME_CONSTS = ____game_config.GAME_CONSTS
--- Отвечает за текущий режим игры, чтобы случайно не накосячить при ручной установке:D
local function init_game_mode()
    local modes = {"mini", "standart", "big"}
    local function set_mode(name, mast_count)
        if mast_count == nil then
            mast_count = 1
        end
        GAME_CONFIG.GAME_MODE.mast_count = 4
        GAME_CONFIG.GAME_MODE.pack_count = 1
    end
    local function set_mast_count(mast_count)
        GAME_CONFIG.GAME_MODE.mast_count = mast_count
    end
    local function get_mode()
        return GAME_CONFIG.GAME_MODE
    end
    local function get_pack_count()
        return GAME_CONFIG.GAME_MODE.pack_count
    end
    local function get_mast_count()
        return GAME_CONFIG.GAME_MODE.mast_count
    end
    local function get_name_mode()
        return modes[GAME_CONFIG.GAME_MODE.pack_count]
    end
    local function get_count_stacks()
        return GAME_CONSTS.values.stack_count
    end
    return {
        set_mode = set_mode,
        set_mast_count = set_mast_count,
        get_mode = get_mode,
        get_pack_count = get_pack_count,
        get_mast_count = get_mast_count,
        get_name_mode = get_name_mode,
        get_count_stacks = get_count_stacks,
        get_modes = function() return modes end
    }
end
____exports.default = init_game_mode()
return ____exports
