--[[ Tags as persistent Storage]]

---@diagnostic disable-next-line: duplicate-set-field
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

function removeTagValue(obj, key)
  for _, tag in pairs(obj.getTags()) do
    if tag:startswith(key) then
      obj.removeTag(tag)
      return true
    end
  end
  return false
end

function setTagValue(obj, key, value)
  removeTagValue(obj, key)
  obj.addTag(key .. ' ' .. value)
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


--[[ Managing Sub-Menus]]

function enterSubMenu(subMenu)
  setTagValue(self, 'subMenu', subMenu)
end

function exitSubMenu()
  removeTagValue(self, 'subMenu')
end

function inSubMenu(subMenu)
  return getTagValue(self, 'subMenu', false) == subMenu
end

function noSubMenu()
  return not getTagValue(self, 'subMenu', false)
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

function scalUpGrid()
  local offset = 0.05

  Grid.sizeX = Grid.sizeX + offset
  Grid.sizeY = Grid.sizeX
end

function scalDownGrid()
  local offset = 0.05

  Grid.sizeX = Grid.sizeX - offset
  Grid.sizeY = Grid.sizeX
end


--[[ Getter/Setter Range, Elevation & Shape]]

function getRange()
  if self.hasTag('modeElevation') then
    return tonumber(getTagValue(self, 'range', '0'))
  else
    return self.getValue()
  end
end

function setRange(toSet)
  if self.hasTag('modeElevation') then
    setTagValue(self, 'range', toSet)
  else
    self.setValue(toSet)
  end
end

function getElevation()
  if self.hasTag('modeElevation') then
    return self.getValue()
  else
    return tonumber(getTagValue(self, 'elevation', '0'))
  end
end

function setElevation(toSet)
  if self.hasTag('modeElevation') then
    self.setValue(toSet)
  else
    setTagValue(self, 'elevation', toSet)
    if toSet > 0 then
      self.setColorTint({0.75,0,0})
    else
      self.setColorTint({0,0,0})
    end
  end
end

function getShape()
  return getTagValue(self, 'shape', false)
end

function setShape(shape)
  setTagValue(self, 'shape', shape)
end


--[[ Getter/Setter for managed AOE ]]

function listManaged()
  managedTable = {}
  managedString = getTagValue(self, 'managed', '')
  numGUID = managedString:len()/6

  for i=1,numGUID,1 do
    index = (i-1)*6 + 1
    table.insert(managedTable, managedString:sub(index, index+5))
  end

  return managedTable
end

function setManaged(toSetTable)
  toSetString = ''
  for _, v in pairs(toSetTable) do
    toSetString = toSetString .. v
  end

  setTagValue(self, 'managed', toSetString)
end

function isManaged(targetGUID)
  local managedTable = listManaged()
  for _, v in pairs(managedTable) do
    if v == targetGUID then 
      return true
    end
  end
  return false
end

function addManaged(toAddGUID)
  if isManaged(toAddGUID) then return end
  local managedTable = listManaged()
  table.insert(managedTable, toAddGUID)
  setManaged(managedTable)
end

function removeManaged(toCullGUID)
  local managedTable = listManaged()
  for i, v in pairs(managedTable) do
    if v == toCullGUID then 
      table.remove(managedTable, i)
    end
  end
  setManaged(managedTable)
end


--[[ Targeting ]]

function saveParaToTarget(player)
  local oldTarget = getObjectFromGUID(getTagValue(self, 'active', false))

  setTagValue(oldTarget, 'manager', player)
  setTagValue(oldTarget, 'shape', getShape())
  setTagValue(oldTarget, 'range', getRange())
  setTagValue(oldTarget, 'elevation', getElevation())
end

function loadParaFromTarget(target)
  setShape(getTagValue(target, 'shape', 'line'))
  setRange(tonumber(getTagValue(target, 'range', '0')))
  setElevation(tonumber(getTagValue(target, 'elevation', '0')))
end

function addTarget(player)
  local newTarget = getHoveredObjbyColor(player)
  if not newTarget then return false end
  local manager = getTagValue(newTarget, 'manager', player)
  if not (manager == player) then return false end

  local oldTarget = getTagValue(self, 'active', false)
  if oldTarget then saveParaToTarget(player) end

  if newTarget.hasTag('AoE') then loadParaFromTarget(newTarget) end

  setTagValue(self, 'active', newTarget.guid)
  addManaged(newTarget.guid)
  newTarget.addTag('AoE')
