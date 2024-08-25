/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-empty-function */
import { FilterByPostfix } from '../../utils/utilityTypes';
import { NodesFromTemplate } from '../../utils/utils';
/**
 * Возвращает объект с отфильтрованными нодами по заданному постфиксу, а так же сразу делает из них кнопки друида.  
 * @param druid экземпляр друида
 * @param nodes объект с нодами полученный из метода get_nodes
 * @param postfix_txt постфикс который необходимо найти в названии ноды для фильтрации
 * @param template название темплейта без слеша
 * @param cloned_node таблица с клонированной нодой в которой надо искать заданные ноды
 * @returns 
 */
export function Buttons<S extends readonly string[], T extends NodesFromTemplate<S>, Postfix extends string>(druid: DruidClass, nodes: T, postfix_btn: Postfix, template = '') {
    type F = FilterByPostfix<keyof T, Postfix>;
    type btn = DruidButton & {
        /**
         * Подписка на события клика
         * @param callback вызывается при нажатии на кнопку
         */
        on(callback: () => void): DruidButton;
        /**
         * Включает/выключает Ноду вместе с друид компонентом.
         * @param is_enabled 
         */
        enable(is_enabled: boolean): void;
    };

    function _on(druidBtn: DruidButton, callback: () => void): DruidButton {
        druidBtn.on_click.subscribe(callback);
        return druidBtn;
    }

    function _enable(node: node, druidBtn: DruidButton, is_enabled: boolean): DruidButton {
        druidBtn.set_enabled(is_enabled);
        gui.set_enabled(node, is_enabled);
        return druidBtn;
    }

    const btns: { [key in F]: btn; } = {} as { [key in F]: btn; };

    for (const node in nodes) {
        if (node.includes(postfix_btn)) {

            const druidBtn = druid.new_button((template != '' ? template + '/' : '') + node, () => { });
            btns[node as unknown as F] = {
                on(callback) {
                    return _on(druidBtn, callback);
                },
                enable(is_enable) {
                    return _enable(nodes[node as unknown as F], druidBtn, is_enable);
                },
                ...druidBtn
            };


        }
    }


    return { ...btns };
}
