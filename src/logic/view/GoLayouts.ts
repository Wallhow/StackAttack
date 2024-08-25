import { GAME_CONSTS } from "../../main/game_config";
import { GoManager } from "../../modules/GoManager";
import { array } from "../../utils/array";



/**
 * Объект для работы с лайаутами го и лайаут зависимыми переменными
 * @param values - объект в котором прописываются лайаут зависимые переменные и их дефолтные значения 
 * @returns Объект отвечающий за лайауты у Go объектов, а так же предоставляет хранилище для лайаут зависимых переменных 
 */
export function GoLayouts<T extends object>(values: T) {
    const default_values = {
        portrait: { ...values },
        landscape: { ...values },
    };
    //кол-во колонок на которые будем разбивать поле, от этого зависит размер карт.
    const rows = () => GAME_CONFIG.is_portrait ? 8 : 10;
    // const rows = () => GameMode.get_name_mode() == 'mini' ? 8 : 10;


    const win_width = 960;
    const card_width = 195;
    const card_height = 289;
    const card_offset_x = 10;

    let goes = {} as { go_home: hash[], go_free_cells: hash[], go_stacks: hash[], go_stacks_zones: hash[], go_stopka: hash, go_joker: hash, };
    let gm: ReturnType<typeof GoManager>;

    function init(go_manager: ReturnType<typeof GoManager>, go_list: typeof goes) {
        goes = go_list;
        gm = go_manager;
    }

    function get_game_sizes(is_portrait: boolean) {
        const padding = is_portrait ? (0) : 2;

        const width = 960 / (rows() + padding) - (is_portrait ? 0 : card_offset_x);

        const s = width / card_width;
        const scale = vmath.vector3(s, s, s);

        const new_card_width = s * card_width;
        const new_card_height = s * card_height;

        const card_offset_y = new_card_height / 2;
        return {
            width,
            scale,

            new_card_width, new_card_height,
            card_offset_y,
        };
    }

    function set_portrait_layout(offset_y = 0) {

        const { go_home, go_stacks, go_stopka, go_stacks_zones, go_free_cells } = goes;
        const { width, scale, new_card_height, card_offset_y } = get_game_sizes(true);
        const pos = vmath.vector3(0, 0, 0);
        const card_offset_x = 0;
        const half_width_card = width / 2;

        const min_offset_y = 90;
        const _first_offset = (width) * 0.5;

        pos.y = -(new_card_height + min_offset_y + (offset_y * 40));

        // дома
        const src_y = pos.y;

        pos.y = -new_card_height / 2 - (min_offset_y + (offset_y * 40));
        for (let i = 0; i < go_home.length; i++) {
            pos.x = (win_width - half_width_card) - (width * i + card_offset_x);
            go.set_position(pos, go_home[i]);

        }
        // free_cells 
        for (let i = 0; i < go_free_cells.length; i++) {
            pos.x = half_width_card + (width * i + card_offset_x);
            go.set_position(pos, go_free_cells[i]);

        }
        // стопка
        pos.x = win_width + (half_width_card + card_offset_x);
        pos.y -= new_card_height + (card_offset_x) + 10;
        go.set_position(pos, go_stopka);

        const size_card = win_width / GAME_CONSTS.values.stack_count - card_offset_x;
        //stacks
        const start_x = win_width / 2 - (go_stacks.length * ((width) + card_offset_x) / 2);
        pos.y = (src_y - size_card - _first_offset);
        for (let x = 0; x < go_stacks.length; x++) {
            pos.x = start_x + (width) * (x) + _first_offset;
            const g = go_stacks[x];
            const g_zone = go_stacks_zones[x];
            go.set_position(pos, g);
            gm.set_position_xy_hash(g_zone, pos.x, pos.y + new_card_height / 2, 0.5, 1);
        }

        set_pos_card_counter();

        set_color('#000', 0.3);
        set_scale(scale);
    }

    function set_landscape_layout(offset_y = 0) {
        const { go_home, go_stacks, go_stopka, go_stacks_zones, go_free_cells } = goes;
        const { width, scale, new_card_height, card_offset_y } = get_game_sizes(false);
        const half_width_card = width / 2;
        const pos = vmath.vector3(0, 0, 0);
        const card_offset_x = 2;

        const min_offset_y = 85;

        const _first_offset = (width + card_offset_x) * 0.5;
        pos.y = -new_card_height / 2 - (min_offset_y + (offset_y * 30));

        //stacks
        const start_x = win_width / 2 - (go_stacks.length * ((width) + card_offset_x) / 2);
        const card_width = (width) + card_offset_x;
        for (let x = 0; x < go_stacks.length; x++) {
            pos.x = start_x + card_width * x + _first_offset;
            const g = go_stacks[x];
            const g_zone = go_stacks_zones[x];
            go.set_position(pos, g);
            gm.set_position_xy_hash(g_zone, pos.x, pos.y + new_card_height / 2, 0.5, 1);
        }


        pos.y = -new_card_height / 2 - (min_offset_y + (offset_y * 30));
        pos.x = (win_width - half_width_card) - (card_offset_x);
        // домa 
        for (let i = 0; i < go_home.length; i++) {
            let j = i;
            if (i >= 2) {
                pos.x = (win_width - half_width_card) - (card_offset_x) - card_width;
                pos.y = -new_card_height / 2 - (min_offset_y + (offset_y * 30));
                j -= 2;
            }
            pos.y = -new_card_height / 2 - (min_offset_y + (offset_y * 30)) - (new_card_height + offset_y) * j;
            go.set_position(pos, go_home[i]);

        }

        // free_cells 
        pos.x = half_width_card + (card_offset_x);
        for (let i = 0; i < go_free_cells.length; i++) {
            let j = i;
            if (i >= 2) {
                pos.x = half_width_card + (card_offset_x) + card_width;
                pos.y = -new_card_height / 2 - (min_offset_y + (offset_y * 30));
                j -= 2;
            }
            pos.y = -new_card_height / 2 - (min_offset_y + (offset_y * 30)) - (new_card_height + offset_y) * j;
            go.set_position(pos, go_free_cells[i]);

        }
        // стопка
        pos.x = win_width + (half_width_card + card_offset_x);
        pos.y -= new_card_height + (card_offset_x) + 10;
        go.set_position(pos, go_stopka);


        set_pos_card_counter();

        set_color('#000', 0.3);
        set_scale(scale);
    }

    function set_pos_card_counter() {
        //opened cards counter
        const p = go.get_position(goes.go_stopka);
        p.x -= 5;
        p.y -= 30;
    }

    function set_scale(scale: vmath.vector3) {
        go.set_scale(scale, goes.go_stopka);

        for (const home of goes.go_home)
            go.set_scale(scale, home);
        for (const free_cell of goes.go_free_cells)
            go.set_scale(scale, free_cell);

        const scale_for_stack_zones = vmath.vector3(scale.x, 3, scale.y);
        for (const i of array.indexes(goes.go_stacks)) {
            const stack_go = goes.go_stacks[i];
            const stack_zone_go = goes.go_stacks_zones[i];

            go.set_scale(scale, stack_go);
            go.set_scale(scale_for_stack_zones, stack_zone_go);
        }
    }

    function set_color(color: string, alpha: number) {
        gm.set_color_hash(goes.go_stopka, color, alpha);

        for (const home of goes.go_home)
            gm.set_color_hash(home, color, alpha);
        for (const free_cell of goes.go_free_cells)
            gm.set_color_hash(free_cell, color, alpha);

        for (const i of array.indexes(goes.go_stacks)) {
            const stack_go = goes.go_stacks[i];
            const stack_zone_go = goes.go_stacks_zones[i];

            gm.set_color_hash(stack_go, color, alpha);
            gm.set_color_hash(stack_zone_go, color, 0);
        }
    }

    function change_layout(is_portret: boolean, offset_y = 0) {
        is_portret ? set_portrait_layout(offset_y) : set_landscape_layout(offset_y);
    }
    /**
     * В методе указываем к какому лайауту относятся задаваемые значения и переопределяем значения конкретных лайаут зависимых переменных 
     * @param is_portrait 
     * @param layout_values 
     */
    function set_values(is_portrait: boolean, layout_values: Partial<typeof values>) {
        default_values[is_portrait ? 'portrait' : 'landscape'] = { ...values, ...layout_values };
    }

    function get_values(is_portrait: boolean) {
        return default_values[is_portrait ? 'portrait' : 'landscape'];
    }

    return {
        init, get_game_sizes: () => get_game_sizes(GAME_CONFIG.is_portrait), change_layout, set_values, get_values
    };
}