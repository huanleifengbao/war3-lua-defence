local start = {}

local mt = ac.skill['王植-台风眼']

function mt:onAdd()
	local hero = self:getOwner()
	hero:cast(self:getName(),hero:getPoint())
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local area = self.area
	self.eff = {}
	local range = area + self.ring * 2
	local size = self.ring/500
	for i = 1,36 do
		local p = point - {i * 10,area + size * 250}
		local eff = ac.effect{
		    target = p,
		    model = [[effect\Lava Crack.mdx]],
		    size = size,
		}
		table.insert(self.eff,eff)
	end
	--for i = 1, 12 do
	--	local i_angle = 30 * i
	--	for j = 1, 6 do
	--		i_angle = i_angle + math.random(-25, 25)
	--		local p = point - {i_angle, area + j * 100 + size * 250}
	--		local eff = ac.effect{
	--		    target = p,
	--		    model = [[effect\Lava Crack.mdx]],
	--		    size = size,
	--		}
	--	end
	--end
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
					local distance = dis - area + 300
					local mover = hero:moverLine
					{
						mover = u,
						distance = distance,
						speed = distance/0.2,
						angle = u:getPoint()/point,
					}
					local damage = self.damage/100 * u:get '生命上限'
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
	local target = start[hero] - {math.random(8) * 45,self.distance}
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

function mt:do_damage(angle)
	local hero = self:getOwner()
	local point = hero:getPoint()
	local area = self.area
	for _, u in ac.selector()
	    : inLine(point,self.count * area,angle,area * 2)
		: isEnemy(hero)
		: ofNot '建筑'
		: ipairs()
	do
		hero:moverLine
		{
			mover = u,
			distance = 500,
			speed = 2000,
			angle = angle,
		}
		local damage = self.damage/100 * u:get '生命上限'
		hero:damage
		{
		    target = u,
		    damage = damage,
		    damage_type = self.damage_type,
		    skill = self,
		}
	end
end

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
			for i = -1,1 do
				local a = angle + 45 * i
				self:do_damage(a)
				local distance = 0
				ac.timer(self.pulse,count,function()
					distance = distance + area
					local p = point - {a,distance}
					ac.effect {
					    target = p,
					    model = [[Abilities\Spells\Other\Incinerate\FireLordDeathExplode.mdl]],
					    size = area/150,
					    time = 1,
					}
				end)
			end
			for i = 1,count do
				local time = self.castChannelTime + self.pulse * i
				for j = -1.5,1.5 do					
					local p = point - {angle + 45 * j,i * area}
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
			for i = -1.5,1.5 do
				local a = angle + 45 * i
				self:do_damage(a)
				local distance = 0
				ac.timer(self.pulse,count,function()
					distance = distance + area
					local p = point - {a,distance}
					ac.effect {
					    target = p,
					    model = [[Abilities\Spells\Other\Incinerate\FireLordDeathExplode.mdl]],
					    size = area/150,
					    time = 1,
					}
				end)
			end
		end
	end)
end

local function createDD(hero,target)
	local point = hero:getPoint()
	local DD = hero:createUnit('王植-DD',point,target/point)
	sg.animation(DD,'stand alternate',true)
	local mover = hero:moverLine
	{
		mover = DD,
		start = point,
		target = target,
		speed = point * target / 1.5,
		parameter = true,
		middleHeight = 300,
	}
	function mover:onRemove()
		sg.animation(DD,'birth')
	end
	return DD
end

local mt = ac.skill['王植-暴击之究极幻想']

