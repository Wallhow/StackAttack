/* eslint-disable @typescript-eslint/no-unsafe-assignment */

import { ComponentsIDs, Components } from "../baseComponents/Components";
import { ecs } from "./ECS";


export type System<components extends ComponentsIDs[number][]> = {
    UUID: number;
    isEnabled: boolean;
    components: readonly string[],
    exclude: (readonly string[]) | undefined,
    update?: (entities: { id: number, components: { [K in components[number]]: Components[K] } }[], dt: number) => void;
    init?: (entities: { id: number, components: { [K in components[number]]: Components[K] } }[]) => void
    input?: (entities: { id: number, components: { [K in components[number]]: Components[K] } }[], action_id: string | hash, action: any) => void;

    on_entity_added?: (entity: { id: number, components: { [K in components[number]]: Components[K] } }) => void
};


export function SystemManager() {
    let ecs: ecs;
    const systems: System<any>[] = [];
    let systemsIDs = -1;
    function create<components extends ComponentsIDs[number][]>(componentsFiltering: components,
        methods?: {
            update?: (entities: { id: number, components: { [K in components[number]]: Components[K] } }[], dt: number) => void
            init?: (entities: { id: number, components: { [K in components[number]]: Components[K] } }[]) => void
            input?: (entities: { id: number, components: { [K in components[number]]: Components[K] } }[], action_id: string | hash, action: any) => void;
            on_entity_added?: (entity: { id: number, components: { [K in components[number]]: Components[K] } }) => void
        }, exclude_comps?: components) {

        const system: System<components> = {
            UUID: systemsIDs++,
            isEnabled: true,
            components: componentsFiltering,
            exclude: exclude_comps,
            ...methods,
        };
        systems.push(system);

        return systemsIDs;
    }

    function update(dt: number) {
        for (const system of systems) {
            if (system.isEnabled) {
                const entities = getEntities(system.components, system.exclude);
                if (system.update != undefined)
                    system.update(entities, dt);
            }
        }
    }

    function setEnabled(descSystem: number, isEnabled: boolean) {
        if (systems[descSystem] != undefined)
            systems[descSystem].isEnabled = isEnabled;
        else assert(false, 'system with descriptor ' + descSystem + 'not found');
    }

    function getEntities(components: readonly string[], exclude?: readonly string[]) {
        const entities: { id: number; components: { [x: string]: any; } }[] = [];

        const res = ecs.getEntitiesWithComponents(components as ComponentsIDs[number][], exclude as ComponentsIDs[number][]);

        if (res.length > 0) {
            const e = res;
            if (e != undefined) {
                for (const i of e) {
                    const entity = ecs.getEntity(i);
                    if (entities.find(e => e.id === i) == undefined)
                        entities.push({ id: i, components: entity });
                }
            }
        }
        return entities;
    }

    function input(action_id: string | hash, action: any) {
        const inputSystems = systems.filter(system => system.components.includes('InputComponent'));
        if (inputSystems.length > 0)
            for (const system of inputSystems) {
                const entities = getEntities(system.components, system.exclude);
                if (system.input != undefined)
                    system.input(entities, action_id, action);
            }
    }

    function init(_ecs: ecs, _systems: (() => number)[]) {
        ecs = _ecs;
        for (const system of _systems)
            system();

        for (const sys of systems) {
            const entities = getEntities(sys.components, sys.exclude);
            if (sys.init != null) sys.init(entities);
        }
    }

    function entity_added(entityId: number) {
        const _systems = systems.filter(system => system.on_entity_added != null);
        for (const sys of _systems) {
            if (getEntities(sys.components, sys.exclude).find(e => e.id == entityId) != null)
                sys.on_entity_added?.({ id: entityId, components: ecs.getEntity(entityId) });
        }
    }
    return {
        update, input, create, init, setEnabled, entity_added
    };

}