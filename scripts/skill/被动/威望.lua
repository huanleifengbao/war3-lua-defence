local tbl = {}
for i = 1,7 do
	table.insert(tbl,i .. '级威望')
end

for _,skill_name in pairs(tbl) do
	local mt = ac.skill[skill_name]

	function mt:onAdd()
	    local hero = self:getOwner()
	    hero:add('战力',self.damage)
	end

	function mt:onRemove()
		local hero = self:getOwner()
	    hero:add('战力',-self.damage)
	end
end