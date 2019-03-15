local mt = ac.skill['龙牙连爪']

function mt:onCastChannel()
    local hero = self:getOwner()
    local point = hero:getPoint()
	local target = self:getTarget()
	local angle = point/target	
	local count = self.count
	local pulse = self.pulse
	local section = self.section
	local radius = self.radius
	hero:speed(0.4/pulse)
	local animation = 2
	local function attack()
		sg.animation(hero,animation)
		if animation == 2 then
			animation = 3
		else
			animation = 2
		end
		ac.wait(pulse,function()
			if not self.is_stop then
				local wave = 6 - animation
				local now_section = section * 0.85
				if wave == 3 then
					now_section = now_section * 0.75
				end
				local add = now_section/(wave - 1)
				for i = 1,wave do
					local a = angle - now_section/2 - add + add * i
					hero:moverLine
					{
						model = [[effect\getsugabluenew.mdx]],
						distance = radius,
						speed = radius/0.25,
						angle = a,
					}
				end
				for _, u in ac.selector()
				    : inSector(point,radius,angle,section)
				    : isEnemy(hero)
				    : ipairs()
				do
					local damage = self.damage * sg.get_allatr(hero)
					hero:damage
					{
					    target = u,
					    damage = damage,
					    damage_type = self.damage_type,
					    skill = self,
					}
				end
			end
			count = count - 1
			if count > 0 then			
				attack()
			end
		end)		
	end
	attack()
end

function mt:onCastShot()
	local hero = self:getOwner()
    local point = hero:getPoint()
	local target = self:getTarget()
	local angle = point/target
	local distance = self.distance
	hero:speed(2)
	sg.animation(hero,'spell slam')
	hero:particle([[Abilities\Weapons\ZigguratFrostMissile\ZigguratFrostMissile.mdl]],'weapon',self.castShotTime)
	ac.wait(0.5,function()
		if not self.is_stop then
			sg.animation(hero,'spell')
			target = sg.on_block(point,point - {distance,angle})
			local eff = hero:particle([[effect\desgaron by deckai.mdx]],'origin')
			local mover = hero:moverLine
			{
				mover = hero,
				start = point,
				target = target,
				distance = distance,
				speed = distance/0.1,
				angle = angle,
				hitArea = self.area,
				hitType = '敌方',
			}
			local skill = self
			function mover:onHit(u)
				local damage = skill.damage2 * sg.get_allatr(hero)
				hero:damage
				{
				    target = u,
				    damage = damage,
				    damage_type = skill.damage_type,
				    skill = skill,
				}
			end
			function mover:onRemove()
				if not self.is_stop then
					hero:speed(1)
					eff()
				end
			end
		end
	end)
end

function mt:onCastStop()
	self.is_stop = true
	local hero = self:getOwner()
	hero:speed(1)
end