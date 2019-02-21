local mt = ac.skill['破灭紫电']

function mt:shot(index,angle)
	local skill = self
	local hero = skill:getOwner()
	local a = hero:getFacing() + angle
	local point = hero:getPoint()
	local count = math.floor(index/2)
	for i = -count,count do
		local mover = hero:moverLine
		{
			model = [[effect\purple_laser.mdx]],
			angle = a + 15 * i,
			speed = 1200,
			distance = skill.distance,
			startHeight = 80,
			finishHeight = 40,
			hitArea = skill.area,
			hitType = '敌方',
		}
		function mover:onHit(u)
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
end

function mt:onCastShot()
	self:shot(3,15)
	ac.wait(self.pulse,function()
		self:shot(3,-15)
	end)
	ac.wait(self.pulse + self.pulse2,function()
		self:shot(5,0)
	end)
end