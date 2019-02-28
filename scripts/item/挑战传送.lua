
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

local exercise_target = {}
local exercise_count = {}
local exercise_mark = {}
for i = 1, 6 do
    exercise_mark[i] = {}
    exercise_count[i] = 0
end

local exercise_monster = {
    ['刷钱1'] = {name = '金币怪1', count = 20, gold = 500, lumber = 0, exp = 100},
    ['刷钱2'] = {name = '金币怪2', count = 20, gold = 10000, lumber = 0, exp = 500},
    ['刷木1'] = {name = '木材怪1', count = 20, gold = 0, lumber = 50, exp = 2500},
    ['刷木2'] = {name = '木材怪2', count = 20, gold = 0, lumber = 500, exp = 10000},
    ['刷经验1'] = {name = '经验宝宝1', count = 20, gold = 0, lumber = 0, exp = 3000},
}

local exercise_point = {
    ac.point(5793, 10301),   ac.point(9034, 10301),
    ac.point(5793, 7740),    ac.point(9034, 7740),
    ac.point(5793, 5547),    ac.point(9034, 5547),
}

--练功房刷怪
local function exercise(unit, id, data)
    local p = exercise_point[id]
    local timer = false
    for i = 1, data.count do
        local u = ac.player(11):createUnit(data.name, p, 270)
        u:set('生命',u:get'生命上限')
        u:set('死亡金钱', data.gold)
        u:set('死亡木材', data.lumber)
        u:set('死亡经验', data.exp)
        table.insert(exercise_mark[id], u)
        exercise_count[id] = exercise_count[id] + 1
        u:event('单位-死亡', function (trg, _)
            trg:remove()
            exercise_count[id] = exercise_count[id] - 1
            --死者移出单位组,没必要注掉了
            --[[for _, u in ipairs(exercise_mark[id]) do
                table.remove(exercise_mark[id], k)
                break
            end]]
            if exercise_count[id] == 0 then
                timer = ac.wait(1, function()
                    timer = false
                    exercise(unit, id, exercise_monster[exercise_target[id]])
                end)
            end
        end)
    end
    --重置方法1:英雄死了
    unit:event('单位-死亡', function (trg, _)
        trg:remove()
        exercise_target[id] = nil
        for _, u in ipairs(exercise_mark[id]) do
            if u:isAlive() then
                ac.effect {
                    target = u:getPoint(),
                    model = [[Abilities\Spells\Human\Polymorph\PolyMorphTarget.mdl]],
                    speed = 2,
                    time = 1,
                }
            end
            u:remove()
        end
        exercise_mark[id] = {}
        if timer and timer ~= false then
            timer:remove()
        end
    end)
end

local tbl = {'刷钱1','刷钱2','刷木1','刷木2','刷经验1'}

for _, tbl_name in pairs(tbl) do
	local mt = ac.item[tbl_name]

    function mt:onCanAdd(unit)
        local player = unit:getOwner()
        local id = player:id()
        local name = self:getName()
        if not exercise_target[id] or (exercise_target[id] ~= name) then
            if exercise_target[id] == nil then
                exercise(unit, id, exercise_monster[name])
            end
            exercise_target[id] = name
            player:message('|cffffff00选择练功目标:|cffff7500'..name..'|r', 10)
        else
            player:message('|cffffff00当前练功目标已是:|cffff7500'..name..'|r', 10)
            return false
        end
    end
end