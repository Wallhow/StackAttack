/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import * as druid from 'druid.druid';
import { hide_gui_list, get_nodes, parse_time } from '../utils/utils';
import { Texts } from '../game/gui_utility/Texts';
import { array } from '../utils/array';
import { apply_settings } from '../utils/settings_utility';
import { StatsRecorder } from './StatsRecorder';
import { Header } from '../general_components/Header';

interface props {
    druid: DruidClass;
    items: node[];
    update_ui: () => void;
}
const druid_comps: DruidNode[] = [];
const gui_nodes = [
    'item/item', 'item/date_txt', 'item/time_txt', 'item/number_txt',
    'container'
] as const;

export function init(this: props): void {
    Manager.init_script();
    this.druid = druid.new(this);

    const header = Header(this.druid);
    header
        .set_name(Lang.get_text('rating'))
        .set_btn_callback(() => { Ads.show_interstitial(); Scene.load('menu'); });

    this.items = [];


    this.update_ui = () => {
        apply_settings();
        init_layout(this.druid, this.items);
        header.on_change_layout();
    };

    this.update_ui();

    function init_layout(druid: DruidClass, items: node[]) {
        const nodes = get_nodes(gui_nodes);

        const name_node_container = 'container';

        const container = druid.new_static_grid(name_node_container, 'item/item', 1);
        const container_size = gui.get_size(gui.get_node(name_node_container));
        const sorted_stats = StatsRecorder.get_sorted();

        for (const j of $range(1, 10)) {
            const record = sorted_stats[j - 1];
            const item_node = item(j, record.date, (record.time != 0) ? parse_time(record.time) : '---');
            const size = gui.get_size(item_node);
            size.x = container_size.x;
            gui.set_size(item_node, size);
            items.push(item_node);
            container.add(item_node, j);
        }

        druid_comps.push(container);



        function item(idx: number, date: string, time: string): node {

            const item_clone = gui.clone_tree(nodes['item/item']);
            const item_nodes = get_nodes(['item', 'date_txt', 'time_txt', 'number_txt'] as const, 'item', item_clone);

            const txts = Texts(item_nodes, 'txt', 'item', item_clone);

            txts['item/number_txt'].set(tostring(idx));
            txts['item/date_txt'].set(date, { axis: 'x' });
            txts['item/time_txt'].set(time, { axis: 'x' });
            gui.set_inherit_alpha(item_nodes['item'], false);

            return item_nodes['item'];
        }


        hide_gui_list(['item/item']);
    }

}



export function on_input(this: props, action_id: string | hash, action: unknown) {
    return this.druid.on_input(action_id, action);
}

export function update(this: props, dt: number): void {
    this.druid.update(dt);
}

export function on_message(this: props, message_id: string | hash, message: any, sender: string | hash | url): void {

    if (message_id == hash('layout_changed')) {
        druid_comps.forEach(c => {
            this.druid.remove(c);
        });
        this.items.forEach(item => gui.delete_node(item));
        array.clear(this.items);
        array.clear(druid_comps);
        this.update_ui();
    }
    this.druid.on_message(message_id, message, sender);
}

export function final(this: props): void {
    Manager.final_script();
    this.druid.final();
}