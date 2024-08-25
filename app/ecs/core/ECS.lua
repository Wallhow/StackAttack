local ____lualib = require("lualib_bundle")
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayReduce = ____lualib.__TS__ArrayReduce
local __TS__ArrayFlatMap = ____lualib.__TS__ArrayFlatMap
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____ComponentManager = require("ecs.core.ComponentManager")
local ComponentManager = ____ComponentManager.ComponentManager
local ____EntityManager = require("ecs.core.EntityManager")
local EntityManager = ____EntityManager.EntityManager
local ____SystemManager = require("ecs.core.SystemManager")
local SystemManager = ____SystemManager.SystemManager
____exports.ECS = function()
    local mapCompEntity = {}
    local sm = SystemManager()
    local em = EntityManager()
    local cm = ComponentManager()
    local newEntity = em.newEntity
    local getEntity = em.getEntity
    local function pack(entityId)
        ____exports.ecs.systems.entity_added(entityId)
    end
    local function addComponent(entityId, component)
        if mapCompEntity[component.UUID] == nil then
            mapCompEntity[component.UUID] = {}
        end
        local ____mapCompEntity_component_UUID_0 = mapCompEntity[component.UUID]
        ____mapCompEntity_component_UUID_0[#____mapCompEntity_component_UUID_0 + 1] = entityId
        em.addComponent(entityId, component)
    end
    local function getEntitiesWithComponent(id)
        return mapCompEntity[id]
    end
    local function getEntitiesWithComponents(ids, exclude)
        local entityLists = __TS__ArrayMap(
            ids,
            function(____, id) return mapCompEntity[id] or ({}) end
        )
        local intersectedEntities = __TS__ArrayReduce(
            entityLists,
            function(____, acc, list)
                return __TS__ArrayFilter(
                    acc,
                    function(____, id) return __TS__ArrayIncludes(list, id) end
                )
            end,
            entityLists[1] or ({})
        )
        if exclude and #exclude > 0 then
            local excludeEntities = __TS__ArrayFlatMap(
                exclude,
                function(____, id) return mapCompEntity[id] or ({}) end
            )
            return __TS__ArrayFilter(
                intersectedEntities,
                function(____, e) return not __TS__ArrayIncludes(excludeEntities, e) end
            )
        end
        return __TS__ArrayFilter(
            intersectedEntities,
            function(____, e) return e end
        )
    end
    local function update(dt)
        sm.update(dt)
    end
    local function input(action_id, action)
        sm.input(action_id, action)
    end
    local thisECS = {
        addComponent = addComponent,
        newEntity = newEntity,
        getEntity = getEntity,
        pack = pack,
        getEntitiesWithComponent = getEntitiesWithComponent,
        getEntitiesWithComponents = getEntitiesWithComponents,
        systems = __TS__ObjectAssign({}, sm),
        comps = __TS__ObjectAssign({}, cm),
        input = input,
        update = update
    }
    return thisECS
end
____exports.ecs = ____exports.ECS()
return ____exports
