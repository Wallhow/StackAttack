/* eslint-disable @typescript-eslint/no-empty-function */
import { GameKeys } from '../modules/GameStorage';
import { _STORAGE_CONFIG } from '../main/game_config';
import { Selector } from './Selector';
import { hex2rgba } from '../utils/utils';
type AdvancedOptions = { icon_scale?: number, icon_colors?: string[], is_bg_disabled?: boolean };

export type ISelectorGroup = ReturnType<typeof SelectorGroup>;

export function SelectorGroup<K extends GameKeys>(druid: DruidClass, setting_key: K, setting_values: (typeof _STORAGE_CONFIG)[K][], icons?: string[], other?: AdvancedOptions) {
    const selectable_items_count = setting_values.length;
    const grid = druid.new_static_grid(setting_key + '/item_container', 'selectable_item/btn', selectable_items_count);
    const items: ReturnType<typeof Selector>[] = [];
    let any_change_clbk = () => { };
    for (const idx of $range(1, selectable_items_count)) {
        const sel_item = Selector(druid, 'selectable_item', other?.is_bg_disabled);
        const i = (idx - 1);
        if (other != undefined) {
            if (other.icon_scale != undefined)
                gui.set_scale(sel_item.nodes.icon, vmath.vector3(other.icon_scale, other.icon_scale, other.icon_scale));
            if (other.icon_colors != undefined)
                gui.set_color(sel_item.nodes.icon, hex2rgba(other.icon_colors[i]));
        }
        if (icons != undefined) {
            const icon = icons[i];
            gui.play_flipbook(sel_item.nodes.icon, icon);
        }

        grid.add(sel_item.root_node, idx);
        bind_setting(setting_key, sel_item, setting_values[i]);
        items.push(sel_item);

        sel_item.on(() => {
            any_change_clbk();
            const f = items.filter(item => item != sel_item);
            f.forEach(item => item.select(false));
        });
    }

    function bind_setting<K extends GameKeys>(setting: K, selector_item: ReturnType<typeof Selector>, value: typeof _STORAGE_CONFIG[K]) {
        selector_item.on(() => {
            GameStorage.set(setting, value);
        });

        if (value == GameStorage.get(setting))
            selector_item.select(true);
    }

    function on(callback: () => void) {
        any_change_clbk = callback;
    }

    return {
        on, druid_nodes: [...items.map(item => item.druid_node), grid], nodes: grid.nodes
    };
}
