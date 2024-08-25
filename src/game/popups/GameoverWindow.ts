/* eslint-disable @typescript-eslint/no-empty-function */
import { tween } from "../../utils/defoldTweens/Tween";
import { get_nodes, hide_gui_list, parse_time } from "../../utils/utils";


export function GameoverWindow() {
    const nodes = get_nodes(['center', 'game_over_popup', 'step_count_txt', 'time_count_txt', 'ok_btn/btn', 'message_txt', 'win_txt'] as const);
    const range_time: [number, number, number][] = [
        [0, 1, 99], [1, 2, 97], [2, 3, 90], [3, 4, 80], [4, 5, 70],
        [5, 6, 60], [6, 7, 50], [7, 8, 40], [8, 9, 30], [9, 10, 20],
        [10, 10000, 10],
    ];

    let count_time_number = 0;
    let steps = 0;
    let message_text = '';

    function set_time(count: number) {
        gui.set_text(nodes.time_count_txt, parse_time(count));
        count_time_number = count;
    }

    function set_text(text: string) {
        message_text = text;
    }

    function set_steps(count: number) {
        steps = count;
    }

    let blocker: DruidBlocker | undefined;
    let ok_btn: DruidButton | undefined;
    function show(druid: DruidClass) {
        gui.set_visible(nodes.center, true);
        gui.set_enabled(nodes.game_over_popup, true);

        gui.set_text(nodes.step_count_txt, tostring(steps));
        gui.set_text(nodes.time_count_txt, parse_time(count_time_number));


        const pack_count = GAME_CONFIG.GAME_MODE.pack_count;
        const time = (count_time_number / 60);
        const p = range_time.find(r => (r[0] * pack_count) <= time && (r[1] * pack_count) > time);
        message_text = message_text.replace('@@%', tostring(p?.[2]) + '%');


        gui.set_text(nodes.message_txt, message_text);

        tween(nodes.center)
            .opacityTo(0, 0)
            .opacityTo(0.2, 0.8)
            .start();
        tween(nodes.game_over_popup)
            .opacityTo(0, 0)
            .opacityTo(0.2, 1)
            .start();

        if (blocker == undefined || ok_btn == undefined) {
            blocker = druid.new_blocker(nodes.center);
            ok_btn = druid.new_button(nodes['ok_btn/btn'], () => {
                Rate.show();
                timer.delay(0.1, false, () => {
                    if (Rate.is_shown())
                        Scene.restart();
                    else
                        Ads.show_interstitial(true, () => Scene.restart());
                });
            });
        }

    }

    return {
        set_time, show, set_text, set_steps
    };
}