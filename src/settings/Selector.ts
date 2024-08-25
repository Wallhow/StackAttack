/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
import { get_nodes } from '../utils/utils';
import { tween } from '../utils/defoldTweens/Tween';

export function Selector(druid: DruidClass, template_name: string, is_bg_off = false) {
    const node_clone = gui.clone_tree(gui.get_node(template_name + '/btn'));
    const nodes = get_nodes(['bg', 'sel', 'icon', 'btn'] as const, template_name, node_clone);
    const btns = druid.new_button(nodes.btn, () => select(true));
    let is_selected = false;
    gui.set_enabled(nodes.btn, true);
    if (is_bg_off)
        gui.set_enabled(nodes.bg, false);

    const anim = {
        select: [
            tween(nodes.sel)
                .opacityTo(0, 0)
                .opacityTo(0.1, 1),
        ],
        unselect: [
            tween(nodes.sel)
                .opacityTo(0.1, 0),
        ]
    };

    function select(enabled: boolean) {
        is_selected = enabled;

        const anim_key: keyof typeof anim = enabled ? 'select' : 'unselect';
        for (const tween of anim[anim_key])
            tween.start(false);
    }

    return {
        on: (callback: () => void) => btns.on_click.subscribe(callback), root_node: nodes.btn, nodes, select, druid_node: btns
    };
}
