function round(number, acc)
    local offset = math.pow(10, acc)
    return math.floor((number * offset) + 0.5) / offset
end

Vector.round = function(self, acc)
    self.x = round(self.x, acc)
    self.y = round(self.y, acc)
    self.z = round(self.z, acc)

    return self
end