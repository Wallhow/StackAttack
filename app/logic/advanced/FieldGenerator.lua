local ____exports = {}
local id_card_map
local ____array = require("utils.array")
local array = ____array.array
local ____card = require("logic.card")
local DcNums = ____card.DcNums
local DcMast = ____card.DcMast
function ____exports.get_card_id(card)
    return id_card_map[card]
end
function ____exports.FieldGenerator(sm)
    local max_card_v1 = 7
    local max_card_v2 = 6
    local function gen()
        do
            local j = 0
            while j < 8 do
                local card_count = j < 4 and max_card_v1 or max_card_v2
                do
                    local i = 0
                    while i < card_count do
                        local id_card = sm.stopka:take_card()
                        sm:open_card(id_card, true)
                        sm:add_to_stack(j, id_card)
                        i = i + 1
                    end
                end
                j = j + 1
            end
        end
    end
    local function generate_tutorial(step)
        local remove_cards_in_stopka_for_use, fill_field, add_card_to_stack
        function remove_cards_in_stopka_for_use(cards_for_uses)
            for ____, card_id in ipairs(cards_for_uses) do
                sm.stopka:take_card_id(____exports.get_card_id(card_id))
            end
        end
        function fill_field(count_in_stacks)
            do
                local j = 0
                while j < 8 do
                    local card_count = count_in_stacks[j + 1]
                    do
                        local i = 0
                        while i < card_count do
                            local id_card = array.random_element(sm:get_game_state().stopka)
                            sm:get_game_state().stopka:splice(
                                sm:get_game_state().stopka:indexOf(id_card),
                                1
                            )
                            sm:open_card(id_card, true)
                            sm:add_to_stack(j, id_card)
                            i = i + 1
                        end
                    end
                    j = j + 1
                end
            end
        end
        function add_card_to_stack(idx_stack, name_cards)
            for ____, name_card in ipairs(name_cards) do
                sm:open_card(
                    ____exports.get_card_id(name_card),
                    true
                )
                sm:add_to_stack(
                    idx_stack,
                    ____exports.get_card_id(name_card)
                )
            end
        end
        if step == 1 then
            remove_cards_in_stopka_for_use({"p6", "b5"})
            local count_cards_in_stacks = {
                7,
                7,
                7,
                7,
                6,
                6,
                5,
                5
            }
            fill_field(count_cards_in_stacks)
            add_card_to_stack(6, {"b5"})
            add_card_to_stack(7, {"p6"})
        elseif step == 2 then
            remove_cards_in_stopka_for_use({
                "bt",
                "p9",
                "b8",
                "p7",
                "b6",
                "p5",
                "b4",
                "p3",
                "b2"
            })
            local count_cards_in_stacks = {
                7,
                7,
                7,
                7,
                6,
                5,
                2,
                2
            }
            fill_field(count_cards_in_stacks)
            add_card_to_stack(5, {"p9"})
            add_card_to_stack(6, {"bt", "b8", "p3", "b2"})
            add_card_to_stack(7, {"p7", "b6", "p5", "b4"})
        end
    end
    return {generate = gen, generate_tutorial = generate_tutorial}
end
id_card_map = {}
function ____exports.make_card_list()
    local list = {}
    do
        local n = 0
        while n < #DcNums do
            do
                local m = 0
                while m < #DcMast do
                    local card = {mast = DcMast[m + 1], nom = DcNums[n + 1]}
                    list[#list + 1] = card
                    id_card_map[card.mast .. card.nom] = #list - 1
                    m = m + 1
                end
            end
            n = n + 1
        end
    end
    return list
end
return ____exports
