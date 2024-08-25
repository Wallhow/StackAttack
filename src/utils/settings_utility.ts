/* eslint-disable @typescript-eslint/no-unsafe-argument */

import { get_nodes, hex2rgba, hide_gui_list } from "./utils";

/* eslint-disable @typescript-eslint/no-unsafe-member-access */
export const COLORS = ['#3b6c6b', '#215134', '#065d57', '#043a4e'];
const bg_texture_name = 'back';
export const PATTERN = {
    3: {
        left: 'patt5_left', center: 'patt5_centre', right: 'patt5_left'
    },
    1: {
        left: 'patt2_left', center: 'patt2_centre', right: 'patt2_left'
    },
    2: {
        left: 'patt1_left', center: 'patt1_centre', right: 'patt1_left'
    },
    0: {
        left: 'patt4_left', center: '', right: 'patt4_left'
    },
    4: {
        left: '', center: '', right: ''
    },
};


export const PACK_PREFAB = ['card_1', 'card_2', 'card_3'];


export function apply_settings() {
    Lang.apply();


    const color = COLORS[GameStorage.get('color_bg')];
    const c = hex2rgba(color);


    //Scene.set_bg(color);
    gui.play_flipbook(gui.get_node('pattern/bg'), bg_texture_name + (GameStorage.get('color_bg') + 1));
    const sel_pattern = GameStorage.get('bg_image');

    timer.delay(0, false, () => show_pattern());

    pcall(() => {
        gui.play_flipbook(gui.get_node('btn_sound/icon'), Sound.is_active() ? 'snd_1' : 'snd_0');
    });

    pcall(() => {
        if (GameStorage.get('snow'))
            gui.play_particlefx(gui.get_node('snow_pfx'));
        else
            gui.stop_particlefx(gui.get_node('snow_pfx'), {});
    });

    pcall(() => {
        const size = gui.get_size(gui.get_node('root'));

        GAME_CONFIG.is_portrait = size.y > size.x;
    });


    function show_pattern() {
        const pattern_nodes = 'pattern/';
        const nodes_pattern = ['center', 'left', 'right'];
        for (const cur_node_name of nodes_pattern) {
            const texture = PATTERN[sel_pattern as 0 | 1 | 2 | 3][cur_node_name as 'center' | 'left' | 'right'];
            if (cur_node_name == 'center') gui.set_visible(gui.get_node(pattern_nodes + cur_node_name), texture != '');
            const cur_node = gui.get_node(pattern_nodes + cur_node_name);

            if (texture != '') {
                gui.play_flipbook(cur_node, texture);
            } else gui.set_visible(cur_node, false);

            if (cur_node_name == 'center' && GAME_CONFIG.is_portrait && texture == '' && sel_pattern != 4) {
                gui.set_visible(cur_node, true);
                gui.play_flipbook(cur_node, 'pic1');
                gui.set_scale(cur_node, vmath.vector3(0.4928, 0.4928, 0.4928));
            }

            if (!GAME_CONFIG.is_portrait && cur_node_name == 'center')
                gui.set_scale(cur_node, vmath.vector3(0.879, 0.879, 0.879));

            const is_left_right_not_visible = (GAME_CONFIG.is_portrait && sel_pattern == 0) || texture == '';

            gui.set_visible(gui.get_node(pattern_nodes + 'left'), !is_left_right_not_visible);
            gui.set_visible(gui.get_node(pattern_nodes + 'right'), !is_left_right_not_visible);

        }
    }
}