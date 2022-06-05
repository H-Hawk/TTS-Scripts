--[[  Constants ]]
gridFactor = { 1,  1.15, 1.15 }
imgUrls = {
  ['line'] = 'http://cloud-3.steamusercontent.com/ugc/1830163886710059483/90007030D4B46B61E5361EE4DFC129264B1034E5/',
  ['cone'] = 'http://cloud-3.steamusercontent.com/ugc/1830163886710059389/253EDF26076AF98A188881BF1CC59F293FB113BA/',
  ['cube'] = 'http://cloud-3.steamusercontent.com/ugc/1830163886710059592/7E6B6A53983B6A8B8C8C56E2571C0345B8073A6D/',
  ['sphere'] = 'http://cloud-3.steamusercontent.com/ugc/1830163886710059312/2376A8F939EC159160A068D4258AD6D630778213/',
  ['cylinder'] = 'http://cloud-3.steamusercontent.com/ugc/1830163886710059312/2376A8F939EC159160A068D4258AD6D630778213/',
}
subMenuTable = {
  [3] = 'all',
  [7] = 'shape',
  [8] = 'fav',
  [9] = 'grid',
  [810] = 'favSave'
}

--[[ Vars ]]
shape = 'cylinder'
range = 5
elevation = 0
modeElevation = false
subMenu = false

--[[ Persisten Vars]]
activeGUID = false
managed = {}
fav = {}


--[[ Data Persistence ]]
function onSave()
  local vars = {
    ['activeGUID'] = activeGUID,
    ['managed'] = managed,
    ['fav'] = fav,
  }

  return JSON.encode(vars)
end

function onLoad(stateString)
  if stateString:len() == 0 then return end

  local state = JSON.decode(stateString)

  activeGUID = state['activeGUID']
  managed = state['managed']
  fav = state['fav']

  if activeGUID then
    setRange(managed[activeGUID]['range'])
    setElevation(managed[activeGUID]['elevation'])
    shape = managed[activeGUID]['shape']
  end
  Global.call('register', self.guid)
end

--[[ Setter Range & Elevation]]
function setRange(toSet)
  range = toSet
  if not modeElevation then
    self.setValue(toSet)
  end
end

function setElevation(toSet)
  elevation = toSet
  if modeElevation then
    self.setValue(toSet)
  elseif toSet > 0 then
    self.setColorTint({0.75,0,0})
  else
    self.setColorTint({0,0,0})
  end
end


--[[ Reading Data From Tags ]]
string.startswith = function(self, str) 
    return self:find('^' .. str) ~= nil
end

function getTagValue(obj, key, default)
  for _, tag in pairs(obj.getTags()) do
    if tag:startswith(key) then
      return tag:sub(key:len()+2, tag:len())
    end
  end
  return default
end


--[[ Helpers for Player and Object Selection]]
function getHoveredObjbyColor(player)
  for _,v in pairs(Player.getPlayers()) do
    if v.color == player then
      if v.getHoverObject() ~= nil then
        return v.getHoverObject()
      else
        return false
      end
    end
  end
end

function isOwner(player)
  local owner = getTagValue(self, 'owner', 'noColor'):lower()
  return (player:lower() == owner)
end


--[[ Manipulating Grid ]]
function toggleGrid()
  Grid.show_lines = not Grid.show_lines

  if Grid.show_lines then
    Grid.snapping = 3
  else
    Grid.snapping = 1
  end
end

function switchToRecGrid()
  Grid.type = 1
end

function switchTohHexGrid()
  Grid.type = 2
end

function switchTovHexGrid()
  Grid.type = 3
end

function scalGrid(offset)
  Grid.sizeX = Grid.sizeX + offset
  Grid.sizeY = Grid.sizeX
end


--[[ Targeting ]]
function isManaged(targetGUID)
  if managed[targetGUID] then 
    return true
  else
    return false
  end
end

function addHoveredTarget(player)
  local newTarget = getHoveredObjbyColor(player)
  if not newTarget then return false end
  local newGUID = newTarget.guid

  if (not managed[newGUID]) and Global.call('isManaged', newGUID) then return end
  
  if managed[newGUID] then
    local a  = managed[newGUID]
    shape = a['shape']
    setRange(a['range'])
    setElevation(a['elevation'])
  else
    shape = 'cylinder'
    setRange(5)
    setElevation(0)
    managed[newGUID] = { ['rotOffset'] = tonumber(getTagValue(newTarget, 'rotOff', '0')) }
  end

  activeGUID = newGUID
