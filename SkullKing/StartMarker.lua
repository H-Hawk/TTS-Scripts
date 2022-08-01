playerPositions = {}

currentPosition = 0

order = { 
	{}, 
	{}, 
	{'Brown', 'Red', 'Green'}, 
	{'Brown', 'Red', 'Green', 'Teal'}, 
	{'White', 'Brown', 'Red', 'Green', 'Teal'},
	{'White', 'Brown', 'Red', 'Green', 'Teal', 'Blue'}
}


--[[ Setup Setter]]
function addPlayerPosition()
	if #playerPositions >= 6 then
		print('Error all player positions already set')
		return
	end

	playerPositions[order[6][#playerPositions+1]] = self.getPosition()
end

function resetPlayerPositions()
	playerPositions = {}
end


--[[ Used in Play ]]
function updatePos(numOfPlayer)
	self.setPosition(playerPositions[numOfPlayer][currentPosition])
end

function goToPlayer(round, numOfPlayer)
	currentPosition = ( (round - 1) % numOfPlayer ) + 1
	updatePos(numOfPlayer)
end


--[[ Debugging ]]
function dumpVars()
	print(JSON.encode(bundleVars()))
end


--[[ Data Persistence ]]
function bundleVars()
	local vars = {
		['playerPositions'] = playerPositions,
	}

	return vars
end

function onSave()
	return JSON.encode(bundleVars())
end

function onLoad(stateString)
	if stateString:len() == 0 then 
		print('Point Counter '..self.guid..' not setup.')
	else

  	local state = JSON.decode(stateString)

  	playerPositions = state['playerPositions']

	Global.registerStartMarker(self)
end


--[[ Upgrade ]]
url = 'https://raw.githubusercontent.com/H-Hawk/TTS-Scripts/main/SkullKing/StartMarker.lua'

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

