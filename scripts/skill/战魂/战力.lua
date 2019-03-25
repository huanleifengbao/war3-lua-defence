local tbl = {'横扫千军','妙手回春','森罗万象','不动如山'}

for _,skill_name in ipairs(tbl) do
	local mt = ac.skill[skill_name]

	function mt:onAdd()
	    local hero = self:getOwner()
	    hero:add('战力',self.dam)
	    self.trg = hero:event('单位-攻击出手', function (_, _, target, damage, mover)
	    	if sg.get_random(self.odds) then
	    		sg.add_allatr(hero,self.atr)
			end
	    	sg.recovery(hero,self.rec)
		end)
		ac.game:eventNotify('地图-获得战魂', hero)
	end

	function mt:onRemove()
		local hero = self:getOwner()
		hero:add('战力',-self.dam)
	    self.trg:remove()
	    ac.game:eventNotify('地图-失去战魂', hero)
	end
end