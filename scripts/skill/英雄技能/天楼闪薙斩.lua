local mt = ac.skill['天楼闪薙斩']

function mt:onCastShot()
    local skill = self
    local hero = skill:getOwner()
    local p1 = hero:getPoint()
    local p2 = skill:getTarget()
    
end