end

function removeHoveredTarget(player)
  local toCull = getHoveredObjbyColor(player)
  if not toCull then return false end

  removeTarget(toCull.guid)
end

function removeTarget(toCullGUID)
  removeAoE(toCullGUID)
  if activeGUID == toCullGUID then activeGUID = false end
  managed[toCullGUID] = nil
end

function removeAllManaged()
  for i, _ in pairs(managed) do
    removeTarget(i)
  end
end

function removeAll()
  Global.call('removeAllAoE')
end


--[[ UI Backend for Setting Range and Elevation]]
function switchRangeAndElevation()
  if modeElevation then
    elevation = self.getValue()
    self.setValue(range)

    if elevation > 0 then 
      self.setColorTint({0.75,0,0})
    else
      self.setColorTint({0,0,0})
    end
    modeElevation = false
  else 
    range = self.getValue()
    self.setValue(elevation)

    self.setColorTint({1,0,0})
    modeElevation = true
  end
end

function decrementByFive()
  local tmp = -1
  if modeElevation then 
    elevation = elevation - 5
    if elevation < 0 then elevation = 0 end
    tmp = elevation
  else
    range = range - 5
    if range < 0 then range = 0 end
    tmp = range
  end
  self.setValue(tmp)
end

function incrementByFive()
  local tmp = -1
  if modeElevation then 
    elevation = elevation + 5
    tmp = elevation
  else
    range = range + 5
    tmp = range
  end
  self.setValue(tmp)
end


-- [[ Calculation for Drawing the AoE ]]
function calcDim(anchorGUID)
  local a = managed[anchorGUID]
  local result = 0

  if a['shape'] == 'sphere' then
    local projectedRadius = math.sqrt((a['range']/5)^2 - (a['elevation']/5)^2)
    if tostring(projectedRadius) ~= tostring(math.sqrt(-1)) then 
      result = 2*projectedRadius + 1
    end
  elseif a['shape'] == 'cube' then
    result = a['range']/5
  else
    result = 2 * (a['range']/5) + 1
  end

  a['dimension'] = result * (Grid.sizeX/gridFactor[Grid.type])
end

function getViewVec(anchorGUID)
  local view = getObjectFromGUID(anchorGUID).getTransformForward()

  if managed[anchorGUID]['rotOffset'] > 0 then
    local rad = math.rad(managed[anchorGUID]['rotOffset'])
    local sin = math.sin(rad)
    local cos = math.cos(rad)

    view = Vector(cos*view.x - sin*view.z, 0, sin*view.x + cos*view.z)
  end

  return view
end

function calcCenter(anchorGUID)
  local pos = getObjectFromGUID(anchorGUID).getPosition()

  if managed[anchorGUID]['shape'] == 'cube' then
    return pos + managed[anchorGUID]['dimension']/2 * getViewVec(anchorGUID)
  else
    return pos
  end
end


--[[ Handeling the Drawing itself]]
function removeAoE(anchorGUID)
  vFound = false
  vDecalTable = Global.getDecals()
  if vDecalTable ~= nil then
    for index, value in ipairs(vDecalTable) do
      if value.name == "aoe"..anchorGUID then
        vFound = true
        table.remove(vDecalTable, index)
      end
    end
  end
  
  if vFound then 
    Global.setDecals(vDecalTable)
  end

  return vFound
end

function draw(anchorGUID)
  removeAoE(anchorGUID)

  local anchor = getObjectFromGUID(anchorGUID)
  local a = managed[anchorGUID]

  calcDim(anchorGUID) 

  a['decal'] = {
    name     = 'aoe'..anchorGUID,
    url      = imgUrls[a['shape']],
    position = calcCenter(anchorGUID),
    rotation = anchor.getRotation() + Vector(90, -a['rotOffset'], 0),
    scale    = Vector(a['dimension'], a['dimension'], 1)
  }
  
  Global.addDecal(a['decal'])
end


--[[ Refreshing ]]
function drawActive()
  if not activeGUID then return false end
  local a = managed[activeGUID]

  a['shape'] = shape
  a['range'] = range
  a['elevation'] = elevation

  draw(activeGUID)
end

function refreshManaged()
  drawActive()
  
  for i, _ in pairs(managed) do
    draw(i)
  end
end

function refreshAll()
  Global.call('refreshAll')
end


