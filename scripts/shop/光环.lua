local mt = ac.skill['原初的符文']

function mt:onAdd()
	local hero = self:getOwner()
	local player = hero:getOwner()
	--特效
	hero:particle([[effect\arua1.mdx]],'origin')
	--攻击获得属性
	self.trg = hero:event('单位-攻击出手', function (_, _, target, damage, mover)
		sg.add_allatr(hero,self.atr)
	end)
	--每秒获得木头
	self.timer = ac.loop(1,function()
		player:add('木材', self.lumber)
	end)
	--战力
	hero:add('战力',self.dam)
end

function mt:onRemove()
	local hero = self:getOwner()
	self.eff()
	self.trg:remove()
	self.timer:remove()
	hero:add('战力',-self.mdf)
end