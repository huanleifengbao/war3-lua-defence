local tbl = {'飞雷','的卢','赤兔'}

for _,skill_name in ipairs(tbl) do
	local mt = ac.skill[skill_name]

	function mt:onAdd()
	    local hero = self:getOwner()
	    hero:add('战力',self.dam)
		hero:add('抗性',self.mdf)
		hero:add('闪避',self.avo)
	    self.trg = ac.loop(1,function()
	    	local count = hero:get('觉醒等级') + 1
			sg.add_allatr(hero,self.atr * count)
	    end)
		ac.game:eventNotify('地图-获得坐骑', hero:getOwner())
	end

	function mt:onRemove()
		local hero = self:getOwner()
		hero:add('战力',-self.dam)
		hero:add('抗性',-self.mdf)
		hero:add('闪避',-self.avo)
	    self.trg:remove()
	    ac.game:eventNotify('地图-失去坐骑', hero:getOwner())
	end
end