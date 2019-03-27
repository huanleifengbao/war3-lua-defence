
-- 第1个值是固定值经验
-- 第2个值会和当前游戏波数相乘
-- 第3个值代表等级,经验为该等级的经验总和,改平衡常数时请同时改该文件(不过等级的[上一个值因素]太难算了,摸)
local data = {
    ['锻造石boss-1'] = {100, 10, 502},
}

ac.game:event('单位-创建', function (_, unit)
    local name = unit:getName()
    if data[name] then
        local exp = 0
        if data[name][1] > 0 then
            exp = exp + data[name][1]
        end
        if data[name][2] > 0 then
            local wave = 1
            if sg.get_wave() then
                wave = sg.get_wave()
            end
            exp = exp + data[name][2] * wave
            print(sg.get_wave(),'波', data[name][2] * wave)
        end
        if data[name][3] > 0 then
            exp = exp + (200 + (data[name][3] - 1) * 15) * data[name][3] / 2
            print(data[name][3],'级',(200 + (data[name][3] - 1) * 15) * data[name][3] / 2)
        end
        unit:add('死亡经验', exp)
    end
end)