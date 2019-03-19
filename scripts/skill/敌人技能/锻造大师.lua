local mt = ac.skill['锻造大师-看破斩']

function mt:onAdd()
	local hero = self:getOwner()
	sg.add_ai_skill(hero)
end

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'attack slam')
	local time = self.castStartTime
	local point = hero:getPoint()
	self.load = sg.load_bar({target = point,time = time})
end

function mt:do_back(u,target)
	local mover = u:moverLine
    {
		mover = u,
		target = target,
		speed = self.back/self.backtime,
	}
	return mover
end

function mt:onCastChannel()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local angle = hero:getFacing()
	local target = sg.on_block(point,point - {angle,-self.back})
	sg.animation(hero,'spell slam',true)
	ac.wait(0.5,function()
		if hero:isAlive() and not self.is_stop then
			hero:speed(0)
		end
	end)
	local mover = self:do_back(hero,target)
	hero:addRestriction '无敌'
	ac.timer(0.05,5,function()
		local u = hero:createUnit('锻造大师-残影',point,angle)
		sg.set_color(u,{a = 0.5})
		local mover = self:do_back(u,target)
		function mover:onRemove()
			u:remove()
		end
	end)
	local skill = self
	function mover:onRemove()
		hero:removeRestriction '无敌'
		skill.trg = hero:event('单位-即将受到伤害',function(_,_,damage)
			local u = damage.source
			skill.block = u:getPoint()
			hero:setFacing(hero:getPoint()/skill.block,0.01)
			hero:particle([[Abilities\Spells\Items\SpellShieldAmulet\SpellShieldCaster.mdl]],'origin')()
			u:particle([[Abilities\Spells\Other\TalkToMe\TalkToMe.mdl]],'overhead',0.5)
			u:addBuff '眩晕'
			{
				time = skill.stun,
			}
			return false
		end)
	end
end

function mt:onCastShot()
	if self.trg then
		self.trg:remove()
	end
	local hero = self:getOwner()
	hero:speed(1)
end

function mt:onCastFinish()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local angle = hero:getFacing()
	local distance = 100
	local block = self.block
	if block then
		distance = self.distance
		angle = point/block + 180
		point = block - {angle,-distance/2}
		hero:blink(point)
		hero:setFacing(angle,0.01)
	end
	local target = sg.on_block(point,point - {angle,distance})
	local mover = hero:moverLine
	{
		mover = hero,
		target = target,
		speed = self.speed,
		hitArea = self.area,
		hitType = '敌方',
	}
	local skill = self
	function mover:onHit(u)
		local damage = skill.damage * sg.get_allatr(hero)
		hero:damage
		{
		    target = u,
		    damage = damage,
		    damage_type = skill.damage_type,
		    skill = skill,
		}
		u:particle([[Abilities\Spells\Other\Stampede\StampedeMissileDeath.mdl]],'chest')()
	end
	hero:addRestriction '硬直'
	ac.wait(self.actiontime,function()
		hero:removeRestriction '硬直'
	end)
end

function mt:onCastStop()
	local hero = self:getOwner()
	hero:speed(1)
	self.is_stop = true
	if self.load then
		self.load:remove()
	end
	if self.trg then
		self.trg:remove()
	end
end