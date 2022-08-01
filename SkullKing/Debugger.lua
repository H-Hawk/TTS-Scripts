urlBid = 'https://raw.githubusercontent.com/H-Hawk/TTS-Scripts/main/SkullKing/Bid.lua'
urlPoint = 'https://raw.githubusercontent.com/H-Hawk/TTS-Scripts/main/SkullKing/PointCounter.lua'

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
	Player[player].getHoverObject().call(func, param)
end


subMenu = {}
subMenu['main'] = {}
subMenu['main'][1] = function(player) callFuncForAllSelected(player, upgrade, {}) end
subMenu['main'][4] = function(player) currentMenu = 'setup' end
subMenu['main'][10] = function(player) callFuncForHovered(player, dumpVars, {}) end

--[[ General Setup Menu ]]
subMenu['setup'] = {}
subMenu['setup'][1] = function(player) currentMenu = 'owner' end
subMenu['setup'][2] = function(player) currentMenu = 'value' end
subMenu['setup'][3] = function(player) callFuncForAllSelected(player, setValue, {10}) end
subMenu['setup'][4] = function(player) callFuncForAllSelected(player, setHome, {}) end
subMenu['setup'][5] = function(player) callFuncForHovered(player, addPlayerPosition, {}) end
subMenu['setup'][6] = function(player) callFuncForHovered(player, resetPlayerPositions, {}) end
subMenu['setup'][7] = function(player) initObj(player, urlBid) end
subMenu['setup'][8] = function(player) initObj(player, urlPoint) end
subMenu['setup'][9] = function(player) currentMenu = 'main' end

--[[ Setting Owner ]]
subMenu['owner'] = {}
subMenu['owner'][1] = function(player) callFuncForAllSelected(player, setOwner, {'White'}) currentMenu = 'setup' end
subMenu['owner'][2] = function(player) callFuncForAllSelected(player, setOwner, {'Brown'}) currentMenu = 'setup' end
subMenu['owner'][3] = function(player) callFuncForAllSelected(player, setOwner, {'Red'}) currentMenu = 'setup' end
subMenu['owner'][4] = function(player) callFuncForAllSelected(player, setOwner, {'Green'}) currentMenu = 'setup' end
subMenu['owner'][5] = function(player) callFuncForAllSelected(player, setOwner, {'Teal'}) currentMenu = 'setup' end
subMenu['owner'][6] = function(player) callFuncForAllSelected(player, setOwner, {'Blue'}) currentMenu = 'setup' end

--[[ Setting Values ]]
subMenu['value'] = {}
for i = 1, 10, 1 do
	subMenu['value'][i] = function(player) callFuncForAllSelected(player, setValue, {i}) currentMenu = 'setup' end
end



currentMenu = 'main'

function onScriptingButtonDown(index, player)
	if not Player[player].host then return end
	subMenu[currentMenu][index](player)
end
