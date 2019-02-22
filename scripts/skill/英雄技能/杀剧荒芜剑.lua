local mt = ac.skill['杀剧荒芜剑']

function mt:do_damage(damage)
	local hero = self:getOwner()
	for _, u in ac.selector()
	    : inRange(self.target,self.area)
	    : isEnemy(hero)
	    : ipairs()
	do
		hero:damage
		{
		    target = u,
		    damage = damage,
		    damage_type = self.damage_type,
		    skill = self,
		}
	end
end

function mt:onCastShot()
    local skill = self
    local hero = skill:getOwner()
    local target = skill:getTarget()
    local count = self.count
    local area = self.area
    local add = 360/count
    local wait = self.wait
    local pulse = self.pulse
    local pulse2 = self.pulse2
    for i = 1,count do
	    local a = add * i
	    local p1 = target - {a,area}
	    local p2 = target - {a + add,area}
	   	local line = hero:createUnit('通用马甲',p1,0)
	    local dummy = hero:createUnit('赵云-分身',target,a)
	    sg.effectU(dummy,'weapon',[[Abilities\Weapons\ZigguratMissile\ZigguratMissile.mdl]])
	    sg.effectU(dummy,'weapon',[[Abilities\Weapons\IllidanMissile\IllidanMissile.mdl]])
	    local moverline = hero:moverLine
	    {
			mover = line,
			start = p1,
			target = p2,
			speed = (p1 * p2)/wait,
	    }
	    function moverline:onRemove()
		    line:remove()
	    end
	    local mover = hero:moverTarget
	    {
			mover = dummy,
			start = target,
			target = line,
			speed = area/wait * 1.3,
	    }
	    sg.animationI(dummy,9,true)
	    function mover:onRemove()
		    local p = dummy:getPoint()
		    local angle = p / target
		    local distance = area * 2
		    dummy:setFacing(angle)
		    sg.animation(dummy,'attack')
		    local mover = hero:moverLine
		    {
				mover = dummy,
				start = p,
				angle = p / target,
				speed = distance / pulse,
				distance = distance,
		    }
		    function mover:onRemove()
			    ac.wait(pulse,function()
			    	sg.animation(dummy,'spell slam')
				    dummy:setFacing(angle + 180)
				    ac.wait(1,function()
				    	dummy:remove()
				    end)
			    end)
		    end
	    end
    end
    --伤害
    self.target = target
    ac.wait(wait,function()
    	local damage = skill.damage * sg.get_allatr(hero)
    	self:do_damage(damage)
    end)
    ac.wait(wait + pulse + pulse2,function()
    	local damage = skill.damage2 * sg.get_allatr(hero)
    	self:do_damage(damage)
    	local eff = hero:createUnit('赵云-爆炸',target,0)
    	ac.wait(1,function()
    		eff:remove()
    	end)
    end)
end