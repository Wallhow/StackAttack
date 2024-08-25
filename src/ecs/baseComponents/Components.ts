import { UserComponentsIDs, UserComps } from "../UserComponents";


export type Component<T extends ComponentsIDs[number]> = {
    [key in keyof Components[T]]: Components[T][key];
} & { UUID: T };

export type ComponentsIDs = typeof _ComponentsIDs;
export type Components = typeof _Components & UserComps;

export const _UserComponentsIDs = UserComponentsIDs;


export const _ComponentsIDs = [...[
    'PositionComponent',
], ..._UserComponentsIDs] as const;

export const _Components = {
    PositionComponent: {
        x: 0,
        y: 0,
    },
};

