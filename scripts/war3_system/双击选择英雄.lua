print('gaga')
ac.event('单位-创建', function (trg, unit)
    print(unit:getOwner(),unit:getname())
    if unit:getOwner() then
        unit:event('玩家-选中单位', function (trg, player, unit)
            unit:remove()
        end)
        unit:event('玩家-取消选中', function (trg, player, unit)
        end)
    end
end)