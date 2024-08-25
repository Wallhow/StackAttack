/* eslint-disable @typescript-eslint/no-unsafe-assignment */

import { array } from "../../utils/array";

export type GroupVer = ReturnType<typeof GroupVer>;
/**
 * Объект объединяющий в группу ноды, работает примерно так же как друид статик груп
 * @param root_node 
 * @param children 
 * Group полностью поддерживает пока только пивоты W, E и Center, c с остальными может вести себя не так как ожидается'
 * @returns 
 */
export function GroupVer(root_node: node, children: node[][]) {
    const pivot = gui.get_pivot(root_node);
    const flat_pivot = (pivot == gui.PIVOT_W || pivot == gui.PIVOT_E || pivot == gui.PIVOT_CENTER);

    let padding = 0;
    let start_offset = 0;

    const _this = {
        pad, offset, apply
    };

    function pad(x: number) {
        padding = x;
        return _this;
    }

    function offset(x: number) {
        start_offset = x;
        return _this;
    }

    function apply() {
        const acc_offset: number[] = [start_offset];
        const total_sizes: number[] = [];  // Суммы размеров всех child

        for (const child_index of array.indexes(children)) {
            const child_list = children[child_index];
            const total_size = get_total_size(child_list);

            total_sizes.push(total_size);

            if (child_list.length > 1) {
                child_list.sort((a, b) => {
                    const size_a = gui.get_size(a);
                    const size_b = gui.get_size(b);
                    const scale_a = gui.get_scale(a);
                    const scale_b = gui.get_scale(b);

                    const area_a = (size_a.x * scale_a.x) * (size_a.y * scale_a.y);
                    const area_b = (size_b.x * scale_b.x) * (size_b.y * scale_b.y);
                    return area_b - area_a > 0 ? 1 : -1;
                });
            }

            for (const child of child_list) {
                if (gui.get_parent(child) == root_node) {

                    let y_offset = gui.get_size(root_node).y / 2;
                    if (!flat_pivot)
                        y_offset = y_offset * (pivot == gui.PIVOT_NW || (pivot == gui.PIVOT_NW) ? 1 : -1);
                    else y_offset = 0;

                    timer.delay(0, false, () => gui.set_position(child, vmath.vector3(acc_offset[child_index], y_offset, 0)));
                }
            }
            const size_offset = gui.get_size(child_list[0]).x * gui.get_scale(child_list[0]).x;

            if (pivot != gui.PIVOT_CENTER)
                acc_offset.push(array.last(acc_offset) + (size_offset + padding) * (pivot == gui.PIVOT_W ? 1 : -1));
            else {
                const offset = array.last(acc_offset) - total_sizes[child_index] / 2;
                acc_offset.push(offset + size_offset + padding);
            }
        }

    }

    function get_total_size(child_list: node[]) {
        let sum = 0;
        for (const child of child_list) {
            const size = gui.get_size(child).x * gui.get_scale(child).x;
            sum += size;
        }
        return sum;
    }

    return _this;
}
