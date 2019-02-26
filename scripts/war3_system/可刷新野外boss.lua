
local tbl = {
    {'电', ac.point(10500, 4100), 2},
    {'雷', ac.point(10500, 1800), 20},
    {'晓', ac.point(10500, -500), 20},
    {'响', ac.point(10500, -3100), 20},
}

for i = 1, #tbl do
    local boss = ac.player(11):createUnit(tbl[i][1], tbl[i][2], 270)
    local trg = boss:event('单位-死亡', function (_, _, killer)
        print(boss:getName()..'又死了 没人性')
        local timer = ac.wait(tbl[i][3], function()
            boss:reborn(tbl[i][2], true)
            print(boss:getName()..'复活了')
        end)
    end)
end