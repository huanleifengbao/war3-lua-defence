
ac.game:event('单位-死亡', function (_, dead, killer)
    local player_dead = dead:getOwner()
    local player_killer = killer:getOwner()
    if player_dead:id() == 11 and (player_killer:id() >= 1 and player_killer:id() <= 6) then
        ac.game:eventNotify('地图-英雄杀敌', killer, player_killer, dead)
        killer:addExp(20 * dead:level(), true)
    end
end)