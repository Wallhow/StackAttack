local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____UserComponents = require("ecs.UserComponents")
local UserComponentsIDs = ____UserComponents.UserComponentsIDs
____exports._UserComponentsIDs = UserComponentsIDs
local ____array_0 = __TS__SparseArrayNew(unpack({"PositionComponent"}))
__TS__SparseArrayPush(
    ____array_0,
    unpack(____exports._UserComponentsIDs)
)
____exports._ComponentsIDs = {__TS__SparseArraySpread(____array_0)}
____exports._Components = {PositionComponent = {x = 0, y = 0}}
return ____exports
