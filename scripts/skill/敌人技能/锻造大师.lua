local mt = ac.skill['锻造大师-看破斩']

function mt:onAdd()
	local hero = self:getOwner()
	sg.add_ai_skill(hero)
	hero:event('单位-复活',function()
		sg.add_ai_skill(hero)
	end)
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
	sg.animation(hero,'spell one',true)
	local mover = self:do_back(hero,target)
	hero:addRestriction '无敌'
	ac.timer(0.05,5,function()
		local u = hero:createUnit('锻造大师-残影',point,angle)
		sg.animation(u,'spell one',true)
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
			skill.block = u
			local p = u:getPoint()
			skill.blink_point = sg.on_block(p,p - {angle,skill.knock_distance})
			hero:setFacing(hero:getPoint()/u:getPoint(),0)
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
	sg.animation(hero,'spell')
end

function mt:do_damage(u,angle)
	local hero = self:getOwner()
	local damage = self.damage * hero:get('攻击')
	hero:damage
	{
	    target = u,
	    damage = damage,
	    damage_type = self.damage_type,
	    skill = self,
	}
	local p = u:getPoint()
	local target = sg.on_block(p,p - {angle,self.knock_distance})
	hero:moverLine
	{
		mover = u,
		start = p,
		target = target,
		speed = self.knock_speed,
	}
	u:particle([[Abilities\Spells\Other\Stampede\StampedeMissileDeath.mdl]],'chest')()
end

function mt:onCastFinish()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local angle = hero:getFacing()
	local block = self.block
	local distance = self.back
	if block then
		distance = point * block:getPoint()
	end
	local target = sg.on_block(point,point - {angle,distance})
	local skill = self
	local mover = hero:moverLine
	{
		mover = hero,
		target = target,
		speed = self.speed,
		hitArea = self.area,
		hitType = '敌方',
	}
	
	function mover:onHit(u)
		skill:do_damage(u,angle)
	end
	hero:addRestriction '硬直'
	ac.wait(self.actiontime,function()
		hero:removeRestriction '硬直'
		--见切成功，气刃大回旋
		if block and hero:isAlive() then
			hero:addRestriction '硬直'
			distance = self.distance
			local p = self.blink_point
			angle = angle + 180
			sg.animation(hero,'spell slam')
			target = sg.leap_block(p,p - {angle,distance * 0.75})			
			ac.wait(0.5,function()
				if hero:isAlive() then
					hero:blink(p - {angle,-distance * 0.25})
					hero:setFacing(angle,0)
					ac.wait(0.35,function()
						if hero:isAlive() then
							local mover = hero:moverLine
							{
								mover = hero,
								target = target,
								speed = self.speed,
								hitArea = self.area,
								hitType = '敌方',
							}		
							function mover:onHit(u)
								skill:do_damage(u,angle)
							end
							ac.wait(1.15,function()
								hero:removeRestriction '硬直'
							end)
						end
					end)
				end
			end)
		end
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

function mt:onCastBreak()
    self:onCastStop()
end