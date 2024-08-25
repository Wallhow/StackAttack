export const InputKeys = ['W', 'A', "S", "D", 'SPACE'] as const;
export enum ControllableComponentStates {
    INITIAL,
    IDLE,
    MOVING_L,
    MOVING_R,
    MOVING_U,
    MOVING_D,
    MOVING_LU,
    MOVING_LD,
    MOVING_RU,
    MOVING_RD,
    JUMPING,
} 