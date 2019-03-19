--获取商城道具
local mt = {}

local function to_letter(i)
	return string.sub('ABCDEFGHIJKLMNOPQRSTUVWXYZ',i,i + 1)
end

local function get_table(player)
	local playerid = player._handle
	if not mt[playerid] then
		local string = '11billing@' .. to_letter(playerid)
		mt[playerid] = jass.InitGameCache(string)
	end
	return mt[playerid]
end
--商城道具列表
local item = {
	['新手礼包'] = 92219,
	['荣光不败之翼'] = 92248,
	['原初的符文'] = 3,
	['土豪玩家'] = 2,
	['时为朦胧的雪花之翼'] = 0,
}
local shop_info = {}
local equip = {}
for i = 1,sg.max_player do
	local player = ac.player(i)
	player.get_status = function(self,key)
		return jass.GetStoredInteger(get_table(player), '状态', key)
	end
	player.get_item = function(self,key)
		return jass.GetStoredInteger(get_table(player), '道具', key)
	end
	player.has_status = function(self,key)
		return jass.HaveStoredInteger(get_table(player), '状态', key)
	end
	player.has_item = function(self,key)
		return jass.HaveStoredInteger(get_table(player), '道具', key)
	end
	shop_info[player] = {}
	local info = shop_info[player]
	player.get_shop_info = function(self,key)
		if not info[key] then
			info[key] = 0
		end
		return info[key]
	end
	player.add_shop_info = function(self,key,num)
		local now = player:get_shop_info(key)
		info[key] = now + num
	end
	player.set_shop_info = function(self,key,num)
		info[key] = num
	end
	--初始化玩家商城信息
	for key,id in pairs(item) do
		if player:has_item(id) then
			player:add_shop_info(key,1)
		end
	end
	equip[player] = {}
end

--领取装备类物品逻辑
for name,_ in pairs(item) do
	local mt = ac.item[name]
	local itemtype = mt.itemtype
	if itemtype then
		function mt:onCanAdd(u)
			local player = u:getOwner()
			local hero = player:getHero()
			local now_equip = equip[player]		
			if player:get_shop_info(name) > 0 then
				local skill = now_equip[itemtype]
				if not skill or skill:getName() ~= name then
					if skill and skill:getName() ~= name then
						player:message('|cffffff00替换|cffff00ff'..itemtype..'|cffffff00:|cffffaa00'..name..'|r', 5)
					else
						player:message('|cffffff00成功领取|cffff00ff'..itemtype..'|cffffff00:|cffffaa00'..name..'|r', 5)
					end
					if skill then
						skill:remove()
					end
					now_equip[itemtype] = hero:addSkill(name,'技能',3)
				else
					player:message('|cffffff00您已经装备|cffffaa00'.. name ..'|r', 5)
					return false
				end
			else
				player:message('|cffffff00您未购买|cffffaa00' .. name .. '|r', 5)
				return false
			end
		end
	end
end

require 'shop.新手礼包'
require 'shop.翅膀'
require 'shop.光环'
require 'shop.称号'