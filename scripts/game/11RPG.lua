local jass = require 'jass.common'
local japi = require 'jass.japi'
local has_record = not not japi.InitGameCache
log.debug('积分环境', has_record)

local names = {
	'FlushGameCache',
	'InitGameCache',
	'StoreInteger',
	'GetStoredInteger',
	'StoreString',
	'SaveGameCache',
    'SyncStoredInteger',
    'HaveStoredInteger',
}
for _, name in ipairs(names) do
	if not japi[name] then
		rawset(japi, name, jass[name])
	end
end

local function get_key(player)
	local i = player:id()
	return string.sub('ABCDEFGHIJKLMNOPQRSTUVWXYZ',i - 1,i)
end

local function is_player(player)
	return player:controller() == '用户' and player:gameState() == '在线'
end

local record_data = {}
for player in ac.eachPlayer() do
	--获取积分对象
	function player.__index:record()
		if not record_data[self] then
			if is_player(self) then
				record_data[self] = japi.InitGameCache('11billing@' .. get_key(self))
			else
				record_data[self] = japi.InitGameCache('')
			end
		end
		return record_data[self]
	end

	--判断玩家是否有商城道具(用来做判断皮肤，人物，地图内特权VIP)等等
	function player.__index:has_item(key)
		if has_record then
			return japi.HaveStoredInteger(self:record(), "状态", key)-- or (ShopItem and ShopItem[self:get_name()] and ShopItem[self:get_name()]:find(key))
		end
		return false
	end

	--扣除玩家一个次数类道具（例如逃跑清除卡，使用后道具 - 1）扣除成功后返回true 失败返回false
	function player.__index:sub_item(key,i)
		return japi.EXNetUseItem(self.handle,key,i)
	end



	-- RPG积分相关
	local score_gc
	local function get_score()
		if not score_gc then
			japi.FlushGameCache(japi.InitGameCache("11.x"))
			score_gc = japi.InitGameCache("11.x")
		end
		return score_gc
	end

	local current_player
	local function get_player()
		if current_player and is_player(current_player) then
			return current_player
		end
		for i = 1, 12 do
			if is_player(ac.player(i)) then
				current_player = ac.player(i)
				return current_player
			end
		end
		return ac.player(1)
	end

	local function write_score(table, key, data)
		japi.StoreInteger(get_score(), table, key, data)
		if get_player() == ac.localPlayer() then
			japi.SyncStoredInteger(get_score(), table, key)
		end
	end

	local function read_score(table, key)
		return japi.GetStoredInteger(get_score(), table, key)
	end

	local score = {}

	function player.__index:get_score(name)
		if not score[name] then
			score[name] = {}
		end
		if not score[name][self.id] then
			score[name][self.id] = read_score(get_key(self), name)
		end
		log.debug(('获取RPG积分:[%s][%s] --> [%s]'):format(self:name(), name, score[name][self.id]))
		return tostring(score[name][self.id])
	end

	function player.__index:set_score(name, value)
		if not score[name] then
			score[name] = {}
		end
		score[name][self.id] = value
		log.debug(('设置RPG积分:[%s][%s] = [%s]'):format(self:name(), name, value))
		if has_record then
			write_score(get_key(self) .. "=", name, value)
		else
			write_score(get_key(self), name, value)
		end
	end

	function player.__index:add_score(name, value)
		local r = self:get_score(name) + value
		score[name][self.id] = r

		local type = '增加'
		if value < 0 then
			type = '减少'
		end

		log.debug((type..'RPG积分:[%s][%s] + [%s]'):format(self:name(), name, value))
		if has_record then
			write_score(get_key(self) .. "+", name, value)
		else
			write_score(get_key(self), name, value + self:get_score(name))
		end
	end
	--获取地图等级
	function player.__index:get_level()
	    local value = self:get_score 'level'
		log.debug(('获取RPG等级:[%s] --> [%s]'):format(self:name(), value))
		return value
	end
end

--function ac.game:score_game_end()
--	write_score("$", "GameEnd", 0)
--end