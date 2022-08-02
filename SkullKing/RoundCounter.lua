--[[ Perma Refresh ]]
function onLoad()
  startLuaCoroutine(self, "check_counter")
end

function check_counter()
    while true do
        self.setValue(Global.getRound())
        wait(0.75)
    end
    return 1
end

function wait(time)
  local start = os.time()
  repeat coroutine.yield(0) until os.time() > start + time
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