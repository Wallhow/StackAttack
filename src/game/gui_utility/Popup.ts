/* eslint-disable @typescript-eslint/no-empty-function */


export function Popup(root_node: node) {
    let is_open = false;

    const user_functions = { open: () => { }, close: () => { } };

    function show(user_func = () => { }) {
        _set_enable_popup(true);
        _set_user_functions('open', user_func);

        user_functions.open();
    }

    function close(user_func = () => { }) {
        _set_user_functions('close', user_func);
        user_functions.close();

        _set_enable_popup(false);
    }

    function layout_changed() {
        if (is_open)
            show();
    }

    function _set_user_functions(key: keyof typeof user_functions, func: () => void) {
        if (user_functions[key] == null)
            user_functions[key] = func;
    }

    function _set_enable_popup(open: boolean) {
        is_open = open;
        gui.set_enabled(root_node, is_open);
    }

    return {
        show,
        close,
        layout_changed
    };
}