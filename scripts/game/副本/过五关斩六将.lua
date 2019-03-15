
local mt = ac.item['副本-过五关斩六将']

--飞机位置
local start_point = ac.point(6050, -9300)
--副本位置
local target_point = {
    ac.point(-7600, 10150),
    ac.point(-6800, -1250),
    ac.point(-7300, 7400),
    ac.point(-3000, 4100),
    ac.point(-4000, -1150),
}
--回城
local home = ac.point(7044, -8792)
--副本初始怪物
local instance_data = {
    {
        {name = '副本-孔秀', point = ac.point(-7777, 11350), facing = 180},
    },
    {
        {name = '副本-韩福', point = ac.point(-6800, 2600), facing = 180},
        {name = '副本-孟坦', point = ac.point(-6725, 5625), facing = 180},
    },
    {
        {name = '副本-卞喜', point = ac.point(-7300, 8700), facing = 180},
    },
    {
        {name = '副本-王植', point = ac.point(-3000, 5100), facing = 180},
    },
    {
        {name = '副本-秦琪', point = ac.point(-1950, 1125), facing = 180},
    },
}
--副本阶段数量
local instance_count = 5

function mt:onCanAdd(unit)
    local player = unit:getOwner()
    if sg.game_mod == '副本' or sg.game_mod == '副本准备' then
        player:message('|cffffff00目前某种副本正在激活|r', 5)
        return false
    end
end

