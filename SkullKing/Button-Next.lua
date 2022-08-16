function onLoad(save_state)
    self.createButton({
        click_function = 'nextRound',
        width = 2900,
        height = 950
    })
end

function onScriptingButtonDown(index, color)
    if self.hasTag('enable') and index = 3 then
        Global.call('nextRound')
    end
end


--[[ Upgrade ]]
url = 'https://raw.githubusercontent.com/H-Hawk/TTS-Scripts/main/SkullKing/Button-Next.lua'

function upgradeCallback(req)
    if req.is_error then
        log(req.error)
    else
        self.script_code = req.text
    end
end

function upgrade()
    WebRequest.get(url, upgradeCallback)
end
