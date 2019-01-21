
ac.game:event('地图-选择英雄', function (_, unit, player)
    unit:event('单位-死亡', function (_, dead, killer)
        local reborn_time = 5
        print(unit:getName()..'屎了'..'....他被'..killer:getName()..'谋害')
        ac.game:eventNotify('地图-英雄死亡', unit, player, reborn_time)
        local timer = ac.wait(reborn_time, function()
            local reborn_p = ac.point(7044, -10529)
            unit:reborn(reborn_p, true)
            unit:set('魔法', unit:get('魔法上限'))
            player:moveCamera(reborn_p, 0.2)
        end)
        local msg = '玩家'..player:id()..'复活时间'
        player:timerDialog(msg, timer)
    end)
end)