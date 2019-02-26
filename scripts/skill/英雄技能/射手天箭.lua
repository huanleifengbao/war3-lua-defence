local mt = ac.skill['射手天箭']

function mt:shot(point,angle,pulse)
	local hero = self:getOwner()
	local area = self.area
	local time = self.time
	local dis = area * 0.3
	local wait = pulse/3
	for i = -1,1 do
		local target = point - {angle + 90,dis * i}
		target = target - {math.random(360),math.random(area * 0.2)}
		local dummy = hero:createUnit('黄忠-射手天箭',target,0)
		--ac.wait(math.random(10)/100,function()
		ac.wait(pulse * (i + 1),function()
		    local mover = hero:moverLine
		    {
				mover = dummy,
				distance = 1,
				angle = angle,
				speed = 1/time,
				startHeight = 2000,
			}
			function mover:onRemove()
				ac.effect {
				    target = target,
				    model = [[Abilities\Weapons\GlaiveMissile\GlaiveMissileTarget.mdl]],
				    size = 0.5,
				    angle = math.random(360),
				    time = 1,
				}

				ac.wait(2,function()					
					dummy:remove()
				end)
			end
		end)
	end
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