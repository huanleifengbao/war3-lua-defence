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
	['荣光不败的白亚之翼'] = 1,
	['原初的符文'] = 3,
	['土豪玩家'] = 2,
}
local shop_info = {}
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
		--return jass.HaveStoredInteger(get_table(player), '道具', key)
		return true
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
end

require 'shop.新手礼包'
require 'shop.荣光不败的白亚之翼'
require 'shop.原初的符文'
require 'shop.土豪玩家'