local ____exports = {}
local _createShrinkText
local ____Tween = require("utils.defoldTweens.Tween")
local tween = ____Tween.tween
function _createShrinkText(labelNode, shrinkAxis, isAnimate)
    if isAnimate == nil then
        isAnimate = true
    end
    local _setScale, getFontMetrics, font, line_break
    function _setScale(scale, isAnimate)
        if isAnimate then
            tween(labelNode).to(
                0.2,
                "scale",
                {scale = vmath.vector3(scale, scale, 0)},
                {easing = "EASING_OUTSINE"}
            ).start()
        else
            gui.set_scale(
                labelNode,
                vmath.vector3(scale, scale, 1)
            )
        end
    end
    function getFontMetrics(value)
        return resource.get_text_metrics(
            font,
            value,
            {
                width = gui.get_size(labelNode).x,
                height = gui.get_size(labelNode).y,
                line_break = line_break
            }
        )
    end
    local srcScl = gui.get_scale(labelNode)
    local wh = shrinkAxis == "x" and "width" or "height"
    font = gui.get_font_resource(gui.get_font(labelNode))
    line_break = gui.get_line_break(labelNode)
    local function set(value)
        local metrics = getFontMetrics(value)
        local nodeSize = gui.get_size(labelNode)
        local scale = math.min(nodeSize[shrinkAxis] * srcScl[shrinkAxis] / metrics[wh], srcScl[shrinkAxis])
        _setScale(scale, isAnimate)
        gui.set_text(labelNode, value)
    end
    return {set = set}
end
function ____exports.ShrinkText(labelNode, shrinkAxis, isAnimate)
    if isAnimate == nil then
        isAnimate = true
    end
    return _createShrinkText(labelNode, shrinkAxis, isAnimate)
end
return ____exports
