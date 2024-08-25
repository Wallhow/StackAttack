local ____exports = {}
local ____ECS = require("ecs.core.ECS")
local ecs = ____ECS.ecs
function ____exports.TintSystem()
    return ecs.systems.create(
        {"GO", "TintComponent"},
        {update = function(____, e, dt)
            for ____, entity in ipairs(e) do
                local ____entity_components_0 = entity.components
                local GO = ____entity_components_0.GO
                local TintComponent = ____entity_components_0.TintComponent
                TintComponent.x = TintComponent.x + 10 * dt
                TintComponent.y = TintComponent.y - 10 * dt
                if TintComponent.x >= 1 then
                    TintComponent.x = 0
                end
                if TintComponent.y <= 0 then
                    TintComponent.y = 1
                end
                go.set(
                    TintComponent.spriteUrl,
                    "tint",
                    vmath.vector4(TintComponent.x, TintComponent.y, TintComponent.z, 1)
                )
            end
        end}
    )
end
return ____exports
