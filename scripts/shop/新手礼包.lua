local name = '新手礼包'
local has = {}
local mt = ac.item[name]

function mt:onCanAdd(u)
	local player = u:getOwner()
	local hero = player:getHero()
	local index = player:get_shop_info(name)
	if index < 0 or has[player] == true then
		player:message('|cffffff00您已经领取过|cffffaa00'.. name ..',|cffffff00无法再次领取|r', 5)
		return false
	elseif index > 0 then
		has[player] = true
		player:set_shop_info(name,-1)
		player:message('|cffffff00成功领取|cffffaa00'..name..'|r', 5)
		--木头
		player:add('木材', self.lumber)
		--战魂
		sg.get_sow(hero,self.sow)
		--抽奖券
		player:add_shop_info('抽奖券',self.draw)
	else
		player:message('|cffffff00您未购买|cffffaa00'..name..'|r', 5)
		return false
	end
end