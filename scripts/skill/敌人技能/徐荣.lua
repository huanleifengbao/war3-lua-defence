local attack_range = 300

local mt = ac.skill['徐荣-暗之咒缚']

function mt:do_stun(time)
	local hero = self:getOwner()
	local target = self:getTarget()
	local damage = self.damage * sg.get_allatr(hero) * self.pulse
	for _, u in ac.selector()
	    : inRange(target,self.area)
	    : isEnemy(hero)
	    : ofNot '建筑'
	    : filter(function (u)
	        return not u:findBuff '暗之咒缚'
	    end)
	    : ipairs()
	do
		u:addBuff '暗之咒缚' 
		{
			source = hero,
			damage = damage,
			pulse = self.pulse,
			skill = self,
			time = time,
		}
	end
end

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animation(hero,'spell')
	hero:speed(0.3)
	local time = self.castChannelTime
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
	    model = [[Abilities\Spells\Demon\DarkPortal\DarkPortalTarget.mdl]],
	    time = 1,
	}
	local target = self:getTarget()
	ac.effect {
	    target = target,
	    size = self.area/350,
	    speed = 1.8/time,
	    model = [[effect\calldown_4.mdx]],
	    height = 20,
	    time = time,
	    skipDeath = true,
	}
	hero:setFacing(point/self:getTarget(),0.1)
end

function mt:onCastShot()
	local hero = self:getOwner()
	hero:speed(0.6)
	local target = self:getTarget()
	local area = self.area
	local stun = self.stun
	self.eff = ac.effect {
	    target = target,
	    size = area/150,
	    height = -300,
	    model = [[effect\hellbond.mdx]],
	    speed = 2,
	    time = stun,
	}
	ac.effect {
	    target = target,
	    size = area/125,
	    model = [[effect\VoidDrown.mdx]],
	    height = 20,
	    time = stun,
	}
	ac.effect {
	    target = target,
	    size = 2,
	    model = [[Abilities\Spells\Other\HowlOfTerror\HowlCaster.mdl]],
	    time = 1,
	}
	self:do_stun(stun)
	local pulse = self.pulse
	ac.timer(pulse,stun/pulse,function()
		stun = stun - pulse
		self:do_stun(stun)
	end)
end

function mt:onCastStop()
	if self.load then
		self.load:remove()
	end
	local hero = self:getOwner()
	hero:speed(1)
end

local mt = ac.buff['暗之咒缚']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNAnimateDead.blp]]
mt.title = '暗之咒缚'
mt.description = '该单位被束缚了，无法行动且受到持续伤害。'

function mt:onAdd()
	local u = self:getOwner()
	u:addRestriction '硬直'
	self.eff = u:particle([[effect\Hell Roots Buff.mdx]],'origin')
end

function mt:onPulse()
	local hero = self.source
	local u = self:getOwner()
	local skill = self.skill
	hero:damage
	{
	    target = u,
	    damage = self.damage,
	    damage_type = skill.damage_type,
	    skill = skill,
	}
end

function mt:onCover(new)
    return new.time > self:remaining()
end

function mt:onRemove()
	local u = self:getOwner()
	u:removeRestriction '硬直'
	self.eff()
end

local mt = ac.skill['徐荣-恶灵轰炸']

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animation(hero,'spell')
	hero:speed(0.5)
	local time = self.castChannelTime
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
	    model = [[Abilities\Spells\Undead\AnimateDead\AnimateDeadTarget.mdl]],
	    time = 1,
	}
	hero:setFacing(point/self:getTarget(),0.1)
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	hero:speed(0.6)	
	local count = self.count
	local add = self.radius/(count - 1)
	local angle = hero:getFacing() - self.radius/2 - add
	local skill = self
	for i = 1,count do
		local a = angle + add * i
		local mover = hero:moverLine
		{
			model = [[Abilities\Spells\Undead\OrbOfDeath\AnnihilationMissile.mdl]],
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
				local damage = skill.damage * sg.get_allatr(hero)
				hero:damage
				{
				    target = u,
				    damage = damage,
				    damage_type = skill.damage_type,
				    skill = skill,
				}
				self:remove()
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

function mt:onCastStop()
	if self.load then
		self.load:remove()
	end
	local hero = self:getOwner()
	hero:speed(1)
end