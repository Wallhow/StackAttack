/* eslint-disable @typescript-eslint/no-unsafe-member-access */

import { Component, ComponentsIDs, Components } from "../baseComponents/Components";


export function ComponentManager() {
    const components: Component<ComponentsIDs[number]>[] = [];

    function create<compID extends ComponentsIDs[number], T extends Components[compID]>(componentID: compID, data: T) {
        (data as any).UUID = componentID;
        return data as unknown as Component<compID>;
    }

    return { create };


}