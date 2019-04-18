
local mt = ac.item['副本-过五关斩六将']
local stage_start = false
--飞机位置
local start_point = ac.point(6050, -9300)
--副本位置
local target_point = {   
    ac.point(-7300, 7400),
    ac.point(-6800, -1250),
    ac.point(-7600, 10150),
    ac.point(-3000, 4100),
    ac.point(-4000, -1150),
}
--回城
local home = ac.point(7044, -8792)
--副本初始怪物
local instance_data = {
    {
        {name = '副本-孔秀', point = ac.point(-7300, 8700), facing = 270},
    },
    {
        {name = '副本-韩福', point = ac.point(-6800, 2600), facing = 270},
        {name = '副本-孟坦', point = ac.point(-6725, 5625), facing = 270},
    },
    {
        {name = '副本-卞喜', point = ac.point(-7777, 11350), facing = 270},
    },
    {
        {name = '副本-王植', point = ac.point(-3050, 4650), facing = 270},
    },
    {
        {name = '副本-秦琪', point = ac.point(-3200, 100), facing = 270},
    },
}
--打boss前的额外怪物
local monster_data = {
    nil,
    nil,
    nil,
    {name = '副本-王植随从', point = ac.point(-2900, 4600), kill_count = 60, max_count = 30},
    {name = '副本-秦琪随从', point = ac.point(-3200, -100), kill_count = 90, max_count = 20},
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
    local trg_mark = {}
    local hero_count = 0
    local boss_mark = {}
    local boss_count = 0
    local monster_mark = {}
    --副本当前阶段
    local instance_lv = 0

    local time = 120
    local msg = '副本-过五关斩六将'
    local time2 = 600
    local msg2 = '时间限制'
    --飞机特效
    local eff1 = ac.effect {
        target = start_point - {135,300},
        model = [[effect\flag.mdx]],
        height = 0,
        angle = 315,
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
            for _,trg in ipairs(trg_mark) do
	            if trg then
		            trg:remove()
	            end
            end
            hero_mark = {}
            boss_mark = {}
            sg.game_mod = '通常'
            for i = 1,sg.max_player do
                local player = ac.player(i)
                player:message('副本已结束,敌人重新开始|cffff7500进攻|r', 5)
                sg.reborn(player,0)
            end
        end
        --删除剩余小怪
        if #monster_mark > 0 then
            for _, u in ipairs(monster_mark) do
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
            monster_mark = {}
        end
        --如果根本没人上飞机就直接end
        if #mark == 0 then
            instance_end()
        else
	        --刁民一下？
	        local rect = ac.rect(-7300,2800,-6200,3200)
	        jass.EnumDestructablesInRect(rect._handle,nil,function()
	        	local door = jass.GetEnumDestructable()
	        	jass.DestructableRestoreLife(door,jass.GetDestructableMaxLife(door), false)
	        end)
	        rect:remove()
	        --音乐
	        ac.game:music([[resource\music\fb3.mp3]])
	        stage_start = true
	        --视野
			sg.off_fog(ac.rect(-8100,6800,-6500,9200))
			sg.off_fog(ac.rect(-7800,-1400,-5700,6300))
			sg.off_fog(ac.rect(-8800,9600,-6300,11700))
			sg.off_fog(ac.rect(-4900,2700,-750,6800))
			sg.off_fog(ac.rect(-5100,-1900,-1100,1900))
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

            --刷小怪
            local monster_start, monster_end
            local monster_timer = nil
            local monster_count = 0
            function monster_start()
                local boss_awake = false
                local kill_count = monster_data[instance_lv].kill_count
                monster_timer = ac.loop(0.3, function()
                    if monster_count < monster_data[instance_lv].max_count then
                        monster_count = monster_count + 1
                        local p1 = hero_mark[math.random(#hero_mark)]:getPoint()
                        local p2 = ac.point(monster_data[instance_lv].point[1] + math.random(-1500,1500),monster_data[instance_lv].point[2] + math.random(-1500,1500))
                        local monster = sg.creeps_player:createUnit(monster_data[instance_lv].name, p2, math.random(360))
                        monster:attack(p1)
                        table.insert(monster_mark, monster)
                        monster:event('单位-死亡', function (trg)
                            monster_count = monster_count - 1
                            if kill_count > 0 then
                                kill_count = kill_count - 1
                            else
                                if boss_awake == false then
                                    boss_awake = true
                                    for _, boss in ipairs(boss_mark) do
                                        boss:removeRestriction '隐藏'
                                        boss:removeRestriction '硬直'
                                        if boss:getName() == '副本-王植' then
                                            local p = boss:getPoint()
                                            ac.effect {
                                                target = p,
                                                model = [[Abilities\Spells\Orc\WarStomp\WarStompCaster.mdl]],
                                                size = 2,
                                                time = 0,
                                            }
                                            local size = 1
                                            ac.timer(0.2, 7, function()
                                                ac.effect {
                                                    target = p,
                                                    model = [[Abilities\Spells\Other\Doom\DoomDeath.mdl]],
                                                    size = size,
                                                    time = 0,
                                                }
                                                size = size * 1.2 + 0.5
                                            end)
                                        end
                                        if boss:getName() == '副本-秦琪' then
                                            for _, u in ipairs(monster_mark) do
                                                if u:isAlive() then
                                                    u:moverTarget
                                                    {
                                                        model = [[Abilities\Weapons\AvengerMissile\AvengerMissile.mdl]],
                                                        target = boss,
                                                        speed = 1500,
                                                        middleHeight = math.random(500),
                                                        finishHeight = 150,
                                                    }
                                                end
                                            end
                                            ac.effect {
                                                target = boss:getPoint(),
                                                model = [[Abilities\Spells\Undead\DeathCoil\DeathCoilSpecialArt.mdl]],
                                                speed = 1,
                                                size = 3,
                                                time = 1,
                                            }
                                        end
                                    end
                                    monster_end()
                                end
                            end
                            trg:remove()
                        end)
                    end
                end)
                for _, boss in ipairs(boss_mark) do
                    boss:addRestriction '隐藏'
                    boss:addRestriction '硬直'
                end
            end
            --清空小怪
            function monster_end()
                if monster_timer then
                    monster_timer:remove()
                    monster_timer = nil
                end
                for _, u in ipairs(monster_mark) do
                    if u:isAlive() then
                        u:kill(u)
                    end
                end
                monster_mark = {}
            end

            local function ace()
                if stage_start == true and hero_count == 0 then
	                stage_start = false
                    monster_end()
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
                player:timerDialog(msg2, timer2)
                player:message('已进入副本,时间限制|cffff7500'..time2..'|r秒请注意', 8)
                player:message('|cff00ff00攻略所有关卡|r才会胜利,|cffff0000团灭或超时|r副本挑战就失败了', 8)
                player:message('另外副本中可是|cffff7500禁止传送|r并且|cffff7500无法复活|r的哟', 8)
                hero_mark[k] = u
                u:addRestriction '硬直'
                local int = 5
                ac.timer(1, 6, function()
                    if int == 5 then
                        player:message('目标:通过|cffff7550所有关卡|r,每次通关都能全体复活', 8)
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
	            --清空事件
	            for _,trg in ipairs(trg_mark) do
		            if trg then
			            trg:remove()
		            end
	            end
                instance_lv = instance_lv + 1
                hero_count = #hero_mark
                --传送英雄
                for k, hero in ipairs(hero_mark) do
                    local player = hero:getOwner()
                    local id = player:id()
                    local p2 = target_point[instance_lv] - {360 / #hero_mark * k, 120}
                    hero:tp(p2, true)
                    --local buff = hero:findBuff('假死')
                    --if buff then
                    --    buff:remove()
                    player:message('阵亡英雄已|cffffff00复活|r', 8)
                    sg.reborn(player,0,p2)
                        --ac.effect {
                        --    target = p2,
                        --    model = [[Abilities\Spells\Human\Resurrect\ResurrectTarget.mdl]],
                        --    time = 0,
                        --}
                   -- end
                    trg_mark[k] = hero:event('单位-死亡', function ()
                        trg_mark[k]:remove()
                        --trg2:remove()
                        hero_count = hero_count - 1
                        if hero_count <= 0 then
                            ace()
                        else
                            --没团灭的死者会假死
                            --hero:addBuff '假死'{}
                           -- for i = 1,sg.max_player do
                            sg.message(sg.player_colour[id]..hero:getName()..'|r被杀了!剩余英雄:|cffff7500'..hero_count..'|r', 5)
                            --end
                            return false
                        end
                    end)
                    --trg2 = hero:event('单位-死亡', function ()
                    --    trg1:remove()
                    --    trg2:remove()
                    --    hero_count = hero_count - 1
                    --    if hero_count <= 0 then
                    --        ace()
                    --    end
                    --end)
                    hero:set('生命', hero:get('生命上限'))
                    hero:set('魔法', hero:get('魔法上限'))
                    player:message('第|cffff7500'..instance_lv..'|r关', 8)
                end
                boss_mark = {}
                for i = 1, #instance_data[instance_lv] do
                    boss_count = boss_count + 1
                    --创建boss
                    local boss = sg.creeps_player:createUnit(instance_data[instance_lv][i].name, instance_data[instance_lv][i].point, instance_data[instance_lv][i].facing)
                    sg.add_ai_skill(boss)
                    table.insert(boss_mark, boss)
                    boss:event('单位-死亡', function (trg, _, killer)
                        trg:remove()
                        if killer ~= boss then
                            boss_count = boss_count - 1
                            if boss_count == 0 then
                                monster_end()
                                --下一关或者通关
                                if instance_lv >= instance_count then
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
		                                            --local buff = hero:findBuff('假死')
		                                            --if buff then
		                                            --    buff:remove()
		                                            --end
		                                            hero:set('生命', hero:get('生命上限'))
		                                            hero:set('魔法', hero:get('魔法上限'))
		                                            hero:removeRestriction '无敌'
		                                        end
		                                        instance_end()
		                                    end)
		                                    ac.game:musicTheme([[resource\music\victory.mp3]])
		                                    for _, hero in ipairs(hero_mark) do
		                                        hero:addRestriction '无敌'
		                                        local player = hero:getOwner()
		                                        player:message('|cff00ff00boss团灭|r了xs,你们胜利了,|cffff7500'..back_time..'|r秒后返回', 8)
		                                        player:message('所有参与者获得|cffffdd00600000|r金钱和|cff25cc75600000|r木材,爽死了', 8)
		                                        player:timerDialog(back_msg, back_timer)
		                                        hero:createItem('副本奖励3')
		                                    end
	                                    end
                                    end)
                                else
                                    local next_time = 5
                                    for _, hero in ipairs(hero_mark) do
                                        local player = hero:getOwner()
                                        player:message('|cff00ff00boss团灭|r了xs,但还没胜利了,|cffff7500'..next_time..'|r秒后进入下一关', 8)
                                    end
                                    ac.wait(5, function()
                                    	if stage_start == true then
                                        	next_lv()
                                    	end
                                    end)
                                end
                            end
                        end
                    end)
                    --如果有怪物表不为空就刷怪
                    if monster_data[instance_lv] then
                        monster_start()
                    end
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
            player:message('还没进副本的进不去了,旗帜都|cffff0000boom|r了', 60)
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
        player:message('|cffff7500过五关斩六将|r副本已激活,想去就所有人在|cffff7500'..time..'|r秒内去|cffff7500能量圈|r集合', 60)
    end
end

--小怪额外装逼表现
ac.game:event('单位-创建', function (_, u)
    if u:getName() == '副本-王植随从' then
        u:addRestriction '隐藏'
        u:addRestriction '硬直'
        u:moverLine
        {
            model = [[Abilities\Weapons\DemolisherFireMissile\DemolisherFireMissile.mdl]],
            angle = 0,
            speed = 1,
            distance = 1.5,
            startHeight = 1500,
            middleHeight = 1500,
            finishHeight = 0,
        }
        ac.wait(1.5, function()
            if u:isAlive() then
                u:animation('birth')
            end
            u:removeRestriction '隐藏'
            ac.wait(0.67, function()
                u:removeRestriction '硬直'
            end)
        end)
    end
    if u:getName() == '副本-秦琪随从' then
        u:addRestriction '硬直'
        u:animation('spell')
        u:moverLine
        {
            mover = u,
            angle = 0,
            speed = 0.7,
            distance = 1,
            startHeight = -300,
            finishHeight = 0,
        }
        ac.effect {
            target = u:getPoint(),
			model = [[Abilities\Spells\Undead\RaiseSkeletonWarrior\RaiseSkeleton.mdl]],
            speed = 0.7,
            size = 1.5,
            time = 0,
		}
        ac.wait(2, function()
            u:removeRestriction '硬直'
        end)
    end
end)