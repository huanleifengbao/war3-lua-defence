local mt = ac.skill['白亚之翼']

function mt:onAdd()
	local hero = self:getOwner()
	local player = hero:getOwner()
	--特效
	self.eff = hero:particle([[effect\wing1.mdx]],'chest')
	--攻击获得属性
	self.trg = hero:event('单位-攻击出手', function (_, _, target, damage, mover)
		sg.add_allatr(hero,self.atk)
	end)
	--每秒获得属性木头
	self.timer = ac.loop(1,function()
		sg.add_allatr(hero,self.atr)
		player:add('木材', self.lumber)
	end)
	--魔抗
	hero:add('魔抗',self.mdf)
end

function mt:onRemove()
	local hero = self:getOwner()
	self.eff()
	self.trg:remove()
	self.timer:remove()
	hero:add('魔抗',-self.mdf)
end

local mt = ac.skill['时为朦胧的雪花之翼']

function mt:onAdd()
	local hero = self:getOwner()
	local player = hero:getOwner()
	--特效
	self.eff = hero:particle([[effect\wing2.mdx]],'chest')
	--攻击获得属性
	self.trg = hero:event('单位-攻击出手', function (_, _, target, damage, mover)
		sg.add_allatr(hero,self.atk)
	end)
	--每秒获得属性木头
	self.timer = ac.loop(1,function()
		sg.add_allatr(hero,self.atr)
		player:add('木材', self.lumber)
	end)
	--魔抗
	hero:add('魔抗',self.mdf)
end

function mt:onRemove()
	local hero = self:getOwner()
	self.eff()
	self.trg:remove()
	self.timer:remove()
	hero:add('魔抗',-self.mdf)
end