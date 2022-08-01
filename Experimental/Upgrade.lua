url = 'https://raw.githubusercontent.com/H-Hawk/TTS-Scripts/main/AoE-v2/aoe-counter.lua'

tmp = -1

function upgradeCallback(request)
	if request.is_error then
        log(request.error)
    else
        print('Test: Callback returned Succesfully')
        local state = self.script_state
        self.script_code = request.text
        onLoad(state)
    end
end

function upgrade()
    WebRequest.get(url, upgradeCallback)
end

function onScriptingButtonDown(index, player)
    if index == 10 then
        upgrade()
    else
        print('Changing to '..index)
        tmp = index
    end
end

function bundleVars()
    local state = {
        ['Tmp']=tmp,
    }

    return state
end

function onSave()
    return JSON.encode(bundleVars())
end

function onLoad(loadString)
    print(loadString)
    
    local state = JSON.decode(loadString)
    
    tmp = state['Tmp']
end