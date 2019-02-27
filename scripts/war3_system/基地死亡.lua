ac.game:event('单位-创建', function (_, unit)
    if unit:getName() == '基地' then
        sg.base = unit
        unit:event('单位-死亡', function (trg, unit)
            for i = 1, 6 do
                ac.player(i):message('|cffffff00家都|cffff0000boom|cffffff00了你不会自己退?|r', 30)
                ac.wait(2, function()
                    ac.player(i):message('|cffff0000哼!|r', 30)
                    ac.wait(1, function()
                        ac.player(i):message('|cffffff00免为其难让你|cff00ff00继续玩|cffffff00一会吧|r', 30)
                        ac.wait(2, function()
                            ac.player(i):message('|cffffff00下次给我好好地守住啊!|cffff0000baka!|r', 30)
                        end)
                    end)
                end)
            end
        end)
    end
end)