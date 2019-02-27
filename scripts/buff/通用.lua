local mt = ac.buff['眩晕']

function mt:onAdd()
	local u = self:getOwner()
	self.eff = sg.effectU(u,'overhead',[[Abilities\Spells\Human\Thunderclap\ThunderclapTarget.mdl]])
	u:addRestriction '硬直'
end

function mt:onRemove()
	local u = self:getOwner()
	self.eff:remove()
	u:removeRestriction '硬直'
end