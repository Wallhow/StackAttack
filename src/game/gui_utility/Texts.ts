/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import { ShrinkText } from '../../utils/ui/gui/components/ShrinkText';
import { NodesFromTemplate } from '../../utils/utils';
import { FilterByPostfix } from '../../utils/utilityTypes';

/**
 * Возвращает объект с отфильтрованными текстовыми нодами по заданному постфиксу.  
 * @param nodes объект с нодами полученный из метода get_nodes
 * @param postfix_txt постфикс который необходимо найти в названии ноды для фильтрации
 * @param template название темплейта без слеша
 * @param cloned_node таблица с клонированной нодой в которой надо искать текстовые ноды
 * @returns 
 */
export function Texts<S extends readonly string[], T extends NodesFromTemplate<S>, template_name extends string, Postfix extends string>(nodes: T, postfix_txt: Postfix, template: template_name, cloned_node?: AnyTable) {
    type F = `${template_name}${template_name extends '' ? '' : '/'}${FilterByPostfix<keyof T, Postfix>}`;
    type text = {
        /** Устанавливает текст ноде
                     * @param value текст
                     * @param shrink не обязательный параметр. Если указан то текст сжимается по заданной оси при выходе за пределаы своего размера
                     */
        set(value: string | number, shrink?: { axis: 'x' | 'y' }): void
    };

    const texts: { [key in F]: text; } = {} as { [key in F]: text; };
    const keys: string[] = [];
    const condition: { [s: string]: string } = {};
    const condition_node = {} as { [node_name: string]: { [in_text: string]: string } };

    function _set(value: string | number, node_name: string, shrink?: { axis: 'x' | 'y' }): void {
        const src_str = type(value) == 'string' ? (value as string) : tostring(value);
        let str = src_str;
        if (condition[str] != undefined)
            str = condition[str];

        if (condition_node[node_name] != undefined && condition_node[node_name][src_str] != undefined)
            str = condition_node[node_name][src_str];


        const node = _get_node(node_name);
        if (shrink != undefined)
            ShrinkText(node, shrink.axis, false).set(str);
        else
            gui.set_text(node, str);
    }

    function _get_node(name: string): node {
        if (cloned_node != undefined)
            return cloned_node[name] as node;

        return gui.get_node(name);
    }
    /**
     * Метод задает для каждой ноды в объекте условие на устанавливаемый текст, срабатывает при использовании метода set на конкретной ноде,
     * сверяет устанавливаемый текст с in_text и если текст соответствует ему то меняет на out_text.
     * @param in_text Паттерн текста
     * @param out_text Паттерн на который будет заменен найденый текст
     */
    function _condition(in_text: string, out_text: string): void {
        condition[in_text] = out_text;
    }

    /**
     * Метод задает для ноды в объекте условие на устанавливаемый текст, срабатывает при использовании метода set на конкретной ноде,
     * сверяет устанавливаемый текст с in_text и если текст соответствует ему то меняет на out_text.
     * @param in_text Паттерн текста
     * @param out_text Паттерн на который будет заменен найденый текст
     */
    function _condition_node(node: F, in_text: string, out_text: string): void {
        if (condition_node[node] == undefined)
            condition_node[node] = {} as { [in_text: string]: string };
        condition_node[node][in_text] = out_text;
    }

    function init() {
        for (const _node of ((nodes as unknown as any).keys as string[])) {
            if (_node.includes(postfix_txt)) {
                const node = _node;
                keys.push(_node);
                texts[_node as unknown as F] = {
                    set(value, shrink) {
                        _set(value, node, shrink);
                    }
                };
            }
        }
    }

    init();
    return { ...texts, condition: _condition, condition_node: _condition_node, keys: keys };
}
