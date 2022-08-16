--[[ Helper ]]
function len(t)
    local out = 0
    for _, _ in pairs(t) do out = out + 1 end
    return out
end


--[[ Const ]]
playSurface = '9a3403'
deckPos = {-45.00, 2.02, -3.00}
deckRot = {0, 180, 180}
seatingOrder = {
    'Brown',
    'Red',
    'Green',
    'Teal',
    'White',
    'Blue'
}


--[[ OnLoad registered Object References ]]
startMarker = {}
pointCounter = {}
bids = {}

--[[ Registering Functions ]]
function registerStartMarker(objRef)
    startMarker = objRef
end

function registerPointCounter(param)
    if param.color == 'Grey' then return end
    
    pointCounter[param.color] = param.objRef
end

function registerBid(param)
    if param.color == 'Grey' then return end

    if not bids[param.color] then 
        bids[param.color] = {}
    end

    table.insert(bids[param.color], param.objRef)
end


--[[ Runtime Vars ]]
activePlayer = {}
numOfPlayer = 0
round = 0
playedBids = {}


--[[ Getter ]]
function getRound()
    return round
end

function getBidDeadzone()
    return 15
end

--[[ SetUp ]]
function shuffle(toShuffel)
    local len, random = #toShuffel, math.random
    for i = len, 2, -1 do
        local j = random( 1, i )
        toShuffel[i], toShuffel[j] = toShuffel[j], toShuffel[i]
    end
    return toShuffel;
end

function seatPlayersRandomly()
    local players = Player.getPlayers()

    local len = len(players)

    if len > 6 then 
        print('Error: Too many Player')
        return
    end

    numOfPlayer = len

    shuffle(players)

    for i, v in ipairs(players) do 
        Player[seatingOrder[i]].changeColor('Grey')
        v.changeColor(seatingOrder[i])
        table.insert(activePlayer, seatingOrder[i])
    end
end

function setUp()
    activePlayer = {}
    seatPlayersRandomly()

    startMarker.call('setNumOfPlayer', numOfPlayer)

    -- Reseting all Bid Token
    for _, pb in pairs(bids) do
        for _, b in pairs(pb) do
            b.call('returnHome')
        end
    end

    -- Reseting all Point Counter
    for _, c in pairs(pointCounter) do
        c.call('reset')
    end

    -- Reseting the Round and Startmarker
    round = 0
    resetDeck(dealNextRound)
end


--[[ Flipping Bids ]]
function getPlayedBids()
    output = {}
    for _, p in pairs(activePlayer) do
        for _, b in pairs(bids[p]) do
            if b.call('isPlayed') then 
                table.insert(output, b)
                break
            end
        end
    end 
    return output
end

-- WIP
function checkBids()
    return true
end

-- WIP
function rejectBids()
    print('WIP')
end

function flipBids()
    local bids = getPlayedBids()
    local lenBids = len(bids)
    
    if not checkBids() then 
        rejectBids()
        return 
    end


    if not (numOfPlayer == lenBids) then
        local msg = 'Error: Mismatch between Number of found Bids('..lenBids..') and Seated Players('..numOfPlayer..')'
        broadcastToAll(msg, {r=1, g=0, b=0})
        
        return
    end

    playedBids = bids
    for _, v in pairs(bids) do
        v.flip()
    end

    startMarker.call('reveal')
end


--[[ Next Round ]]
function returnPlayedBids()
    for _, v in pairs(playedBids) do
        v.call('returnHome')
    end
end

function resetDeck(continue)
    local cards = getObjectsWithTag('Card')
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

        local msg = 'Couldnt retrieve all Cards. Please wait a secound.'
        broadcastToAll(msg, {r=1, g=1, b=1})
        
        return 
    end

    deck = deck[1]

    deck.setPosition(deckPos)
    deck.setRotation(deckRot)

    continue(deck)
end

function dealNextRound(deck)
    round = round + 1

    startMarker.call('goToPlayer', round)

    deck.shuffle()
    deck.deal(round)
end

function nextRound()
    returnPlayedBids()

    local continue = function(deck) print('DeadBeef') end

    if round < 10 then 
        continue = dealNextRound
    else
        continue = function(deck)
            print('The Game only has 10 Rounds')
        end
    end

    resetDeck(continue)
end


--[[ Loading Functions ]]
function freezeObj(toFreeze)
    for i = 1, len(toFreeze), 1 do
        obj = getObjectFromGUID(toFreeze[i])
        if obj ~= nil then
            obj.interactable = false
            obj.tooltip = false
        end
    end
end

function onLoad()
    freezeObj({playSurface})
end


--[[ Debugging ]]
function dumpVars()
    print('ping')
    bidsGuid = {}

    for c, pb in pairs(bids) do
        bidsGuid[c] = {}
        for _, b in pairs(pb) do
            table.insert(bidsGuid[c], b.guid) 
        end
    end

    print(JSON.encode_pretty(bidsGuid))
end