local start = {}

local mt = ac.skill['王植-台风眼']

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local area = self.area
	self.eff = {}
	local size = self.range/1000
	for i = 1,40 do
		local p = point - {i * 9,area + size * 100}
		local eff = ac.effect{
		    target = p,
		    model = [[effect\Flame Aura.mdx]],
		    size = size,
		}
		table.insert(self.eff,eff)
	end
	local range = self.range
	local mark = {}
	self.timer = ac.loop(0.05,function()
		if hero:isAlive() then
			for _, u in ac.selector()
			    : inRange(point,range)
			    : isEnemy(hero)
			    : ofNot '建筑'
			    : filter(function (u)
			        return not mark[u]
			    end)
			    : ipairs()
			do		
				local dis = u:getPoint() * point
				if dis > area then
					mark[u] = true
					local distance = dis - area + 25
					local mover = hero:moverLine
					{
						mover = u,
						distance = distance,
						speed = distance/0.1,
						angle = u:getPoint()/point,
					}
					local damage = self.damage * hero:get('攻击')
					hero:damage
					{
					    target = u,
					    damage = damage,
					    damage_type = self.damage_type,
					    skill = self,
					}
					function mover:onRemove()
						mark[u] = nil
					end
				end
			end
		else
			for _,eff in ipairs(self.eff) do
				eff:remove()
			end
			self.timer:remove()
			print('ea')
		end
	end)
	start[hero] = point
end

local mt = ac.skill['王植-追击之究极幻想']

function mt:onCastChannel()
	local hero = self:getOwner()
	hero:addBuff '无敌'
	{
		time = self.castChannelTime + self.castShotTime + 7,
	}
	hero:addRestriction '硬直'
	sg.animation(hero,'death',true)
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	ac.effect {
        target = point,
        model = [[Abilities\Spells\Other\Doom\DoomDeath.mdl]],
        size = 2,
        time = 0,
    }
    hero:addRestriction '隐藏'
end

function mt:onCastFinish()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local target = start[hero] - {math.random(4) * 90,self.distance}
	ac.effect {
        target = target,
        model = [[Abilities\Spells\Human\MarkOfChaos\MarkOfChaosTarget.mdl]],
        size = 2,
        time = 0,
    }
    hero:blink(target)
    ac.wait(1,function()
    	if hero:isAlive() then
    		hero:removeRestriction '隐藏'
    		hero:removeRestriction '硬直'
    		hero:cast('王植-冲拳',start[hero])
		end
	end)
end

local mt = ac.skill['王植-冲拳']

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'stand channel',true)
	local time = self.castStartTime + self.wait
	local point = hero:getPoint()
	local target = self:getTarget()
	local angle = point/target
	self.load = sg.load_bar({target = point,time = time})
	hero:setFacing(angle,0.1)
	local area = self.area
	for i = 1,self.count do
		for j = -1,1 do
			local new_time = time + self.pulse * i
			local p = point - {angle + 45 * j,i * area}
			ac.effect {
			    target = p,
			    size = area/350,
			    speed = 1.8/new_time,
			    model = [[effect\calldown_4.mdx]],
			    height = 20,
			    time = new_time,
			    skipDeath = true,
			}
		end
	end
end

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animation(hero,3)
	local point = hero:getPoint()
	local target = self:getTarget()
	local angle = point/target
	local area = self.area
	local count = self.count
	ac.wait(self.wait,function()
		if hero:isAlive() then
			local distance = 0
			ac.timer(self.pulse,count,function()
				distance = distance + area
				for i = -1,1 do
					local p = point - {angle + 45 * i,distance}
					ac.effect {
					    target = p,
					    model = [[Abilities\Spells\Other\Incinerate\FireLordDeathExplode.mdl]],
					    size = area/150,
					    time = 1,
					}
				end
			end)
			for i = 1,count do
				local time = self.castChannelTime + self.pulse * i
				for j = -1,1,2 do					
					local p = point - {angle + 22.5 * j,i * area}
					ac.effect {
					    target = p,
					    size = area/350,
					    speed = 1.8/time,
					    model = [[effect\calldown_4.mdx]],
					    height = 20,
					    time = time,
					    skipDeath = true,
					}
				end
			end
		end
	end)
end

function mt:onCastShot()
	local hero = self:getOwner()
	sg.animation(hero,4)
	local point = hero:getPoint()
	local target = self:getTarget()
	local angle = point/target
	local area = self.area
	local count = self.count
	ac.wait(self.wait,function()
		if hero:isAlive() then
			local distance = 0
			ac.timer(self.pulse,count,function()
				distance = distance + area
				for i = -1,1,2 do
					local p = point - {angle + 22.5 * i,distance}
					ac.effect {
					    target = p,
					    model = [[Abilities\Spells\Other\Incinerate\FireLordDeathExplode.mdl]],
					    size = area/150,
					    time = 1,
					}
				end
			end)
		end
	end)
end