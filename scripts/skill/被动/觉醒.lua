local tbl = {}
for i = 0,10 do
	table.insert(tbl,i .. '阶觉醒')
end

for _,skill_name in ipairs(tbl) do
	local mt = ac.skill[skill_name]

	function mt:onAdd()
	    local hero = self:getOwner()
	    sg.add_allatr(hero,self.add)
	    self.trg = ac.loop(1,function()
			sg.add_allatr(hero,self.atr)
	    end)
	end

	function mt:onRemove()
	    self.trg:remove()
	end
end