
--专属专用
--道具名字,传送目标点,需求专武等级
local tbl = {
    {'挑战电', ac.point(10500, 3200), 2},
    {'挑战雷', ac.point(10500, 900), 3},
    {'挑战晓', ac.point(10500, -1600), 4},
    {'挑战响', ac.point(10500, -4000), 5},
}

for i = 1, #tbl do
	local mt = ac.item[tbl[i][1]]

    function mt:onCanAdd(unit)
        local player = unit:getOwner()
        if unit:userData('专属等级') and unit:userData('专属等级') >= tbl[i][3] then
            unit:blink(tbl[i][2])
            player:moveCamera(tbl[i][2], 0.2)
        else
            player:message('|cffffff00你没有资格挑战该boss,|cffff7500专属装备|cffffff00至少需要|cffff7500Lv'..tbl[i][3]..'|r', 10)
            return false
        end
    end
end

--练功房
local point = {
    ac.point(6293, 10301),   ac.point(9534, 10301),
    ac.point(6293, 7740),    ac.point(9534, 7740),
    ac.point(6293, 5547),    ac.point(9534, 5547),
}

local mt = ac.item['练功房']

function mt:onCanAdd(unit)
    local player = unit:getOwner()
    local id = player:id()
    local target = point[id]
    unit:blink(target)
    player:moveCamera(target, 0.2)
end