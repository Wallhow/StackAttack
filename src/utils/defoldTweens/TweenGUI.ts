/* eslint-disable @typescript-eslint/no-for-in-array */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-extra-non-null-assertion */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-non-null-assertion */
/* eslint-disable @typescript-eslint/no-unsafe-return */
import { ANIMATION_DATA, ANIMATION_EASINGS, ANIMATION_PLAYBACKS, GUI_NODE } from "./CommonTypes";
import * as flow from 'ludobits.m.flow';
//TODO : заменить rotation на euler
type MainGUIPropsSchema = {
    position: { position: vmath.vector3 },
    rotation: { rotation: vmath.vector3 },
    scale: { scale: vmath.vector3 },
    color: { color: vmath.vector4 },
    size: { size: vmath.vector3 },
    //TODO: 
    //outline: {},
    //fill_angle: {},
    //inner_radius: {},
    //slice9: {}
};

type ExtensionGUIPropsSchema = {
    'position.x': { x: number }, 'position.y': { y: number }, 'position.z': { z: number },
    'scale.x': { x: number }, 'scale.y': { y: number }, 'scale.z': { z: number },
    'size.x': { x: number }, 'size.y': { y: number }, 'size.z': { z: number },
    'rotation.x': { x: number }, 'rotation.y': { y: number }, 'rotation.z': { z: number },
    'color.x': { x: number }, 'color.y': { y: number }, 'color.z': { z: number }, 'color.w': { w: number }
};

type GUIPropsSchema = MainGUIPropsSchema & ExtensionGUIPropsSchema;

export type GUIPropsAnimation = keyof GUIPropsSchema;
export type GUIValuesPropsAnimations<T extends GUIPropsAnimation> = GUIPropsSchema[T];

export type GUIOtherOptions = {
    easing?: ANIMATION_EASINGS;
    playback?: ANIMATION_PLAYBACKS;
    delay?: number,
    compliteFunc?: (() => void) | null
};
const _defaultGUIOpationsMap: Required<{ [k in keyof GUIOtherOptions]: GUIOtherOptions[k] }> = {
    easing: "EASING_LINEAR",
    playback: "PLAYBACK_ONCE_FORWARD",
    delay: 0,
    compliteFunc: null
};


type Target = { node: GUI_NODE, prop: GUIPropsAnimation, value: GUIValuesPropsAnimations<GUIPropsAnimation> };

type CallableTween = { key: 'CALLABLE', func: () => void };
type DelayTween = { key: 'DELAY', delay: number };
type ParallelsTween = { key: 'PARALLEL' };

type ByTween = { key: 'BY', getValueFun: () => number | vmath.vector3 | vmath.vector4 } & ANIMATION_DATA & Target;
type ToTween = { key: 'TO' } & ANIMATION_DATA & Target;

// ----------------------------------------------------------------
type GUITweenData = CallableTween | ByTween | ToTween | DelayTween | ParallelsTween;

