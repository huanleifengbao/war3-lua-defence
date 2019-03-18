local name = '土豪玩家'

local mt = ac.item[name]

function mt:onCanAdd(hero)
	local player = hero:getOwner()
	local index = player:get_shop_info(name)
	if index > 0 then
		player:set_shop_info(name,-1)
		player:message('成功领取' .. name .. '！', 5)
		--特效
		hero:particle([[effect\tuhaowanjia.mdx]],'overhead')
		--木头
		player:add('木材', self.lumber)
		--抽奖券
		player:add_shop_info('抽奖券',self.draw)		
		--攻击获得木头
		hero:event('单位-攻击出手', function (_, _, target, damage, mover)
			player:add('木材', self.atk)
		end)
		--杀敌获得属性
		ac.game:event('单位-死亡', function (_, dead, killer)
			if killer == hero then
				sg.add_allatr(hero,self.atr)
			end
		end)
		--属性加成
		hero:add('战力',self.mdf)
		hero:add('魔抗',self.mdf)
		hero:add('吸血',self.leap)
	elseif index < 0 then
		player:message('您已经领取过'.. name .. '，无法再次领取', 5)
		return false
	else
		player:message('您未购买' .. name .. '', 5)
		return false
	end
end