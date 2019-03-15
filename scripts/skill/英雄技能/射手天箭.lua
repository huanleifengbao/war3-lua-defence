local mt = ac.skill['射手天箭']

function mt:shot(point,angle,pulse)
	local hero = self:getOwner()
	local area = self.area
	local time = self.time
	local dis = area * 0.3
	local wait = pulse/3
	for i = -1,1 do
		ac.wait(pulse * (i + 1),function()
			local target = point - {angle + 90,dis * i}
			target = target - {math.random(360),math.random(area * 0.2)}
			ac.effect {
			    target = target,
			    model = [[effect\RainOfArrow.mdx]],
			    angle = math.random(360),
			    speed = 1/time,
			    time = 1,
			}
		end)
	end
	ac.effect {
	    target = point - {angle + 90,math.random(-50,50)},
	    model = [[effect\WhiteElement.mdx]],
	    size = area/500,
	    speed = 0.8/time,
	    time = 2,
	}
	--伤害
	ac.wait(time,function()
		for _, u in ac.selector()
		    : inRange(point,area)
		    : isEnemy(hero)
		   	: filter(function(u)
			    return not self.mark[u]
			end)
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
			self.mark[u] = true
		end
	end)
end

function mt:onCastShot()
    local hero = self:getOwner()
    local point = hero:getPoint()
	local target = self:getTarget()
	local distance = self.distance
	local area = self.area
	local speed = self.speed
	local angle = point/target
	local dis = area/2
	local pulse = dis/speed
	local count = 1
	self.mark = {}
	ac.timer(pulse,distance/dis - 1,function()
		local p = point - {angle,speed * count * pulse}
		count = count + 1
		self:shot(p,angle,pulse)
	end)
end