export function _newTweensForNode(obj: GUI_NODE) {
    assert(flow != undefined, 'ludobits.m.flow is not defined, please add it to your project this library');

    const currentNode = typeof obj === 'string' ? gui.get_node(obj) : obj;
    const sequence: GUITweenData[] = [];
    let isParallelMode = false;

    function to<T extends GUIPropsAnimation>(duration: number, prop: T, value: GUIValuesPropsAnimations<T>, otherOpt?: GUIOtherOptions) {
        const { easing, playback, delay, compliteFunc } = _getOtherOpt(otherOpt);
        sequence.push({ key: 'TO', node: currentNode, prop, value: _getValue(prop, value) as vmath.vector3 | vmath.vector4, duration, delay, compliteFunc, playback, easing });
        return tweensForNode;
    }

    function by<T extends GUIPropsAnimation>(duration: number, prop: T, value: GUIValuesPropsAnimations<T>, otherOpt?: GUIOtherOptions) {
        const getValueFun = () => {
            const curPropValue = _getNodeProp(prop) as vmath.vector3 | number;
            const newValue = _getValue(prop, value);
            return curPropValue + newValue;
        };

        const { easing, playback, delay, compliteFunc } = _getOtherOpt(otherOpt);
        sequence.push({ key: 'BY', getValueFun, node: currentNode, prop, value: 0 as vmath.vector3, duration, delay, compliteFunc, playback, easing });
        return tweensForNode;
    }

    function call(func: () => void) {
        sequence.push({ key: 'CALLABLE', func });
        return tweensForNode;
    }

    function delay(duration: number) {
        sequence.push({ key: 'DELAY', delay: duration });
        return tweensForNode;
    }

    function parallel() {
        sequence.push({ key: 'PARALLEL' });
        return tweensForNode;
    }

    function opacityTo(duration: number, opacity: number, otherOpt?: GUIOtherOptions) {
        return to(duration, 'color.w', { w: opacity }, otherOpt);
    }
    function opacityBy(duration: number, opacity: number, otherOpt?: GUIOtherOptions) {
        return by(duration, 'color.w', { w: opacity }, otherOpt);
    }

    function moveBy(duration: number, positionBy: { x?: number, y?: number }, otherOpt?: GUIOtherOptions) {
        return by(duration, 'position', {
            position: vmath.vector3(
                positionBy.x != undefined ? positionBy.x : 0,
                positionBy.y != undefined ? positionBy.y : 0,
                0)
        }, otherOpt);
    }

    function moveTo(duration: number, positionTo: { x?: number, y?: number }, otherOpt?: GUIOtherOptions) {
        return to(duration, 'position', {
            position: vmath.vector3(
                positionTo.x != undefined ? positionTo.x : 0,
                positionTo.y != undefined ? positionTo.y : 0,
                0)
        }, otherOpt);
    }

    function scaleTo(duration: number, scaleBy: { x?: number, y?: number }, otherOpt?: GUIOtherOptions) {
        if (scaleBy.x == undefined || scaleBy.y == undefined) {
            if (scaleBy.x != undefined)
                return to(duration, 'scale.x', { x: scaleBy.x }, otherOpt);
            else
                return to(duration, 'scale.y', { y: scaleBy.y! }, otherOpt);
        } else {
            return to(duration, 'scale', {
                scale: vmath.vector3(
                    scaleBy.x != undefined ? scaleBy.x : 0,
                    scaleBy.y != undefined ? scaleBy.y : 0,
                    1)
            }, otherOpt);
        }
    }

    function start(isRemoveTweenOnEnd = true): Coroutine | undefined {
        if (sequence.length > 0) {
            const tweenFlow = flow.start(() => {
                sequence.reduce((acc, tween, tweenIdx) => {
                    if (tween.key == 'BY' || tween.key == 'TO')
                        runByOrToTween(tween, tweenIdx);

                    if (tween.key == 'CALLABLE')
                        tween.func();

                    if (tween.key == 'DELAY')
                        flow.delay(tween.delay);
                    if (tween.key == 'PARALLEL')
                        isParallelMode = true;

                    return acc;
                }, 0);

                if (isRemoveTweenOnEnd) sequence.splice(0, sequence.length);
                isParallelMode = false;
                flow.stop(tweenFlow);

            }, { parallel: true });

            return tweenFlow;
        }
    }

    function stop(descr: Coroutine) {
        flow.stop(descr);
    }

    /*  function _startTween(c: Coroutine, isRemoveTweenOnEnd: boolean) {
         sequence.reduce((acc, tween, tweenIdx) => {
             pprint(tweenIdx)
 
             if (tween.key == 'BY' || tween.key == 'TO')
                 runByOrToTween(tween, tweenIdx);
 
             if (tween.key == 'CALLABLE') {
                 tween.func();
                 pprint('call function');
                 flow.delay(0);
             }
 
             if (tween.key == 'DELAY')
                 flow.delay(tween.delay);
             if (tween.key == 'PARALLEL')
                 isParallelMode = true;
 
             return acc;
         }, 0);
 
         pprint('Stop Tween')
         flow.stop(c);
 
         if (isRemoveTweenOnEnd) sequence.splice(0, sequence.length);
         isParallelMode = false;
 
     } */

    function runByOrToTween(tween: ByTween | ToTween, tweenIdx: number) {
        const { duration, delay, node, prop, value, compliteFunc, playback, easing } = tween;
        const isNeedInstantSet = tweenIdx === 0 && delay == 0 && duration == 0;

        const val = _isBy(tween) ? tween.getValueFun() : value;

        if (!isNeedInstantSet) {
            if (isParallelMode) {
                const parallelCoroutine = flow.start(() => {
                    flow.gui_animate(node, prop, playback, val, easing, duration, delay);
                    flow.stop(parallelCoroutine);
                }, { parallel: true });
            }
            else
                flow.gui_animate(node, prop, playback, val, easing, duration, delay);
        }
        else
            _setNodeProp(tween.prop, val);

        if (compliteFunc != null)
            compliteFunc();
    }

    function _isBy(tween: GUITweenData): tween is ByTween { return tween.key == 'BY'; }

    function _getOtherOpt(otherOpt?: GUIOtherOptions): Required<GUIOtherOptions> {
        const easing = gui[_getGetGUIOtherOpt(otherOpt, 'easing')];
        const playback = gui[_getGetGUIOtherOpt(otherOpt, 'playback')];
        const delay = _getGetGUIOtherOpt(otherOpt, 'delay');
        const compliteFunc = _getGetGUIOtherOpt(otherOpt, 'compliteFunc');
        return {
            easing, playback, delay, compliteFunc
        };
    }

    function _getValue<T extends GUIPropsAnimation>(prop: T, value: GUIValuesPropsAnimations<T>): vmath.vector3 | number {
        const axis = _getAxis(prop);
        return axis != undefined ? (value as any)[axis] as number : (value as any)[prop] as vmath.vector3;
    }

    function _getAxis<T extends GUIPropsAnimation>(prop: T) {
        if (prop.includes('.')) {
            const axis = (string.sub(prop, prop.indexOf('.') + 2, prop.length));
            return axis;
        } else
            return undefined;
    }


    function _getClearProp<T extends GUIPropsAnimation>(prop: T) {
        const axis = _getAxis(prop);
        return axis != undefined ? prop.replace('.' + axis, '') : prop;
    }

    function _getNodeProp<T extends GUIPropsAnimation>(prop: T): GUIPropsSchema[T][keyof GUIPropsSchema[T]] {
        const prop_key = _getClearProp(prop);
        const axis = _getAxis(prop) != undefined ? _getAxis(prop)! : '';
        const key = ('get_' + prop_key) as keyof typeof gui;

        const callableFun = (gui[key]);
        const returnValue = callableFun(currentNode);
        return (prop.includes('.') ? returnValue[axis] : returnValue) as GUIPropsSchema[T][keyof GUIPropsSchema[T]];
    }

    function _setNodeProp<T extends GUIPropsAnimation>(prop: T, value: vmath.vector3 | number) {
        const prop_key = _getClearProp(prop);
        const axis = _getAxis(prop) != undefined ? _getAxis(prop)! : '';
        const key = ('set_' + prop_key) as keyof typeof gui;
        const setFunc = (gui[key]);

        if (axis != '') {
            const curPropValue = _getNodeProp(_getClearProp(prop) as GUIPropsAnimation) as vmath.vector3;
            const newValue = value;
            curPropValue[axis as keyof { x: number; y: number; z: number; }] = newValue as number;
            setFunc(currentNode, curPropValue);
        }
        else
            setFunc(currentNode, value);
    }

    function _getGetGUIOtherOpt<T extends GUIOtherOptions, Keys extends keyof GUIOtherOptions>(opt: T | undefined, key: Keys): Required<GUIOtherOptions>[Keys] {
        if (opt == null) return _defaultGUIOpationsMap[key];

        if ((opt as any)[key] === undefined)
            return _defaultGUIOpationsMap[key];
        else return (opt as any)[key]!!;
    }

    const tweensForNode = {
        to, by, opacityBy, opacityTo, moveBy, moveTo, call, delay, start, parallel, stop, scaleTo
    };

    return tweensForNode;
}



