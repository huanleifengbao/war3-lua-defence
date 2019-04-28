local mt = ac.skill['狂雷奔腾']

function mt:onCastChannel()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local target = self:getTarget()
	local angle = point/target
	local time = self.castChannelTime
	local count = time/0.18
	local area = self.area
	local loop = 0
	local mark = {}
	hero:particle([[Abilities\Weapons\Bolt\BoltImpact.mdl]],'weapon')()
	local timer = ac.timer(0.18,count,function()
		for i = 1,2 do
			local a = angle - 180 + loop * 180/count * (-1)^i
			local p = point - {a,area * 0.5}
			ac.effect {
			    target = p,
			    model = [[Abilities\Weapons\Bolt\BoltImpact.mdl]],
			    time = 1,
			}
			local lnt = ac.lightning {
	            source = p,
	            target = point - {a,area * 1.5},
	            model = 'CHIM',
	            targetHeight = 2000,
	        }
	        ac.wait(0.5, function()
	            lnt:remove()
	        end)
		end
		loop = loop + 1
		for _, u in ac.selector()
		    : inRange(point,area)
		    : isEnemy(hero)
		    : filter(function (u)
		        return not mark[u]
		    end)
		    : ipairs()
		do
			u:addBuff '麻痹'
			{
				time = self.stun,
			}
			mark[u] = true
		end
	end)
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local target = self:getTarget()
	local angle = point/target
	local distance = self.distance
	local area = self.area
	local count = 5
	local loop = 0
	local timer = ac.timer(0.05,count,function()
		loop = loop + 1
		local p = point - {angle,loop * distance/count}
		local lnt = ac.lightning {
	            source = p,
	            target = p,
	            model = 'CHIM',
	            targetHeight = 2000,
	    }
	    ac.wait(0.5, function()
	        lnt:remove()
	    end)
		ac.effect {
		    target = p,
		    model = [[Abilities\Spells\Human\Thunderclap\ThunderClapCaster.mdl]],
		    size = area/300,
		    time = 1,
		}
	end)
	local group = {}
	for _, u in ac.selector()
	    : inRange(point,area)
	    : isEnemy(hero)
	    : ipairs()
	do
		table.insert(group,u)
	end
	for _, u in ac.selector()
	    : inLine(point,distance + area/2,angle,area*2)
	    : isEnemy(hero)
	    : ipairs()
	do
		table.insert(group,u)
	end
	local damage = self.damage * sg.get_allatr(hero)
	for _,u in ipairs(group) do		
		hero:damage
		{
		    target = u,
		    damage = damage,
		    damage_type = self.damage_type,
		    skill = self,
		    attack = true,
		}
	end
end