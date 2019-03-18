local mt = ac.skill['张角-雷鸣电闪']

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'spell channel',true)
	local time = self.castStartTime
	local point = hero:getPoint()
	local target = self:getTarget()
	self.load = sg.load_bar({target = point,time = time})
	ac.effect {
	    target = point,
	    model = [[Abilities\Spells\Orc\LightningShield\LightningShieldTarget.mdl]],
	    size = 2,
	    time = 0.6,
	}
end

function mt:onCastChannel()
	local hero = self:getOwner()
	local point = hero:getPoint()
	sg.animation(hero,'spell slam')
	self.angle = {}
	for i = 1,self.direct do
		local angle = hero:getFacing() + 360/self.direct * i
		local distance = self.area * self.count
		local speed = distance/self.castChannelTime
		local dummy = hero:createUnit('张角-闪电预警',point,angle)
		local lighting = ac.lightning {
		    source = point,
		    target = dummy,
		    model = 'CLSB',
		    sourceHeight = 60,
		}
		local mover = hero:moverLine
		{
			mover = dummy,
			start = point,
			distance = distance,
			angle = angle,
			speed = speed,
		}
		function mover:onRemove()
			lighting:remove()
			dummy:remove()
		end
		self.angle[i] = angle
	end
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local area = self.area
	local damage = self.damage * sg.get_allatr(hero)
	sg.animation(hero,'spell throw')
	for i = 1,self.direct do
		local angle = self.angle[i]
		local distance = area * self.count + area
		for i = 1,self.count do
			ac.effect {
			    target = point - {},
			    model = [[effect\Purple Lightning.mdx]],
			    size = area/70,
			    speed = 0.4,
			    time = 3,
			}
		end
		ac.wait(self.wait,function()
			for _, u in ac.selector()
			    : inLine(point,distance,angle,area)
			    : isEnemy(hero)
			    : ofNot '建筑'
			    : ipairs()
			do		
				hero:damage
				{
				    target = u,
				    damage = damage,
				    damage_type = self.damage_type,
				    skill = self,
				}
				u:addBuff '麻痹'
				{
					time = self.stun,
				}
			end
		end)
	end
end