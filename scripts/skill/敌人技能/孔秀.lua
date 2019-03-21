local mt = ac.skill['孔秀-战争践踏']

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'stand channel',true)
	local time = self.castStartTime + self.castChannelTime
	local point = hero:getPoint()
	self.eff = {}
	self.eff[#self.eff + 1] = sg.load_bar({target = point,time = time})
	ac.effect {
	    target = point,
	    size = 2,
	    model = [[Abilities\Spells\NightElf\BattleRoar\RoarCaster.mdl]],
	    time = 1,
	}
	local area = self.area
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

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animation(hero,'spell slam')
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local area = self.area
	for _, u in ac.selector()
	    : inRange(point,area)
	    : isEnemy(hero)
	    : ofNot '建筑'
	    : ipairs()
	do
		local damage = self.damage * hero:get('攻击')
		hero:damage
		{
		    target = u,
		    damage = damage,
		    damage_type = self.damage_type,
		    skill = self,
		}
		u:addBuff '眩晕'
		{
			time = self.stun,
		}
	end
	ac.effect {
	    target = point,
	    size = area/250,
	    model = [[effect\DarkBlast.mdx]],
	    time = 1,
	}
end