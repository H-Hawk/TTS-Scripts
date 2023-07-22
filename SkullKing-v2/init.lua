tag_func = require("utils.tag_function")
require("utils.vector_utils")


local resting_positions = {}
local playing_bet = {}
local starting_marker = {}


addHotkey("Set Resting Positions", function ()
    for _, obj in pairs(getObjectsWithTag("bid")) do
        resting_positions[obj.getGUID()] = obj.getPosition():round(2)
    end

    print(JSON.encode(resting_positions))
end, false)

addHotkey("Set Action Positions", function ()
    for _, obj in pairs(getObjectsWithTag("bid")) do
        local color = tag_func.get_value(obj, "Player", nil)
        if color ~= nil then
            if obj.hasTag("value 0")then
                playing_bet[color] = obj.getPosition():round(2)
            end
            if obj.hasTag("value 1") then
                starting_marker[color] = obj.getPosition():round(2)
            end
        end
    end

    print(JSON.encode(playing_bet))
    print(JSON.encode(starting_marker))
end, false)


function onSave()
    local tmp = {
        resting_positions = resting_positions,
        starting_marker = starting_marker,
        playing_bet = playing_bet
    }

    return JSON.encode(tmp)
end