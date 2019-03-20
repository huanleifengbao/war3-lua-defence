
ac.wait(0, function()
    sg.game_mod = '通常'
	for i = 1,sg.max_player do
        local player = ac.player(i)
        if player:controller() == '用户' and player:gameState() == '在线' then
            print('玩家'..i..'正在选择难度')
            for i2 = 1,sg.max_player do
                local msg_player = ac.player(i2)
                local msg_id = msg_player:id()
                msg_player:message(sg.player_colour[msg_id]..msg_player:name()..'|r正在选择难度', 10)
            end
            local dialog = player:dialog{
                '选择难度',
                {'1', 'Q', '|cff00ff00Easy(Q)|r'},
                {'2', 'W', '|cffffff00Normal(W)|r'},
                {'3', 'E', '|cffff0000Hard(E)|r'},
                {'4', 'R', '|cffff00ffLunatic(R)|r'},
            }
            function dialog:onClick(name)
	            sg.difficult = tonumber(name)
                ac.game:eventNotify('地图-选择难度', tonumber(name))
                print('====难度选择完毕,游戏开始====')
            end
            break
        end
    end
end)