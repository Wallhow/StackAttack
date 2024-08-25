local ____exports = {}
local ____array = require("utils.array")
local array = ____array.array
local ____utils = require("utils.utils")
local ____repeat = ____utils["repeat"]
local flow = require("ludobits.m.flow")
function ____exports.VictoryEffects(go_cards, gm)
    local random_sign
    function random_sign()
        return math.random() > 0.5 and 1 or -1
    end
    local function do_effect_1()
        local dir = {}
        local speed = {}
        ____repeat(
            #go_cards,
            function()
                dir[#dir + 1] = {
                    x = random_sign() * math.random(),
                    y = random_sign() * math.random()
                }
                speed[#speed + 1] = math.random(5, 10)
            end
        )
        local acc_r = 0
        timer.delay(
            0.016,
            true,
            function()
                for ____, i in ipairs(array.indexes(go_cards)) do
                    local g = go_cards[i + 1]
                    local pos = go.get_position(g)
                    pos.x = pos.x + dir[i + 1].x * speed[i + 1]
                    pos.y = pos.y + dir[i + 1].y * speed[i + 1]
                    go.set_position(pos, g)
                    go.set_rotation(
                        vmath.quat_rotation_z(acc_r),
                        g
                    )
                    acc_r = acc_r + speed[i + 1]
                end
            end
        )
    end
    local function do_effect_3()
        local ltrb = Camera.get_ltrb()
        for ____, i in ipairs(array.indexes(go_cards)) do
            local g = go_cards[#go_cards - 3 - i + 1]
            if g ~= nil then
                gm.do_move_anim_hash(
                    g,
                    vmath.vector3(
                        ltrb.z * 0.5,
                        -math.abs(ltrb.w) - 100,
                        0
                    ),
                    1
                )
                flow.delay(0.05)
            end
        end
    end
    local function do_effect_2(home)
        local dir = {}
        local vel = {}
        local speed = {}
        local ltrb = Camera.get_ltrb()
        local go_list = {}
        local start_time = {}
        local max_time = 0
        local counter = 0
        for ____, i in ipairs(array.indexes(home)) do
            local card = home[#home - 1 - i + 1]
            local xx = random_sign() * math.random()
            local _speed = math.random(5, 10)
            local id = card
            go_list[#go_list + 1] = go_cards[id + 1]
            dir[#dir + 1] = {x = xx, y = 1}
            vel[#vel + 1] = {x = 0, y = 0}
            speed[#speed + 1] = _speed
            counter = counter + 1 * 2
            start_time[#start_time + 1] = counter
            if max_time < counter then
                max_time = counter
            end
        end
        local acc_r = 0
        timer.delay(
            0.016,
            true,
            function()
                for ____, j in ipairs(array.indexes(go_list)) do
                    local g = go_list[j + 1]
                    if start_time[j + 1] <= acc_r or acc_r > max_time then
                        local pos = go.get_position(g)
                        vel[j + 1].x = dir[j + 1].x * speed[j + 1]
                        local ____vel_index_0, ____y_1 = vel[j + 1], "y"
                        ____vel_index_0[____y_1] = ____vel_index_0[____y_1] - 1
                        pos.x = pos.x + vel[j + 1].x
                        pos.y = pos.y + vel[j + 1].y
                        go.set_position(pos, g)
                        if pos.y < ltrb.w or pos.y > ltrb.y then
                            vel[j + 1].y = vel[j + 1].y * -1
                        end
                        if pos.x < ltrb.x or pos.x > ltrb.z then
                            local ____dir_index_2, ____x_3 = dir[j + 1], "x"
                            ____dir_index_2[____x_3] = ____dir_index_2[____x_3] * -1
                        end
                    end
                end
                acc_r = acc_r + 1
            end
        )
    end
    local function do_effect_4(home)
        local dir = {}
        local vel = {}
        local speed = {}
        local ltrb = Camera.get_ltrb()
        local go_list = {}
        local start_time = {}
        local max_time = 0
        local counter = 0
        local xx = -1 * math.random()
        local _speed = math.random(5, 10)
        for ____, i in ipairs(array.indexes(home)) do
            local card = home[#home - 1 - i + 1]
            local id = card
            go_list[#go_list + 1] = go_cards[id + 1]
            dir[#dir + 1] = {x = xx, y = 1}
            vel[#vel + 1] = {x = 0, y = 0}
            speed[#speed + 1] = _speed
            counter = counter + 1 * 2
            start_time[#start_time + 1] = counter
            if max_time < counter then
                max_time = counter
            end
        end
        local acc_r = 0
        timer.delay(
            0.016,
            true,
            function()
                for ____, j in ipairs(array.indexes(go_list)) do
                    local g = go_list[j + 1]
                    if start_time[j + 1] <= acc_r or acc_r > max_time then
                        local pos = go.get_position(g)
                        vel[j + 1].x = dir[j + 1].x * speed[j + 1]
                        local ____vel_index_4, ____y_5 = vel[j + 1], "y"
                        ____vel_index_4[____y_5] = ____vel_index_4[____y_5] - 1
                        pos.x = pos.x + vel[j + 1].x
                        pos.y = pos.y + vel[j + 1].y
                        go.set_position(pos, g)
                        if pos.y < ltrb.w or pos.y > ltrb.y then
                            vel[j + 1].y = vel[j + 1].y * -1
                        end
                        if pos.x < ltrb.x or pos.x > ltrb.z then
                            local ____dir_index_6, ____x_7 = dir[j + 1], "x"
                            ____dir_index_6[____x_7] = ____dir_index_6[____x_7] * -1
                        end
                    end
                end
                acc_r = acc_r + 1
            end
        )
    end
    return {do_effect_1 = do_effect_1, do_effect_2 = do_effect_2, do_effect_3 = do_effect_3, do_effect_4 = do_effect_4}
end
return ____exports
