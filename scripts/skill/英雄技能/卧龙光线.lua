local mt = ac.skill['卧龙光线']

function mt:shot(index)
	local skill = self
	local hero = skill:getOwner()
	local angle = hero:getFacing()
	local point = hero:getPoint()
	local count = math.floor(index/2)
	local add = 20
	if count ~= 0 then
		add = add/count
	end
	for i = -count,count do
		local a = angle + i * add
		local mover = hero:moverLine
		{
			model = [[effect\blue_laser.mdx]],
			angle = a,
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
	self:shot(3)
	ac.wait(self.pulse,function()
		self:shot(3)
	end)
	ac.wait(self.pulse * 2,function()
		self:shot(1)
		ac.timer(self.pulse2 * 2,2,function()
			self:shot(1)
		end)
	end)
end