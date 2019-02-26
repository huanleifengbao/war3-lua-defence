local mt = ac.skill['月遁血祭']

function mt:do_damage(target)
	local skill = self
	local hero = self:getOwner()
	for _, u in ac.selector()
	    : inRange(target,self.area)
	    : isEnemy(hero)
	    : ipairs()
	do
		local mover = hero:moverLine
	    {
			mover = u,
			distance = 1,
			angle = 0,
			speed = 1/skill.time,
			parameter = true,
			middleHeight = 300,
		}
		u:addRestriction '硬直'
		function mover:onRemove()
			u:removeRestriction '硬直'
		end
		local damage = skill.damage * sg.get_allatr(hero)
		hero:damage
		{
		    target = u,
		    damage = damage,
		    damage_type = skill.damage_type,
		    skill = skill,
		}
	end	
end

function mt:onCastShot()
    local hero = self:getOwner()
    local point = hero:getPoint()
	local area = self.area
	local pulse = self.pulse
	local count = self.count
	ac.effect {
	    target = point,
	    model = [[effect\weapon slam.mdx]],
	    size = area/300,
	    speed = 0.4/pulse,
	    time = pulse * count + 1,
	    angle = math.random(360),
	}
	self:do_damage(point)
	if count > 1 then
		ac.timer(pulse,count - 1,function()
			self:do_damage(point)
		end)
	end
end