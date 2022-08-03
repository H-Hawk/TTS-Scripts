owner = 'Grey'


--[[ Setup Setters]]
function setOwner(color)
	owner = color
end


--[[ Used in Play ]]
function reset()
	self.setValue(0)
end


--[[ Debugging ]]
function dumpVars()
	print(JSON.encode(bundleVars()))
end


--[[ Data Persistence ]]
function bundleVars()
	local vars = {
		['owner'] = owner,
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

  	owner = state['owner']

	Global.call('registerPointCounter', {color=owner, objRef=self})
end


--[[ Upgrade ]]
url = 'https://raw.githubusercontent.com/H-Hawk/TTS-Scripts/main/SkullKing/PointCounter.lua'

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