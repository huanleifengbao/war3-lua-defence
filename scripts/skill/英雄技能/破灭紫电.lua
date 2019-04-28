local mt = ac.skill['破灭紫电']

function mt:shot(count,direct)
	local skill = self
	local hero = skill:getOwner()
	local angle = hero:getFacing()
	local num = self.angle
	local add
	if count ~= 1 then
		if direct ~= 0 then
			num = num / 2
			add = num/(count - 1) * direct
			angle = angle - num * direct - add
		else
			add = num/(count - 1)
			angle = angle - num/2 - add
		end
	else
		add = 0
	end
	for i = 1,count do
		local a = angle + i * add
		local mover = hero:moverLine
		{
			model = [[effect\purple_laser.mdx]],
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
			    attack = true,
			}
		end
	end
end

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,3)
end

function mt:onCastShot()
	local hero = self:getOwner()
	local direct = 1
	local wait = self.pulse
	local count = self.count - 1
	local timer = ac.timer(wait,count,function()
		direct = -1 * direct
		self:shot(self.laser,direct)
	end)
	timer()
	sg.animation(hero,4)
	wait = wait * count + self.pulse2
	ac.wait(wait - 0.3,function()
		if hero:isAlive() then
			sg.animation(hero,5)
		end
	end)
	ac.wait(wait,function()
		if hero:isAlive() then
			self:shot(self.laser2,0)
		end
	end)
end