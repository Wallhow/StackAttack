export function set_flag(num: number, index: number, val: boolean) {
    const v_or = bit.lshift(2, index);
    const v_and = bit.bnot(v_or);
    if (val)
        return bit.bor(num, v_or);
    else
        return bit.band(num, v_and);
}

export function is_flag(num: number, index: number) {
    const v_or = bit.lshift(2, index);
    return bit.band(num, v_or) == v_or;
}