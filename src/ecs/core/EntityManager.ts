import { ComponentsIDs, Components, Component } from "../baseComponents/Components";


type EntityComponents = { [key in ComponentsIDs[number]]: Components[key] };
export function EntityManager() {

    let UIDsEntity = 0;
    const entities: { [id: number]: EntityComponents } = {};

    function newEntity() {
        const id = UIDsEntity;
        if (entities[id] == undefined)
            entities[id] = {} as EntityComponents;

        UIDsEntity += 1;
        return id;
    }

    function getEntity(id: number) {
        return entities[id];
    }

    function addComponent<compID extends ComponentsIDs[number]>(entityId: number, component: Component<compID>) {
        (entities[entityId][component.UUID] as any) = component;
    }

    

    return {
        newEntity, getEntity, addComponent
    };

}