function mt:onCastChannel()
	local hero = self:getOwner()
	hero:addBuff '无敌'
	{
		time = self.castChannelTime + self.castShotTime,
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
    local angle = math.random(360)
    for i = 1,self.count do
	    local p = start[hero] - {angle + i * self.radius/(self.count-1),self.distance}
	    local DD = createDD(hero,p)
	    ac.wait(self.wait + self.pulse * i,function()
	    	DD:cast('王植-DD冲锋',start[hero])
	    end)
    end
end

function mt:onCastFinish()
	local hero = self:getOwner()
	local point = hero:getPoint()
	ac.effect {
        target = point,
        model = [[Abilities\Spells\Human\MarkOfChaos\MarkOfChaosTarget.mdl]],
        size = 2,
        time = 0,
    }
    ac.wait(1,function()
    	if hero:isAlive() then
    		hero:removeRestriction '隐藏'
    		hero:removeRestriction '硬直'
    		sg.animation(hero,'stand',true)
		end
	end)
end

local function congya(DD,distance,time)
	local point = DD:getPoint()
	local angle = DD:getFacing()
	ac.effect {
        target = point,
        model = [[Abilities\Spells\Other\Doom\DoomDeath.mdl]],
        size = 1,
        time = 0,
    }
	local mover = DD:moverLine
	{
		start = point,
		mover = DD,
		angle = angle,
		distance = distance,
		speed = distance/time,
	}
	local dis = 0
	ac.timer(0.02,10,function()
		dis = dis + distance/10
		local p = point - {angle,dis}
		for i = -1,1 do
			ac.effect {
		        target = p - {angle + 90,200 * i},
		        model = [[Abilities\Spells\Other\Doom\DoomDeath.mdl]],
		        size = 0.75,
		        time = 0,
		    }		
		end
	end)
	return mover
end

local mt = ac.skill['王植-DD冲锋']

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animation(hero,'stand alternate',true)
	local point = hero:getPoint()
	local time = self.castChannelTime
	self.load = sg.load_bar({target = point,time = time})
	hero:setFacing(point/self:getTarget(),0.1)
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local target = self:getTarget()
	local angle = point/target
	local area = self.area
	local distance = self.distance
	ac.effect {
        target = point,
        model = [[Abilities\Spells\Other\Doom\DoomDeath.mdl]],
        size = 1,
        time = 0,
    }
    for _, u in ac.selector()
	    : inLine(point,distance,angle,area)
		: isEnemy(hero)
		: ofNot '建筑'
		: ipairs()
	do
		hero:moverLine
		{
			mover = u,
			distance = distance + 200 - point * u:getPoint(),
			speed = distance/0.5,
			angle = angle,
		}
	end
	local mover = congya(hero,self.distance,self.time)
	function mover:onRemove()
		hero:kill(hero)
	end
end

local mt = ac.skill['王植-乱击之究极幻想']

function mt:onCastChannel()
	local hero = self:getOwner()
	hero:addBuff '无敌'
	{
		time = 11,
	}
	hero:addRestriction '硬直'
	sg.animation(hero,'death')
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
    local random = math.random(8) * 45
    self.target = start[hero] - {random,self.distance}
    self.DD = createDD(hero,start[hero] - {random + -1^math.random(1,2) * 90,self.distance + 100})
end

function mt:onCastFinish()
	local hero = self:getOwner()
	local point = self.target
	ac.effect {
        target = point,
        model = [[Abilities\Spells\Human\MarkOfChaos\MarkOfChaosTarget.mdl]],
        size = 2,
        time = 0,
    }
    local p = start[hero]
    local DD = self.DD
    hero:blink(point)
    ac.wait(1,function()
    	if hero:isAlive() then
    		hero:removeRestriction '隐藏'
    		hero:setFacing(point/p,0.1)
    		ac.wait(2,function()
    			hero:removeRestriction '硬直'
    			hero:cast('王植-冲拳',p)
    			DD:cast('王植-DD冲锋',p)
    			for i = -1,1,2 do
	    			local a = DD:getPoint()/p + 45 * i
	    			local dd = hero:createUnit('王植-DD',p - {a,self.distance + 100},a + 180)
	    			ac.effect {
				        target = dd:getPoint(),
				        model = [[Abilities\Spells\Other\Doom\DoomDeath.mdl]],
				        size = 2,
				        time = 0,
				    }
					sg.animation(dd,'birth')
					ac.wait(1.5,function()
						dd:cast('王植-DD冲锋',p)
					end)
    			end
    		end)
		end
	end)
end