end

function removeHover(player)
  local toCull = getHoveredObjbyColor(player)
  if not toCull then return false end

  removeTarget(player, toCull)
end

function removeTarget(player, toCull)
  if not isManaged(toCull.guid) then return end

  removeAoE(toCull.guid)
  if getTagValue(self, 'active', false) == toCull.guid then
    removeTagValue(self, 'active')
  end
  removeManaged(toCull.guid)
  removeTagValue(toCull, 'manager')
  toCull.removeTag('AoE')
end

function removeAllManaged(player)
  for i,v in pairs(listManaged()) do
    removeTarget(player, getObjectFromGUID(v))
  end
end


--[[ UI Backend for Setting Range and Elevation]]

function switchRangeAndElevation()
  if self.hasTag('modeElevation') then
    local elevation = self.getValue()
    local range = tonumber(getTagValue(self, 'range', '0'))

    removeTagValue(self, 'range')

    setTagValue(self, 'elevation', elevation)
    self.setValue(range)

    if elevation > 0 then 
      self.setColorTint({0.75,0,0})
    else
      self.setColorTint({0,0,0})
    end
    self.removeTag('modeElevation') 
  else 
    local elevation = tonumber(getTagValue(self, 'elevation', '0'))
    local range = self.getValue()

    removeTagValue(self, 'elevation')

    setTagValue(self, 'range', range)
    self.setValue(elevation)

    self.setColorTint({1,0,0})
    self.addTag('modeElevation') 
  end
end

function decrementByFive()
  local tmp = self.getValue() - 5
  if tmp < 0 then 
    tmp = 0
  end
  self.setValue(tmp)
end

function incrementByFive()
  local tmp = self.getValue() + 5
  self.setValue(tmp)
end


-- [[ Calculation for Drawing the AoE ]]

function calcDim(shape, range, elevation)
  if shape == 'sphere' then
    local projectedRadius = math.sqrt((range/5)^2 - (elevation/5)^2)
    if tostring(projectedRadius) == tostring(math.sqrt(-1)) then 
      return 0
    else
      return 2*projectedRadius + 1
    end
  elseif shape == 'cube' then
    return range/5
  else
    return 2 * (range/5) + 1
  end
end

function getViewVec(target)
  local view = target.getTransformForward()
  local rotOffset = tonumber(getTagValue(target, 'rotOff', false))

  if rotOffset then
    local rad = math.rad(rotOffset)
    local sin = math.sin(rad)
    local cos = math.cos(rad)

    view = Vector(cos*view.x - sin*view.z, 0, sin*view.x + cos*view.z)
  end

  return view
end

function calcCenter(anchor, shape, dim)
  local pos = anchor.getPosition()

  if shape == 'cube' then
    return pos + dim/2 * getViewVec(anchor)
  else
    return pos
  end
end

--[[ Handeling the Drawing itself]]

function removeAoE(anchorGUID)
  vFound = false
  vDecalTable = Global.getDecals()
  if vDecalTable ~= nil then
    for index, value in pairs(vDecalTable) do
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

function draw(anchor, shape, range, elevation)
  local gridFactor = { 1,  1.15, 1.15 }
  local imgUrls = {
    ['line'] = 'http://cloud-3.steamusercontent.com/ugc/1830163607510884164/C8229AB3AC5B6ECC9AD82707DD6319E0AE7DBE8D/',
    ['cone'] = 'http://cloud-3.steamusercontent.com/ugc/1830163607510884072/DC2C8FA19225A57A3FF85087EF17651EF0FE17DA/',
    ['cube'] = 'http://cloud-3.steamusercontent.com/ugc/1830163607510884252/B415A23C08A78D7ABD2D129275F652C5CF8BAF10/',
    ['sphere'] = 'http://cloud-3.steamusercontent.com/ugc/1830163607510883986/7607CB1B7467813343CEF27D34E4685E1935EF03/',
    ['cylinder'] = 'http://cloud-3.steamusercontent.com/ugc/1830163607510883986/7607CB1B7467813343CEF27D34E4685E1935EF03/',
  }

  anchor = getObjectFromGUID(anchor)

  local dim = calcDim(shape, range, elevation) * (Grid.sizeX/gridFactor[Grid.type])
  if dim == 0 then print('Waring Dimensons equal 0') end

  local rot = anchor.getRotation()
  local rotOffset = tonumber(getTagValue(anchor, 'rotOff', '0'))
  local pos = calcCenter(anchor, shape, dim)

  local params = {
    name     = 'aoe'..anchor.guid,
    url      = imgUrls[shape],
    position = pos,
    rotation = rot + Vector(90, -rotOffset, 0),
    scale    = Vector(dim, dim, 1)
  }

  removeAoE(anchor.guid)
  Global.addDecal(params)
  
