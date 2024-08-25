import { ShrinkText } from "../utils/ui/gui/components/ShrinkText";

export type Header = ReturnType<typeof Header>;

export function Header(druid: DruidClass, template_name = 'header') {

    const header_name_node = template_name + '/name';
    const header_btn_node = template_name + '/btn';
    const label = ShrinkText(gui.get_node(header_name_node), 'x');
    let name_text = '';
    function set_name(name: string) {
        name_text = name;

        label.set(name);
        return _this;
    }


    function set_btn_callback(callback: () => void) {
        druid.new_button(header_btn_node, callback);
        return _this;
    }

    function on_change_layout() {
        label.set(name_text);
        return _this;
    }

    const _this = {
        set_name, set_btn_callback, on_change_layout
    };

    return _this;
}