local tag_func = require("utils.tag_function")

local skull_king = {
    resting_places = {
        ["01fc34"] = {x=-32.27,y=1.65,z=-41.83},
        ["0a509a"] = {x=22.71,y=1.65,z=-39.44},
        ["0b59cd"] = {x=5.98,y=1.65,z=41.83},
        ["0e0497"] = {x=-20.32,y=1.65,z=41.83},
        ["0efff0"] = {x=-20.32,y=1.65,z=44.22},
        ["14a131"] = {x=-27.49,y=1.65,z=-41.83},
        ["1819b2"] = {x=-32.27,y=1.65,z=-39.44},
        ["185089"] = {x=-25.1,y=1.65,z=-39.44},
        ["190bf4"] = {x=-1.19,y=1.65,z=-39.44},
        ["1c4f04"] = {x=-29.88,y=1.65,z=-41.83},
        ["1c5435"] = {x=-22.71,y=1.65,z=44.22},
        ["203a34"] = {x=1.19,y=1.65,z=39.44},
        ["238504"] = {x=20.32,y=1.65,z=-41.83},
        ["26e82b"] = {x=-5.98,y=1.65,z=-39.44},
        ["2b274c"] = {x=-3.59,y=1.65,z=-41.83},
        ["2e6d2d"] = {x=-17.93,y=1.65,z=41.83},
        ["3208e6"] = {x=29.88,y=1.65,z=39.44},
        ["326845"] = {x=17.93,y=1.65,z=-44.22},
        ["335881"] = {x=3.59,y=1.65,z=39.44},
        ["34a305"] = {x=-5.98,y=1.65,z=-44.22},
        ["3665ad"] = {x=-17.93,y=1.65,z=39.44},
        ["3680cd"] = {x=-3.59,y=1.65,z=-39.44},
        ["38964c"] = {x=5.98,y=1.65,z=39.44},
        ["3b3476"] = {x=-1.19,y=1.65,z=41.83},
        ["43f6fd"] = {x=25.09,y=1.65,z=39.44},
        ["48daef"] = {x=20.32,y=1.65,z=-44.22},
        ["492800"] = {x=5.98,y=1.65,z=44.22},
        ["4a60fc"] = {x=-5.98,y=1.65,z=-41.83},
        ["4fada0"] = {x=25.09,y=1.65,z=44.22},
        ["5769a8"] = {x=17.93,y=1.65,z=-41.83},
        ["578ce2"] = {x=15.54,y=1.65,z=-44.22},
        ["58f0c2"] = {x=1.2,y=1.65,z=41.83},
        ["5d7db0"] = {x=17.92,y=1.65,z=-39.44},
        ["5e8b1a"] = {x=29.88,y=1.65,z=44.22},
        ["5eb6ff"] = {x=-27.49,y=1.65,z=-44.22},
        ["60325e"] = {x=-32.27,y=1.65,z=-44.22},
        ["628b9c"] = {x=1.2,y=1.65,z=44.22},
        ["63c16d"] = {x=-27.49,y=1.65,z=-39.44},
        ["70842a"] = {x=25.09,y=1.65,z=41.83},
        ["719e6d"] = {x=-22.71,y=1.65,z=41.83},
        ["7bb523"] = {x=-22.71,y=1.65,z=39.44},
        ["86ef6d"] = {x=-1.19,y=1.65,z=-41.83},
        ["93e7ca"] = {x=-8.37,y=1.65,z=-44.22},
        ["97b4b2"] = {x=20.32,y=1.65,z=-39.44},
        ["98fec1"] = {x=-3.59,y=1.65,z=-44.22},
        ["9da447"] = {x=-25.1,y=1.65,z=41.83},
        ["a658e1"] = {x=-20.31,y=1.65,z=39.43},
        ["aa42e4"] = {x=-17.93,y=1.65,z=44.22},
        ["ab5f4d"] = {x=-8.37,y=1.65,z=-39.44},
        ["b25d98"] = {x=-25.1,y=1.65,z=-41.83},
        ["b90445"] = {x=22.7,y=1.65,z=39.44},
        ["c5f73e"] = {x=15.54,y=1.65,z=-41.83},
        ["cca913"] = {x=-1.19,y=1.65,z=39.44},
        ["d0d48d"] = {x=29.88,y=1.65,z=41.83},
        ["d10aa8"] = {x=27.49,y=1.65,z=44.22},
        ["d5d2e5"] = {x=-29.88,y=1.65,z=-44.22},
        ["d6461c"] = {x=27.49,y=1.65,z=41.83},
        ["d707a3"] = {x=15.54,y=1.65,z=-39.44},
        ["d7be41"] = {x=-8.37,y=1.65,z=-41.83},
        ["f20f17"] = {x=-29.88,y=1.65,z=-39.44},
        ["f428b5"] = {x=-25.1,y=1.65,z=39.44},
        ["f625fd"] = {x=3.59,y=1.65,z=44.22},
        ["f88423"] = {x=3.59,y=1.65,z=41.83},
        ["fd2c06"] = {x=27.48,y=1.65,z=39.44},
        ["fd756c"] = {x=22.7,y=1.65,z=-41.83},
        ["fe5a08"] = {x=22.71,y=1.65,z=41.83}
    },
    action_places = {
        starting_marker = {
            Blue = {x=27.48,y=1.65,z=39.44},
            Brown = {x=-5.98,y=1.65,z=-39.44},
            Green = {x=-20.31,y=1.65,z=39.43},
            Red = {x=-29.88,y=1.65,z=-39.44},
            Teal = {x=3.59,y=1.65,z=39.44},
            White = {x=17.92,y=1.65,z=-39.44}
        },
        playing_bet = {
            Blue = {x=29.88,y=1.65,z=39.44},
            Brown = {x=-8.37,y=1.65,z=-39.44},
            Green = {x=-17.93,y=1.65,z=39.44},
            Red = {x=-32.27,y=1.65,z=-39.44},
            Teal = {x=5.98,y=1.65,z=39.44},
            White = {x=15.54,y=1.65,z=-39.44}
        }
    },
    starting_marker = "c2ea6f",
    deck_pos = {-45.00, 2.02, -3.00},
    deck_rot = {0, 180, 180},
    seating_order = {
        "Brown",
        "Red",
        "Green",
        "Teal",
        "White",
        "Blue"
    }
}




