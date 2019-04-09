local mt = ac.skill['韩富-风暴之锤']

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'attack')
	hero:particle([[Abilities\Spells\Other\FrostBolt\FrostBoltMissile.mdl]],'weapon')()
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local target = self:getTarget()
	local mover = hero:moverTarget
	{
		model = [[Abilities\Spells\Undead\FreezingBreath\FreezingBreathMissile.mdl]],
		start = point,
		target = target,
		speed = self.speed,
		startHeight = 100,
		finishHeight = 60,
	}
	local skill = self
	function mover:onRemove()
		local damage = skill.damage * hero:get('攻击')
		hero:damage
		{
		    target = target,
		    damage = damage,
		    damage_type = skill.damage_type,
		    skill = skill,
		}
		target:addBuff '冰冻'
		{
			time = skill.stun,
		}
	end
end

local mt = ac.skill['韩富-重生']
local count = {}
local hp = {}

function mt:onAdd()
	local hero = self:getOwner()
	count[hero] = self.count
	hp[hero] = 100
	self.trg = hero:event('单位-即将扣除生命',function(_,_,damage)
		if count[hero] > 0 and damage:get_currentdamage() >= hero:get('生命') then
			count[hero] = count[hero] - 1
			local point = hero:getPoint()
			hero:addRestriction '无敌'
			hero:addRestriction '硬直'
			hero:set('生命',hero:get'生命上限' * 0.01)
			sg.animation(hero,'death')
			ac.wait(self.dying,function()
				if hero:isAlive() then
					local rate = 1/self.time/20 * hp[hero]/100
					hero:speed(-0.5)
					local now_hp = 0
					ac.timer(0.05,self.time/0.05,function()
						if hero:isAlive() then
							now_hp = now_hp + hero:get('生命上限') * rate
							hero:set('生命',now_hp)
						end
					end)
				end
			end)
			for _, u in ac.selector()
			    : inRange(point,self.area)
			    : isEnemy(hero)
			    : ofNot '建筑'
			    : ipairs()
			do
				local mover = hero:moverTarget
				{
					model = [[Abilities\Spells\Undead\FreezingBreath\FreezingBreathMissile.mdl]],
					start = point,
					target = u,
					speed = self.speed,
					startHeight = 100,
					finishHeight = 60,
				}
				local skill = self
				function mover:onRemove()
					local damage = skill.damage * hero:get('攻击')
					hero:damage
					{
					    target = u,
					    damage = damage,
					    damage_type = skill.damage_type,
					    skill = skill,
					}
					u:addBuff '冰冻'
					{
						time = skill.stun,
					}
				end
			end
			ac.wait(self.time + self.dying,function()
				if hero:isAlive() then
					hero:speed(1)
					hero:removeRestriction '无敌'
					hero:removeRestriction '硬直'
					hp[hero] = hp[hero] - self.hpdown
				end
			end)
			return false
		end
	end)
end