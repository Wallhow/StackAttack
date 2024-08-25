local ____lualib = require("lualib_bundle")
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__StringReplace = ____lualib.__TS__StringReplace
local ____exports = {}
local ____Tween = require("utils.defoldTweens.Tween")
local tween = ____Tween.tween
local ____utils = require("utils.utils")
local get_nodes = ____utils.get_nodes
local parse_time = ____utils.parse_time
function ____exports.GameoverWindow()
    local nodes = get_nodes({
        "center",
        "game_over_popup",
        "step_count_txt",
        "time_count_txt",
        "ok_btn/btn",
        "message_txt",
        "win_txt"
    })
    local range_time = {
        {0, 1, 99},
        {1, 2, 97},
        {2, 3, 90},
        {3, 4, 80},
        {4, 5, 70},
        {5, 6, 60},
        {6, 7, 50},
        {7, 8, 40},
        {8, 9, 30},
        {9, 10, 20},
        {10, 10000, 10}
    }
    local count_time_number = 0
    local steps = 0
    local message_text = ""
    local function set_time(count)
        gui.set_text(
            nodes.time_count_txt,
            parse_time(count)
        )
        count_time_number = count
    end
    local function set_text(text)
        message_text = text
    end
    local function set_steps(count)
        steps = count
    end
    local blocker
    local ok_btn
    local function show(druid)
        gui.set_visible(nodes.center, true)
        gui.set_enabled(nodes.game_over_popup, true)
        gui.set_text(
            nodes.step_count_txt,
            tostring(steps)
        )
        gui.set_text(
            nodes.time_count_txt,
            parse_time(count_time_number)
        )
        local pack_count = GAME_CONFIG.GAME_MODE.pack_count
        local time = count_time_number / 60
        local p = __TS__ArrayFind(
            range_time,
            function(____, r) return r[1] * pack_count <= time and r[2] * pack_count > time end
        )
        message_text = __TS__StringReplace(
            message_text,
            "@@%",
            tostring(p and p[3]) .. "%"
        )
        gui.set_text(nodes.message_txt, message_text)
        tween(nodes.center).opacityTo(0, 0).opacityTo(0.2, 0.8).start()
        tween(nodes.game_over_popup).opacityTo(0, 0).opacityTo(0.2, 1).start()
        if blocker == nil or ok_btn == nil then
            blocker = druid:new_blocker(nodes.center)
            ok_btn = druid:new_button(
                nodes["ok_btn/btn"],
                function()
                    Rate.show()
                    timer.delay(
                        0.1,
                        false,
                        function()
                            if Rate.is_shown() then
                                Scene.restart()
                            else
                                Ads.show_interstitial(
                                    true,
                                    function() return Scene.restart() end
                                )
                            end
                        end
                    )
                end
            )
        end
    end
    return {set_time = set_time, show = show, set_text = set_text, set_steps = set_steps}
end
return ____exports
