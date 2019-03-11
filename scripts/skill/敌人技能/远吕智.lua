local attack_range = 300

local mt = ac.skill['远吕智-灾厄的三重奏']

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