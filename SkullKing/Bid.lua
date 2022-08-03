--[[ Helpers ]]
function round(toRound, decParam)
	local dec = decParam or 0

	local shiftingPow = math.pow(10, dec)

	return math.floor( (toRound*shiftingPow) + 0.5 ) / shiftingPow
end

function roundVec(toRound, dec)
	local out = {}
	
	for i, v in pairs(toRound) do
		out[i] = round(v, dec)
	end

	return out
end

--[[ Setup Const ]]
owner = 'Grey'
value = -1

home = {}


--[[ Setup Setters]]
function setOwner(color)
	owner = color
end

function setValue(number)
	value = number
end

function setHome()
	home.position = roundVec(self.getPosition(), 2)
	home.rotation = roundVec(self.getRotation())
end


--[[ Used in Play ]]
function returnHome()
	self.setPosition(home.position)
	self.setRotation(home.rotation)
end 


--[[ Debugging ]]
function dumpVars()
	print(JSON.encode(bundleVars()))
end


--[[ Data Persistence ]]
function bundleVars()
	local vars = {
		owner = owner,
		value = value,
		home = home
	}

	return vars
end

function onSave()
	return JSON.encode(bundleVars())
end

function onLoad(stateString)
	if stateString:len() == 0 then 
		print('Bidtoken '..self.guid..' not setup.')
	else
		local state = JSON.decode(stateString)
	
		owner = state.owner
		value = state.value 
		home =  state.home
	
		Global.call('registerBid', {color=owner, objRef=self})
	end
end


--[[ Upgrade ]]
url = 'https://raw.githubusercontent.com/H-Hawk/TTS-Scripts/main/SkullKing/Bid.lua'

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

