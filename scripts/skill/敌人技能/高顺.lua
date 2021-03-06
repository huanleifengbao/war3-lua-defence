local attack_range = 300

local mt = ac.skill['高顺-八刀一闪']

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'stand ready',true)
	local time = self.castStartTime
	local point = hero:getPoint()
	self.load = sg.load_bar({target = point,time = time})
	ac.effect {
	    target = point,
	    size = 2,
	    height = 250,
	    model = [[Abilities\Spells\Human\Invisibility\InvisibilityTarget.mdl]],
	    time = 1,
	}
	self.eff = {}
	self.eff[#self.eff + 1] = hero:particle([[Abilities\Weapons\ZigguratFrostMissile\ZigguratFrostMissile.mdl]],'weapon')
	self.eff[#self.eff + 1] = hero:particle([[Abilities\Weapons\ZigguratMissile\ZigguratMissile.mdl]],'weapon')
	self.eff[#self.eff + 1] = hero:particle([[Abilities\Weapons\ChimaeraLightningMissile\ChimaeraLightningMissile.mdl]],'weapon')
	hero:setFacing(point/self:getTarget(),0.1)
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
		for _,eff in ipairs(skill.eff) do
			eff()
		end
	end
	ac.wait(time,function()
		local mark = {}
		for i = 1,count do
			local p = point - {angle,distance/count * i - attack_range}
			local tbl = {2,3}
			if sg.get_random(50) then
				tbl = {3,2}
			end
			local unit = {}
			for j = 1,2 do
				local u = hero:createUnit('高顺-八刀一闪',p,angle)
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
				    : filter(function(u)
				        return not mark[u]
				    end)
				    : ipairs()
				do
					local damage = skill.damage/100 * u:get '生命上限'
					hero:damage
					{
					    target = u,
					    damage = damage,
					    damage_type = skill.damage_type,
					    skill = skill,
					}
					u:particle([[Abilities\Spells\Other\Stampede\StampedeMissileDeath.mdl]],'chest')()
					mark[u] = true
				end
			end)
		end
	end)
end

function mt:onCastStop()
	if self.load then
		self.load:remove()
	end
	for _,eff in ipairs(self.eff) do
		eff()
	end
end

function mt:onCastBreak()
    self:onCastStop()
end

local mt = ac.skill['高顺-次元空间斩']

function mt:onCastStart()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local target = self:getTarget():getPoint()
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
	hero:setFacing(point/self:getTarget(),0.1)
end

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animation(hero,'stand ready')
	local time = self.castChannelTime
	local point = hero:getPoint()
	self.load = sg.load_bar({target = point,time = time})
	ac.effect {
	    target = point,
	    size = 2,
	    height = 250,
	    model = [[Abilities\Spells\Human\Invisibility\InvisibilityTarget.mdl]],
	    time = 1,
	}
	self.target_point = self:getTarget():getPoint()
	ac.effect {
	    target = self.target_point,
	    model = [[effect\Dimension Slash.mdx]],
	    size = self.area/200,
	    speed = 0.6/time,
	    time = time * 2,
	}
end

function mt:onCastShot()
	local hero = self:getOwner()
	local target = self.target_point
	local area = self.area
	sg.animationI(hero,0)
	ac.wait(0.2,function()
		ac.effect {
		    target = target,
		    model = [[effect\DarkBlast.mdx]],
		    size = self.area/200,
		    time = 1,
		}
		for _, u in ac.selector()
		    : inRange(target,area)
		    : isEnemy(hero)
		    : ofNot '建筑'
		    : ipairs()
		do
			local damage = self.damage/100 * u:get '生命上限'
			hero:damage
			{
			    target = u,
			    damage = damage,
			    damage_type = self.damage_type,
			    skill = self,
			}
		end
	end)
end

function mt:onCastStop()
	if self.load then
		self.load:remove()
	end
end

function mt:onCastBreak()
    self:onCastStop()
end