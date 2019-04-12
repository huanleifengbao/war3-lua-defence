local attack_range = 300

local mt = ac.skill['远吕智-陨石流星']

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animation(hero,'stand ready',true)
	local time = self.castChannelTime
	local point = hero:getPoint()
	local target = self:getTarget()
	self.eff = {}
	self.load = sg.load_bar({target = point,time = time})
	self.eff[#self.eff + 1] = ac.effect {
	    target = point,
	    model = [[Abilities\Spells\Human\FlameStrike\FlameStrikeTarget.mdl]],
	    time = 3,
	}
	self.point = {}
	for i = 1,self.count do
		ac.wait(i * self.pulse,function()
			local p = target - {math.random(360),math.random(self.minrandom,self.maxrandom)}
			self.eff[#self.eff + 1] = ac.effect {
			    target = p,
			    size = self.area/350,
			    speed = 1.8/(time + self.wait),
			    model = [[effect\calldown_4.mdx]],
			    height = 20,
			    time = time + self.wait,
			    skipDeath = true,
			}
			self.point[i] = p
		end)
	end
	hero:setFacing(point/self:getTarget(),0.1)
end

function mt:onCastShot()
	local hero = self:getOwner()
	sg.animation(hero,'spell slam')
	local wait = self.wait
	local area = self.area
	for i = 1,self.count do
		ac.wait(i * self.pulse,function()
			local p = self.point[i]
			ac.effect {
			    target = p,
			    model = [[effect\firestone.mdx]],
			    size = area/200,
			    speed = 1/wait,
			    time = 2,
			}
			ac.wait(wait,function()
				for _, u in ac.selector()
				    : inRange(p,area)
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
		end)
	end
end

function mt:onCastStop()
	if self.load then
		self.load:remove()
	end
end

function mt:onCastBreak()
	self:onCastStop()
    for _,eff in ipairs(self.eff) do
		if eff then
			eff:remove()
		end
	end
end

local mt = ac.skill['远吕智-大地摇动']

function mt:do_damage(point,damage)
	local hero = self:getOwner()
	local area = self.area
	for _, u in ac.selector()
	    : inRange(point,area)
	    : isEnemy(hero)
	    : ofNot '建筑'
	    : ipairs()
	do
		hero:damage
		{
		    target = u,
		    damage = damage * u:get '生命上限',
		    damage_type = self.damage_type,
		    skill = self,
		}
	end	
end

function mt:create_fire(point)
	local hero = self:getOwner()
	self:do_damage(point,self.damage/100)
	local damage_pulse = self.damage_pulse
	ac.timer(damage_pulse,self.time/damage_pulse,function()
		self:do_damage(point,self.damage2/100 * damage_pulse)
	end)
end

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animation(hero,'stand ready',true)
	local time = self.castChannelTime
	local point = hero:getPoint()
	self.load = sg.load_bar({target = point,time = time})
	ac.effect {
	    target = point,
	    model = [[Abilities\Spells\NightElf\BattleRoar\RoarCaster.mdl]],
	    size = 2,
	    time = 1,
	}
	hero:setFacing(point/self:getTarget(),0.1)
end

function mt:onCastShot()
	local hero = self:getOwner()
	sg.animation(hero,'spell')
	local point = hero:getPoint()
	local target = self:getTarget()
	local angle = point/target
	local distance = self.distance
	local area = self.area
	local dummy = hero:createUnit('远吕智-激光预警',point,0)
	local wait = self.wait
	local mover = hero:moverLine
	{
		mover = dummy,
		start = point,
		angle = angle,
		speed = distance/wait,
		distance = distance,
	}
	local lighting = ac.lightning {
	    source = point - {angle + 20,130},
	    target = dummy,
	    model = 'AFOD',
	    sourceHeight = 180,
	}
	function mover:onRemove()
		lighting:remove()
		dummy:remove()
	end
	hero:particle([[Abilities\Spells\Orc\Bloodlust\BloodlustSpecial.mdl]],'hand left',1)
	ac.wait(wait,function()
		local dis = 0
		local count = self.count
		local time = self.time		
		ac.timer(self.pulse,count,function()
			dis = dis + distance/count
			local p = point - {angle,dis}
			p = p - {angle + 90,math.random(-50,50)}
			ac.effect {
			    target = p,
			    model = [[Abilities\Spells\Other\Incinerate\FireLordDeathExplode.mdl]],
			    size = area/150,
			    time = 1,
			}
			ac.effect {
			    target = p,
			    model = [[effect\Lava Crack.mdx]],
			    angle = math.random(360),
			    size = area/200,
			    time = time,
			}
			self:create_fire(p)
			time = time - self.pulse
		end)
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

local mt = ac.skill['远吕智-灾厄的三重奏']

function mt:do_damage(area,func)
	local hero = self:getOwner()
	local point = hero:getPoint()
	for _, u in ac.selector()
	    : inRange(point,area)
	    : isEnemy(hero)
	    : ofNot '建筑'
	    : ipairs()
	do
		func(u)
	end
end

function mt:on_eyes(func)
	local hero = self:getOwner()
	local point = hero:getPoint()
	self:do_damage(self.eyearea,function(u)
		local facing = u:getFacing() + 360
		local angle = u:getPoint()/point + 360
		if math.abs(facing%360 - angle%360) <= 60 then
			func(u)
		end
	end)
end

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'stand ready',true)
	local time = self.castStartTime
	local point = hero:getPoint()
	self.eff = {}
	self.eff[#self.eff + 1] = sg.load_bar({target = point,time = time})
	ac.effect {
	    target = point,
	    size = 2,
	    model = [[Abilities\Spells\Other\HowlOfTerror\HowlCaster.mdl]],
	    time = 1,
	}
	local area = self.area	
	--内圈
	self.eff[#self.eff + 1] = ac.effect {
	    target = point,
	    size = area/200,
	    zScale = 0.1,
	    height = 20,
	    model = [[effect\Cosmic Slam.mdx]],
	    time = time,
	}
	self.eff[#self.eff + 1] = ac.effect {
	    target = point,
	    size = area/600,
	    zScale = 0.1,
	    height = 20,
	    model = [[effect\Cosmic Slam.mdx]],
	    time = time,
	}
	--石化眼
	self.eff[#self.eff + 1] = ac.effect {
	    target = point,
	    size = 5,
	    height = 50,
	    model = [[Abilities\Spells\Human\MagicSentry\MagicSentryCaster.mdl]],
	    time = time + self.pulse,
	}
	self.eff[#self.eff + 1] = ac.timer(0.5,(time + self.pulse + self.pulse2)/0.5,function()
		self:on_eyes(function(u)
			u:addBuff '即将石化'
			{
				source = hero,
				time = 0.6,
			}
		end)
	end)
	ac.wait(self.pulse,function()

	end)
	hero:setFacing(point/self:getTarget(),0.1)
end

function mt:onCastChannel()
	local hero = self:getOwner()
	local point = hero:getPoint()
	hero:speed(1.5/self.castChannelTime)
	sg.animation(hero,'spell slam')
	local area = self.area
	--内圈伤害判定
	ac.effect {
	    target = point,
	    size = area/250,
	    height = 20,
	    speed = 2,
	    model = [[effect\BloodSlam.mdx]],
	    time = 1,
	}
	ac.effect {
	    target = point,
	    model = [[Abilities\Spells\Human\MarkOfChaos\MarkOfChaosDone.mdl]],
	    time = 1,
	}
	self:do_damage(area,function(u)
		local damage = self.damage/100 * u:get '生命上限'
		hero:damage
		{
		    target = u,
		    damage = damage,
		    damage_type = self.damage_type,
		    skill = self,
		}
	end)
	local time = self.pulse
	self.eff[#self.eff + 1] = sg.load_bar({target = point,time = time})
	--外圈
	self.eff[#self.eff + 1] = ac.effect {
	    target = point,
	    size = area/70,
	    zScale = 0.1,
	    height = 20,
	    model = [[effect\Cosmic Slam.mdx]],
	    time = time,
	}
	ac.wait(time,function()
		if not self.is_stop then
			--外圈伤害判定
			self:do_damage(self.range,function(u)
				if u:getPoint() * point > area then
					local damage = self.damage2/100 * u:get '生命上限'
					hero:damage
					{
					    target = u,
					    damage = damage,
					    damage_type = self.damage_type,
					    skill = self,
					}
				end
			end)
			ac.effect {
			    target = point,
			    size = area/40,
			    zScale = 0.1,
			    height = 20,
			    speed = 2,
			    model = [[effect\Blood Explosion.mdx]],
			    time = 1,
			}
			ac.effect {
			    target = point,
			    model = [[Abilities\Spells\Human\MarkOfChaos\MarkOfChaosDone.mdl]],
			    time = 1,
			}
			time = self.pulse2
			self.eff[#self.eff + 1] = sg.load_bar({target = point,time = time})
			ac.wait(time,function()
				if not self.is_stop then
					--石化眼判定
					ac.effect {
					    target = point,
					    size = area/100,
					    zScale = 1,
					    model = [[effect\Lightning Boom.mdx]],
					    time = 1,
					}
					self:on_eyes(function(u)
						u:addBuff '石化'
						{
							time = self.stone,
						}
					end)
				end
			end)
		end
	end)
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	sg.animation(hero,'spell')
	hero:speed(1)
end

function mt:onCastStop()
	self.is_stop = true
	for _,eff in ipairs(self.eff) do
		if eff then
			eff:remove()
		end
	end
	local hero = self:getOwner()
	hero:speed(1)
end

function mt:onCastBreak()
    self:onCastStop()
end