local ____lualib = require("lualib_bundle")
local __TS__StringIncludes = ____lualib.__TS__StringIncludes
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____ShrinkText = require("utils.ui.gui.components.ShrinkText")
local ShrinkText = ____ShrinkText.ShrinkText
--- Возвращает объект с отфильтрованными текстовыми нодами по заданному постфиксу.
-- 
-- @param nodes объект с нодами полученный из метода get_nodes
-- @param postfix_txt постфикс который необходимо найти в названии ноды для фильтрации
-- @param template название темплейта без слеша
-- @param cloned_node таблица с клонированной нодой в которой надо искать текстовые ноды
-- @returns
function ____exports.Texts(nodes, postfix_txt, template, cloned_node)
    local _get_node
    function _get_node(name)
        if cloned_node ~= nil then
            return cloned_node[name]
        end
        return gui.get_node(name)
    end
    local texts = {}
    local keys = {}
    local condition = {}
    local condition_node = {}
    local function _set(value, node_name, shrink)
        local src_str = type(value) == "string" and value or tostring(value)
        local str = src_str
        if condition[str] ~= nil then
            str = condition[str]
        end
        if condition_node[node_name] ~= nil and condition_node[node_name][src_str] ~= nil then
            str = condition_node[node_name][src_str]
        end
        local node = _get_node(node_name)
        if shrink ~= nil then
            ShrinkText(node, shrink.axis, false).set(str)
        else
            gui.set_text(node, str)
        end
    end
    --- Метод задает для каждой ноды в объекте условие на устанавливаемый текст, срабатывает при использовании метода set на конкретной ноде,
    -- сверяет устанавливаемый текст с in_text и если текст соответствует ему то меняет на out_text.
    -- 
    -- @param in_text Паттерн текста
    -- @param out_text Паттерн на который будет заменен найденый текст
    local function _condition(in_text, out_text)
        condition[in_text] = out_text
    end
    --- Метод задает для ноды в объекте условие на устанавливаемый текст, срабатывает при использовании метода set на конкретной ноде,
    -- сверяет устанавливаемый текст с in_text и если текст соответствует ему то меняет на out_text.
    -- 
    -- @param in_text Паттерн текста
    -- @param out_text Паттерн на который будет заменен найденый текст
    local function _condition_node(node, in_text, out_text)
        if condition_node[node] == nil then
            condition_node[node] = {}
        end
        condition_node[node][in_text] = out_text
    end
    local function init()
        for ____, _node in ipairs(nodes.keys) do
            if __TS__StringIncludes(_node, postfix_txt) then
                local node = _node
                keys[#keys + 1] = _node
                texts[_node] = {set = function(self, value, shrink)
                    _set(value, node, shrink)
                end}
            end
        end
    end
    init()
    return __TS__ObjectAssign({}, texts, {condition = _condition, condition_node = _condition_node, keys = keys})
end
return ____exports
