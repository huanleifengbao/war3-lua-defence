local mt = ac.skill['势如破竹']

function mt:onAdd()
    local hero = self:getOwner()
    hero:add('战力',self.dam)
    self.trg = hero:event('单位-攻击出手', function (_, _, target, damage, mover)
    	sg.recovery(hero,self.rec)
	end)
	self.trg2 = ac.game:event('单位-死亡', function (_, dead, killer)
		if killer == hero and sg.get_random(self.odds) then
			local count = hero:get('觉醒等级')
			sg.add_allatr(hero,self.atr * count)
		end
	end)
end

function mt:onRemove()
	hero:add('战力',-self.dam)
    self.trg:remove()
    self.trg2:remove()
end