local skill_name = '势如破竹'
local mt = ac.skill[skill_name]

function mt:onEnable()
	self.open = true
	self:setOption('description', ac.table.skill[skill_name].description)
	local hero = self:getOwner()
	hero:add('战力',self.dam)
	self.trg = hero:event('单位-攻击出手', function (_, _, target, damage, mover)
		if sg.get_random(self.rec_odds) then
    		sg.recovery(hero,self.rec)
		end
	end)
	self.trg2 = ac.game:event('单位-死亡', function (_, dead, killer)
		if killer == hero and sg.get_random(self.odds) then
			local count = hero:get('觉醒等级')
			sg.add_allatr(hero,self.atr * count)
		end
	end)
	ac.game:eventNotify('地图-获得战魂', hero)
end

function mt:onDisable()
	local msg = '|cffffcc00 未解锁|n|n|r'
	self:setOption('description', msg..ac.table.skill[skill_name].description)
	if self.open then
		self.open = false
	else
		return
	end
	local hero = self:getOwner()
	hero:add('战力',-self.dam)
	self.trg:remove()
	self.trg2:remove()
	ac.game:eventNotify('地图-失去战魂', hero)
end