/* eslint-disable @typescript-eslint/no-non-null-assertion */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-argument */
import { is_flag, set_flag } from "../logic_state_machine/state_helper";
import { StateInfo, TransitionFnc, StateItemInfo } from "../logic_state_machine/state_interfaces";
import { StateManager } from "../logic_state_machine/state_manager";
import { array } from "../utils/array";
import { DeepTypes } from "../utils/utilityTypes";
import { DcTransitionStates } from "./states";
import { is_equal_pos } from "../logic/utils";
import { StateSchema } from "./GameState";
/**
 * Версия Объекта не финальная, есть еще мысли по улучшению данного объекта. Сейчас выглядит сложно, но работает хорошо.
 */
export type Data = { state: StateInfo, id_item: number, other: any, to_pos: vmath.vector3 };
/**
 * Объект обертка для работы со стейт менеджером и транзишенами
 * @param data_init_func  - Функция инициализирующая дополнительное хранилище для цикла "обновление -> обработка" game_state.
 * @returns 
 */
export function ViewGameStateWrapper<D extends Data>(data_init_func: (def_data: Data) => D, states: StateSchema,) {
    type StateUpdateFunctionMap = { [key in keyof StateSchema]: (state: DeepTypes<StateSchema>[key], other: { force_update: boolean, game_state: StateSchema, id_child: number, index: number }, flag: number) => number };
    type StateHandlerFunctionMap = { [key: number]: (data: D) => void };

    const state_manager = StateManager(_get_transition_set);
    //Методы для переходов
    const overrided_def_transitions = {} as { [key in DcTransitionStates]: (data: D, _go: hash, cb_end: () => void) => void };

    let update_states: StateUpdateFunctionMap;
    let handlers_state: StateHandlerFunctionMap;
    let updatable_states_map: Partial<{ [key in keyof StateSchema]: number }>;
    const default_transitions = _create_default_transition();

    /**
     * 
     * @param game_state 
     * @param updatable_states - Карта { состояние: id }. Обрабатываться будут только те поля состояния которым назначен id. Если поле это массив массивов то id каждого дочернего элемента будет id + n где n <= state.field.length   
     */
    function init(updatable_states: typeof updatable_states_map) {
        update_states = _create_default_update_state(states);
        handlers_state = {} as StateHandlerFunctionMap;
        updatable_states_map = updatable_states;
    }

    /**
     * Устанавливает функцию обновления для состояния, вызывается для каждого корневого поля StateSchema,
     * в поле state в функции обработчике будет возвращать либо само поле из StateSchema либо его дочерние эллементы, как в случае со stack_ids
     * @param handlers 
     */
    function set_update_states(handlers: Partial<StateUpdateFunctionMap>) {
        update_states = { ...update_states, ...handlers };
    }
    /**
     * Устанавливает функцию обработчик для конкретного состояния.
     * @param id - id состояния
     * @param handler - функция обработчик состояния
     */
    function set_handler_state(id: number, handler: (data: D) => void) {
        handlers_state[id] = handler;
    }

    /**
     * Устанавливает функции обработки для состояний которые содержат в себе массивы.
     * @param init - функция обработчик состояния карты в которой i это порядковый номер массива
     * @param state - название поля состояния 
     */
    function set_handlers_state(state: keyof StateSchema, init: (data: D, i: number) => void) {
        for (const i of $range(0, states[state].length - 1)) {
            const handler = (data: D) => {
                const index = i;
                init(data, index);
            };
            handlers_state[(updatable_states_map[state] as number + i)] = handler;
        }

    }

    let update_all_states = null as ((other: { force_update: boolean, game_state: StateSchema, id_child: number, index: number }, flag: number) => number) | null;
    /**
     * Устанавливает обработчик который будет применятся к каждому элементу состояния при каждом обновлении состояния
     * @param handler 
     */
    function set_all_states_handler(handler: (other: { force_update: boolean, game_state: StateSchema, id_child: number, index: number }, flag: number) => number) {
        update_all_states = handler;
    }

    /**
     * Обновляет состояние игры, применяя функции обновления для каждого обновляемого состояния.
     * @param state - текущее состояние игры
     * @param force_update - флаг принудительного обновления
     */
    function update(state: StateSchema, force_update = false) {
        for (const key_state in state) {
            const other = { force_update, game_state: state, id_child: -1, index: -1 };
            const key = key_state as keyof StateSchema;

            if (key in updatable_states_map) {
                const dc_type = updatable_states_map[key]!;
                const update_state_function = update_states[key];

                _update_state_general(state, key, dc_type, (id, mask, index, sub_state) => {
                    const _state = (sub_state != undefined ? sub_state : state[key]) as unknown;
                    other.id_child = id;
                    other.index = index;
                    let new_mask = update_state_function(_state as any, other, mask);
                    if (update_all_states != null)
                        new_mask = update_all_states(other, new_mask);
                    force_update = force_update || other.force_update;
                    state_manager.update_states(id, new_mask, index, force_update);
                }, force_update);
            }
        }

        state_manager.apply_state();
    }

    function _get_transition_set(state_info: StateItemInfo) {
        const data = data_init_func({ state: state_info.state, id_item: state_info.id_item, other: {}, to_pos: vmath.vector3() });


        // eslint-disable-next-line @typescript-eslint/no-for-in-array
        for (const handler_key of Object.keys(states)) {
            if (states[handler_key as keyof StateSchema][0] != null) {
                for (const i of $range(0, states[handler_key as keyof StateSchema].length - 1)) {
                    check(handler_key, i);
                }
            }
            else check(handler_key);

        }

        //Проверка на истинность флага и если тру то вызов обработчика состояния 
        function check(handler_key: string, index = 0) {
            const k = updatable_states_map[handler_key as keyof StateSchema] as unknown as number;

            if (k != null && handlers_state[k + index] != null)
                if (is_flag(state_info.state.mask, k + index))
                    handlers_state[k + index](data);

        }

        return [
            default_transitions[DcTransitionStates.RENDER_ORDER](data),
            //default_transitions[DcTransitionStates.OPENED](data),
            default_transitions[DcTransitionStates.POSITION](data)
        ];
    }

    /**
    * Общая функция обработки обновления состояния для сложных объектов состояния.
    * Обрабатывает каждое состояние и вызывает функцию обновления.
    * @param state - текущее состояние игры
    * @param key - ключ состояния
    * @param flag - флаг состояния карты
    * @param upd - функция обновления
    * @param force_update - флаг принудительного обновления
    */
    function _update_state_general(state: StateSchema, key: keyof StateSchema, flag: number, upd: (id: number, mask: number, index: number, sub_state?: any) => void, force_update = false) {
        const item_state = state[key];


        if (typeof item_state === 'object') {
            if (Array.isArray(item_state) && typeof item_state[0] == 'number') {
                //для одиночных элементов состояния
                calculate_mask_and_update((item_state as any), flag);

            }
            else {
                //для множественных элементов состояния
                const keys = Object.keys(item_state);
                for (const i of array.indexes(keys)) {
                    const sub_key = keys[i];
                    calculate_mask_and_update((item_state as any)[sub_key], flag + i);
                }
            }
        }


        function calculate_mask_and_update(item_state: number[], initial_mask: number) {
            for (const i of array.indexes(item_state)) {
                const id = item_state[i];
                upd(id, set_flag(0, initial_mask, true), i, item_state);
            }
        }
    }


    /**
    * Создает базовый набор функций обновления состояния для каждого корневого поля состояния игры.
    * @param game_state - текущее состояние игры
    * @returns объект, содержащий функции обновления состояния для каждого корневого поля состояния игры.
    */
    function _create_default_update_state(game_state: StateSchema): StateUpdateFunctionMap {
        const default_update_states = {} as StateUpdateFunctionMap;

        for (const k in game_state) {
            default_update_states[k as keyof StateSchema] = (_: any, __: any, mask: number) => mask;
        }

        return default_update_states;
    }
    /**
    * Перегружает стандартный переход, заменяя его пользовательским действием.
    * @param transition - тип перехода
    * @param action - функция действия для перехода
    */
    function override_def_transition(transition: DcTransitionStates, action: (data: D, _go: hash, cb_end: () => void) => void) {
        overrided_def_transitions[transition] = action;
    }


    function _create_default_transition(): { [key in DcTransitionStates]: (data: D) => [DcTransitionStates, TransitionFnc] } {
        return {
            [DcTransitionStates.RENDER_ORDER]: (data: D) => {
                return [
                    DcTransitionStates.RENDER_ORDER,
                    (_go: hash, cb_end: () => void) => {
                        if (DcTransitionStates.RENDER_ORDER in overrided_def_transitions)
                            overrided_def_transitions[DcTransitionStates.RENDER_ORDER](data, _go, cb_end);
                    }
                ];
            },

            /* [DcTransitionStates.OPENED]: (data: D) => {
                return [
                    DcTransitionStates.OPENED,
                    (_go: hash, cb_end: () => void) => {
                        if (DcTransitionStates.OPENED in overrided_def_transitions)
                            overrided_def_transitions[DcTransitionStates.OPENED](data, _go, cb_end);
                    }
                ];
            }, */

            [DcTransitionStates.POSITION]: (data: D) => {
                return [
                    DcTransitionStates.POSITION,
                    (_go: hash, cb_end: () => void) => {

                        const cur_pos = go.get_position(_go);
                        if (is_equal_pos(cur_pos, data.to_pos)) {
                            cb_end();
                        } else
                            if (DcTransitionStates.POSITION in overrided_def_transitions)
                                overrided_def_transitions[DcTransitionStates.POSITION](data, _go, cb_end);
                    }
                ];
            }
        };
    }

    return {
        set_update_states, set_handler_state, set_handlers_state, set_all_states_handler, update, init,
        get_state_manager: () => state_manager,
        override_def_transition,
        set_go_list: state_manager.set_go_list,
        set_order_trasitions: state_manager.transition_manager.set_order_trasitions,
        is_animations_done: state_manager.transition_manager.is_all_processed,
        configure_seq_list_items: state_manager.configure_seq_list_items
    };
}
