local pick_mark = {}

for i = 1, 6 do
    ac.player(i):event('玩家-选中单位', function (trg, player, unit)
        if unit:getOwner()._id == 16 and not player:getHero() then
            if pick_mark[i] == unit then
                trg:remove()
                unit:setOwner(player, true)
                player:addHero(unit)
                unit:blink(ac.point(7044, -8792))
            else
                pick_mark[i] = unit
                ac.wait(400, function()
                    pick_mark[i] = false
                end)
            end
        end
    end)
end