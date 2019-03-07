local mt = ac.skill['刹那无影剑']

function mt:finish()
	local hero = self:getOwner()
	local dummy = self.dummy
	dummy:blink(hero:getPoint())
	dummy:setFacing(hero:getFacing())
	ac.effect {
	    target = dummy:getPoint(),
	    model = [[Abilities\Spells\Items\AIil\AIilTarget.mdl]],
	    time = 1,
	}
	ac.wait(self.pulse,function()		
		dummy:remove()
	end)
end

function mt:do_damage(boolean)
	local hero = self:getOwner()
	local list = self.list
	local dummy = self.dummy
	if #list <= 0 then
		self:finish()
		return
	end
	local pulse = self.pulse
	if boolean then
		pulse = 0
	end
	ac.wait(self.pulse,function()
		local u
		for i = #list,1,-1 do
			local unit = list[i]
			table.remove(list,i)
			self.eff[unit]:remove()
			if unit:isAlive() then
				u = unit
				break										
			end
		end
		if u then
			local angle = u:getFacing()
			dummy:blink(u:getPoint() - {angle - 180,50})
			dummy:setFacing(angle)
			sg.animation(dummy,'attack')
			sg.effectU(u,'chest',[[Abilities\Spells\Orc\LightningBolt\LightningBoltMissile.mdl]],0)
			local damage = self.damage * sg.get_allatr(hero) + hero:get '攻击'
			hero:damage
			{
			    target = u,
			    damage = damage,
			    damage_type = self.damage_type,
			    attack = true,
			    skill = self,
			}
			self:do_damage()
		else
			self:finish()
		end
	end)
end

function mt:onCastShot()
    local hero = self:getOwner()
    local target = self:getTarget()
    local area = self.area
    local list = {}
    self.eff = {}
    for _,u in ac.selector()
	    : inRange(target,self.area)
	    : isEnemy(hero)
	    : ipairs()
	do
		table.insert(list,u)
		self.eff[u] = sg.effectU(u,'origin',[[Abilities\Spells\Other\HowlOfTerror\HowlTarget.mdl]])
	end
	ac.effect {
	    target = target,
	    model = [[Abilities\Spells\Items\AIil\AIilTarget.mdl]],
	    xScale = area/150,
	    yScale = area/150,
	    zScale = area/750,
	    time = 1,
	}	
	if #list > 0 then
		local dummy = hero:createUnit('刘备-分身',hero:getPoint(),hero:getFacing())
		sg.set_color(dummy,{a = 200})
		sg.animationSpeed(dummy,2)
		sg.effectU(dummy,'weapon',[[Abilities\Weapons\PhoenixMissile\Phoenix_Missile_mini.mdl]])
		sg.effectU(dummy,'hand',[[Abilities\Weapons\FaerieDragonMissile\FaerieDragonMissile.mdl]])
		self.list = list
		self.dummy = dummy	
		self:do_damage(true)
	end
end