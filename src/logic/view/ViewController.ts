/* eslint-disable @typescript-eslint/no-for-in-array */
/* eslint-disable @typescript-eslint/no-empty-function */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable no-empty */
/* eslint-disable prefer-const */
/* eslint-disable no-constant-condition */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-argument */
import { is_flag, set_flag } from "../../logic_state_machine/state_helper";
import { GoManager } from "../../modules/GoManager";
import { CardData } from "../card";
import { DcTransitionStates, } from "../../data_oriented_core/states";
import { EnamCardStates } from "./EnamCardStates";
import * as flow from 'ludobits.m.flow';
import { DcTransitionItems } from "../../logic_state_machine/state_interfaces";
import { IGameItem } from "../../modules/modules_const";
import { range, repeat } from "../../utils/utils";
import { PACK_PREFAB } from "../../utils/settings_utility";
import { Data, ViewGameStateWrapper as ViewGameStateWrapper } from "../../data_oriented_core/ViewGameStateWrapper";
import { Stopwatch } from "../advanced/Stopwatch";
import { VictoryEffects } from "./VictoryEffects";
import { GAME_CONSTS } from "../../main/game_config";
import { GoLayouts } from "./GoLayouts";
import { clamp } from "../../utils/math_utils";
import { StateSchema } from "../../data_oriented_core/GameState";

interface ClickCardInfo extends IGameItem {
    id_stack?: number;
    id_card?: number;
}

