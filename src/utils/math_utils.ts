function is_point_in_zone(A: vmath.vector3, B: vmath.vector3, C: vmath.vector3, D: vmath.vector3, E: vmath.vector3) {
    function side(a: vmath.vector3, b: vmath.vector3, p: vmath.vector3) {
        const val = (b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x);
        if (val == 0)
            return 0;
        return val > 0 ? 1 : -1;
    }

    return side(A, B, E) == -1 &&
        side(B, C, E) == -1 &&
        side(C, D, E) == -1 &&
        side(D, A, E) == -1;
}

export function rotate_around(vec: vmath.vector3, angle_rad: number) {
    const c = math.cos(angle_rad), s = math.sin(angle_rad);
    const x = vec.x;
    const y = vec.y;
    vec.x = x * c - y * s;
    vec.y = x * s + y * c;
}

export function rotate_around_center(vec: vmath.vector3, center: vmath.vector3, angle_rad: number) {
    const c = math.cos(angle_rad), s = math.sin(angle_rad);
    const x = vec.x - center.x;
    const y = vec.y - center.y;
    vec.x = x * c - y * s + center.x;
    vec.y = x * s + y * c + center.y;
}

const a = vmath.vector3(0, 0, 0);
const b = vmath.vector3(0, 0, 0);
const c = vmath.vector3(0, 0, 0);
const d = vmath.vector3(0, 0, 0);

export function is_intersect_zone(check_pos: vmath.vector3, go_pos: vmath.vector3, go_size: vmath.vector3, go_angle_deg: number, inner_offset?: vmath.vector3) {
    const w = go_size.x;
    const h = go_size.y;
    const angle = math.rad(go_angle_deg);

    a.x = -w / 2; a.y = h / 2;
    b.x = w / 2; b.y = h / 2;
    c.x = w / 2; c.y = -h / 2;
    d.x = -w / 2; d.y = -h / 2;


    if (angle != 0) {
        rotate_around(a, angle);
        rotate_around(b, angle);
        rotate_around(c, angle);
        rotate_around(d, angle);
    }
    // если присутствует смещение спрайта внутри гошки
    if (inner_offset) {
        rotate_around(inner_offset, angle);
        a.x += inner_offset.x; a.y += inner_offset.y;
        b.x += inner_offset.x; b.y += inner_offset.y;
        c.x += inner_offset.x; c.y += inner_offset.y;
        d.x += inner_offset.x; d.y += inner_offset.y;
    }

    a.x += go_pos.x; a.y += go_pos.y;
    b.x += go_pos.x; b.y += go_pos.y;
    c.x += go_pos.x; c.y += go_pos.y;
    d.x += go_pos.x; d.y += go_pos.y;



    return is_point_in_zone(a, b, c, d, check_pos);
}

export function get_debug_intersect_points() {
    return [a, b, c, d];
}

export function loop(value: number, max_value: number) {
    if (value < 0) return max_value;
    if (value > max_value) return 0;
    return value;

}

export const clamp = (value: number, min: number, max: number): number =>
    math.min(math.max(value, min), max);
