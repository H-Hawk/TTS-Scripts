manager = {}

function register(managerGUID)
  table.insert(manager, managerGUID)
  print(JSON.encode_pretty(manager))
end

function isManaged(targetGUID)
  for _, v in pairs(manager) do
    local tmp = getObjectFromGUID(v).call('isManaged', targetGUID)
    if tmp then return tmp end
  end
end

function refreshAll()
  for _, v in pairs(manager) do
    getObjectFromGUID(v).call('refreshManaged')
  end
end 

function removeAllAoE()
  for _, v in pairs(manager) do
    getObjectFromGUID(v).call('removeAllManaged')
  end
end