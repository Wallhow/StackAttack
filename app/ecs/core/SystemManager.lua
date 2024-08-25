local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local ____exports = {}
function ____exports.SystemManager()
    local getEntities, ecs
    function getEntities(components, exclude)
        local entities = {}
        local res = ecs.getEntitiesWithComponents(components, exclude)
        if #res > 0 then
            local e = res
            if e ~= nil then
                for ____, i in ipairs(e) do
                    local entity = ecs.getEntity(i)
                    if __TS__ArrayFind(
                        entities,
                        function(____, e) return e.id == i end
                    ) == nil then
                        entities[#entities + 1] = {id = i, components = entity}
                    end
                end
            end
        end
        return entities
    end
    local systems = {}
    local systemsIDs = -1
    local function create(componentsFiltering, methods, exclude_comps)
        local ____systemsIDs_0 = systemsIDs
        systemsIDs = ____systemsIDs_0 + 1
        local system = __TS__ObjectAssign({UUID = ____systemsIDs_0, isEnabled = true, components = componentsFiltering, exclude = exclude_comps}, methods)
        systems[#systems + 1] = system
        return systemsIDs
    end
    local function update(dt)
        for ____, system in ipairs(systems) do
            if system.isEnabled then
                local entities = getEntities(system.components, system.exclude)
                if system.update ~= nil then
                    system:update(entities, dt)
                end
            end
        end
    end
    local function setEnabled(descSystem, isEnabled)
        if systems[descSystem + 1] ~= nil then
            systems[descSystem + 1].isEnabled = isEnabled
        else
            assert(
                false,
                ("system with descriptor " .. tostring(descSystem)) .. "not found"
            )
        end
    end
    local function input(action_id, action)
        local inputSystems = __TS__ArrayFilter(
            systems,
            function(____, system) return __TS__ArrayIncludes(system.components, "InputComponent") end
        )
        if #inputSystems > 0 then
            for ____, system in ipairs(inputSystems) do
                local entities = getEntities(system.components, system.exclude)
                if system.input ~= nil then
                    system:input(entities, action_id, action)
                end
            end
        end
    end
    local function init(_ecs, _systems)
        ecs = _ecs
        for ____, system in ipairs(_systems) do
            system()
        end
        for ____, sys in ipairs(systems) do
            local entities = getEntities(sys.components, sys.exclude)
            if sys.init ~= nil then
                sys:init(entities)
            end
        end
    end
    local function entity_added(entityId)
        local _systems = __TS__ArrayFilter(
            systems,
            function(____, system) return system.on_entity_added ~= nil end
        )
        for ____, sys in ipairs(_systems) do
            if __TS__ArrayFind(
                getEntities(sys.components, sys.exclude),
                function(____, e) return e.id == entityId end
            ) ~= nil then
                local ____opt_1 = sys.on_entity_added
                if ____opt_1 ~= nil then
                    ____opt_1(
                        sys,
                        {
                            id = entityId,
                            components = ecs.getEntity(entityId)
                        }
                    )
                end
            end
        end
    end
    return {
        update = update,
        input = input,
        create = create,
        init = init,
        setEnabled = setEnabled,
        entity_added = entity_added
    }
end
return ____exports
