ac.game:event('单位-创建', function (_, unit)
    if unit:getName() == '基地' then
        sg.base = unit
        unit:event('单位-死亡', function (trg, unit)
            trg:remove()
            local p1 = unit:getPoint()
            for x = 1, 15 do
                for y = 1, 4 + x do
                    local p2 = p1 - {(360 / (4 + x) * y), 50 * x}
                    ac.effect {
                        target = p2,
                        model = [[Objects\Spawnmodels\Other\NeutralBuildingExplosion\NeutralBuildingExplosion.mdl]],
                        time = 2,
                    }
                end
            end
            for _, u in ac.selector()
                : inRange(unit, 800)
                : ipairs()
            do
                unit:kill(u)
            end
            for i = 1, 6 do
                ac.player(i):moveCamera(p1, 0)
                ac.player(i):message('|cffffff00家都|cffff0000boom|cffffff00了你不会自己退?|r', 30)
                ac.wait(3.5, function()
                    ac.player(i):message('|cffff0000哼!|r', 30)
                    ac.wait(2, function()
                        ac.player(i):message('|cffffff00免为其难让你|cff00ff00继续玩|cffffff00一会吧|r', 30)
                        ac.wait(2.5, function()
                            ac.player(i):message('|cffffff00下次给我好好地守住啊!|cffff0000baka!|r', 30)
                        end)
                    end)
                end)
            end
        end)
    end
end)