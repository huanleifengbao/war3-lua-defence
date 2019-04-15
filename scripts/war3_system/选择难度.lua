
local mark = false
ac.wait(0, function()
    sg.game_mod = '通常'
	for i = 1,sg.max_player do
        local player = ac.player(i)       
        if player:controller() == '用户' and player:gameState() == '在线' then
            print('玩家'..i..'正在选择难度')
            for i2 = 1,sg.max_player do
                local msg_player = ac.player(i2)
                local msg_id = msg_player:id()
                msg_player:message(sg.player_colour[i]..player:name()..'|r正在选择难度', 10)
            end
            local dialog = player:dialog{
                '选择难度',
                {'1', 'Q', '|cff00ff00简单(Q)|r'},
                {'2', 'W', '|cffffff00普通(W)|r'},
                {'3', 'E', '|cffff0000困难(E)|r'},
                {'4', 'R', '|cffff00ff噩梦(R)|r'},
            }
            local time = 20
            player:message('请在|cffffcc00'..time..'|r内选择,超时将自动选择|cff00ff00简单|r难度', 10)
            --超时没点默认简单
            local timer = ac.wait(time, function()
                if mark == true then
                    return
                end
                mark = true
                dialog:hide()
                ac.game:eventNotify('地图-选择难度', 1, player)
            end)
            local msg = '选择难度'
            player:timerDialog(msg, timer)
            function dialog:onClick(name)
                if mark == true then
                    return
                end
                mark = true
                timer:remove()
                sg.difficult = tonumber(name)
                --参数:对话框信息,选难度的玩家
                ac.game:eventNotify('地图-选择难度', tonumber(name), player)
                print('====难度选择完毕,游戏开始====')
            end
            break
        end
    end
end)