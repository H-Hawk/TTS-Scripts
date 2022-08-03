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
round = 1
playedBids = {}


--[[ Getter ]]
function getRound()
	return round
end


--[[ SetUp ]]
function shuffle(toShuffel)
	local len, random = #toShuffel, math.random ;
	for i = len, 2, -1 do
		local j = random( 1, i );
		toShuffel[i], toShuffel[j] = tbl[j], toShuffel[i];
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
	seatPlayersRandomly()

	-- Reseting all Bid Token
	for _, p in pairs(bids) do
		for _, b in pairs(bids[p]) do
			b.returnHome()
		end
	end

	-- Reseting all Point Counter
	for _, c in pairs(pointCounter) do
		c.reset()
	end

	-- Resetin the Round and Startmarker
	round = 1
	startMarker.call('goToPlayer', {round=round, numOfPlayer=numOfPlayer})

	local deck = resetDeck()
	deck.shuffle()
	deck.deal(round)
end


--[[ Flipping Bids ]]
function getPlayedBids()
	output = {}
	for _, p in pairs(activePlayer) do
		for _, b in pairs(bids[p]) do
			if b.is_face_down then 
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
	if not checkBids() then 
		rejectBids()
		return 
	end

	local bids = getPlayedBids()
	local lenBids = len(bids)
	if not numOfPlayer == lenBids then
		print('Error: Mismatch between Number of found Bids'..lenBids..' and Seated Players('..numOfPlayer..')')
		return
	end

	playedBids = bids
	for _, v in pairs(bids) do
		v.flip()
	end
end


--[[ Next Round ]]
function returnPlayedBids()
	for _, v in pairs(playedBids) do
		v.returnHome()
	end
end

function resetDeck()
	local deck = group(getObjectsWithTag('Card'))
	local lenDeck = len(deck)
	if not lenDeck == 1 then 
		print('Error: Unable to reset Deck. Trying Again.')
		return resetDeck()
	else 
		deck = deck[1]
		deck.setPosition(deckPos)
		deck.setRotation(deckRot)

		return deck
	end
end

function nextRound()
	round = round + 1

	returnPlayedBids()

	startMarker.call('goToNextPlayer', {round=round, numOfPlayer=numOfPlayer})

	local deck = resetDeck()
	deck.shuffle()
	deck.deal(round)
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


--[[ Upgrade ]]
url = 'https://raw.githubusercontent.com/H-Hawk/TTS-Scripts/main/SkullKing/Global.lua'

function upgradeCallback(req)
	if req.is_error then
        log(req.error)
    else
        local state = self.script_state
        self.script_code = req.text
        onLoad(state)
    end
end

function upgrade()
    WebRequest.get(url, upgradeCallback)
end