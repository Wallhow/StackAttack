import { tween } from "../../utils/defoldTweens/Tween";
import { get_nodes } from "../../utils/utils";
import { Buttons } from "../gui_utility/Buttons";

export function RestartConfirmWindow(druid: DruidClass, close_cb: () => void) {

    const nodes = get_nodes([
        'restart_popup', 'restart_yes/btn', 'restart_no/btn', 'center', 'restart_text'
    ] as const);
    const blocker = druid.new_blocker(nodes.center);
    blocker.set_enabled(false);
    const btns = Buttons(druid, nodes, '/btn');
    let is_enabled = false;

    function init() {
        btns['restart_no/btn'].on(no);
        btns['restart_yes/btn'].on(yes);
    }

    function no(is_call_cb = true) {
        tween(nodes.restart_popup)
            .opacityTo(0.3, 0)
            .call(() => {
                is_enabled = false;
                gui.set_enabled(nodes.restart_popup, false);
                blocker.set_enabled(false);
                gui.set_visible(nodes.center, false);
                if (is_call_cb) close_cb();
            })
            .start();
    }

    function yes() {
        if (GameStorage.get('tutorial_done')) {
            EventBus.trigger('REPLAY');
            no(false);
        }
    }

    function show() {
        is_enabled = true;
        gui.set_enabled(nodes.restart_popup, true);
        gui.set_visible(nodes.center, true);
        blocker.set_enabled(true);
        tween(nodes.restart_popup)
            .opacityTo(0, 0)
            .start();
        tween(nodes.restart_popup)
            .opacityTo(0.3, 1)
            .start();

    }

    init();

    return {
        show, close: no, is_enable: () => is_enabled
    };
}