
--没刁民需求的专用
--道具名字,传送目标点
local tbl = {
    {'挑战锻造石boss-6', ac.point(430, 9800)}, {'挑战锻造石boss-1', ac.point(2250, 9800)},
    {'挑战锻造石boss-7', ac.point(430, 7000)}, {'挑战锻造石boss-2', ac.point(2250, 7000)},
    {'挑战锻造石boss-8', ac.point(430, 4100)}, {'挑战锻造石boss-3', ac.point(2250, 4100)},
    {'挑战锻造石boss-9', ac.point(430, 1600)}, {'挑战锻造石boss-4', ac.point(2250, 1600)},
    {'挑战锻造石boss-10', ac.point(430, -1100)}, {'挑战锻造石boss-5', ac.point(2250, -1100)},
    {'挑战锻造石boss-11', ac.point(-10900, 10600)},
}

for i = 1, #tbl do
	local mt = ac.item[tbl[i][1]]

    function mt:onCanAdd(unit)
        return unit:tp(tbl[i][2])
    end
end

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
            return unit:tp(tbl[i][2])
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
    return unit:tp(target)
end

local exercise_target = {}
local exercise_count = {}
local exercise_mark = {}
for i = 1, sg.max_player do
    exercise_mark[i] = {}
    exercise_count[i] = 0
end

local exercise_monster = {
    ['刷钱1'] = {name = '金币怪1', count = 20, cd = 1, gold = 500, lumber = 0, exp = 3000},
    ['刷钱2'] = {name = '金币怪2', count = 20, cd = 1, gold = 10000, lumber = 0, exp = 3000},
    ['刷木1'] = {name = '木材怪1', count = 20, cd = 1, gold = 0, lumber = 50, exp = 3000},
    ['刷木2'] = {name = '木材怪2', count = 20, cd = 1, gold = 0, lumber = 150, exp = 3000},
    ['刷木3'] = {name = '木材怪3', count = 20, cd = 1, gold = 0, lumber = 500, exp = 3000},
    ['刷经验1'] = {name = '经验宝宝1', count = 20, cd = 1, gold = 0, lumber = 0, exp = 3000},
    ['作弊刷怪'] = {name = '经验宝宝1', count = 100, cd = 0.1, gold = 0, lumber = 0, exp = 3000},
}

local exercise_point = {
    ac.point(5793, 10301),   ac.point(9034, 10301),
    ac.point(5793, 7740),    ac.point(9034, 7740),
    ac.point(5793, 5547),    ac.point(9034, 5547),
}

--练功房刷怪
local function exercise(unit, id, data)
    local p = exercise_point[id]
    local rect = ac.rect(p, 2688, 2176)
    local timer = false
    for _ = 1, data.count do
        local u = ac.player(11):createUnit(data.name, p, 270)
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
                timer = ac.wait(data.cd, function()
                    timer = false
                    exercise(unit, id, exercise_monster[exercise_target[id]])
                end)
            end
        end)
    end
    --重置,结束刷怪
    local trg
    local function exercise_end()
        trg:remove()
        rect:remove()
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
    end
    --重置方法1:英雄死了
    trg = unit:event('单位-死亡', function ()
        exercise_end()
    end)
    --重置方法2:英雄出区域了
    function rect:onLeave(u)
        if u == unit then
            exercise_end()
        end
    end
end

local tbl = {'刷钱1','刷钱2','刷木1','刷木2','刷木3','刷经验1','作弊刷怪'}

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

--挑战觉醒boss,跟练功房机制差不多
local point = {
    ac.point(-6800, -3900),
    ac.point(-4500, -3900),
    ac.point(-2300, -3900),
    ac.point(-100, -3900),
    ac.point(1950, -3900),
    ac.point(4100, -3900),
}

local mt = ac.item['觉醒挑战房']

function mt:onCanAdd(unit)
    local player = unit:getOwner()
    local id = player:id()
    local target = point[id]
    return unit:tp(target)
end

local awake_boss = {}
local awake_data = {
    ['挑战觉醒boss-1'] = {name = '觉醒boss-1', lv = 1000, awake = 0},
    ['挑战觉醒boss-2'] = {name = '觉醒boss-2', lv = 2000, awake = 1},
    ['挑战觉醒boss-3'] = {name = '觉醒boss-3', lv = 3000, awake = 2},
    ['挑战觉醒boss-4'] = {name = '觉醒boss-4', lv = 4000, awake = 3},
    ['挑战觉醒boss-5'] = {name = '觉醒boss-5', lv = 5000, awake = 4},
    ['挑战觉醒boss-6'] = {name = '觉醒boss-6', lv = 6000, awake = 5},
    ['挑战觉醒boss-7'] = {name = '觉醒boss-7', lv = 7000, awake = 6},
    ['挑战觉醒boss-8'] = {name = '觉醒boss-8', lv = 8000, awake = 7},
    ['挑战觉醒boss-9'] = {name = '觉醒boss-9', lv = 9000, awake = 8},
    ['挑战觉醒boss-10'] = {name = '觉醒boss-10', lv = 10000, awake = 9},
}
local awake_point = {
    ac.point(-6800, -3500),
    ac.point(-4500, -3500),
    ac.point(-2300, -3500),
    ac.point(-100, -3500),
    ac.point(1950, -3500),
    ac.point(4100, -3500),
}
--boss位置偏移:角度,距离
awake_point_ex = {90, 600}