function mt:onAdd()
    sg.game_mod = '副本准备'
    local mark = {}
    local hero_mark = {}
    local hero_count = 0
    local boss_mark = {}
    local boss_count = 0
    --副本当前阶段
    local instance_lv = 0

    local time = 120
    local msg = '副本-过五关斩六将'
    local time2 = 300
    local msg2 = '时间限制'
    --飞机特效
    local eff1 = ac.effect {
        target = start_point,
        model = [[units\undead\UndeadAirBarge\UndeadAirBarge.mdl]],
        height = 350,
        angle = 120,
        size = 2,
        speed = 1,
    }
    local eff2 = ac.effect {
        target = start_point,
        model = [[buildings\other\CircleOfPower\CircleOfPower.mdl]],
        size = 3.5,
        speed = 1,
    }
    local textTag_msg = '|cffffcc00'..msg..'|n|cffffff00参与人数:'..'0'..'/'..sg.player_count..'|r'
    local textTag = ac.textTag()
        : text(textTag_msg, 0.04)
        : at(start_point, 50)
    local timer

    local rect = ac.rect(start_point, 500, 500)
    local function instance()
        if timer then
            timer:remove()
        end
        --结束副本一定会跑的函数
        local function instance_end()
        	sg.camera()
            sg.start_enemy()
            for _, u in pairs(sg.all_enemy) do
                local buff = u:findBuff('冻结')
                if buff then
                    buff:remove()
                end
            end
            hero_mark = {}
            boss_mark = {}
            sg.game_mod = '通常'
            for i = 1,sg.max_player do
                local player = ac.player(i)
                player:message('副本已结束,敌人重新开始|cffff7500进攻|r', 5)
            end
        end
        --如果根本没人上飞机就直接end
        if #mark == 0 then
            instance_end()
        else
            --时限
            local timer2 = ac.wait(time2, function()
                for _, hero in ipairs(hero_mark) do
                    local player = hero:getOwner()
                    player:message('哎鸭|cffff7500超时|r了', 8)
                    hero:kill(hero)
                    ac.effect {
                        target = hero:getPoint(),
                        model = [[Objects\Spawnmodels\NightElf\NEDeathSmall\NEDeathSmall.mdl]],
                        speed = 1,
                        time = 0,
                    }
                end
            end)
            local function ace()
                if hero_count == 0 then
                    timer2:remove()
                    for _, hero in ipairs(hero_mark) do
                        local player = hero:getOwner()
                        hero:kill(hero)
                        player:message('啊欧|cffff7500团灭|r了,副本失败', 8)
                    end
                    local end_time = 4
                    ac.wait(end_time, function()
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
                        instance_end()
                    end)
                end
            end
            --遍历进入副本的英雄
            for k, u in ipairs(mark) do
                local player = u:getOwner()
                local id = player:id()
                player:timerDialog(msg2, timer2)
                player:message('已进入副本,时间限制|cffff7500'..time2..'|r秒请注意', 8)
                player:message('|cff00ff00攻略所有关卡|r才会胜利,|cffff0000团灭或超时|r副本挑战就失败了', 8)
                player:message('另外副本中可是|cffff7500禁止传送|r并且|cffff7500无法复活|r的哟', 8)
                hero_mark[k] = u
                hero_count = hero_count + 1
                local trg1, trg2
                trg1 = u:event('单位-即将死亡', function ()
                    trg1:remove()
                    trg2:remove()
                    hero_count = hero_count - 1
                    if hero_count <= 0 then
                        ace()
                    else
                        --没团灭的死者会假死
                        u:addBuff '假死'{}
                        for i = 1,sg.max_player do
                            ac.player(i):message(sg.player_colour[id]..u:getName()..'|r被杀了!剩余英雄:|cffff7500'..hero_count..'|r', 5)
                        end
                        return false
                    end
                end)
                trg2 = u:event('单位-死亡', function ()
                    trg1:remove()
                    trg2:remove()
                    hero_count = hero_count - 1
                    if hero_count <= 0 then
                        ace()
                    end
                end)
                u:addRestriction '硬直'
                local int = 5
                ac.timer(1, 6, function()
                    if int == 5 then
                        player:message('目标:讨伐(击杀)|cffff00ff虎牢关吕布|r', 8)
                    end
                    if int <= 3 and int >= 1 then
                        player:message('开始倒计时:|cffff7500'..int..'|r', 1)
                    end
                    if int == 0 then
                        player:message('|cffff7500葱鸭!|r', 2)
                        u:removeRestriction '硬直'
                    end
                    int = int - 1
                end)
            end
            local next_lv
            function next_lv()
                instance_lv = instance_lv + 1
                --传送英雄
                for k, hero in ipairs(hero_mark) do
                    local player = hero:getOwner()
                    local p2 = target_point[instance_lv] - {360 / #hero_mark * k, 120}
                    hero:tp(p2, true)
                    player:message('第|cffff7500'..instance_lv..'|r关', 8)
                end
                for i = 1, #instance_data[instance_lv] do
                    boss_count = boss_count + 1
                    --创建boss
                    local boss = sg.creeps_player:createUnit(instance_data[instance_lv][i].name, instance_data[instance_lv][i].point, instance_data[instance_lv][i].facing)
                    table.insert(boss_mark, boss)
                    boss:event('单位-死亡', function (trg, _, killer)
                        trg:remove()
                        if killer ~= boss then
                            boss_count = boss_count - 1
                            if boss_count == 0 then
                                if instance_lv >= instance_count then
                                    timer2:remove()
                                    local back_time = 10
                                    local back_msg = '即将返回'
                                    local back_timer = ac.wait(back_time, function()
                                        for _, hero in ipairs(hero_mark) do
                                            hero:tp(home, true)
                                        end
                                        instance_end()
                                    end)
                                    for _, hero in ipairs(hero_mark) do
                                        local player = hero:getOwner()
                                        player:message('|cff00ff00boss团灭|r了xs,你们胜利了,|cffff7500'..back_time..'|r秒后返回', 8)
                                        player:message('所有参与者获得|cffffdd00600000|r金钱和|cff25cc75600000|r木材,爽死了', 8)
                                        player:timerDialog(back_msg, back_timer)
                                        hero:createItem('副本奖励3')
                                    end
                                else
                                    local next_time = 5
                                    for _, hero in ipairs(hero_mark) do
                                        local player = hero:getOwner()
                                        player:message('|cff00ff00boss团灭|r了xs,但还没胜利了,|cffff7500'..next_time..'|r秒后进入下一关', 8)
                                    end
                                    ac.wait(5, function()
                                        next_lv()
                                    end)
                                end
                            end
                        end
                    end)
                end
            end
            next_lv()
            sg.game_mod = '副本'
        end
        eff1:remove()
        eff2:remove()
        textTag:remove()
        rect:remove()
    end

    --进入/离开副本区域
    function rect:onEnter(u)
        local player = u:getOwner()
        local id = player:id()
        if u:isHero() and (id >= 1 and id <= sg.max_player) then
            table.insert(mark, u)
            textTag_msg = '|cffffcc00'..msg..'|n|cffffff00参与人数:'..#mark..'/'..sg.player_count..'|r'
            textTag:text(textTag_msg, 0.04)
            if #mark >= sg.player_count then
                instance()
            end
        end
    end
    function rect:onLeave(u)
        for k, unit in ipairs(mark) do
            if u == unit then
                table.remove(mark, k)
                textTag_msg = '|cffffcc00'..msg..'|n|cffffff00参与人数:'..#mark..'/'..sg.player_count..'|r'
                textTag:text(textTag_msg, 0.04)
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
        player:message('|cffff7500过五关斩六将|r副本已激活,想去就所有人在|cffff7500'..time..'|r秒内去|cffff7500飞机|r集合.jpg', 60)
    end
end