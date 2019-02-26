local mt = ac.skill['倾国倾城']

function mt:do_damage(damage,target)
	local hero = self:getOwner()
	local area = self.area
	for _,u in ac.selector()
	    : inRange(target,self.area)
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

function mt:love(target)
	local area = self.area
	--桃心特效数
	local count = 30
	local pi = math.pi
	for i = 1,count do
		local x,y = target:getXY()
		local a = 2 * pi/count * i
		--local dis = area * (1 - math.sin(a))
		local m = math.sin(a)
		local n = math.cos(a)
		local dis = m * math.sqrt(math.abs(n))/(m + 1.4) - 2 * m + 2
		local p = target - {360/count * i,dis * area * 0.3}
		p[2] = p[2] + area * 0.3
		ac.effect {
		    target = p,
		    model = [[effect\AbstruseMetathesis.mdx]],
		    time = 1,
		}	
	end
	--圈圈特效数
	local count = 30
	for i = 1,count do
		local p = target - {360/count * i,area * 0.9}
		ac.effect {
		    target = p,
		    model = [[effect\AbstruseMetathesis.mdx]],
		    time = 1,
		}
	end
end

function mt:onCastShot()
    local hero = self:getOwner()
    local target = self:getTarget()
    local area = self.area
    local count = 6
    local add = area * 0.3
    local distance = 0
    ac.timer(0.2,3,function()
    	distance = distance + add
    	local a = math.random(360)
    	for i = 1,count do
	    	local p = target - {360/count * i + a,distance}
	    	ac.effect {
			    target = p,
			    model = [[Objects\Spawnmodels\NightElf\NECancelDeath\NECancelDeath.mdl]],
			    time = 1,
			}
    	end
    	count = count + 6
    end)
    self:do_damage(self.damage * sg.get_allatr(hero),target)
    ac.timer(self.pulse,self.count,function()
    	self:love(target)
    	self:do_damage(self.damage2 * sg.get_allatr(hero),target)
    end)
end