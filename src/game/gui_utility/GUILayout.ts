

export function GUILayout<T extends readonly string[]>(names_layout: T) {
    type LayotData = { name: T[number], type: number };


    const apply_layout_funcs = {} as { [key in T[number]]: ((w: number, h: number) => void)[] };
    const layouts_conditions_list = {} as { layout: LayotData, condition: (this: void, width: number, height: number, current_layout: LayotData, previous_layout: LayotData) => void }[];

    let previous_layout = {} as LayotData;
    let current_layout = {} as LayotData;

    function set_apply_func(name_layout: T[number], func: (w: number, h: number) => void, type = 0): void {
        if (apply_layout_funcs[name_layout] == null)
            apply_layout_funcs[name_layout] = [];
        apply_layout_funcs[name_layout][type] = func;
    }

    function apply(layout: T[number], type = 0) {
        const [width, height] = window.get_size();
        if (current_layout == null)
            current_layout = { name: layout, type };
        else {
            previous_layout = current_layout;
            current_layout = { name: layout, type };
        }

        const apply_func = apply_layout_funcs[current_layout.name][current_layout.type]
        if (apply_func != null)
            apply_func(width, height);
       /*  else
            assert(false, 'no apply func for layout ' + current_layout.name + ' type ' + current_layout.type); */

    }

    function layout_changed(data: { layout: 'portrait' | 'landscape' }) {
        const [width, height] = window.get_size();
        resize(width, height);
    }

    function resize(width: number, height: number) {
        const condition = layouts_conditions_list.find(val => val.condition(width, height, current_layout, previous_layout));
        if (condition != null) {
            if (condition.layout.name != current_layout.name || condition.layout.type != current_layout.type)
                apply(condition.layout.name, condition.layout.type);
        }
    }

    function set_layout_condition(layout: LayotData, condition: (width: number, height: number, current_layout: LayotData, previous_layout: LayotData) => void) {
        layouts_conditions_list.push({ layout, condition });
    }

    return {
        set_apply_func,
        resize,
        layout_changed,
        set_layout_condition,
        apply
    };
}