end


--[[ Refreshing ]]

function drawActive(player)
  local active = getTagValue(self, 'active', false)
  if not active then 
    return false
  end

  saveParaToTarget(player)
  draw(active, getShape(), getRange(), getElevation())
end

function refresh(anchorGUID)
  local anchor = getObjectFromGUID(anchorGUID)
  local shape = getTagValue(anchor, 'shape', 'line')
  local range = tonumber(getTagValue(anchor, 'range', '0'))
  local elevation = tonumber(getTagValue(anchor, 'elevation', '0'))

  draw(anchorGUID, shape, range, elevation)
end

function refreshManaged(player)
  local managedTable = listManaged()
  local active = getTagValue(self, 'active', false)

  for _, v in pairs(managedTable) do
    if v == active then
      drawActive(player)
    else
      refresh(v)
    end
  end
end

function refreshAll()
  for _, v in pairs(getObjects()) do
    if v.hasTag('AoE') then
      refresh(v.guid)
    end
  end
end


--[[ Setting and Load Favorites ]]

function saveFav(index)
  local fav = getShape() .. ' ' .. getRange()
  setTagValue(self, 'fav' .. index, fav)
end

function loadFav(index)
  local favString = getTagValue(self, 'fav' .. index, false)
  if not favString then return end

  local shape = favString:sub(1, favString:find(' ')-1)
  local range = tonumber(favString:sub(favString:find(' ')+1, favString:len()))

  setShape(shape)
  setRange(range)
end


--[[ Binding everything to the scripting Keys]]

function onScriptingButtonDown(index, player)
  if not (player:lower() == getTagValue(self, 'owner', 'noColor'):lower()) then return end
  
  if noSubMenu() then
    if index == 1 then 
      addTarget(player)
      drawActive(player)
    elseif index == 2 then 
      removeHover(player)
    elseif index == 3 then 
      enterSubMenu('all')
    elseif index == 4 then 
      decrementByFive()
      drawActive(player)
    elseif index == 5 then 
      switchRangeAndElevation()
    elseif index == 6 then 
      incrementByFive()
      drawActive(player)
    elseif index == 7 then 
      enterSubMenu('shape')
    elseif index == 8 then 
      enterSubMenu('fav')
    elseif index == 9 then 
      enterSubMenu('grid')
    elseif index == 10 then 
      drawActive(player)
    end
  end

  if inSubMenu('shape') then
    if index == 1 then setShape('line')
    elseif index == 2 then setShape('cone')
    elseif index == 3 then setShape('cube')
    elseif index == 4 then setShape('sphere')
    elseif index == 5 then setShape('cylinder')
    else return
    end
    drawActive(player)
  end

  if inSubMenu('grid') then
    if index == 1 then scalDownGrid()
    elseif index == 2 then refreshAll()
    elseif index == 3 then scalUpGrid()
    elseif index == 4 then switchToRecGrid()
    elseif index == 5 then switchTohHexGrid()
    elseif index == 6 then switchTovHexGrid()
    elseif index == 10 then toggleGrid()
    else return
    end
    drawActive(player)
  end

  if inSubMenu('fav') then
    if index == 10 then enterSubMenu('favSave')
    else
      loadFav(index)
    end
    drawActive(player)
  end

  if inSubMenu('favSave') then
    if index == 8 or index == 10 then 
      return
    else
      saveFav(index)
    end
  end

  if inSubMenu('all') then
    if index == 10 then refreshManaged(player)
    elseif index == 2 then removeAllManaged(player)
    else return
    end
  end

end

function onScriptingButtonUp(index, player)
  if not (player:lower() == getTagValue(self, 'owner', 'noColor'):lower()) then return end
  
  local subMenuKeys = { [3]=true, [7]=true, [8]=true, [9]=true }

  if subMenuKeys[index] then 
    exitSubMenu()
  elseif inSubMenu('favSave') and index == 10 then
    enterSubMenu('fav')
  end
end

