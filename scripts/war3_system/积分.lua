--11积分，需在war3map.j下声明全局变量[gamecache YYScoreGamecache]才可使用
--local Jglobals = require 'jass.globals'
--local jass = require 'jass.common'
--local japi = require 'jass.japi'
--local YYScore = Jglobals.YYScoreGamecache

--jass.FlushGameCache(jass.InitGameCache('11.x'))
--gamecache = jass.InitGameCache('11.x')

--local function to_letter(i)
--	return string.sub('ABCDEFGHIJKLMNOPQRSTUVWXYZ',i,i + 1)
--end
--local function isLivingPlayer(player)
--	return player:gameState() == '在线' and player:controller() == '用户'
--end

--local local_player
--local function writeToScore(tbl,key,data)
--	if not local_player or not isLivingPlayer(local_player) then
--		for i = 1,12 do
--			local player = ac.player(i)
--			if isLivingPlayer(player) or i == 12 then
--				local_player = player
--				break
--			end
--		end
--	end
--	jass.StoreInteger(YYScore,tbl,key,data)
--	if ac.localPlayer() == local_player then
--		japi.SyncStoredInteger(YYScore,tbl,key)
--	end
--end

--积分API
--function ac.game:getScore(player,key)
--	return japi.GetStoredInteger(YYScore,to_letter(player._handle),key)
--end
--function ac.game:setScore(player,key,value)
--	writeToScore(to_letter(player._handle) ..  '=' ,key,value)
--end
--function ac.game:addScore(player,key,value)
--	writeToScore(to_letter(player._handle) ..  '+' ,key,value)
--end

--通关时结算通关积分
ac.game:event('地图-游戏通关', function()
	for i = 1,sg.max_player do
		local player = ac.player(i)
		if not player._isRemove then
			local score = sg.difficult
			player:message('恭喜通关！所有在线玩家获得了|cffffdd00通关+' .. score .. '|r的积分奖励',5)
			player:add_score('通关',score)
			--ac.game:addScore(player,'通关',score)
		end
	end
end)

--进入无尽后，退出游戏的玩家结算无尽积分
ac.game:event('玩家-退出游戏', function(_,player)
	if sg.ex_mode then
		local score = sg.get_wave()
		player:add_score('无尽',score)
		--ac.game:addScore(player,'无尽',score)
	end
end)