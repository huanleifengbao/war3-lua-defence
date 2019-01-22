
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

local title = {
    [1] = '|cffffff00弟弟|r',
    [2] = '|cff505050露米娅',
    [3] = '|cff00ffff⑨',
    [4] = '|cffff0000红美铃',
    [5] = '|cffff00ff姆Q',
    [6] = '|cffccffffPAD',
    [7] = '|cffaaccff蕾米',
    [8] = '|cffffcc00芙兰',
}
local title_icon = {
    [1] = [[ReplaceableTextures\CommandButtons\BTNPenguin.blp]],
    [2] = [[ReplaceableTextures\CommandButtons\BTNDispelMagic.blp]],
    [3] = [[ReplaceableTextures\CommandButtons\BTNIceShard.blp]],
    [4] = [[ReplaceableTextures\CommandButtons\BTNGauntletsOfOgrePower.blp]],
    [5] = [[ReplaceableTextures\CommandButtons\BTNNecromancerAdept.blp]],
    [6] = [[ReplaceableTextures\CommandButtons\BTNArcaniteArmor.blp]],
    [7] = [[ReplaceableTextures\CommandButtons\BTNSearingArrows.blp]],
    [8] = [[ReplaceableTextures\CommandButtons\BTNVampiricAura.blp]],
}
local title_level = {
    [1] = 0,
    [2] = 5,
    [3] = 9,
    [4] = 20,
    [5] = 30,
    [6] = 45,
    [7] = 60,
    [8] = 100,
}
local player_title = {}
for i = 1, 6 do
    player_title[i] = 1
end

ac.wait(0, function()
    local board = ac.game:board(7, 6, '初始化中')
    ac.wait(1, function()
        board:show()
        board:style(true, false)
        board[1][1]:text('基地')
        board[1][2]:text('英雄')
        board[1][3]:text('Lv')
        board[1][4]:text('杀敌')
        board[1][5]:text('翻车')
        board[1][6]:text('称号')
        for i = 1, 7 do
            board[i][1]:width(0.07)
            board[i][2]:width(0.05)
            board[i][3]:width(0.02)
            board[i][4]:width(0.02)
            board[i][5]:width(0.025)
            board[i][6]:width(0.03)
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
            board[id+1][2]:style(true, true)
            board[id+1][2]:icon(unit:slk('art'))
            board[id+1][2]:text(unit:getName())
            board[id+1][3]:text('1')
            board[id+1][4]:text('0')
            board[id+1][5]:text('|cffff0000没死过|r')
            board[id+1][6]:style(true, true)
            board[id+1][6]:icon(title_icon[player_title[id]])
            board[id+1][6]:text(title[player_title[id]])
        end
    end)

    --等级
    ac.game:event('地图-选择英雄', function (_, unit, player)
        unit:event('单位-升级', function (trg, unit)
            local id = player:id()
            board[id+1][3]:text(unit:level())
        end)
        unit:event('单位-降级', function (trg, unit)
            local id = player:id()
            board[id+1][3]:text(unit:level())
        end)
    end)

    --死亡
    local hero_dead = {}
    for i = 1, 6 do
        hero_dead[i] = 0
    end
    ac.game:event('地图-英雄死亡', function (_, unit, player, reborn_time)
        local id = player:id()
        if unit then
            hero_dead[id] = hero_dead[id] + 1
            board[id+1][5]:text(hero_dead[id])
        end
    end)

    --击杀
    local hero_kill = {}
    for i = 1, 6 do
        hero_kill[i] = 0
    end
    ac.game:event('地图-英雄杀敌', function (_, unit, player, dead)
        local id = player:id()
        if unit then
            hero_kill[id] = hero_kill[id] + 1
            board[id+1][4]:text(hero_kill[id])
            --称号
            if player_title[id] < #title_level and hero_kill[id] >= title_level[player_title[id] + 1] then
                player_title[id] = player_title[id] + 1
                board[id+1][6]:icon(title_icon[player_title[id]])
                board[id+1][6]:text(title[player_title[id]])
                print(unit:getName()..'成为了'..title[player_title[id]])
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
        game_mod_str = '|cffffcc00难度: |r'..game_mod_str
    end)

    ac.loop(1, function()
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
        game_time_str = game_time_str..game_time[3]..':'
        if game_time[2] < 10 then
            game_time_str = game_time_str..'0'
        end
        game_time_str = game_time_str..game_time[2]..':'
        if game_time[1] < 10 then
            game_time_str = game_time_str..'0'
        end
        game_time_str = game_time_str..game_time[1]
        board:title('|cffffff00〓传奇三国积分版〓  |r'..game_mod_str..'    '..game_time_str)

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