--召唤boss
local function awake(unit, id, data)
    local p = awake_point[id]
    awake_boss[id] = ac.player(11):createUnit(data.name, p - awake_point_ex, 270)
    --冻结boss,可以按继续再打
    local function awake_zzz()
        if not awake_boss[id]:userData('暂停挑战') then
            local buff = awake_boss[id]:addBuff '暂停挑战'{}
            awake_boss[id]:userData('暂停挑战', buff)
        end
    end
    --冻结1:英雄死了
    local trg = unit:event('单位-死亡', function ()
        awake_zzz()
    end)
    --冻结2:英雄溜了
    local rect = ac.rect(p, 1280, 2688)
    function rect:onLeave(u)
        if u == unit then
            awake_zzz()
        end
    end
    --boss死了,结束
    awake_boss[id]:event('单位-死亡', function(_, _, killer)
        trg:remove()
        rect:remove()
        if killer ~= awake_boss[id] then
            if data.awake + 1 > unit:get('觉醒等级') then
                unit:set('觉醒等级', data.awake + 1)
                ac.game:eventNotify('地图-觉醒等级变化', unit)
            end
        end
        awake_boss[id] = nil
    end)
end

local tbl = {'挑战觉醒boss-1','挑战觉醒boss-2','挑战觉醒boss-3','挑战觉醒boss-4','挑战觉醒boss-5','挑战觉醒boss-6','挑战觉醒boss-7','挑战觉醒boss-8','挑战觉醒boss-9','挑战觉醒boss-10'}

for _, tbl_name in pairs(tbl) do
	local mt = ac.item[tbl_name]

    function mt:onCanAdd(unit)
        local player = unit:getOwner()
        local id = player:id()
        local name = self:getName()
        local data = awake_data[name]
        local mark = true
        if data.lv > unit:level() then
            player:message('|cffffff00等级不足|cffff7500 '..data.lv..' |cffffff00无法挑战|r', 10)
            mark = false
        end
        if data.awake > unit:get('觉醒等级') then
            player:message('|cffffff00觉醒程度不足|cffff7500 '..data.awake..'阶 |cffffff00无法挑战|r', 10)
            mark = false
        end
        if data.awake < unit:get('觉醒等级') then
            player:message('|cffffff00这家伙已经是个手下败将了|r', 10)
            mark = false
        end
        if mark == false then
            return false
        end
        if not awake_boss[id] then
            local hero = player:getHero()
            awake(hero, id, awake_data[name])
            player:message('|cffffff00挑战:|cffff7500'..awake_data[name].name..'|r', 10)
        else
            player:message('|cffffff00当前已有挑战目标,你必须|cff00ff00胜利|cffffff00或者|cffff0000放弃|r', 10)
            return false
        end
    end
end

local mt = ac.item['继续-觉醒boss']

function mt:onAdd()
    local unit = self:getOwner()
    local player = unit:getOwner()
    local id = player:id()
    local boss = awake_boss[id]
    if boss then
        local buff = boss:userData('暂停挑战')
        if buff then
            buff:remove()
            boss:userData('暂停挑战', nil)
            player:message('|cffffff00继续挑战!|r')
        else
            player:message('|cffffff00boss并不处于暂停状态|r')
            return false
        end
    else
        player:message('|cffffff00当前没有挑战任何boss|r')
        return false
    end
end

local mt = ac.item['放弃-觉醒boss']

function mt:onAdd()
    local unit = self:getOwner()
    local player = unit:getOwner()
    local id = player:id()
    local boss = awake_boss[id]
    if boss then
        ac.effect {
            target = boss:getPoint(),
            model = [[Abilities\Spells\Orc\FeralSpirit\feralspirittarget.mdl]],
            speed = 1,
            size = 3,
            time = 1,
        }
        boss:kill(boss)
        boss:remove()
        player:message('|cffff0000已放弃|r')
    else
        player:message('|cffffff00当前没有挑战任何boss|r')
        return false
    end
end

local mt = ac.buff['暂停挑战']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNReplay-Pause.blp]]
mt.title = '暂停挑战'
mt.description = 'boss不会行动也不会受到攻击'

function mt:onAdd()
	local u = self:getOwner()
	u:addRestriction '硬直'
	u:addRestriction '无敌'
    u:speed(0)
    u:color(1, 1, 1, 0.5)
end

function mt:onCover()
    return false
end

function mt:onRemove()
	local u = self:getOwner()
	u:removeRestriction '硬直'
    u:removeRestriction '无敌'
    u:speed(1)
    u:color(1, 1, 1, 1)
end