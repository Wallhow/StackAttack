/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import * as druid from 'druid.druid';
import { show_gui_list, hide_gui_list, set_text, get_nodes, hex2rgba, repeat } from '../utils/utils';
import { Buttons } from '../game/gui_utility/Buttons';
import { SelectPackCountWindow } from './popups/SelectPackCountWindow';
import { apply_settings } from '../utils/settings_utility';
import { ADS_CONFIG, IS_HUAWEI } from '../main/game_config';

interface props {
    druid: DruidClass;
    update_ui: () => void;

}


export function init(this: props): void {
    Manager.init_script();

    if (!GameStorage.get('tutorial_done'))
        Scene.load('game');

    this.druid = druid.new(this);

    const node_names = [
        'btn_exit/btn', 'btn_settings/btn', 'btn_stats/btn', 'btn_play/btn', 'root',
    ] as const;
    const nodes = get_nodes(node_names);

    const btns = Buttons(this.druid, nodes, '/btn');

    btns['btn_play/btn'].on(() => Scene.load('game'));
    btns['btn_stats/btn'].on(() => { Scene.load('stats'); });
    btns['btn_settings/btn'].on(() => Scene.load('settings'));


    this.update_ui = init_ui;

    init_ui();



    function init_ui(this: any) {

        apply_settings();

        if (System.platform != 'HTML5')
            btns['btn_exit/btn'].on(() => sys.exit(0));


        if (System.platform == "HTML5") {
            btns['btn_exit/btn'].enable(false);
            hide_gui_list(['home_name']);

            if (!GAME_CONFIG.is_portrait) {
                let pos = gui.get_position(nodes['btn_settings/btn']);
                pos.x = 150;
                gui.set_position(nodes['btn_settings/btn'], pos);
                pos.x *= -1;
                gui.set_position(nodes['btn_stats/btn'], pos);

                pos = gui.get_position(nodes['btn_play/btn']);
                pos.x = 0;
                gui.set_position(nodes['btn_play/btn'], pos);
            }
        }


        if (IS_HUAWEI)
            set_text('home_name', Lang.get_lang() == 'ru' ? 'Свободная ячейка' : 'Freecell');

        if (System.platform != 'iPhone OS')
            hide_gui_list(['btnPrivacy']);
        else
            set_text('privacy', Lang.get_lang() == 'ru' ? "Политика конфиденциальности" : "Privacy Policy");

    }

    if (ADS_CONFIG.is_mediation && System.platform != "HTML5" && Lang.is_gdpr()) {
        log('check request GDPR');
        const gdpr = Storage.get_int('gdpr', -1);
        // запрашиваем, инфа не сохранена
        if (gdpr == -1) {
            log('request GDPR');
            //
            let is_checked = true;
            show_gui_list(['gdpr_block']);
            this.druid.new_blocker('gdpr_block');
            this.druid.new_button('gdpr_url', () => sys.open_url(Lang.get_lang() == 'ru' ? 'https://sb-games.ru/policy-ru.html' : 'https://sb-games.ru/policy.html'));
            this.druid.new_checkbox('gdpr_check_box', (_, val: boolean) => is_checked = val, 'gdrp_is_readed', is_checked);

            this.druid.new_button('btnGdprOk', () => {
                hide_gui_list(['gdpr_block']);
                Storage.set('gdpr', is_checked ? 1 : 0);
                yandexads.set_user_consent(is_checked);
            });
        }
    }
    if (System.platform == 'iPhone OS')
        this.druid.new_button('btnPrivacy', () => sys.open_url(Lang.get_lang() == 'ru' ? 'https://sb-games.ru/policy-ru.html' : 'https://sb-games.ru/policy.html'));


}

export function on_input(this: props, action_id: string | hash, action: unknown) {
    return this.druid.on_input(action_id, action);
}

export function update(this: props, dt: number): void {
    this.druid.update(dt);
}

export function on_message(this: props, message_id: string | hash, message: any, sender: string | hash | url): void {
    if (message_id == hash('layout_changed')) {
        this.update_ui();
    }

    this.druid.on_message(message_id, message, sender);

}

export function final(this: props): void {
    Manager.final_script();
    this.druid.final();
}