ac.game:event('单位-创建', function (_, unit)
    print(unit:getOwner()._id,unit:getName())
    if unit:getOwner() then
        unit:event('玩家-选中单位', function (trg, player, unit)
            print('gaga')
            unit:remove()
        end)
        unit:event('玩家-取消选中', function (trg, player, unit)
        end)
    end
end)