--[[ Setting and Load Favorites ]]
function saveFav(index)
  fav[index] = { ['shape'] = shape, ['range'] = range }
end

function loadFav(index)
  shape = fav[index]['shape']
  setRange(fav[index]['range'])
  setElevation(0)
end

--[[ Loadtime Frontloader]]
function loadTimeOpt(player)
  local target = getHoveredObjbyColor(player)
  if not target then return false end

  local dummies = {
    {
      name     = 'aoeLineDummy',
      url      = imgUrls['line'],
      position = target.getPosition(),
      rotation = target.getRotation() + Vector(90, 0, 0),
      scale    = Vector(0.1, 0.1, 1)
    },
    {
      name     = 'aoeConeDummy',
      url      = imgUrls['cone'],
      position = target.getPosition(),
      rotation = target.getRotation() + Vector(90, 0, 0),
      scale    = Vector(0.1, 0.1, 1)
    },
    {
      name     = 'aoeCubeDummy',
      url      = imgUrls['cube'],
      position = target.getPosition(),
      rotation = target.getRotation() + Vector(90, 0, 0),
      scale    = Vector(0.1, 0.1, 1)
    },
    {
      name     = 'aoeCircleDummy',
      url      = imgUrls['sphere'],
      position = target.getPosition(),
      rotation = target.getRotation() + Vector(90, 0, 0),
      scale    = Vector(0.1, 0.1, 1)
    },
  } 

  for _, v in pairs(dummies) do 
    Global.addDecal(v)
  end
end


--[[ Debugging ]]
function printVars()
  local vars = {
    ['shape'] = shape,
    ['range'] = range,
    ['elevation'] = elevation,
    ['modeElevation'] = modeElevation,
    ['subMenu'] = subMenu,
    ['activeGUID'] = activeGUID,
    ['managed'] = managed,
    ['fav'] = fav,
  }
  print(JSON.encode_pretty(vars))
end

function hardReset()
  removeAllManaged()

  shape = 'cylinder'
  setRange(5)
  setElevation(0)
  modeElevation = false
  subMenu = false
  activeGUID = false
  managed = {}
  fav = {}
end

--[[ Binding everything to the scripting Keys]]

function onScriptingButtonDown(index, player)
  if not isOwner(player) then return end
  
  if not subMenu then
    if index == 1 then 
      addHoveredTarget(player)
      drawActive()
    elseif index == 2 then 
      removeHoveredTarget(player)
    elseif index == 4 then 
      decrementByFive()
      drawActive()
    elseif index == 5 then 
      switchRangeAndElevation()
    elseif index == 6 then 
      incrementByFive()
      drawActive()
    elseif subMenuTable[index] then 
      subMenu = subMenuTable[index]
      return
    elseif index == 10 then 
      drawActive()
    end
  end

  if subMenu == 'shape' then
    if index == 1 then shape = 'line'
    elseif index == 2 then shape = 'cone'
    elseif index == 3 then shape = 'cube'
    elseif index == 4 then shape = 'sphere'
    elseif index == 5 then shape = 'cylinder'
    else return
    end
    drawActive()
  end

  if subMenu == 'grid' then
    if index == 1 then scalGrid(-0.05)
    elseif index == 2 then refreshAll()
    elseif index == 3 then scalGrid(0.05)
    elseif index == 4 then switchToRecGrid()
    elseif index == 5 then switchTohHexGrid()
    elseif index == 6 then switchTovHexGrid()
    elseif index == 10 then toggleGrid()
    else return
    end
    drawActive()
  end

  if subMenu == 'fav' then
    if index == 10 then subMenu = 'favSave'
    else loadFav(index) end
    drawActive()
  end

  if subMenu == 'favSave' then
    if not (index == 8 or index == 10) then 
      saveFav(index)
    end
  end

  if subMenu == 'all' then
    if index == 10 then refreshManaged()
    elseif index == 2 then removeAllManaged()
    elseif index == 5 then removeAll()
    elseif index == 7 then loadTimeOpt(player)
    elseif index == 8 then printVars()
    elseif index == 9 then hardReset()
    end
  end

end

function onScriptingButtonUp(index, player)
  if not isOwner(player) then return end
  
  if subMenuTable[index] == subMenu then 
    subMenu = false
  elseif subMenu == 'favSave' and index == 8 then
    subMenu = false
  elseif subMenu == 'favSave' and index == 10 then
    subMenu = 'fav'
  end
end

