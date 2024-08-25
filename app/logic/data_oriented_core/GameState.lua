local ____exports = {}
function ____exports.GameState(_state)
    local game_state = _state
    return {
        get = function() return game_state end,
        set = function(new_state)
            game_state = new_state
        end
    }
end
return ____exports
