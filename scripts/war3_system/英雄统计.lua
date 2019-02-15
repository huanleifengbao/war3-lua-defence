
ac.game:event('单位-死亡', function (_, dead, killer)
    local player_dead = dead:getOwner()
    local player_killer = killer:getOwner()
    if player_dead:id() == 11 and (player_killer:id() >= 1 and player_killer:id() <= 6) then
        ac.game:eventNotify('地图-英雄杀敌', killer, player_killer, dead)
        killer:addExp(20 * dead:level(), true)
        player_killer:add('金币', 100)
        player_killer:add('木材', 10)
        ac.textTag()
            : text('文字内容', 0.1)
            : at(dead:get_point(), 100)
            : speed(0.2, 45)
            : life(2, 1)
            : show(function (player)
                return player == player_killer
            end)
    end
end)