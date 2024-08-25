/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import { Buttons } from "../../game/gui_utility/Buttons";
import { DailyBonuses } from "../../logic/advanced/DailyBonuses";
import { tween } from "../../utils/defoldTweens/Tween";
import { get_nodes } from "../../utils/utils";

export function SelectPackCountWindow(druid: DruidClass, callback_btns_pressed: (index_btn: number) => void) {

    const names_node = [
        'pack_1/btn', 'pack_2/btn', 'pack_3/btn', 'close/btn', 'shadow',
        'window_pack_count',
    ] as const;
    const nodes = get_nodes(names_node, '');
    const blocker = druid.new_blocker(nodes.shadow);
    blocker.set_enabled(false);

    const btns = Buttons(druid, nodes, '/btn', '');
    btns['close/btn'].on(close);

    for (const i of $range(1, 3)) {
        const index_btn = i;
        const key = `pack_${i}/btn`;
        (btns as any)[key].on(() => { callback_btns_pressed(index_btn); });
    }



    function close() {
        tween(nodes.window_pack_count)
            .opacityTo(0.3, 0)
            .call(() => {
                gui.set_enabled(nodes.window_pack_count, false);
                blocker.set_enabled(false);
            })
            .start();
    }

    function show() {
        gui.set_enabled(nodes.window_pack_count, true);
        blocker.set_enabled(true);
        tween(nodes.window_pack_count)
            .opacityTo(0, 0)
            .start();

        tween(nodes.window_pack_count)
            .opacityTo(0.3, 1)
            .start();

    }

    return {
        show, close
    };
}