--[[ Perma Refresh ]]
function onLoad(_)
    Wait.time(refresh, 1, -1)
end

function refresh()
    self.setValue(Global.call('getRound'))
end


--[[ Upgrade ]]
url = 'https://raw.githubusercontent.com/H-Hawk/TTS-Scripts/main/SkullKing/RoundCounter.lua'

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