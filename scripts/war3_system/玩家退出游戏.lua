
for i = 1,sg.max_player do
    local player = ac.player(i)
    player:event('玩家-退出游戏', function()
        local hero = player:getHero()
        if hero then
            sg.player_count = sg.player_count - 1
            player:message(sg.player_colour[i]..hero:getName()..'|cffff0000退出|r了游戏', 10)
            ac.game:eventNotify('地图-删除英雄', hero, player)
            hero:remove()
            for _, unit in ipairs(sg.family[player]) do
                unit:remove()
            end
        end
    end)
end