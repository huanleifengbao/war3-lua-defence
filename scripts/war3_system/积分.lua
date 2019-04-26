--积分战力加成
ac.game:event('地图-选择英雄', function(_, hero, player)
    local score = math.floor(tonumber(player:get_score('战力值')))
    local damage = math.floor(score/10)
    if damage > 0 then
	    player:message('您拥有' .. score .. '点|cffffdd00战力值|r积分,获得了|cffffdd00' .. damage .. '%|r的战力奖励。',5)
	    hero:add('战力',damage)
    end
end)

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
ac.game:event('地图-进攻开始', function(_,wave)
	if sg.ex_mode then
		local score = wave - 1
		if score > 0 then
			for i = 1,sg.max_player do
				local player = ac.player(i)			
				if not player._isRemove then
					player:add_score('无尽',score)
					player:message('所有在线玩家获得了|cffffdd00无尽+' .. score .. '|r的积分奖励',5)
				end
			end
		end
	end
end)

--每分钟提交杀敌数量的积分
function sg.kill_score()
	for i = 1,sg.max_player do
		local rate = 100
		local player = ac.player(i)
		if sg.player_kill_count[player] and not player._isRemove then
			local score = math.floor(sg.player_kill_count[player]/rate)
			sg.player_kill_count[player] = sg.player_kill_count[player] - score * rate
			player:add_score('杀敌',score)
		end
	end
end
ac.loop(60,function()
	sg.kill_score()
end)