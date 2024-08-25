/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable no-inner-declarations */
// eslint-disable-next-line @typescript-eslint/no-namespace
export namespace array {

    export function random_element<T>(arr: T[]): T {
        return arr.length > 1 ? arr[math.random(0, arr.length - 1)] : arr[0];
    }
    export function clear<T>(arr: T[], callback_befor_remove?: (element: T) => void) {
        if (callback_befor_remove)
            for (const el of arr)
                callback_befor_remove(el);
        arr.splice(0, arr.length);
    }

    export function sum(this: void, arr: number[]): number {
        return arr.length > 1 ? arr.reduce((acc, cur) => acc + cur, 0) : arr[0];
    }

    export function remove<T>(arr: T[], condition: ((element_in_arr: T) => boolean)): void;
    export function remove<T>(arr: T[], element: T): void;
    export function remove<T>(arr: T[], par: ((element_in_arr: T) => boolean) | T) {
        if (typeof (par) === 'function') {
            const index = arr.findIndex((v) => (par as any)(v));
            if (index != -1)
                arr.splice(index, 1);
        }
        else {
            const index = arr.indexOf(par);
            if (index != -1)
                arr.splice(index, 1);
        }

    }

    export function removeIndex<T>(arr: T[], index: number) {
        if (index != -1)
            arr.splice(index, 1);
    }
    export function removeIndexes<T>(arr: T[], indexes: number[]) {
        iterate_back(indexes, (i) => arr.splice(i, 1));
    }
    export function exclude<T>(arr: T[], condition: (element: T) => boolean) {
        return arr.filter(el => !condition(el));
    }
    export function pop<T>(arr: T[], idx?: number) {
        const element = idx == undefined ? arr.pop() : _popEl(arr, idx);
        return element;
    }


    export function first<T>(arr: T[]): T { return arr[0]; }
    export function last<T>(arr: T[]): T { return arr.length > 1 ? arr[arr.length - 1] : first(arr); }

    export function shuffle<T>(arr: T[]): void {
        math.randomseed(os.time());
        for (let i = arr.length - 1; i > 0; i--) {
            const j = math.floor(math.random() * (i + 1));
            // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
            [arr[i], arr[j]] = [arr[j], arr[i]];
        }
    }

    export function inverse<T>(arr: T[]): T[] { return arr.reverse(); }

    export function iterate_back<T>(arr: T[], handler: (el: T, i: number) => void) {
        for (let i = arr.length - 1; i >= 0; i--)
            handler(arr[i], i);
    }

    /**Добавляет элемент в начало массива, возвращая новый массив */
    export function push_begin<T>(arr: T[], el: T) {
        return [el].concat(arr);
    }

    function _popEl<T>(arr: T[], idx: number): T {
        const element = arr[idx];
        arr.splice(idx, 1);
        return element;
    }

    export function indexes<T>(arr: T[]): number[] {
        return arr.map((e, i) => i);
    }
}

