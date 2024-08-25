local ____exports = {}
local ____utils = require("utils.utils")
local hex2rgba = ____utils.hex2rgba
____exports.COLORS = {"#3b6c6b", "#215134", "#065d57", "#043a4e"}
local bg_texture_name = "back"
____exports.PATTERN = {
    [3] = {left = "patt5_left", center = "patt5_centre", right = "patt5_left"},
    [1] = {left = "patt2_left", center = "patt2_centre", right = "patt2_left"},
    [2] = {left = "patt1_left", center = "patt1_centre", right = "patt1_left"},
    [0] = {left = "patt4_left", center = "", right = "patt4_left"},
    [4] = {left = "", center = "", right = ""}
}
____exports.PACK_PREFAB = {"card_1", "card_2", "card_3"}
function ____exports.apply_settings()
    local show_pattern, sel_pattern
    function show_pattern()
        local pattern_nodes = "pattern/"
        local nodes_pattern = {"center", "left", "right"}
        for ____, cur_node_name in ipairs(nodes_pattern) do
            local texture = ____exports.PATTERN[sel_pattern][cur_node_name]
            if cur_node_name == "center" then
                gui.set_visible(
                    gui.get_node(pattern_nodes .. cur_node_name),
                    texture ~= ""
                )
            end
            local cur_node = gui.get_node(pattern_nodes .. cur_node_name)
            if texture ~= "" then
                gui.play_flipbook(cur_node, texture)
            else
                gui.set_visible(cur_node, false)
            end
            if cur_node_name == "center" and GAME_CONFIG.is_portrait and texture == "" and sel_pattern ~= 4 then
                gui.set_visible(cur_node, true)
                gui.play_flipbook(cur_node, "pic1")
                gui.set_scale(
                    cur_node,
                    vmath.vector3(0.4928, 0.4928, 0.4928)
                )
            end
            if not GAME_CONFIG.is_portrait and cur_node_name == "center" then
                gui.set_scale(
                    cur_node,
                    vmath.vector3(0.879, 0.879, 0.879)
                )
            end
            local is_left_right_not_visible = GAME_CONFIG.is_portrait and sel_pattern == 0 or texture == ""
            gui.set_visible(
                gui.get_node(pattern_nodes .. "left"),
                not is_left_right_not_visible
            )
            gui.set_visible(
                gui.get_node(pattern_nodes .. "right"),
                not is_left_right_not_visible
            )
        end
    end
    Lang.apply()
    local color = ____exports.COLORS[GameStorage.get("color_bg") + 1]
    local c = hex2rgba(color)
    gui.play_flipbook(
        gui.get_node("pattern/bg"),
        bg_texture_name .. tostring(GameStorage.get("color_bg") + 1)
    )
    sel_pattern = GameStorage.get("bg_image")
    timer.delay(
        0,
        false,
        function() return show_pattern() end
    )
    pcall(function()
        gui.play_flipbook(
            gui.get_node("btn_sound/icon"),
            Sound.is_active() and "snd_1" or "snd_0"
        )
    end)
    pcall(function()
        if GameStorage.get("snow") then
            gui.play_particlefx(gui.get_node("snow_pfx"))
        else
            gui.stop_particlefx(
                gui.get_node("snow_pfx"),
                {}
            )
        end
    end)
    pcall(function()
        local size = gui.get_size(gui.get_node("root"))
        GAME_CONFIG.is_portrait = size.y > size.x
    end)
end
return ____exports
