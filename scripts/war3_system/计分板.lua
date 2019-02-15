
local player_colour = {
    [1] = '|cFFF00000',
    [2] = '|c000000FF',
    [3] = '|c000EEEEE',
    [4] = '|c77700077',
    [5] = '|cFFFFFF00',
    [6] = '|cFFF77700',
    [7] = '|c000EEE00',
    [8] = '|cFFF222FF',
    [9] = '|c88888888',
    [10] = '|c777DDDFF',
    [11] = '|c00077766',
    [12] = '|c44400000',
}

--威望
local title = {
    [1] = '|cffffffcc初入江湖|r',
    [2] = '|cff505050武林菜鸟',
    [3] = '|cff00ffff声名鹊起',
    [4] = '|cff00aa00武林高手',
    [5] = '|cffff00ff一代宗师',
    [6] = '|cffccffff武林至尊',
    [7] = '|cffff0000独孤求败',
    [100] = '|cffffffff最多七个汉字哦',
}
local title_icon = {
    [1] = [[ReplaceableTextures\CommandButtons\BTNPenguin.blp]],
    [2] = [[ReplaceableTextures\CommandButtons\BTNDispelMagic.blp]],
    [3] = [[ReplaceableTextures\CommandButtons\BTNIceShard.blp]],
    [4] = [[ReplaceableTextures\CommandButtons\BTNGauntletsOfOgrePower.blp]],
    [5] = [[ReplaceableTextures\CommandButtons\BTNNecromancerAdept.blp]],
    [6] = [[ReplaceableTextures\CommandButtons\BTNArcaniteArmor.blp]],
    [7] = [[ReplaceableTextures\CommandButtons\BTNSearingArrows.blp]],
}
local title_level = {
    [1] = 0,
    [2] = 1000,
    [3] = 2000,
    [4] = 3000,
    [5] = 4000,
    [6] = 5000,
    [7] = 6000,
}

--觉醒
local title2 = {
    [1] = '|cffffffcc未觉醒|r',
    [2] = '|cffffffcc一阶|r',
    [3] = '|cff505050二阶',
    [4] = '|cff00ffff三阶',
    [5] = '|cff00aa00四阶',
    [6] = '|cffff00ff五阶',
    [7] = '|cffccffff六阶',
    [8] = '|cffff0000七阶',
    [9] = '|cffff0000八阶',
    [10] = '|cffff0000九阶',
    [11] = '|cffff0000十阶',
    [100] = '|cffffffff最多七个汉字哦',
}
local title2_icon = {
    [1] = [[ReplaceableTextures\CommandButtons\BTNPenguin.blp]],
    [2] = [[ReplaceableTextures\CommandButtons\BTNDispelMagic.blp]],
    [3] = [[ReplaceableTextures\CommandButtons\BTNIceShard.blp]],
    [4] = [[ReplaceableTextures\CommandButtons\BTNGauntletsOfOgrePower.blp]],
    [5] = [[ReplaceableTextures\CommandButtons\BTNNecromancerAdept.blp]],
    [6] = [[ReplaceableTextures\CommandButtons\BTNArcaniteArmor.blp]],
    [7] = [[ReplaceableTextures\CommandButtons\BTNSearingArrows.blp]],
    [8] = [[ReplaceableTextures\CommandButtons\BTNSearingArrows.blp]],
    [9] = [[ReplaceableTextures\CommandButtons\BTNSearingArrows.blp]],
    [10] = [[ReplaceableTextures\CommandButtons\BTNSearingArrows.blp]],
}

