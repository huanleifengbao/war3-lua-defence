local mt = ac.skill['张宝-急冻凝结']

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'spell channel',true)
	local time = self.castStartTime + self.castChannelTime
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
	--随机内外圈
	if sg.get_random(50) then
		self.ring = 1
	else
		self.ring = -1
	end
	--随机撒谎
	if sg.get_random(50) then
		self.lie = true
		ac.effect {
		    target = point,
		    size = 3,
		    model = [[Objects\InventoryItems\QuestionMark\QuestionMark.mdl]],
		    height = 300,
		    time = time,
		}
	end

	if self.ring == 1 then
		--外圈
		self.eff[#self.eff + 1] = ac.effect {
		    target = point,
		    size = area/70,
		    zScale = 0.1,
		    height = 20,
		    model = [[effect\Cosmic Slam.mdx]],
		    time = time,
		}
	else
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
	end
end

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animation(hero,'spell')
end

function mt:do_damage(u)
	local hero = self:getOwner()
	local damage = self.damage * hero:get('攻击')
	hero:damage
	{
	    target = u,
	    damage = damage,
	    damage_type = self.damage_type,
	    skill = self,
	}
	u:addBuff '冰冻'
	{
		time = self.stun,
	}
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local area = self.area
	if self.lie == true then
		self.ring = -self.ring
	end	
	if self.ring == 1 then
		--外圈伤害判定
		local range = self.range
		for _, u in ac.selector()
		    : inRange(point,range)
		    : isEnemy(hero)
		    : ofNot '建筑'
		    : ipairs()
		do
			if u:getPoint() * point > area then
				self:do_damage(u)
			end
		end
		ac.effect {
		    target = point,
		    size = range/200,
		    speed = 2,
		    model = [[effect\icestomp.mdx]],
		    time = 3,
		}
	else
		--内圈伤害判定
		for _, u in ac.selector()
		    : inRange(point,area)
		    : isEnemy(hero)
		    : ofNot '建筑'
		    : ipairs()
		do
			self:do_damage(u)
		end
		ac.effect {
		    target = point,
		    size = area/250,
		    model = [[effect\IceNova.mdx]],
		    time = 1,
		}
	end
end

function mt:onCastStop()
	for _,eff in ipairs(self.eff) do
		if eff then
			eff:remove()
		end
	end
end

function mt:onCastBreak()
    self:onCastStop()
end