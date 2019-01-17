local pick_mark = {}

for i = 1, 6 do
    ac.player(i):event('玩家-选中单位', function (trg, player, unit)
        if unit:getOwner()._id == 16 and not player:getHero() then
            if pick_mark[i] == unit then
                trg:remove()
                unit:setOwner(player, true)
                player:addHero(unit)
                unit:blink(ac.point(7044, -8792))
                --复活
                unit:event('单位-死亡', function (trg, unit)
                    print('nsl')
                    ac.wait(1, function()
                        unit:reborn(ac.point(7044, -10529), true)
                        print('nhl')
                        --[[unit:set('生命', unit:get('生命上限'))
                        unit:set('魔法', unit:get('魔法上限'))
                        unit:blink(ac.point(7044, -10529))]]
                    end)
                end)
            else
                pick_mark[i] = unit
                ac.wait(0.3, function()
                    pick_mark[i] = false
                end)
            end
        end
    end)
end