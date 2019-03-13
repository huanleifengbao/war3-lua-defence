local attack_range = 200

local mt = ac.skill['华雄-冲击波']

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'spell throw',true)
	local time = self.castStartTime
	local point = hero:getPoint()
	self.load = ac.effect {
	    target = point,
	    model = [[effect\Progressbar.mdx]],
	    speed = 1/time,
	    size = 2,
	    height = 500,
	    time = time,
	    skipDeath = true,
	}
	ac.effect {
	    target = point,
	    size = 2,
	    model = [[Abilities\Spells\NightElf\Taunt\TauntCaster.mdl]],
	    time = 1,
	}
	hero:setFacing(point/self:getTarget(),0.1)
end

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animationI(hero,7)
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local target = self:getTarget()
	local angle = point / target
	local area = self.area
	local skill = self
	target = point - {angle,attack_range + area}
	for j = 1,self.hang do
		local t = target - {-angle,j * area/self.hang}
		for i = -self.lie,self.lie do
			local k = 1
			if i < 0 then
				k = -1
			end
			local p = t - {angle + 150 * k,area * math.abs(i)}
			local mover = hero:moverLine
			{
				model = [[Abilities\Spells\Orc\Shockwave\ShockwaveMissile.mdl]],
				start = p,
				angle = angle,
				speed = self.speed,
				distance = self.distance,
				hitArea = area,
				hitType = '敌方',
			}		
			function mover:onHit(u)
				if not u:isType '建筑' then
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
	end
end

function mt:onCastStop()
	if self.load then
		self.load:remove()
	end
end

local mt = ac.skill['华雄-雷霆一击']

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'Spell Slam',true)
	local time = self.castStartTime
	local point = hero:getPoint()
	self.load = ac.effect {
	    target = point,
	    model = [[effect\Progressbar.mdx]],
	    speed = 1/time,
	    size = 2,
	    height = 500,
	    time = time,
	    skipDeath = true,
	}
	ac.effect {
	    target = point,
	    size = 2,
	    model = [[Abilities\Spells\Other\HowlOfTerror\HowlCaster.mdl]],
	    time = 1,
	}
	hero:setFacing(point/self:getTarget(),0.1)
end

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animationI(hero,8)
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local angle = math.random(360)
	local area = self.hitarea
	local count = self.count
	local target = point - {hero:getFacing(),attack_range}
	local skill = self
	ac.effect {
	    target = target,
	    size = area/250,
	    model = [[Abilities\Spells\Human\Thunderclap\ThunderClapCaster.mdl]],
	    time = 1,
	}
	local damage = skill.damage * sg.get_allatr(hero)
	for _, u in ac.selector()
	    : inRange(target,area)
	    : isEnemy(hero)
	    : ofNot '建筑'
	    : ipairs()
	do	
		hero:damage
		{
		    target = u,
		    damage = damage,
		    damage_type = skill.damage_type,
		    skill = skill,
		}
		u:addBuff '眩晕' 
		{
			time = skill.stun,
		}
		print(u)
	end
	for i = 1,count do
		local mover = hero:moverLine
		{
			model = [[Abilities\Spells\Orc\Shockwave\ShockwaveMissile.mdl]],
			start = target,
			angle = 360/count * i + angle,
			speed = self.speed,
			distance = self.distance,
			hitArea = self.area,
			hitType = '敌方',
		}
		function mover:onHit(u)
			if not u:isType '建筑' then
				local damage = skill.damage2 * sg.get_allatr(hero)
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
end

function mt:onCastStop()
	if self.load then
		self.load:remove()
	end
end