local ____exports = {}
function ____exports.Popup(root_node)
    local _set_user_functions, _set_enable_popup, is_open, user_functions
    function _set_user_functions(key, func)
        if user_functions[key] == nil then
            user_functions[key] = func
        end
    end
    function _set_enable_popup(open)
        is_open = open
        gui.set_enabled(root_node, is_open)
    end
    is_open = false
    user_functions = {
        open = function()
        end,
        close = function()
        end
    }
    local function show(user_func)
        if user_func == nil then
            user_func = function()
            end
        end
        _set_enable_popup(true)
        _set_user_functions("open", user_func)
        user_functions.open()
    end
    local function close(user_func)
        if user_func == nil then
            user_func = function()
            end
        end
        _set_user_functions("close", user_func)
        user_functions.close()
        _set_enable_popup(false)
    end
    local function layout_changed()
        if is_open then
            show()
        end
    end
    return {show = show, close = close, layout_changed = layout_changed}
end
return ____exports
