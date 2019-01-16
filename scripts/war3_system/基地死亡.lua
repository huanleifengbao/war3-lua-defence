ac.game:event('单位-创建', function (_, unit)
    if unit:getName() == '基地' then
        unit:event('单位-死亡', function (trg, unit)
            print('gameover')
        end)
    end
end)