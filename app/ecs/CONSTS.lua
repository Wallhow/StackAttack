local ____exports = {}
____exports.InputKeys = {
    "W",
    "A",
    "S",
    "D",
    "SPACE"
}
____exports.ControllableComponentStates = ControllableComponentStates or ({})
____exports.ControllableComponentStates.INITIAL = 0
____exports.ControllableComponentStates[____exports.ControllableComponentStates.INITIAL] = "INITIAL"
____exports.ControllableComponentStates.IDLE = 1
____exports.ControllableComponentStates[____exports.ControllableComponentStates.IDLE] = "IDLE"
____exports.ControllableComponentStates.MOVING_L = 2
____exports.ControllableComponentStates[____exports.ControllableComponentStates.MOVING_L] = "MOVING_L"
____exports.ControllableComponentStates.MOVING_R = 3
____exports.ControllableComponentStates[____exports.ControllableComponentStates.MOVING_R] = "MOVING_R"
____exports.ControllableComponentStates.MOVING_U = 4
____exports.ControllableComponentStates[____exports.ControllableComponentStates.MOVING_U] = "MOVING_U"
____exports.ControllableComponentStates.MOVING_D = 5
____exports.ControllableComponentStates[____exports.ControllableComponentStates.MOVING_D] = "MOVING_D"
____exports.ControllableComponentStates.MOVING_LU = 6
____exports.ControllableComponentStates[____exports.ControllableComponentStates.MOVING_LU] = "MOVING_LU"
____exports.ControllableComponentStates.MOVING_LD = 7
____exports.ControllableComponentStates[____exports.ControllableComponentStates.MOVING_LD] = "MOVING_LD"
____exports.ControllableComponentStates.MOVING_RU = 8
____exports.ControllableComponentStates[____exports.ControllableComponentStates.MOVING_RU] = "MOVING_RU"
____exports.ControllableComponentStates.MOVING_RD = 9
____exports.ControllableComponentStates[____exports.ControllableComponentStates.MOVING_RD] = "MOVING_RD"
____exports.ControllableComponentStates.JUMPING = 10
____exports.ControllableComponentStates[____exports.ControllableComponentStates.JUMPING] = "JUMPING"
return ____exports
