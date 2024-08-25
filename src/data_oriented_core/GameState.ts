
export interface StateSchema {
    field: number[],
    reserve: number[],
    boxes: number[]
}

export type GameState = ReturnType<typeof GameState>;
export function GameState(_state: StateSchema) {
    let game_state = _state;

    return {
        get: () => game_state,
        set: (new_state: StateSchema) => {
            game_state = new_state;
        }
    };
}