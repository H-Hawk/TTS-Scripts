function onLoad(save_state)
    self.createButton({
        click_function = 'flipBids',
        width = 2900,
        height = 950
    })
end

function onScriptingButtonDown(index, color)
    if self.hasTag('enable') and index == 1 then
        Global.call('flipBids')
    end
end


--[[ Upgrade ]]
url = 'https://raw.githubusercontent.com/H-Hawk/TTS-Scripts/main/SkullKing/Button-Flip.lua'

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