ac.wait(0, function()
    local board = ac.game:board(7, 9, '初始化中')
    ac.wait(1, function()
        board:show()
        board:style(true, false)
        board[1][1]:text('基地')
        board[1][2]:text('战力')
        board[1][3]:text('抗性')
        board[1][4]:text('闪避')
        board[1][5]:text('－－－－－威望－－－－－')
        board[1][6]:text('觉醒')
        board[1][7]:text('战魂')
        board[1][8]:text('坐骑')
        board[1][9]:text('杀敌')
        for i = 1, 9 do
            board[i][1]:width(0.07)
            board[i][2]:width(0.03)
            board[i][3]:width(0.02)
            board[i][4]:width(0.02)
            board[i][5]:width(0.06)
            board[i][6]:width(0.04)
            board[i][7]:width(0.02)
            board[i][8]:width(0.02)
            board[i][9]:width(0.035)
            if i ~= 1 then
                local player = ac.player(i-1)
                if player and player:controller() == '用户' and player:gameState() == '在线' then
                    board[i][1]:text(player_colour[i-1]..player:name()..'|r')
                end
            end
        end
    end)

    ac.game:event('地图-选择英雄', function (_, unit, player)
        local id = player:id()
        if unit then
            --开挂
            unit:addSkill('赤兔', '技能', 1)
            unit:addSkill('三国无双', '技能', 2)
            --初始化积分相关属性
            unit:set('威望等级', 1)
            unit:set('觉醒等级', 1)
            unit:set('战魂数量', 0)
            unit:set('坐骑数量', 0)
            --设置多面板
            board[id+1][1]:style(true, true)
            board[id+1][1]:icon(unit:slk('art'))
            board[id+1][2]:text(math.floor(unit:get('战力')))
            board[id+1][3]:text(math.floor(unit:get('抗性')))
            board[id+1][4]:text(math.floor(unit:get('闪避')))
            board[id+1][5]:style(true, true)
            board[id+1][5]:icon(title_icon[unit:get('威望等级')])
            board[id+1][5]:text(title[unit:get('威望等级')])
            board[id+1][6]:style(true, true)
            board[id+1][6]:icon(title2_icon[unit:get('觉醒等级')])
            board[id+1][6]:text(title2[unit:get('觉醒等级')])
            board[id+1][7]:text(title2[unit:get('战魂数量')])
            board[id+1][8]:text(title2[unit:get('坐骑数量')])
            board[id+1][9]:text('0')
        end
    end)

    --等级
    --[[ac.game:event('地图-选择英雄', function (_, unit, player)
        unit:event('单位-升级', function (trg, unit)
            local id = player:id()
            board[id+1][3]:text(unit:level())
        end)
        unit:event('单位-降级', function (trg, unit)
            local id = player:id()
            board[id+1][3]:text(unit:level())
        end)
    end)]]

    --死亡
    --[[local hero_dead = {}
    for i = 1, 6 do
        hero_dead[i] = 0
    end
    ac.game:event('地图-英雄死亡', function (_, unit, player, reborn_time)
        local id = player:id()
        if unit then
            hero_dead[id] = hero_dead[id] + 1
            board[id+1][5]:text(hero_dead[id])
        end
    end)]]

    --击杀
    local hero_kill = {}
    for i = 1, 6 do
        hero_kill[i] = 0
    end
    ac.game:event('地图-英雄杀敌', function (_, unit, player, dead)
        local id = player:id()
        if unit then
            hero_kill[id] = hero_kill[id] + 1
            board[id+1][9]:text(hero_kill[id])
            --称号
            if unit:get('威望') < #title_level and hero_kill[id] >= title_level[unit:get('威望') + 1] then
                unit:add('威望', 1)
                board[id+1][4]:icon(title_icon[unit:get('威望')])
                board[id+1][4]:text(title[unit:get('威望')])
                print(unit:getName()..'成为了'..title[unit:get('威望')])
            end
        end
    end)

    --显示游戏时间
    local game_time_str = ''
    local game_time = {}
    game_time[1] = 0
    game_time[2] = 0
    game_time[3] = 0

    --显示游戏难度
    local game_mod_str = '难度选择中...'
    ac.game:event('地图-选择难度', function (_, num)
        if num == 1 then
            game_mod_str = '|cff00ff00Easy|r'
        elseif num == 2 then
            game_mod_str = '|cffffff00Normal|r'
        elseif num == 3 then
            game_mod_str = '|cffff0000Hard|r'
        elseif num == 4 then
            game_mod_str = '|cffff00ffLunatic|r'
        end
        game_mod_str = '|cffffcc00当前难度: |r'..game_mod_str
    end)

    ac.loop(1, function()
        --修改玩家属性
        for i = 1, 6 do
            local player = ac.player(i)
            if player and player:controller() == '用户' then
                local unit = player:getHero()
                if unit then
                    board[i+1][2]:text(math.floor(unit:get('战力')))
                    board[i+1][3]:text(math.floor(unit:get('抗性')))
                    board[i+1][4]:text(math.floor(unit:get('闪避')))
                end
            end
        end
        
        --修改标题
        game_time_str = ''
        if game_time[1] >= 59 then
            game_time[1] = 0
            if game_time[2] >= 59 then
                game_time[2] = 0
                game_time[3] = game_time[3] + 1
            else
                game_time[2] = game_time[2] + 1
            end
        else
            game_time[1] = game_time[1] + 1
        end
        if game_time[3] < 10 then
            game_time_str = game_time_str..'0'
        end
        game_time_str = game_time_str..game_time[3]..'时'
        if game_time[2] < 10 then
            game_time_str = game_time_str..'0'
        end
        game_time_str = game_time_str..game_time[2]..'分'
        if game_time[1] < 10 then
            game_time_str = game_time_str..'0'
        end
        game_time_str = game_time_str..game_time[1]..'秒'
        board:title('|cffffff00〓传奇三国〓             玩家英雄属性     |r'..game_mod_str..'    '..'游戏时间:'..game_time_str)

        --显示基地血量
        local base_str = '基地[|cffffcc00'
        for i = 1, 20 do
            if sg.base and sg.base:get('生命') / sg.base:get('生命上限') > 0.05 * (i-0.5) then
                base_str = base_str..'I'
            else
                base_str = base_str..' '
            end
        end
        base_str = base_str..'|r]'
        board[1][1]:text(base_str)
    end)
end)