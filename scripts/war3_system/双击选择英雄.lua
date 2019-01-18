local pick_mark = {}

for i = 1, 6 do
    ac.player(i):event('玩家-选中单位', function (trg, player, unit)
        if unit:getOwner()._id == 16 and not player:getHero() then
            if pick_mark[i] == unit then
                trg:remove()
                unit:setOwner(player, true)
                player:addHero(unit)
                local start_p = ac.point(7044, -8792)
                unit:blink(start_p)
                player:moveCamera(start_p, 0.2)
                --复活
                unit:event('单位-死亡', function (trg, killer, dead)
                    local timer = ac.wait(5, function()
                        local reborn_p = ac.point(7044, -10529)
                        unit:reborn(reborn_p, true)
                        unit:set('魔法', unit:get('魔法上限'))
                        player:moveCamera(reborn_p, 0.2)
                    end)
                    local msg = '玩家'..i..'复活时间'
                    player:timerDialog(msg, timer)
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