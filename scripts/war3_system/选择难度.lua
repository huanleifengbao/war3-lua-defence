
ac.wait(0, function()
    for i = 1, 6 do
        local player = ac.player(i)
        if player:controller() == '用户' and player:gameState() == '在线' then
            print('玩家'..i..'正在选择难度')
            local dialog = player:dialog{
                '选择难度',
                {'1', 'Q', '|cff00ff00Easy(Q)|r'},
                {'2', 'W', '|cffffff00Normal(W)|r'},
                {'3', 'E', '|cffff0000Hard(E)|r'},
                {'4', 'R', '|cffff00ffLunatic(R)|r'},
            }
            function dialog:onClick(name)
                ac.game:eventNotify('地图-选择难度', tonumber(name))
            end
            break
        end
    end
end)