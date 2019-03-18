local name = '荣光不败的白亚之翼'

local mt = ac.item[name]

function mt:onCanAdd(hero)
	local player = hero:getOwner()
	local index = player:get_shop_info(name)
	if index > 0 then
		player:set_shop_info(name,-1)
		player:message('成功领取' .. name .. '！', 5)
		--特效
		hero:particle([[effect\wing1.mdx]],'chest')
		--攻击获得属性
		hero:event('单位-攻击出手', function (_, _, target, damage, mover)
			sg.add_allatr(hero,self.atk)
		end)
		--每秒获得属性木头
		ac.loop(1,function()
			sg.add_allatr(hero,self.atr)
			player:add('木材', self.lumber)
		end)
		--魔抗
		hero:add('魔抗',self.mdf)
	elseif index < 0 then
		player:message('您已经领取过'.. name .. '，无法再次领取', 5)
		return false
	else
		player:message('您未购买' .. name .. '', 5)
		return false
	end
end