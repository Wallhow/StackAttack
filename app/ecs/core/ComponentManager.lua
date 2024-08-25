local ____exports = {}
function ____exports.ComponentManager()
    local components = {}
    local function create(componentID, data)
        data.UUID = componentID
        return data
    end
    return {create = create}
end
return ____exports
