local name = '新手礼包'

local mt = ac.item[name]

function mt:onCanAdd(hero)
	local player = hero:getOwner()
	local index = player:get_shop_info(name)
	if index > 0 then
		player:set_shop_info(name,-1)
		player:message('成功领取' .. name .. '！', 5)
		--木头
		player:add('木材', self.lumber)
		--战魂
		sg.get_sow(hero,self.sow)
		--抽奖券
		player:add_shop_info('抽奖券',self.draw)
	elseif index < 0 then
		player:message('您已经领取过'.. name .. '，无法再次领取', 5)
		return false
	else
		player:message('您未购买' .. name .. '', 5)
		return false
	end
end