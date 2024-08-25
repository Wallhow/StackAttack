local ____exports = {}
local ____ShrinkText = require("utils.ui.gui.components.ShrinkText")
local ShrinkText = ____ShrinkText.ShrinkText
function ____exports.Header(druid, template_name)
    if template_name == nil then
        template_name = "header"
    end
    local _this
    local header_name_node = template_name .. "/name"
    local header_btn_node = template_name .. "/btn"
    local label = ShrinkText(
        gui.get_node(header_name_node),
        "x"
    )
    local name_text = ""
    local function set_name(name)
        name_text = name
        label.set(name)
        return _this
    end
    local function set_btn_callback(callback)
        druid:new_button(header_btn_node, callback)
        return _this
    end
    local function on_change_layout()
        label.set(name_text)
        return _this
    end
    _this = {set_name = set_name, set_btn_callback = set_btn_callback, on_change_layout = on_change_layout}
    return _this
end
return ____exports
