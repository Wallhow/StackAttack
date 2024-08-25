local ____exports = {}
function ____exports.EntityManager()
    local UIDsEntity = 0
    local entities = {}
    local function newEntity()
        local id = UIDsEntity
        if entities[id] == nil then
            entities[id] = {}
        end
        UIDsEntity = UIDsEntity + 1
        return id
    end
    local function getEntity(id)
        return entities[id]
    end
    local function addComponent(entityId, component)
        entities[entityId][component.UUID] = component
    end
    return {newEntity = newEntity, getEntity = getEntity, addComponent = addComponent}
end
return ____exports
