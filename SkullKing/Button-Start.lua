function onLoad(save_state)
    self.createButton({
        click_function = "setUp",
        width = 2900,
        height = 950
    })
end

function onScriptingButtonDown(index, color)
    if self.hasTag('enable') and index == 8 then
        Global.call('setUp')
    end
end


--[[ Upgrade ]]
url = 'https://raw.githubusercontent.com/H-Hawk/TTS-Scripts/main/SkullKing/Button-Start.lua'

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
