export type FilterByPostfix<T, U extends string> = T extends `${infer R}${U}` ? T : never;
export type FilterByPrefix<T, U extends string> = T extends `${U}${infer R}` ? T : never;

/**
 * Получая на вход GameState выводит типы для его элементов, если элементы содержат массивы других массивов то под 
 * ключем родителя возвращает тип дочерних массивов 
 * например у stack_ids это будет просто CardList, а не CardList[]
 */
export type DeepTypes<T> = {
    [K in keyof T]: T[K] extends Array<infer U>
    ? U extends Array<infer J> ? U : T[K] : T[K]
};