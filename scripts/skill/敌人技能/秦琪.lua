local mt = ac.skill['秦琪-死亡脉冲']

function mt:onCastStart()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local time = self.castStartTime + self.castChannelTime
	sg.animation(hero,'stand channel',true)
	self.load = sg.load_bar({target = point,time = time})
	ac.effect {
	    target = point,
	    size = 2,
	    model = [[Abilities\Spells\Other\HowlOfTerror\HowlCaster.mdl]],
	    time = 1,
	}
end

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animation(hero,'attack spell')
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local count = self.count
	local skill = self
	for i = 1,count do
		local a = 360/count * i
		local mover = hero:moverLine
		{
			model = [[effect\Shade Missile.mdx]],
			start = point,
			angle = a,
			speed = self.speed,
			distance = self.distance,
			hitType = '敌方',
			hitArea = self.area,
			startHeight = 50,
			finishHeight = 50,
		}
		function mover:onHit(u)
			if not u:isType '建筑' then
				local damage = skill.damage * hero:get('攻击')
				hero:damage
				{
				    target = u,
				    damage = damage,
				    damage_type = skill.damage_type,
				    skill = skill,
				}
				self:remove()
				u:addBuff '死神镰刀'
				{
					source = hero,
					damage = skill.damage2,
					time = skill.stun,
					skill = skill,
				}
			end
		end
		local pulse = 0.15
		local index = 1
		local add = 0
		local timer = ac.loop(0.05,function()
			add = add + index * self.angle/(pulse/0.05)
			if math.abs(add) >= self.angle then
				index = -index
			end
			mover:setOption('angle',a + add)
			mover:setAngle(a + add)
		end)
		function mover:onRemove()
			timer:remove()
		end
	end
end

local mt = ac.buff['死神镰刀']

function mt:onAdd()
	local u = self:getOwner()
	u:addRestriction '硬直'
	ac.effect {
	    target = u:getPoint(),
	    size = 1.5,
	    model = [[effect\Death Spell.mdx]],
	    angle = u:getFacing(),
	    time = 0.8,
	}
	self.eff = u:particle([[effect\Hell Roots Buff.mdx]],'origin')
end

function mt:onCover()
	return false
end

function mt:onRemove()
	local u = self:getOwner()
	u:removeRestriction '硬直'
	local skill = self.skill
	local damage = (u:get('生命上限') - u:get('生命')) * self.damage
	self.source:damage
	{
	    target = u,
	    damage = damage,
	    damage_type = skill.damage_type,
	    skill = skill,
	}
	self.eff()
end