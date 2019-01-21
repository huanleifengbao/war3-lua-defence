ac.game:event('单位-创建', function (_, unit)
    if unit:getName() == '基地' then
        sg.base = unit
        unit:event('单位-死亡', function (trg, unit)
            print('家都boom了你不会自己退?rua')
        end)
    end
end)