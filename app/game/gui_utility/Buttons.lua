local ____lualib = require("lualib_bundle")
local __TS__StringIncludes = ____lualib.__TS__StringIncludes
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
--- Возвращает объект с отфильтрованными нодами по заданному постфиксу, а так же сразу делает из них кнопки друида.
-- 
-- @param druid экземпляр друида
-- @param nodes объект с нодами полученный из метода get_nodes
-- @param postfix_txt постфикс который необходимо найти в названии ноды для фильтрации
-- @param template название темплейта без слеша
-- @param cloned_node таблица с клонированной нодой в которой надо искать заданные ноды
-- @returns
function ____exports.Buttons(druid, nodes, postfix_btn, template)
    if template == nil then
        template = ""
    end
    local function _on(druidBtn, callback)
        druidBtn.on_click:subscribe(callback)
        return druidBtn
    end
    local function _enable(node, druidBtn, is_enabled)
        druidBtn:set_enabled(is_enabled)
        gui.set_enabled(node, is_enabled)
        return druidBtn
    end
    local btns = {}
    for node in pairs(nodes) do
        if __TS__StringIncludes(node, postfix_btn) then
            local druidBtn = druid:new_button(
                (template ~= "" and template .. "/" or "") .. node,
                function()
                end
            )
            btns[node] = __TS__ObjectAssign(
                {
                    on = function(self, callback)
                        return _on(druidBtn, callback)
                    end,
                    enable = function(self, is_enable)
                        return _enable(nodes[node], druidBtn, is_enable)
                    end
                },
                druidBtn
            )
        end
    end
    return __TS__ObjectAssign({}, btns)
end
return ____exports
