local mt = ac.skill['卧龙光线']

function mt:shot(count)
	local skill = self
	local hero = skill:getOwner()
	local angle = hero:getFacing()
	local point = hero:getPoint()
	local add
	if count ~= 1 then
		add = self.angle/(count - 1)
		angle = angle - self.angle/2 - add
	else
		add = 0
	end
	for i = 1,count do
		local a = angle + i * add
		local mover = hero:moverLine
		{
			model = [[effect\blue_laser.mdx]],
			angle = a,
			speed = self.speed,
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
	local hero = self:getOwner()
	local count = self.count
	local wait = self.pulse
	local timer = ac.timer(wait,count - 1,function()
		self:shot(self.laser)
	end)
	timer()
	wait = wait * count
	ac.wait(wait - 0.3,function()
		if hero:isAlive() then
			sg.animation(hero,'spell')
		end
	end)
	ac.wait(wait,function()	
		local timer = ac.timer(self.pulse2,self.count2 - 1,function()
			if hero:isAlive() then
				self:shot(self.laser2)
			end		
		end)
		timer()
	end)
end