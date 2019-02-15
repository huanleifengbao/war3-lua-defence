
ac.game:event('单位-死亡', function (_, dead, killer)
    local player_dead = dead:getOwner()
    local player_killer = killer:getOwner()
    if player_dead:id() == 11 and (player_killer:id() >= 1 and player_killer:id() <= 6) then
        ac.game:eventNotify('地图-英雄杀敌', killer, player_killer, dead)
        killer:addExp(20 * dead:level(), true)
        local gold = 100
        local lumber = 10
        player_killer:add('金币', gold)
        player_killer:add('木材', lumber)
        local msg = '|cffffdd00+'..gold..'|n'
        ac.textTag()
            : text(msg, 0.025)
            : at(dead:getPoint(), 120)
            : speed(0.025, 90)
            : life(1.5, 0.8)
            : show(function (player)
                return player == player_killer
            end)
        local msg = '|cff25cc75+'..lumber..'|n'
        ac.textTag()
            : text(msg, 0.025)
            : at(dead:getPoint(), 80)
            : speed(0.025, 90)
            : life(1.5, 0.8)
            : show(function (player)
                return player == player_killer
            end)
    end
end)