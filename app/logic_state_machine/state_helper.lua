local ____exports = {}
function ____exports.set_flag(num, index, val)
    local v_or = bit.lshift(2, index)
    local v_and = bit.bnot(v_or)
    if val then
        return bit.bor(num, v_or)
    else
        return bit.band(num, v_and)
    end
end
function ____exports.is_flag(num, index)
    local v_or = bit.lshift(2, index)
    return bit.band(num, v_or) == v_or
end
return ____exports
