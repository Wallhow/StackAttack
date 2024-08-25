/* eslint-disable @typescript-eslint/no-unsafe-assignment */


export type ComponentsIdList = number[];

/* export class ComponentsFilter {

    private static UIDsComp = 0;
    private static registerComponents: { [id: string]: number } = {};

    static getCompKey(component: Component) {
        const key = this.registerComponents[component.meta.name] ?? this.newCompKey(component);
        return key;
    }

    static getCompKeyByName(componentName: string) {
        const key = this.registerComponents[componentName] ?? this.newCompKeyByName(componentName);
        return key;
    }

    private static newCompKey(component: Component) {
        this.registerComponents[component.meta.name] = this.UIDsComp;
        this.UIDsComp++;
        return this.registerComponents[component.meta.name];
    }
    private static newCompKeyByName(componentName: string) {
        this.registerComponents[componentName] = this.UIDsComp;
        this.UIDsComp++;
        return this.registerComponents[componentName];
    }
} */