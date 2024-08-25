import { tween } from "../../../defoldTweens/Tween";

export type ShrinkText = ReturnType<typeof _createShrinkText>;
export function ShrinkText(labelNode: node, shrinkAxis: 'x' | 'y', isAnimate = true): ShrinkText {
    return _createShrinkText(labelNode, shrinkAxis, isAnimate);
}


function _createShrinkText(labelNode: node, shrinkAxis: 'x' | 'y', isAnimate = true) {
    const srcScl = gui.get_scale(labelNode);
    const wh = shrinkAxis === 'x' ? 'width' : 'height';
    const font = gui.get_font_resource(gui.get_font(labelNode));
    const line_break = gui.get_line_break(labelNode);

    function set(value: string) {
        const metrics = getFontMetrics(value);

        const nodeSize = gui.get_size(labelNode);
        const scale = Math.min((nodeSize[shrinkAxis] * srcScl[shrinkAxis]) / metrics[wh], srcScl[shrinkAxis]);

        _setScale(scale, isAnimate);

        gui.set_text(labelNode, value);
    }

    function _setScale(scale: number, isAnimate: boolean) {
        if (isAnimate)
            tween(labelNode).to(0.2, 'scale', { scale: vmath.vector3(scale, scale, 0) }, { easing: 'EASING_OUTSINE' }).start();
        else
            gui.set_scale(labelNode, vmath.vector3(scale, scale, 1));
    }

    function getFontMetrics(value: string) {
        return resource.get_text_metrics(font, value,
            {
                width: gui.get_size(labelNode).x,
                height: gui.get_size(labelNode).y,
                line_break

            }) as { width: number, height: number, max_ascent: number, max_descent: number };

    }


    return {
        set,
    };
}