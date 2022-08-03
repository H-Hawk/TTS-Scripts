--[[ Helper ]]
function len(t)
	local out = 0
	for _, _ in pairs(t) do out = out + 1 end
	return out
end


--[[ Const ]]
order = { 
	{}, 
	{}, 
	{'Brown', 'Red', 'Green'}, 
	{'Brown', 'Red', 'Green', 'Teal'}, 
	{'White', 'Brown', 'Red', 'Green', 'Teal'},
	{'White', 'Brown', 'Red', 'Green', 'Teal', 'Blue'}
}


--[[ Setup Const ]]
playerPositions = {}


--[[ Setup Setter]]
function addPlayerPosition()
	print('Adding Position to Startmarker') 

	local len = len(playerPositions)

	if len >= 6 then
		print('Error: all player positions already set')
		return
	end

	playerPositions[order[6][len+1]] = self.getPosition()
	print('Ending Succesful')
end

function resetPlayerPositions()
	print('Reseting the player positions')
	playerPositions = {}
end


--[[ Used in Play ]]
function updatePos(numOfPlayer)
	self.setPosition(playerPositions[numOfPlayer][currentPosition])
end

function goToPlayer(param)
	currentPosition = ( (param.round - 1) % param.numOfPlayer ) + 1
	updatePos(param.numOfPlayer)
end


--[[ Debugging ]]
function dumpVars()
	print(JSON.encode(bundleVars()))
end


--[[ Data Persistence ]]
function bundleVars()
	local vars = {
		playerPositions = playerPositions
	}

	return vars
end

function onSave()
	return JSON.encode(bundleVars())
end

function onLoad(stateString)
	if stateString:len() == 0 then 
		print('Start Marker '..self.guid..' not setup.')
	else
  		local state = JSON.decode(stateString)
  		playerPositions = state.playerPositions

		Global.call('registerStartMarker', self)
	end
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

