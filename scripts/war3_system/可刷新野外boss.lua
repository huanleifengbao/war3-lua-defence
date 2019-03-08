
--专属专用
--boss名字,位置,复活时间,挑战成功率,成功时获得的专属挑战等级
local tbl = {
    {'电', ac.point(10500, 4100), 10, 80, 3},
    {'雷', ac.point(10500, 1800), 10, 70, 4},
    {'晓', ac.point(10500, -500), 10, 60, 5},
    {'响', ac.point(10500, -3100), 10, 50, 6},
}

for i = 1, #tbl do
    local boss = ac.player(11):createUnit(tbl[i][1], tbl[i][2], 270)
    boss:event('单位-死亡', function (_, _, killer)
        if killer:userData('专属挑战等级') < tbl[i][5] then
            if sg.get_random(tbl[i][4]) then
                killer:userData('专属挑战等级', tbl[i][5])
                killer:getOwner():message('|cff00ff00挑战|cffffcc00'..tbl[i][1]..'|cff00ff00成功了!|r', 10)
            else
                killer:getOwner():message('|cffff0000哦豁,挑战失败了|r', 10)
            end
        else
            killer:getOwner():message('|cffffcc00'..tbl[i][1]..'|cffffff00已经成功挑战过了|r', 10)
        end
        ac.wait(tbl[i][3], function()
            boss:reborn(tbl[i][2], true)
        end)
    end)
end

--没那么多刁民机制的普通人
--boss名字,位置,复活时间,物品掉落表{'物品名字', 概率(概率可超过100来代表数量)}
local tbl = {
    {'锻造石boss-6', ac.point(430, 10800), 10, {{'六级锻造石', 100}}}, {'锻造石boss-1', ac.point(2250, 10800), 10, {{'一级锻造石', 1000}}},
    {'锻造石boss-7', ac.point(430, 8000), 10, {{'七级锻造石', 100},{'玄铁', 10}}}, {'锻造石boss-2', ac.point(2250, 8000), 10, {{'二级锻造石', 100}}},
    {'锻造石boss-8', ac.point(430, 5100), 10, {{'八级锻造石', 100},{'百年玄铁', 10}}}, {'锻造石boss-3', ac.point(2250, 5100), 10, {{'三级锻造石', 100}}},
    {'锻造石boss-9', ac.point(430, 2600), 10, {{'九级锻造石', 100},{'千年玄铁', 10}}}, {'锻造石boss-4', ac.point(2250, 2600), 10, {{'四级锻造石', 100}}},
    {'锻造石boss-10', ac.point(430, -100), 10, {{'十级锻造石', 100},{'九幽玄铁', 10}}}, {'锻造石boss-5', ac.point(2250, -100), 10, {{'五级锻造石', 100}}},
    {'锻造石boss-11', ac.point(-9800, 11100), 10, {{'终极锻造石', 100}}}
}

for i = 1, #tbl do
    local boss = ac.player(11):createUnit(tbl[i][1], tbl[i][2], 270)
    boss:event('单位-死亡', function (_, _, killer)
        --killer:getOwner():message('|cff00ff00挑战|cffffcc00'..tbl[i][1]..'|cff00ff00成功了!|r', 10)
        local p = boss:getPoint()
        if #tbl[i][4] > 0 then
            for item_table = 1, #tbl[i][4] do
                local item_name = tbl[i][4][item_table][1]
                local count_rd = tbl[i][4][item_table][2]
                for _ = 1, 100 do
                    if count_rd >= 100 then
                        local item = p:createItem(item_name)
                        print(item:getPoint())
                        ac.effect {
                            target = item:getPoint(),
                            model = [[Abilities\Spells\Other\Transmute\PileofGold.mdl]],
                            speed = 1,
                            time = 1.5,
                        }
                        count_rd = count_rd - 100
                    else
                        break
                    end
                end
                if sg.get_random(count_rd) then
                    local item = p:createItem(item_name)
                    ac.effect {
                        target = item:getPoint(),
                        model = [[Abilities\Spells\Other\Transmute\PileofGold.mdl]],
                        speed = 1,
                        time = 1.5,
                    }
                end
            end
        end
        ac.wait(tbl[i][3], function()
            boss:reborn(tbl[i][2], true)
        end)
    end)
end