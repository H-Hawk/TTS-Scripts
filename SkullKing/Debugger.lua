urlBid = 'https://raw.githubusercontent.com/H-Hawk/TTS-Scripts/main/SkullKing/Bid.lua'
urlPoint = 'https://raw.githubusercontent.com/H-Hawk/TTS-Scripts/main/SkullKing/PointCounter.lua'

--[[ Helper ]]
function len(t)
    local out = 0
    for _, _ in pairs(t) do out = out + 1 end
    return out
end


objToInit = {}

function writeObjs(req)
    if req.is_error then
        log(req.error)
    else
        for _, v in pairs(objToInit) do
            v.script_code = req.text
        end
    end
end

function initObj(player, url)
    objToInit = Player[player].getSelectedObjects()
    WebRequest.get(url, writeObjs)
end

function callFuncForAllSelected(player, func, param)
    for _, v in pairs(Player[player].getSelectedObjects()) do
        v.call(func, param)
    end
end

function callFuncForHovered(player, func, param)
    local obj = Player[player].getHoverObject()
    print(obj.guid)
    obj.call(func, param)
end

function upgradeAll()
    for _, obj in pairs(getObjects()) do 
        if obj.script_code:len() > 10 then
            obj.call('upgrade')
        end
    end
    broadcastToAll('Remember to upgrade the Global script manually, as its not automatically upgraded', {r=1, g=0, b=0})
end

subMenu = {}
subMenu['main'] = {}
--subMenu['main'][1] = function(player) callFuncForAllSelected(player, 'upgrade') end
subMenu['main'][4] = function(player) currentMenu = 'setup' print('Entered Setup Mode') end
subMenu['main'][5] = function(player) print('dd') Global.call('dumpVars') end
subMenu['main'][6] = function(player) print(JSON.encode_pretty(Player[player].getHoverObject().getPosition())) end
subMenu['main'][8] = function(player) currentMenu = 'upgrade' print('Entered Upgrade Mode') end
subMenu['main'][10] = function(player) callFuncForHovered(player, 'dumpVars') end

--[[ Upgrade Menu]]
subMenu['upgrade'] = {}
for i = 1, 10, 1 do
    subMenu['upgrade'][i] = function(player) currentMenu = 'main' print('Leaving Upgrade Mode') end
end
subMenu['upgrade'][3] = function(player) upgradeAll() currentMenu = 'main' print('Leaving Upgrade Mode') end

--[[ General Setup Menu ]]
subMenu['setup'] = {}
subMenu['setup'][1] = function(player) currentMenu = 'owner' end
subMenu['setup'][2] = function(player) currentMenu = 'value' end
subMenu['setup'][3] = function(player) callFuncForAllSelected(player, 'setValue', 10) end
subMenu['setup'][4] = function(player) callFuncForAllSelected(player, 'setHome') end
subMenu['setup'][5] = function(player) callFuncForHovered(player, 'addPlayerPosition') end
subMenu['setup'][6] = function(player) callFuncForHovered(player, 'resetPlayerPositions') end
subMenu['setup'][7] = function(player) currentMenu = 'init' end
subMenu['setup'][9] = function(player) currentMenu = 'main' end

subMenu['init'] = {}
subMenu['init'][1] = function(player) initObj(player, urlBid) end
subMenu['init'][2] = function(player) initObj(player, urlPoint) end
subMenu['init'][9] = function(player) currentMenu = 'setup' end

--[[ Setting Owner ]]
subMenu['owner'] = {}
subMenu['owner'][1] = function(player) callFuncForAllSelected(player, 'setOwner', 'White') currentMenu = 'setup' end
subMenu['owner'][2] = function(player) callFuncForAllSelected(player, 'setOwner', 'Brown') currentMenu = 'setup' end
subMenu['owner'][3] = function(player) callFuncForAllSelected(player, 'setOwner', 'Red') currentMenu = 'setup' end
subMenu['owner'][4] = function(player) callFuncForAllSelected(player, 'setOwner', 'Green') currentMenu = 'setup' end
subMenu['owner'][5] = function(player) callFuncForAllSelected(player, 'setOwner', 'Teal') currentMenu = 'setup' end
subMenu['owner'][6] = function(player) callFuncForAllSelected(player, 'setOwner', 'Blue') currentMenu = 'setup' end

--[[ Setting Values ]]
subMenu['value'] = {}
for i = 1, 10, 1 do
    subMenu['value'][i] = function(player) callFuncForAllSelected(player, 'setValue', i) currentMenu = 'setup' end
end



currentMenu = 'main'

function onScriptingButtonDown(index, player)
    if self.hasTag('disable') then return end
    if not Player[player].host then print(Player[player].steam_name..' hat sich mit einem Hammer auf die Finger gehauen!') return end
    print('Previous Menu: '..currentMenu)
    subMenu[currentMenu][index](player)
    print('Current Menu: '..currentMenu)
end

--[[ Upgrade ]]
url = 'https://raw.githubusercontent.com/H-Hawk/TTS-Scripts/main/SkullKing/Debugger.lua'

function upgradeCallback(req)
    if req.is_error then
        log(req.error)
    else
        self.setLuaScript(req.text)
    end
end

function upgrade()
    WebRequest.get(url, upgradeCallback)
end