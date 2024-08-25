/* eslint-disable @typescript-eslint/unbound-method */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-empty-interface */

import * as druid from 'druid.druid';
import { _STORAGE_CONFIG } from '../main/game_config';
import { ISelectorGroup, SelectorGroup } from './SelectorGroup';
import { apply_settings } from '../utils/settings_utility';
import { array } from '../utils/array';
import { Header } from '../general_components/Header';

interface props {
    druid: DruidClass;
    init_ui: () => void;
}

export function init(this: props): void {
    Manager.init_script();
    this.druid = druid.new(this);

    const header = Header(this.druid);
    header
        .set_name(Lang.get_text('settings'))
        .set_btn_callback(() => { Ads.show_interstitial(); Scene.load('menu'); });

    const druidComps: DruidNode[] = [];
    const selector_nodes: node[] = [];
    this.init_ui = () => {
        if (druidComps.length != 0)
            for (const n of druidComps)
                this.druid.remove(n);
        array.clear(druidComps);

        if (selector_nodes.length != 0)
            for (const n of selector_nodes)
                gui.delete_node(n);
        array.clear(selector_nodes);

        apply_settings();
        const groups: ISelectorGroup[] = [];
        groups.push(SelectorGroup(this.druid, 'bg_image', [0, 1, 2, 3, 4], ['patt1', 'patt2', 'patt3', 'patt4', 'cir_btn']));
        groups.push(SelectorGroup(this.druid, 'color_bg', [0, 1, 2, 3],
            ['color1', 'color2', 'color3', 'color4'],
            { is_bg_disabled: true, icon_scale: 0.83 }
        ));
        groups.push(SelectorGroup(this.druid, 'pack', [0, 1, 2], ['pack_1', 'pack_2', 'pack_3'], { icon_scale: 1, is_bg_disabled: true }));

        for (const g of groups) {
            g.on(() => apply_settings());
            druidComps.push(...g.druid_nodes);
            selector_nodes.push(...g.nodes);
        }

        header.on_change_layout();
    };

    this.init_ui();

}

export function on_input(this: props, action_id: string | hash, action: unknown) {
    return this.druid.on_input(action_id, action);
}

export function update(this: props, dt: number): void {
    this.druid.update(dt);
}

export function on_message(this: props, message_id: string | hash, message: any, sender: string | hash | url): void {
    this.druid.on_message(message_id, message, sender);

    if (message_id == hash('layout_changed')) {
        this.init_ui();
    }
}

export function final(this: props): void {
    this.druid.final();
}



