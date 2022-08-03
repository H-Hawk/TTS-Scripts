-- Start
function onLoad(save_state)
    self.createButton({
        click_function = "setUp",
        width = 2900,
        height = 950
    })
end

-- Flip
function onLoad(save_state)
    self.createButton({
        click_function = 'flipBids',
        width = 2900,
        height = 950
    })
end

-- Next
function onLoad(save_state)
    self.createButton({
        click_function = 'nextRound',
        width = 2900,
        height = 950
    })
end