local state = {
    number_of_players = 0,
    round = 0,
    phase = 0,
    number_of_placed_bets = 0,
    placed_bets = {}
}


function flip_played_bids()
    if state.phase == 2 then
        for _, bid_guid in pairs(state.placed_bets) do
            getObjectFromGUID(bid_guid).flip()
        end
    end
end

function continue_to_play_phase() 
    if state.number_of_placed_bets == state.number_of_players then
        state.phase = 2
        flip_played_bids()
    end
end


function deal_next_round(deck)
    state.round = state.round + 1
    state.phase = 1

    startMarker.call('goToPlayer', round)

    deck.shuffle()
    deck.deal(round)
end

function reset_deck(continue)
    local cards = getObjectsWithTag('card')
    local deck = group(cards)

    local allResting = true
    for _, v in pairs(cards) do
        allResting = allResting and v.resting
    end

    if not allResting then
        local callBack = function()
            resetDeck(continue)
        end

        Wait.time(callBack, 2)
        return
    end

    deck = deck[1]

    deck.setPosition(skull_king.deck_pos)
    deck.setRotation(skull_king.deck_rot)

    continue(deck)
end

function next_round()
    -- Returning Bids to their Players
    for _, bid_guid in pairs(state.placed_bets) do
        getObjectFromGUID(bid_guid).setPosition(skull_king.resting_places[bid_guid])
    end

    -- Collecting Cards
    local continue = function(deck) print('DeadBeef') end

    if state.round < 10 then 
        continue = deal_next_round
    else
        continue = function(deck)
            print('The Game only has 10 Rounds')
        end
    end

    resetDeck(continue)
end

function onObjectPickUp(player_color, picked_up_object)
    if picked_up_object.hasTag("bid") then
        local owner_color = tag_func.get_value(picked_up_object, "player", nil)
        if owner_color ~= nil and player_color == owner_color and state.placed_bets[owner_color] ~= nil then
            state.placed_bets[owner_color] = picked_up_object.getGUID()
            state.number_of_placed_bets = state.number_of_placed_bets + 1
            picked_up_object.setPosition(skull_king.action_places[owner_color])
        end
    end
end

function onLoad(load_string) 
    state = JSON.decode(load_string)
end

function onSave()
    return JSON.encode(state)
end


