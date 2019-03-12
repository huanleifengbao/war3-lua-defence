
--飞机位置
local start_point = ac.point(6050, -9300)
--副本位置
local target_point = ac.point(-4100, 8150)
--回城
local home = ac.point(7044, -8792)
--副本初始怪物
local instance_data = {
    {name = '副本-张宝', point = ac.point(-2000, 8150)},
    {name = '副本-张角', point = ac.point(-4100, 10280)},
    {name = '副本-张梁', point = ac.point(-2000, 10280)},
}

local mt = ac.item['副本-大战黄巾贼']

function mt:onCanAdd(unit)
    local player = unit:getOwner()
    if sg.game_mod == '副本' or sg.game_mod == '副本准备' then
        player:message('|cffffff00目前某种副本正在激活|r', 10)
        return false
    end
end

function mt:onAdd()
    sg.game_mod = '副本准备'
    local mark = {}

    local time = 120
    local msg = '副本-大战黄巾贼'
    local time2 = 300
    local msg2 = '时间限制'
    --飞机特效
    local eff = ac.effect {
        target = start_point,
        model = [[units\creeps\GoblinZeppelin\GoblinZeppelin.mdl]],
        size = 3,
        speed = 1,
    }
    local timer

    local rect = ac.rect(start_point, 500, 500)
    local function instance()
        if timer then
            timer:remove()
        end
        --结束副本一定会跑的函数
        local function instance_end()
            sg.start_enemy()
            for _, u in pairs(sg.all_enemy) do
                local buff = u:findBuff('冻结')
                if buff then
                    buff:remove()
                end
            end
            sg.game_mod = '通常'
            for i = 1,sg.max_player do
                local player = ac.player(i)
                player:message('副本已结束,敌人重新开始|cffff7500进攻|r', 10)
            end
        end
        --如果根本没人上飞机就直接end
        if #mark == 0 then
            instance_end()
        else
            sg.game_mod = '副本'
            local hero_mark = {}
            local hero_count = 0
            local boss_mark = {}
            local boss_count = 0
            --时限
            local timer2 = ac.wait(time2, function()
                for _, hero in ipairs(hero_mark) do
                    local player = hero:getOwner()
                    player:message('哎鸭|cffff7500超时|r了', 10)
                    hero:kill(hero)
                    ac.effect {
                        target = hero:getPoint(),
                        model = [[Objects\Spawnmodels\NightElf\NEDeathSmall\NEDeathSmall.mdl]],
                        speed = 1,
                        time = 0,
                    }
                end
            end)
            local function game_over()
                if hero_count == 0 then
                    timer2:remove()
                    for _, hero in ipairs(hero_mark) do
                        local player = hero:getOwner()
                        hero:kill(hero)
                        player:message('啊欧|cffff7500团灭|r了,副本失败', 10)
                    end
                    local end_time = 4
                    local end_timer = ac.wait(end_time, function()
                        instance_end()
                        for _, boss in ipairs(boss_mark) do
                            ac.effect {
                                target = boss:getPoint(),
                                model = [[Abilities\Spells\Orc\FeralSpirit\feralspirittarget.mdl]],
                                speed = 1,
                                size = 3,
                                time = 1,
                            }
                            boss:kill(boss)
                            boss:remove()
                        end
                    end)
                end
            end
            --遍历进入副本的英雄
            for k, u in ipairs(mark) do
                u:getOwner():message('已进入副本,时间限制|cffff7500'..time2..'|r秒请注意', 10)
                u:getOwner():message('|cff00ff00击杀所有boss|r就会胜利,|cffff0000团灭或超时|r副本挑战就失败了', 10)
                u:getOwner():message('另外副本中可是|cffff7500禁止传送|r并且|cffff7500无法复活|r的哟', 10)
                hero_mark[k] = u
                hero_count = hero_count + 1
                u:event('单位-即将死亡', function (trg, _)
                    trg:remove()
                    hero_count = hero_count - 1
                    if hero_count == 0 then
                        game_over()
                    else
                        --没团灭的死者会假死
                        u:addBuff '假死'{}
                        for i = 1,sg.max_player do
                            local player = ac.player(i)
                            local id = u:getOwner():id()
                            player:message(sg.player_colour[id]..u:getName()..'|r被杀了!剩余英雄:|cffff7500'..hero_count..'|r', 10)
                        end
                        return false
                    end
                end)
                u:event('单位-死亡', function (trg, _)
                    trg:remove()
                    hero_count = hero_count - 1
                    if hero_count == 0 then
                        game_over()
                    end
                end)
                local p2 = target_point - {360 / #mark * k, 120}
                u:blink(p2)
            end
            --移动镜头
            for i = 1,sg.max_player do
                local player = ac.player(i)
                player:timerDialog(msg2, timer2)
                player:moveCamera(target_point, 0.2)
            end
            --创建boss
            for i = 1, #instance_data do
                boss_count = boss_count + 1
                local boss = ac.player(11):createUnit(instance_data[i].name, instance_data[i].point, 270)
                table.insert(boss_mark, boss)
                boss:event('单位-死亡', function (trg, _, killer)
                    trg:remove()
                    if killer ~= boss then
                        boss_count = boss_count - 1
                        if boss_count == 0 then
                            timer2:remove()
                            local back_time = 10
                            local back_msg = '即将返回'
                            local back_timer = ac.wait(back_time, function()
                                instance_end()
                                for _, hero in ipairs(hero_mark) do
                                    local player = hero:getOwner()
                                    hero:blink(home)
                                    hero:stop()
                                    player:moveCamera(home, 0.2)
                                end
                            end)
                            for _, hero in ipairs(hero_mark) do
                                local player = hero:getOwner()
                                player:message('|cff00ff00boss团灭|r了xs,你们胜利了,|cffff7500'..back_time..'|r秒后返回', 10)
                                player:timerDialog(back_msg, back_timer)
                            end
                            --打赢了当然要放点烟花(TNT)庆祝下
                            --放个p
                            --[==[local p1 = boss:getPoint()
                            ac.timer(0.05, 100, function()
                                local p2 = p1 - {math.random(360), math.random(100, 800)}
                                local mover = boss:moverLine
                                {
                                    model = [[Abilities\Weapons\DemolisherFireMissile\DemolisherFireMissile.mdl]],
                                    start = p2,
                                    angle = 0,
                                    speed = 600,
                                    distance = 1200,
                                    startHeight = 1500,
                                    middleHeight = 1500,
                                    finishHeight = 0,
                                }
                                --[=[ac.effect {
                                    target = p2,
                                    model = [[Abilities\Weapons\DemolisherFireMissile\DemolisherFireMissile.mdl]],
                                    speed = 1,
                                    size = math.random(10, 30) / 10,
                                    time = 0,
                                }]=]
                            end)]==]--
                        end
                    end
                end)
            end
        end
        eff:remove()
        rect:remove()
    end

    --进入/离开副本区域
    function rect:onEnter(u)
        local player = u:getOwner()
        local id = player:id()
        if u:isHero() and (id >= 1 and id <= 6) then
            table.insert(mark, u)
            if #mark >= 1 then
                instance()
            end
        end
    end
    function rect:onLeave(u)
        for k, unit in ipairs(mark) do
            if u == unit then
                table.remove(mark, k)
                break
            end
        end
    end

    --进入副本的时限
    timer = ac.wait(time, function()
        for i = 1,sg.max_player do
            local player = ac.player(i)
            player:message('还没进副本的进不去了,飞机都|cffff0000boom|r了', 60)
        end
        instance()
    end)
    --冻结所有怪物
    sg.stop_enemy()
    for _, u in pairs(sg.all_enemy) do
        u:addBuff '冻结'{}
    end
	for i = 1,sg.max_player do
        local player = ac.player(i)
        player:timerDialog(msg, timer)
        player:message('进攻的敌人已被|cff00ffff冻结|r', 60)
        player:message('|cffff7500大战黄巾贼|r副本已激活,想去就所有人在|cffff7500'..time..'|r内去|cffff7500飞机|r集合.jpg', 60)
    end
end