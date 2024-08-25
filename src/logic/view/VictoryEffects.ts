import { GoManager } from "../../modules/GoManager";
import { array } from "../../utils/array";
import { repeat } from "../../utils/utils";
import * as flow from 'ludobits.m.flow';

export function VictoryEffects(go_cards: hash[], gm: ReturnType<typeof GoManager>) {

    function do_effect_1() {
        const dir: { x: number, y: number }[] = [];

        const speed: number[] = [];

        repeat(go_cards.length, () => {
            dir.push({ x: random_sign() * math.random(), y: random_sign() * math.random() });


            speed.push(math.random(5, 10));
        });
        let acc_r = 0;
        timer.delay(0.016, true, () => {
            for (const i of array.indexes(go_cards)) {
                const g = go_cards[i];
                const pos = go.get_position(g);
                pos.x += dir[i].x * speed[i];
                pos.y += dir[i].y * speed[i];
                go.set_position(pos, g);
                go.set_rotation(vmath.quat_rotation_z(acc_r), g);
                acc_r += speed[i];
            }
        });
    }

   

    function do_effect_3() {
        const ltrb = Camera.get_ltrb();

        for (const i of array.indexes(go_cards)) {
            const g = go_cards[go_cards.length - 3 - i];
            if (g != undefined) {
                gm.do_move_anim_hash(g, vmath.vector3(ltrb.z * 0.5, -math.abs(ltrb.w) - 100, 0), 1);
                flow.delay(0.05);
            }
        }
    }

    //Хаотичный разлет карт с эмуляцией физики и отскока от пола
    function do_effect_2(home: number[]) {
        const dir: { x: number, y: number }[] = [];
        const vel: { x: number, y: number }[] = [];
        const speed: number[] = [];
        const ltrb = Camera.get_ltrb();

        const go_list: hash[] = [];
        const start_time: number[] = [];
        let max_time = 0;
        let counter = 0;
        for (const i of array.indexes(home)) {
            const card = home[(home.length - 1) - i];

            const xx = random_sign() * math.random();
            const _speed = math.random(5, 10);

            const id = card;
            go_list.push(go_cards[id]);
            dir.push({ x: xx, y: 1 });
            vel.push({ x: 0, y: 0 });
            speed.push(_speed);

            counter += 1 * 2;
            start_time.push(counter);
            if (max_time < counter)
                max_time = counter;

        }

        let acc_r = 0;
        timer.delay(0.016, true, () => {
            for (const j of array.indexes(go_list)) {
                const g = go_list[j];
                if (start_time[j] <= acc_r || acc_r > max_time) {

                    const pos = go.get_position(g);

                    vel[j].x = dir[j].x * speed[j];
                    vel[j].y -= 1;

                    pos.x += vel[j].x;
                    pos.y += vel[j].y;
                    go.set_position(pos, g);

                    if (pos.y < ltrb.w || pos.y > ltrb.y)
                        vel[j].y = vel[j].y * -1;

                    if (pos.x < ltrb.x || pos.x > ltrb.z)
                        dir[j].x *= -1;
                }
            }

            acc_r += 1;
        });
    }
    //Змейка
    function do_effect_4(home: number[]) {
        const dir: { x: number, y: number }[] = [];
        const vel: { x: number, y: number }[] = [];
        const speed: number[] = [];
        const ltrb = Camera.get_ltrb();

        const go_list: hash[] = [];
        const start_time: number[] = [];
        let max_time = 0;
        let counter = 0;
        const xx = -1 * math.random();
        const _speed = math.random(5, 10);
        for (const i of array.indexes(home)) {
            const card = home[(home.length - 1) - i];
            const id = card;
            go_list.push(go_cards[id]);
            dir.push({ x: xx, y: 1 });
            vel.push({ x: 0, y: 0 });
            speed.push(_speed);

            counter += 1 * 2;
            start_time.push(counter);
            if (max_time < counter)
                max_time = counter;

        }

        let acc_r = 0;
        timer.delay(0.016, true, () => {
            for (const j of array.indexes(go_list)) {
                const g = go_list[j];
                if (start_time[j] <= acc_r || acc_r > max_time) {

                    const pos = go.get_position(g);

                    vel[j].x = dir[j].x * speed[j];
                    vel[j].y -= 1;

                    pos.x += vel[j].x;
                    pos.y += vel[j].y;
                    go.set_position(pos, g);

                    if (pos.y < ltrb.w || pos.y > ltrb.y)
                        vel[j].y = vel[j].y * -1;

                    if (pos.x < ltrb.x || pos.x > ltrb.z)
                        dir[j].x *= -1;
                }
            }

            acc_r += 1;
        });
    }


    function random_sign() {
        return math.random() > 0.5 ? 1 : -1;
    }

    return {
        do_effect_1, do_effect_2, do_effect_3, do_effect_4
    };
}