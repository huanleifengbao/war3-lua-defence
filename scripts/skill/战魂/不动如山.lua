local mt = ac.skill['不动如山']

function mt:onAdd()
    local hero = self:getOwner()
    hero:add('战力',self.dam)
    self.trg = hero:event('单位-攻击出手', function (_, _, target, damage, mover)
    	if sg.get_random(self.odds) then
    		sg.add_allatr(hero,self.atr)
		end
    	sg.recovery(hero,self.rec)
	end)
end

function mt:onRemove()
	hero:add('战力',-self.dam)
    self.trg:remove()
end