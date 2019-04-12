local mt = ac.skill['张梁-狂风吹拂']

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
	local x,y = point:getXY()
	local start = ac.point(x - 1000,y + 1000)
	for i = 0,3 do
		for j = 0,1 do
			local angle = 270 * j
			local direct = angle - 90 + 180 * j
			local p = start - {angle,i * self.area * 2}
			local lnt = ac.lightning {
			    source = p,
			    target = p - {direct,self.distance},
			    model = 'DRAM',
			    sourceHeight = 10,
			    targetHeight = 10,
			}
			self.eff[#self.eff + 1] = lnt
			ac.wait(time,function()
				lnt:remove()
			end)
		end
	end
end

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animation(hero,'spell throw')
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local area = self.area
	local x,y = point:getXY()
	local start = ac.point(x - 1000,y + 1000)
	local skill = self	
	if self.lie == true then
		start = ac.point(x - 1000 + area,y + 1000 - area)
	end	
	local hit = {}
	local distance = self.distance
	for i = 0,3 do
		for j = 0,1 do
			local angle = 270 * j
			local direct = angle - 90 + 180 * j
			local p = start - {angle,i * self.area * 2}
			local mover = hero:moverLine
			{
				start = p,
				model = [[effect\getsugabluenew.mdx]],
				angle = direct,
				distance = distance,
				speed = distance/0.5,
				hitArea = area/2,
				hitType = '敌方'
			}
			function mover:onHit(u)
				if not hit[u] then
					local damage = skill.damage/100 * u:get '生命上限'
					hero:damage
					{
					    target = u,
					    damage = damage,
					    damage_type = skill.damage_type,
					    skill = skill,
					}
					u:addBuff '击飞'
					{
						height = 500,
						time = skill.stun,
					}
					hit[u] = true
				end
			end
		end
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