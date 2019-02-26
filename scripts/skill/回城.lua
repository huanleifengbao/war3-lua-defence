
local mt = ac.skill['回城']

local target = ac.point(7044, -8792)

function mt:onCastShot()
    local skill = self
    local hero = skill:getOwner()
    local player = hero:getOwner()

    hero:blink(target)
    player:moveCamera(target, 0.2)
end