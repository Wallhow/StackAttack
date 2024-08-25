/* eslint-disable @typescript-eslint/no-unsafe-member-access */


export function get_random_numbers(count: number) {
    const list: number[] = [];
    for (let i = 0; i < count; i++) {
        list.push(i);
    }
    for (let i = 0; i < list.length; i++) {
        const r = math.random(0, list.length - 1);
        const tmp = list[r];
        list[r] = list[i];
        list[i] = tmp;
    }
    return list;
}

export function is_equal_pos(p1: vmath.vector3, p2: vmath.vector3, sigma = 0.001) {
    return (math.abs(p1.x - p2.x) < sigma && math.abs(p1.y - p2.y) < sigma);
}

export function deep_copy<T>(original: T): T {
    return json.decode(json.encode(original)) as T;
}