local mt = ac.skill['头号玩家']
local has = {}
function mt:onAdd()
	local hero = self:getOwner()
	local player = hero:getOwner()
	--特效
	self.eff = hero:particle([[effect\bw_wanjiadebaba.mdx]],'overhead')
	if not has[player] then
		--木头
		player:add('木材', self.lumber)
		--抽奖券
		player:add_shop_info('抽奖券',self.draw)
	end
	--攻击获得木头
	self.trg = hero:event('单位-攻击出手', function (_, _, target, damage, mover)
		player:add('木材', self.atk)
	end)
	--杀敌获得属性
	self.trg2 = ac.game:event('单位-死亡', function (_, dead, killer)
		if killer == hero then
			sg.add_allatr(hero,self.atr)
		end
	end)
	--属性加成
	hero:add('战力',self.mdf)
	hero:add('魔抗',self.mdf)
	hero:add('吸血',self.leap)
	has[player] = true
end

function mt:onRemove()
	local hero = self:getOwner()
	self.eff()
	self.trg:remove()
	self.trg2:remove()
	hero:add('战力',-self.mdf)
	hero:add('魔抗',-self.mdf)
	hero:add('吸血',-self.leap)
end