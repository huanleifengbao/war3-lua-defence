local pick_mark = {}

for i = 1, 6 do
    ac.player(i):event('玩家-选中单位', function (trg, player, unit)
        if unit:getOwner():id() == 16 and not player:getHero() then
            if pick_mark[i] == unit then
                trg:remove()
                unit:setOwner(player, true)
                player:addHero(unit)
                local start_p = ac.point(7044, -8792)
                unit:blink(start_p)
                player:moveCamera(start_p, 0.2)
                ac.game:eventNotify('地图-选择英雄', unit, player)
            else
                pick_mark[i] = unit
                ac.wait(0.3, function()
                    pick_mark[i] = false
                end)
            end
        end
    end)
end