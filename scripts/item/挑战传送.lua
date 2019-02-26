
local tbl = {
    {'挑战电', ac.point(10500, 3200)},
    {'挑战雷', ac.point(10500, 900)},
    {'挑战晓', ac.point(10500, -1600)},
    {'挑战响', ac.point(10500, -4000)},
}

for i = 1, #tbl do
	local mt = ac.item[tbl[i][1]]

    function mt:onCanAdd(unit)
        local player = unit:getOwner()
        unit:blink(tbl[i][2])
        player:moveCamera(tbl[i][2], 0.2)
    end
end