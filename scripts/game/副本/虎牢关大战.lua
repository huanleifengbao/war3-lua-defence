
local mt = ac.item['副本-虎牢关大战']
local stage_start = false
--飞机位置
local start_point = ac.point(6050, -9300)
--副本位置
local target_point = ac.point(-8900, -750)
--回城
local home = ac.point(7044, -8792)
--副本初始怪物
local instance_data = {
    {name = '副本-虎牢关吕布', point = ac.point(-8800, 1400), facing = 180},
}
--事件:一群刁民
local event1_mark = false
local event1_rect = ac.rect(ac.point(-11300, 450), ac.point(-9900, 900))
local event1_monster_data = {
    {name = '副本-虎牢关老阴比', point = ac.point(-10600, 1100), count = 15, width = 1200, facing = 270},
    {name = '副本-虎牢关老阴比', point = ac.point(-10600, -200), count = 15, width = 1200, facing = 90},
}

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
    local event1_monster_mark = {}

    local time = 120
    local msg = '副本-虎牢关大战'
    local time2 = 300
    local msg2 = '时间限制'
    --飞机特效
    local eff1 = ac.effect {
        target = start_point,
        model = [[units\human\Gyrocopter\Gyrocopter_V1.mdl]],
        height = 300,
        angle = 135,
        size = 2.5,
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
        	ac.game:music(sg.last_music)
        	stage_start = false
        	sg.camera()
            sg.start_enemy()
            for _, u in pairs(sg.all_enemy) do
                local buff = u:findBuff('冻结')
                if buff then
                    buff:remove()
                end
            end
            --清空事件
            event1_mark = false
            if #event1_monster_mark > 0 then
                for _, u in ipairs(event1_monster_mark) do
                    if u:isAlive() then
                        ac.effect {
                            target = u:getPoint(),
                            model = [[Abilities\Spells\Human\Polymorph\PolyMorphTarget.mdl]],
                            speed = 2,
                            time = 0,
                        }
                        u:kill(u)
                        u:remove()
                    end
                end
                event1_monster_mark = {}
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
	        --音乐
	        ac.game:music([[resource\music\fb1.mp3]])
	        stage_start = true
	        --视野
			sg.off_fog(ac.rect(-11650,-1650,-8100,2300))
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
	                stage_start = false
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
            --锁镜头区域
            sg.camera({left = ac.point(-10500,1300),right = ac.point(-9500,-800)})
            --遍历进入副本的英雄
            for k, u in ipairs(mark) do
                local player = u:getOwner()
                local id = player:id()
                player:timerDialog(msg2, timer2)
                player:message('已进入副本,时间限制|cffff7500'..time2..'|r秒请注意', 8)
                player:message('|cff00ff00击杀虎牢关吕布|r就会胜利,|cffff0000团灭或超时|r副本挑战就失败了', 8)
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
                local p2 = target_point - {360 / #mark * k, 120}
				u:tp(p2, true)
                u:set('生命', u:get('生命上限'))
                u:set('魔法', u:get('魔法上限'))
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
            --创建boss
            for i = 1, #instance_data do
                boss_count = boss_count + 1
                local boss = sg.creeps_player:createUnit(instance_data[i].name, instance_data[i].point, instance_data[i].facing)
                table.insert(boss_mark, boss)
                boss:event('单位-死亡', function (trg, _, killer)
                    trg:remove()
                    if killer ~= boss then
                        boss_count = boss_count - 1
                        if boss_count == 0 then
	                        ac.wait(0,function()
	                        	if stage_start == true then
		                        	sg.base.shop:getItem(msg):remove()
		                        	stage_start = false
		                            timer2:remove()
		                            local back_time = 10
		                            local back_msg = '即将返回'
		                            local back_timer = ac.wait(back_time, function()
		                                for k, hero in ipairs(hero_mark) do
		                                    local p2 = home - {360 / #hero_mark * k, 120}
		                                    hero:tp(p2, true)
		                                    local buff = hero:findBuff('假死')
		                                    if buff then
		                                        buff:remove()
		                                    end
		                                    hero:set('生命', hero:get('生命上限'))
		                                    hero:set('魔法', hero:get('魔法上限'))
		                                    hero:removeRestriction '无敌'
		                                end
		                                instance_end()
		                            end)
		                            for _, hero in ipairs(hero_mark) do
		                                hero:addRestriction '无敌'
		                                local player = hero:getOwner()
		                                player:message('|cff00ff00boss团灭|r了xs,你们胜利了,|cffff7500'..back_time..'|r秒后返回', 8)
		                                player:message('所有参与者获得|cffffdd00200000|r金钱和|cff25cc75200000|r木材,爽死了', 8)
		                                player:timerDialog(back_msg, back_timer)
		                                hero:createItem('副本奖励1')
		                            end
		                            --赢了也会关掉所有事件并且清掉小怪
		                            event1_mark = false
		                            for _, u in ipairs(event1_monster_mark) do
		                                if u:isAlive() then
		                                    ac.effect {
		                                        target = u:getPoint(),
		                                        model = [[Abilities\Spells\Human\Polymorph\PolyMorphTarget.mdl]],
		                                        speed = 2,
		                                        time = 0,
		                                    }
		                                    u:kill(u)
		                                    u:remove()
		                                end
		                            end
		                            ac.game:musicTheme([[resource\music\victory.mp3]])
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
                            end)
                        end
                    end
                end)
            end
            sg.game_mod = '副本'
            event1_mark = true
            --事件:进入区域会刷兵
            function event1_rect:onEnter(u)
                local player = u:getOwner()
                local id = player:id()
                if event1_mark == true and u:isHero() and (id >= 1 and id <= sg.max_player) then
                    event1_mark = false
                    u:addBuff '诱捕'
                    {
                        time = 5,
                    }
                    local p1 = u:getPoint()
                    for _, hero in ipairs(hero_mark) do
                        hero:getOwner():message('被|cffff7500埋伏|r了!', 8)
                    end
                    for i = - event1_monster_data[1].count / 2, event1_monster_data[1].count / 2 do
                        local width = event1_monster_data[1].width / event1_monster_data[1].count
                        local p2 = event1_monster_data[1].point - {0, width * i}
                        local monster = sg.creeps_player:createUnit(event1_monster_data[1].name, p2, event1_monster_data[1].facing)
                        monster:attack(p1)
                        table.insert(event1_monster_mark, monster)
                    end
                    for i = - event1_monster_data[2].count / 2, event1_monster_data[2].count / 2 do
                        local width = event1_monster_data[2].width / event1_monster_data[2].count
                        local p2 = event1_monster_data[2].point - {0, width * i}
                        local monster = sg.creeps_player:createUnit(event1_monster_data[2].name, p2, event1_monster_data[2].facing)
                        monster:attack(p1)
                        table.insert(event1_monster_mark, monster)
                    end
                end
            end
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
    ac.game:event('地图-删除英雄', function (_, u)
        for k, unit in ipairs(mark) do
            if u == unit then
                table.remove(mark, k)
                break
            end
        end
        textTag_msg = '|cffffcc00'..msg..'|n|cffffff00参与人数:'..#mark..'/'..sg.player_count..'|r'
        textTag:text(textTag_msg, 0.04)
        if #mark >= sg.player_count then
            instance()
        end
    end)

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
        player:message('|cffff7500虎牢关大战|r副本已激活,想去就所有人在|cffff7500'..time..'|r秒内去|cffff7500飞机|r集合.jpg', 60)
    end
end