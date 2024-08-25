local ____exports = {}
local ____DailyBonuses = require("logic.advanced.DailyBonuses")
local DailyBonuses = ____DailyBonuses.DailyBonuses
local ____game_config = require("main.game_config")
local GAME_CONSTS = ____game_config.GAME_CONSTS
local ____Tween = require("utils.defoldTweens.Tween")
local tween = ____Tween.tween
local ____utils = require("utils.utils")
local get_nodes = ____utils.get_nodes
local ____Buttons = require("game.gui_utility.Buttons")
local Buttons = ____Buttons.Buttons
local ____Popup = require("game.gui_utility.Popup")
local Popup = ____Popup.Popup
function ____exports.get_purchase_bonuses(bonus_id, cbk)
    if System.platform == "HTML5" and HtmlBridge.get_platform() == "yandex" then
    else
        cbk()
    end
end
function ____exports.StoreWindow(druid, close_callback)
    local close, resize, nodes, blocker, parent, timer_resize_desc
    function close()
        parent.close(function()
            blocker:set_enabled(false)
            tween(nodes.root).opacityTo(0.3, 0).call(function()
                close_callback()
                if timer_resize_desc ~= nil then
                    timer.cancel(timer_resize_desc)
                    timer_resize_desc = nil
                end
            end).start()
        end)
    end
    function resize(width, height)
        gui.set_scale(
            gui.get_node("store/root"),
            vmath.vector3(1)
        )
        if width < height then
            local scale = height / width
            if scale > 2 then
                gui.set_scale(
                    gui.get_node("store/root"),
                    vmath.vector3(2 / scale)
                )
            end
        end
    end
    local name_template = "store"
    nodes = get_nodes({
        "magick_stick_x1/btn",
        "close/btn",
        "magick_stick_x10/btn",
        "joker_x1/btn",
        "joker_x10/btn",
        "combo/btn",
        "combo_part_1",
        "combo_part_2",
        "and",
        "root"
    }, name_template)
    blocker = druid:new_blocker("center")
    local btns = Buttons(druid, nodes, "/btn", name_template)
    parent = Popup(nodes.root)
    local function init()
        blocker:set_enabled(false)
        btns["close/btn"]:on(close)
        btns["combo/btn"]:on(function() return ____exports.get_purchase_bonuses("combo", close) end)
        btns["joker_x10/btn"]:on(function() return ____exports.get_purchase_bonuses("joker", close) end)
        btns["magick_stick_x10/btn"]:on(function() return ____exports.get_purchase_bonuses("magick_stick", close) end)
    end
    local function show()
        parent.show(function()
            blocker:set_enabled(true)
            tween(nodes.root).opacityTo(0, 0).start()
            tween(nodes.root).opacityTo(0.3, 1).start()
            if timer_resize_desc == nil then
                local pre_size_screen = {width = 10000, height = 10000}
                resize(
                    window.get_size(),
                    select(
                        2,
                        window.get_size()
                    )
                )
                timer_resize_desc = timer.delay(
                    0.2,
                    true,
                    function()
                        local width, height = window.get_size()
                        if pre_size_screen.width ~= width then
                            resize(width, height)
                            pre_size_screen.width = width
                            pre_size_screen.height = height
                        end
                    end
                )
            end
        end)
    end
    init()
    local layout_changed = parent.layout_changed
    return {show = show, close = close, layout_changed = layout_changed}
end
function ____exports.get_rewarded_bonus(bonus_id, cbk_rewarded)
    Ads.show_reward(function(res)
        if res then
            DailyBonuses.add_bonus(bonus_id, bonus_id == "tips" and GAME_CONSTS.bonuses.BonusesCount.tips or 1)
            if cbk_rewarded then
                cbk_rewarded()
            end
        end
    end)
end
return ____exports
