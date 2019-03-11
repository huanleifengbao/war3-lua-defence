local attack_range = 300

local mt = ac.skill['李傕-八刀一闪']

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'stand ready',true)
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
	    height = 250,
	    model = [[Abilities\Spells\Human\Invisibility\InvisibilityTarget.mdl]],
	    time = 1,
	}
	self.eff = hero:particle([[Abilities\Weapons\ZigguratFrostMissile\ZigguratFrostMissile.mdl]],'weapon')
	self.eff2 = hero:particle([[Abilities\Weapons\ZigguratMissile\ZigguratMissile.mdl]],'weapon')
	self.eff3 = hero:particle([[Abilities\Weapons\ChimaeraLightningMissile\ChimaeraLightningMissile.mdl]],'weapon')
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local angle = hero:getFacing()
	local distance = self.distance
	local count = self.count
	local area = self.area
	local time = self.time
	local pulse = self.pulse
	sg.animationI(hero,5)
	hero:speed(3)
	local target = sg.on_block(point,point - {angle,distance})	
	local mover = hero:moverLine
    {
		mover = hero,
		target = target,
		speed = distance/0.1,
	}
	local skill = self
	function mover:onRemove()
		hero:speed(1)
		skill.eff()
		skill.eff2()
		skill.eff3()
	end
	ac.wait(time,function()
		for i = 1,count do
			local p = point - {angle,distance/count * i - attack_range}
			local tbl = {2,3}
			if sg.get_random(50) then
				tbl = {3,2}
			end
			local unit = {}
			for j = 1,2 do
				local u = hero:createUnit('李傕-八刀一闪',p,angle)
				u:speed(2.6 - 0.2 * i)
				sg.animationI(u,tbl[j])
				sg.set_color(u,{a = 0})
				unit[j] = u
			end
			ac.wait(0.1 + pulse * i,function()
				ac.wait(0.5,function()
					for i = 1,2 do
						unit[i]:remove()
					end
				end)
				for _, u in ac.selector()
				    : inRange(p,area)
				    : isEnemy(hero)
				    : ofNot '建筑'
				    : ipairs()
				do
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
			end)
		end
	end)
end

function mt:onCastStop()
	if self.load then
		self.load:remove()
	end
	self.eff()
	self.eff2()
	self.eff3()
end

local mt = ac.skill['李傕-次元空间斩']

function mt:onCastStart()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local target = self:getTarget()
	local angle = point/target
	local time = self.castStartTime
	local distance = self.back
	target = sg.on_block(point,point - {angle,-distance})
	sg.animation(hero,'spell throw')
	hero:speed(0.6/time)
	local mover = hero:moverLine
    {
		mover = hero,
		target = target,
		speed = distance/time,
	}
	function mover:onRemove()
		hero:speed(1)
	end
end

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animation(hero,'stand ready')
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
	    height = 250,
	    model = [[Abilities\Spells\Human\Invisibility\InvisibilityTarget.mdl]],
	    time = 1,
	}	
	local target = self:getTarget()
	ac.effect {
	    target = target,
	    model = [[effect\Dimension Slash.mdx]],
	    size = self.area/300,
	    speed = 0.6/time,
	    time = time * 2,
	}
end

function mt:onCastShot()
	local hero = self:getOwner()
	local target = self:getTarget()
	local area = self.area
	sg.animationI(hero,0)
	ac.effect {
	    target = target,
	    model = [[effect\DarkBlast.mdx]],
	    size = self.area/250,
	    time = 1,
	}
	for _, u in ac.selector()
	    : inRange(target,area)
	    : isEnemy(hero)
	    : ofNot '建筑'
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