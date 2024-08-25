import { tween } from "../../utils/defoldTweens/Tween";
import { get_nodes, set_text } from "../../utils/utils";
import { Buttons } from "../gui_utility/Buttons";

export function ExitConfirmWindow(druid: DruidClass, close_cb: () => void) {

    const nodes = get_nodes([
        'exit_popup', 'exit_yes/btn', 'exit_no/btn', 'center', 'exit_txt'
    ] as const);
    const blocker = druid.new_blocker(nodes.center);
    blocker.set_enabled(false);
    const btns = Buttons(druid, nodes, '/btn');
    let is_enabled = false;

    function init() {
        btns['exit_no/btn'].on(close);
        btns['exit_yes/btn'].on(exit);
    }

    function close() {
        tween(nodes.exit_popup)
            .opacityTo(0.3, 0)
            .call(() => {
                is_enabled = false;
                gui.set_enabled(nodes.exit_popup, false);
                blocker.set_enabled(false);
                gui.set_visible(nodes.center, false);
                close_cb();
            })
            .start();
    }

    function exit() {
        Ads.show_interstitial();
        Scene.load('menu');
    }

    function show() {
        is_enabled = true;
        set_text('exit_txt', Lang.get_text('exit_txt')); 
        gui.set_enabled(nodes.exit_popup, true);
        gui.set_visible(nodes.center, true);
        blocker.set_enabled(true);
        tween(nodes.exit_popup)
            .opacityTo(0, 0)
            .start();
        tween(nodes.exit_popup)
            .opacityTo(0.3, 1)
            .start();

    }

    init();

    return {
        show, close, is_enable: () => is_enabled
    };
}