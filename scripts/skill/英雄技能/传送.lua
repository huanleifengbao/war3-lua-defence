local mt = ac.skill['传送']

function mt:onCastShot()
    local hero = self:getOwner()
    local target = self:getTarget()
	if target.type == 'point' then
		for _, u in ac.selector()
		    : inRange(target,self.area)
		    : isAlly(hero)
		    : allowGod()
		    : ofNot '中立'
		    : filter(function (u)
		        return hero ~= u
		    end)
		    : ipairs()
		do
			target = u
			break
		end
	end
	if target.type == 'unit' then
		hero:tp(target)
	else
		hero:getOwner():message('|cffffff00指定点附近没有友军|r', 3)
	end
end