
ac.game:event('单位-死亡', function (_, dead, killer)
    local player_dead = dead:getOwner()
    local player_killer = killer:getOwner()
    if (player_dead == sg.creeps_player or player_dead == sg.enemy_player) and (player_killer:id() >= 1 and player_killer:id() <= sg.max_player) then
        killer:userData('杀敌数', killer:userData('杀敌数') + 1)
        ac.game:eventNotify('地图-英雄杀敌', killer, player_killer, dead)
        print(killer:get('额外金钱'))
        local gold = (dead:get('死亡金钱') + killer:get('击杀金钱')) * (1 + killer:get('额外金钱')/100)
        local lumber = (dead:get('死亡木材') + killer:get('击杀木材')) * (1 + killer:get('额外木材')/100)
        local exp = (dead:get('死亡经验') + killer:get('击杀经验')) * (1 + killer:get('额外经验')/100)
        local msg_height = 140
        if gold > 0 then
            player_killer:add('金币', gold)
            local msg = '|cffffdd00+'..math.floor(gold)..'|n'
            ac.textTag()
                : text(msg, 0.025)
                : at(dead:getPoint(), msg_height)
                : speed(0.025, 90)
                : life(1.5, 0.8)
                : show(function (player)
                    return player == player_killer
                end)
            msg_height = msg_height - 40
        end
        if lumber > 0 then
            player_killer:add('木材', lumber)
            local msg = '|cff25cc75+'..math.floor(lumber)..'|n'
            ac.textTag()
                : text(msg, 0.025)
                : at(dead:getPoint(), msg_height)
                : speed(0.025, 90)
                : life(1.5, 0.8)
                : show(function (player)
                    return player == player_killer
                end)
            msg_height = msg_height - 40
        end
        if exp > 0 then
            killer:addExp(exp, true)
            --[[local msg = '|cff757575+'..math.floor(exp)..'exp|n'
            ac.textTag()
                : text(msg, 0.022)
                : at(dead:getPoint(), msg_height)
                : speed(0.025, 90)
                : life(1.5, 0.8)
                : show(function (player)
                    return player == player_killer
                end)]]
        end
    end
end)