/* eslint-disable @typescript-eslint/unbound-method */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/ban-types */

import { ComponentsIDs, Component } from "../baseComponents/Components";
import { ComponentManager } from "./ComponentManager";
import { EntityManager } from "./EntityManager";
import { SystemManager } from "./SystemManager";

type EntityIDList = number[];
export type ecs = ReturnType<typeof ECS>;

export const ECS = () => {
    const mapCompEntity: { [uidComponents in ComponentsIDs[number]]: EntityIDList } = {} as { [uidComponents in ComponentsIDs[number]]: EntityIDList };

    const sm = SystemManager();
    const em = EntityManager();
    const cm = ComponentManager();

    const { newEntity, getEntity } = em;

    function pack(entityId: number) {
        ecs.systems.entity_added(entityId);
    }

    function addComponent<compID extends ComponentsIDs[number]>(entityId: number, component: Component<compID>) {
        if (mapCompEntity[component.UUID] == undefined) {
            mapCompEntity[component.UUID] = [];
        }
        mapCompEntity[component.UUID].push(entityId);

        em.addComponent(entityId, component);

    }

    function getEntitiesWithComponent<compID extends ComponentsIDs[number]>(id: compID): EntityIDList {
        return mapCompEntity[id];
    }

    function getEntitiesWithComponents<compID extends ComponentsIDs[number]>(ids: compID[], exclude?: compID[]): EntityIDList {

        // Получаем список сущностей, у которых есть хотя бы один из указанных компонентов
        const entityLists = ids.map(id => mapCompEntity[id] || []);

        // Находим пересечение списков сущностей
        const intersectedEntities = entityLists.reduce((acc, list) => {
            return acc.filter(id => list.includes(id));
        }, entityLists[0] || []);
        // Если есть компоненты для исключения, фильтруем сущности
        if (exclude && exclude.length > 0) {
            const excludeEntities = exclude.flatMap(id => mapCompEntity[id] || []);
            return intersectedEntities.filter(e => !excludeEntities.includes(e));
        }
        return intersectedEntities.filter(e => e);
    }

    function update(dt: number) {
        sm.update(dt);
    }

    function input(action_id: string | hash, action: any) {
        sm.input(action_id, action);
    }



    const thisECS = {
        addComponent, newEntity, getEntity, pack, getEntitiesWithComponent, getEntitiesWithComponents,
        systems: { ...sm },

        comps: { ...cm },
        input, update
    };

    return thisECS;




};

export const ecs = ECS();