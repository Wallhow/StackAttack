/* eslint-disable @typescript-eslint/ban-types */
/* eslint-disable @typescript-eslint/no-extra-non-null-assertion */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-non-null-assertion */
/* eslint-disable @typescript-eslint/no-unsafe-return */
import { _newTweensForNode } from "./TweenGUI";

export function tween(obj: string | node | hash) {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-return
    return _newTweensForNode(obj);
}