export type ViewController = ReturnType<typeof ViewController>;
export function ViewController() {
    // ui
    const gm = GoManager<ClickCardInfo>();
    const layouts = GoLayouts({ y_padding: (): number => 28, dir_cards_home: 1 });

    let time_opening = 0.1;
    let time_moving = 0.1;

    let goes: hash[] = [];

    let get_game_state: () => StateSchema;

    let view_gs_wrapper: ReturnType<typeof ViewGameStateWrapper>;

    function init() {
        init_view_game_state_wrapper();
        init_game_objects();

        events_subscribe();

    }


    type ViewData = ReturnType<typeof init_data>;
    //Функция инициализирующая дополнительное хранилище для цикла "обновление -> обработка" game_state для ViewGameStateManager
    function init_data(d: Data) {
        return { ...d, to_pos: vmath.vector3(), to_scale: vmath.vector3((960 / 15) / 130, (960 / 15) / 130, 1) };
    }
    function init_view_game_state_wrapper() {

        const vgs_wrapper = ViewGameStateWrapper(init_data, get_game_state());
        view_gs_wrapper = vgs_wrapper;

        //Инициализируем враппер
        //Передаем стейт и карту в которой указываем какой id соответствует каждому обновляемому полю в стейте.
        //если поле это массив массивов то id каждого дочернего элемента будет id + n где n <= state.field.length
        vgs_wrapper.init(
            {
                boxes: 10
            }
        );

        vgs_wrapper.override_def_transition(DcTransitionStates.RENDER_ORDER, (data, _go, cb_end) => {
            data.other.z = data.other.z ?? data.state.index;
            gm.set_render_order_hash(_go, data.other.z);

            if (data.other.color != null)
                gm.set_color_hash(_go, data.other.color);

            cb_end();
        });

        /*  vgs_wrapper.override_def_transition(DcTransitionStates.OPENED, (data, _go, cb_end) => {
             const cd = dc_card_list[data.id_item];
             const cur_anim = gm.get_sprite_hash(_go);
 
             const to_name = is_flag(data.state.mask, EnamCardStates.OPENED) ? (cd.mast + cd.nom) : current_rub;
 
             if (hash(to_name) == cur_anim) {
                 cb_end();
                 return;
             }
 
             const scale = go.get_scale(_go);
 
             gm.do_scale_anim_hash(_go, vmath.vector3(0.001, scale.y, 1), time_opening, 0, () => {
                 gm.set_sprite_hash(_go, to_name);
                 gm.do_scale_anim_hash(_go, scale, time_opening, 0, () => {
                     cb_end();
                 });
             });
         }); */

        vgs_wrapper.override_def_transition(DcTransitionStates.POSITION, (data, _go, cb_end) => {

            const tmp_z = gm.get_render_order_hash(_go);
            log(_go)
            gm.set_render_order_hash(_go, 110 + data.state.index);

            if (data.to_scale != undefined && data.to_scale.x != undefined)
                go.set_scale(data.to_scale, _go);
            log(data.to_pos)
            gm.move_to_with_time_hash(_go, data.to_pos, time_moving, () => {
                gm.set_render_order_hash(_go, tmp_z); cb_end();

            });

        });


        vgs_wrapper.set_update_states({
            boxes: (s, other, flag) => {
                return set_flag(flag, 17, other.id_child % 3 == 0);
            }

        });




        let acc = 0;
        vgs_wrapper.set_handler_state(10, (data: ViewData) => {
            if (is_flag(data.state.mask, 17)) {
                const p = go.get_position(hash('/hand'));
                p.x += (960 / 15) / 2 + acc;
                acc += (960 / 15);
                log('index ', data.state.index)
                data.to_pos.x = p.x;
                data.to_pos.y = p.y;
            } else {
                const p = go.get_position(hash('/hand'));
                p.x -= 200;

                data.to_pos.x = p.x;
                data.to_pos.y = p.y;
            }

            //field
            //data.other.z = data.state.index;
        });

    }


    function change_layout(d: { layout: 'portrait' | 'landscape' }, is_gameover: boolean) {

    }


    function events_subscribe() {


    }


    function init_game_objects() {
        const pos = go.get_position(hash('/hand'));
        pos.y -= 200;

        repeat(get_game_state().boxes.length, (i) => {
            const _go = gm.make_go('test', pos);
            goes.push(_go);
            log('create')
        });
        pprint(goes)
        view_gs_wrapper.set_go_list(goes);
        view_gs_wrapper.set_order_trasitions([DcTransitionStates.RENDER_ORDER, DcTransitionStates.POSITION,]);

    }

    function is_animations_done() {
        return view_gs_wrapper.is_animations_done();
    }

    function wait_animations() {
        while (true) {
            if (is_animations_done()) {
                break;
            }
            flow.delay(0.1);
        }
    }

    function configure_times(t_moving: number, t_opening: number) {
        time_moving = t_moving;
        time_opening = t_opening;
    }

    function apply_state(game_state: StateSchema, wait_applying = false, is_force_update = false) {
        view_gs_wrapper.update(game_state, is_force_update);

        if (wait_applying)
            wait_animations();

    }

    function refresh_view() {
        configure_times(0, 0);
        view_gs_wrapper.configure_seq_list_items(DcTransitionItems.PARALLEL);
        view_gs_wrapper.update(get_game_state(), true);
    }

    function do_message(message_id: hash, _message: AnyTable, sender: hash) {
        gm.do_message(message_id, _message);
    }

    /**
     * Устанавливает функцию для получения StateSchema необходимого для обновления представления 
     * @see seq_update_data_view, @see par_update_data_view
     * @param get_game_state_func 
     */
    function set_get_game_state_func(get_game_state_func: () => StateSchema) {
        get_game_state = get_game_state_func;
    }

    const def_opt = { open_t: 0.3, move_t: 0.3, wait_anim: true, is_force_update: false, complite: () => { } };
    /**Обновляет представление данных (game_state) 
     * @param state_edit_func функция в которой проводятся изменения состояния данных
     * @param transition - последовательное или параллельное изменение состояния
     * @param opt - доп. опции : 
     * open_t - время открытие карты, 
     * move_t продолжительность перемещения карты,
     * wait_anim - ждать ли завершения анимации, 
     * complite - функция вызываемая по завершению действия с данными и если указано wait_anim = true, по завершению анимации }
    */
    function update_data_view(game_state: StateSchema, state_edit_func: (() => void) | undefined, transition: DcTransitionItems, opt: typeof def_opt) {
        configure_times(opt.move_t, opt.open_t);
        view_gs_wrapper.configure_seq_list_items(transition);
        if (state_edit_func)
            state_edit_func();
        //wait_animations();
        apply_state(game_state, false, opt.is_force_update);
        if (opt.wait_anim)
            wait_animations();
        opt.complite();
    }
    /** Обновление представления game_state последовательное */
    function seq_update_data_view(opt: Partial<typeof def_opt> = {}, state_edit_func?: () => void) {
        const game_state = get_game_state();
        update_data_view(game_state, state_edit_func, DcTransitionItems.SEQUENCE, { ...def_opt, ...opt });
    }
    /** Обновление представления game_state параллельное */
    function par_update_data_view(opt: Partial<typeof def_opt> = {}, state_edit_func?: () => void) {
        const game_state = get_game_state();
        update_data_view(game_state, state_edit_func, DcTransitionItems.PARALLEL, { ...def_opt, ...opt });
    }


    return {
        init, do_message, apply_state, configure_times, wait_animations,
        set_get_game_state_func, seq_update_data_view: seq_update_data_view, par_update_data_view,
        configure_seq_list_items: (items: DcTransitionItems) => { view_gs_wrapper.configure_seq_list_items(items); },
        change_layout, is_animations_done,
        refresh_view
    };
}


