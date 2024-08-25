local ____exports = {}
local ____TweenGUI = require("utils.defoldTweens.TweenGUI")
local _newTweensForNode = ____TweenGUI._newTweensForNode
function ____exports.tween(obj)
    return _newTweensForNode(obj)
end
return ____exports
