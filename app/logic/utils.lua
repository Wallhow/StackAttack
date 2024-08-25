local ____exports = {}
function ____exports.get_random_numbers(count)
    local list = {}
    do
        local i = 0
        while i < count do
            list[#list + 1] = i
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #list do
            local r = math.random(0, #list - 1)
            local tmp = list[r + 1]
            list[r + 1] = list[i + 1]
            list[i + 1] = tmp
            i = i + 1
        end
    end
    return list
end
function ____exports.is_equal_pos(p1, p2, sigma)
    if sigma == nil then
        sigma = 0.001
    end
    return math.abs(p1.x - p2.x) < sigma and math.abs(p1.y - p2.y) < sigma
end
function ____exports.deep_copy(original)
    return json.decode(json.encode(original))
end
return ____exports
