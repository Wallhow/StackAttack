export type TNom = '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' | '10' | 'v' | 'd' | 'k' | 't';
export type TMast = 'b' | 'p' | 'k' | 'c';

export const DcMast: TMast[] = ['c', 'p', 'b', 'k'];
export const DcNums: TNom[] = (['t', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'v', 'd', 'k']);


export interface CardState {
    // id: number;
    is_open: boolean;
    is_movable: boolean;
}

export interface CardData {
    mast: TMast;
    nom: TNom;
    is_joker?: boolean;
}