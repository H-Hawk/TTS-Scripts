---@diagnostic disable-next-line: duplicate-set-field
string.startswith = function(self, str)
    ---@diagnostic disable-next-line: param-type-mismatch
    return self:find('^' .. str) ~= nil
end


local tag_func = {}

tag_func.get_value = function (obj, key, default)
  for _, tag in pairs(obj.getTags()) do
    if tag:startswith(key) then
      return tag:sub(key:len()+2, tag:len())
    end
  end
  return default
end

tag_func.remove_key = function (obj, key)
  for _, tag in pairs(obj.getTags()) do
    if tag:startswith(key) then
      obj.removeTag(tag)
      return true
    end
  end
  return false
end

tag_func.set = function (obj, key, value)
  removeTagValue(obj, key)
  obj.addTag(key .. ' ' .. value)
end

return tag_func

