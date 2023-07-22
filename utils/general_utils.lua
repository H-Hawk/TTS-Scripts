local general_utils = {}

general_utils.round = function (number, acc)
    local offset = math.pow(10, acc)
    return math.floor((number * offset) + 0.5) / offset
end

general_utils.shuffle = function (toShuffel)
    local len, random = #toShuffel, math.random
    for i = len, 2, -1 do
        local j = random( 1, i )
        toShuffel[i], toShuffel[j] = toShuffel[j], toShuffel[i]
    end
    return toShuffel;
end

general_utils.len = function (t)
    local out = 0
    for _, _ in pairs(t) do out = out + 1 end
    return out
end

return general_utils

