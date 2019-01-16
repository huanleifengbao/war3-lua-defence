ac.game:event('单位-创建', function (_, unit)
    print(unit:getOwner()._id,unit:getName())
    if unit:getOwner()._id == 16 then
        unit:event('玩家-选中单位', function (trg, player, unit)
            print('ga')
            print(player._id)
            if not player:getHero() then
                trg:remove()
                unit:setOwner(player, true)
                player:addHero(unit)
                unit:blink({7044, -8792})
            end
        end)
    end
end)