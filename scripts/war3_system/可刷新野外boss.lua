
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