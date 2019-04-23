local mt = ac.skill['卞喜-神圣护甲']

function mt:onAdd()
	local hero = self:getOwner()
	self.trg = hero:event('单位-即将受到伤害',function()
		hero:addBuff '无敌'
		{
			time = self.time,
		}
	end)
end

function mt:onRemove()
	self.trg:remove()
end