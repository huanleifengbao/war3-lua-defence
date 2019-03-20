local has = {}

local name = '新手礼包'
has[name] = {}
local mt = ac.item[name]

function mt:onCanAdd(u)
	local player = u:getOwner()
	local hero = player:getHero()
	local index = player:get_shop_info(name)
	if index < 0 or has[name][player] == true then
		return false,'|cffffff00您已经领取过|cffffaa00'.. name ..',|cffffff00无法再次领取|r'
	elseif index > 0 then
		has[name][player] = true
		player:set_shop_info(name,-1)
		player:message('|cffffff00成功领取|cffffaa00'..name..'|r', 5)
		--木头
		player:add('木材', self.lumber)
		--战魂
		sg.get_sow(hero,self.sow)
		--抽奖券
		player:add_shop_info('抽奖券',self.draw)
	else
		return false,'|cffffff00您未购买|cffffaa00'..name..'|r'
	end
end

local name = '锻造礼包'
has[name] = {}
local mt = ac.item[name]

function mt:onCanAdd(u)
	local player = u:getOwner()
	local hero = player:getHero()
	local index = player:get_shop_info(name)
	if index < 0 or has[name][player] == true then
		return false,'|cffffff00您已经领取过|cffffaa00'.. name ..',|cffffff00无法再次领取|r'
	elseif index > 0 then
		has[name][player] = true
		player:set_shop_info(name,-1)
		player:message('|cffffff00成功领取|cffffaa00'..name..'|r', 5)
		--成功率
		hero:addBuff '锻造成功率上升'
		{
			time = 0,
			odds = 20,
		}
		--强化券
		local item = hero:create_item('锻造保护券')
		item:stack(self.ticket)
	else
		return false,'|cffffff00您未购买|cffffaa00'..name..'|r'
	end
end

local mt = ac.buff['锻造成功率上升']
mt.coverGlobal = 1
mt.keep = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNRepair.blp]]
mt.title = '锻造成功率上升'
mt.description = '该玩家的锻造成功率提升了。'

function mt:onCover(new)
    self.odds = self.odds + new.odds
    return false
end
