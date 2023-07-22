utils = require("utils.general_utils")

Vector.round = function(self, acc)
    self.x = utils.round(self.x, acc)
    self.y = utils.round(self.y, acc)
    self.z = utils.round(self.z, acc)

    return self
end

