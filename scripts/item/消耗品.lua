
local mt = ac.item['经验之书']

function mt:onAdd()
    local item = self
    --作用目标是玩家英雄
    local unit = item:getOwner()
    local i_player = unit:getOwner()
    local hero = i_player:getHero()
    local p = hero:getPoint()

    local exp = item.exp
    local msg_height = 60
    hero:addExp(exp, true)
    local msg = '|cff757575+'..math.floor(exp)..'exp|n'
    ac.textTag()
        : text(msg, 0.022)
        : at(p, msg_height)
        : speed(0.025, 90)
        : life(1.5, 0.8)
        : show(function (player)
            return player == i_player
        end)
end

local tbl = {'作弊等级','孙子兵法'}

for _, tbl_name in ipairs(tbl) do
	local mt = ac.item[tbl_name]

	function mt:onCanAdd(unit)
        local player = unit:getOwner()
        local hero = player:getHero()
        if hero:level() >= sg.max_level then
        	return false,'|cffffff00你的英雄已达到|cffff7500满级|r'
    	end
    end

    function mt:onAdd()
        local item = self
        --作用目标是玩家英雄
        local unit = item:getOwner()
        local i_player = unit:getOwner()
        local hero = i_player:getHero()
        local p = hero:getPoint()

        local lv = item.lv
        local msg_height = 60
        hero:level(hero:level() + lv, true)
        local msg = '|cff00ddeeLevel Up'..math.floor(lv)..'|n'
        ac.textTag()
            : text(msg, 0.022)
            : at(p, msg_height)
            : speed(0.025, 90)
            : life(1.5, 0.8)
            : show(function (player)
                return player == i_player
            end)
    end
end

local mt = ac.item['作弊金钱']

function mt:onAdd()
    local item = self
    local unit = item:getOwner()
    local i_player = unit:getOwner()

    local gold = item.gold
    local lumber = item.lumber
    local msg_height = 140
    if gold > 0 then
        i_player:add('金币', gold)
        local msg = '|cffffdd00+'..math.floor(gold)..'|n'
        ac.textTag()
            : text(msg, 0.025)
            : at(unit:getPoint(), msg_height)
            : speed(0.025, 90)
            : life(1.5, 0.8)
            : show(function (player)
                return player == i_player
            end)
        msg_height = msg_height - 40
    end
    if lumber > 0 then
        i_player:add('木材', lumber)
        local msg = '|cff25cc75+'..math.floor(lumber)..'|n'
        ac.textTag()
            : text(msg, 0.025)
            : at(unit:getPoint(), msg_height)
            : speed(0.025, 90)
            : life(1.5, 0.8)
            : show(function (player)
                return player == i_player
            end)
        msg_height = msg_height - 40
    end
    ac.effect {
        target = unit:getPoint(),
        model = [[Abilities\Spells\Other\Transmute\PileofGold.mdl]],
        speed = 1,
        size = 2,
        time = 1.5,
    }
end

local tbl = {'副本奖励1','副本奖励2','副本奖励3'}

for _, tbl_name in ipairs(tbl) do
	local mt = ac.item[tbl_name]

    function mt:onAdd()
        local item = self
        local unit = item:getOwner()
        local i_player = unit:getOwner()

        local gold = item.gold
        local msg = ''
        local text = ac.textTag()
            : text(msg, 0.025)
            : at(unit:getPoint(), 250)
            : show(function (player)
                return player == i_player
            end)
        local gold_add = 0
        local gold_add2 = 0
        local gold_sum = 0
        local size = 0.025
        local size_int = 16
        local timer
        timer = ac.timer(0.04, 500, function()
            if size_int > 15 then
                gold_add = gold_add + gold_add2
                gold_add2 = gold_add2 + math.random(2,3)
                if gold_add > gold then
                    gold_add = gold
                    size_int = 15
                end
                gold = gold - gold_add
                gold_sum = gold_sum + gold_add
                i_player:add('金币', gold_add)
                i_player:add('木材', gold_add)
            else
                if size_int > 0 then
                    size = size + (size_int - 8) * 0.0015
                else
                    text:life(0.6, 0.3)
                    timer:remove()
                end
                size_int = size_int - 1
            end
            msg = ''
            msg = msg..'|cffffdd00+'..gold_sum..'|r|n'
            msg = msg..'|cff25cc75+'..gold_sum..'|r|n'
            text:text(msg, size)
            text:at(unit:getPoint(), 250)
        end)
        ac.effect {
            target = unit:getPoint(),
            model = [[Abilities\Spells\Other\Transmute\PileofGold.mdl]],
            speed = 1,
            size = 2,
            time = 1.5,
        }
    end
end

local mt = ac.item['作弊属性']

function mt:onAdd()
    local item = self
    --作用目标是玩家英雄
    local unit = item:getOwner()
    local i_player = unit:getOwner()
    local hero = i_player:getHero()

    hero:add('力量', self.attribute['力量'])
    hero:add('敏捷', self.attribute['敏捷'])
    hero:add('智力', self.attribute['智力'])
    hero:particle([[Abilities\Spells\Other\Charm\CharmTarget.mdl]], 'origin', 0)
end

local mt = ac.item['作弊自杀']

function mt:onAdd()
    local item = self
    --作用目标是玩家英雄
    local unit = item:getOwner()
    local i_player = unit:getOwner()
    local hero = i_player:getHero()

    hero:kill(hero)
end

local mt = ac.item['作弊清怪']

function mt:onAdd()
    local item = self
    --作用目标是玩家英雄
    local unit = item:getOwner()
    local i_player = unit:getOwner()
    local hero = i_player:getHero()

    for _, u in ipairs(sg.all_enemy) do
        hero:kill(u)
    end
end

local mt = ac.item['作弊WTF']

function mt:onAdd()
    local item = self
    --作用目标是玩家英雄
    local unit = item:getOwner()
    local i_player = unit:getOwner()
    local hero = i_player:getHero()

    hero:set('冷却缩减', 100)
end

local mt = ac.item['商城作弊怪']

function mt:onAdd()
    local item = self
    local unit = item:getOwner()
    local player = unit:getOwner()

	player:add_shop_info('新手礼包',1)
	player:add_shop_info('白亚之翼',1)
	player:add_shop_info('原初的符文',1)
	player:add_shop_info('头号玩家',1)
	player:add_shop_info('大师祝福',1)
	player:add_shop_info('天神下凡',1)
	player:add_shop_info('时为朦胧的雪花之翼',1)
	function player.__index:get_score()
		return 99999
	end
    player:message('哇噢商城的|cffffdd00氪金|r道具都是我的啦!', 5)
end

local mt = ac.item['作弊副本']

function mt:onAdd()
    local item = self
    local unit = item:getOwner()
    local player = unit:getOwner()

    local shop = sg.base:createShop()
    local tbl = {'副本-虎牢关大战','副本-大战黄巾贼','副本-过五关斩六将'}

    for _,skill_name in ipairs(tbl) do
        local skill = shop:getItem(skill_name)
        if not skill:isEnable() then
            skill:enable()
        end
    end
    player:message('8说了,副本|cffffdd00解锁了|r,葱鸭', 5)
end

local mt = ac.skill['治疗药水-小']

function mt:onCastShot()
    local skill = self
    --作用目标是玩家英雄
    local unit = skill:getOwner()
    local i_player = unit:getOwner()
    local hero = i_player:getHero()

    local heal = skill.heal
    local heal_rate = skill.heal_rate * hero:get('生命上限') / 100
    heal = heal + heal_rate
    heal = math.min(hero:get('生命上限') - hero:get('生命'), heal)
    hero:add('生命', heal)
    hero:particle([[Abilities\Spells\Undead\VampiricAura\VampiricAuraTarget.mdl]], 'origin', 0)
    local msg = '|cff00ff00+'..math.floor(heal)..'|n'
    ac.textTag()
        : text(msg, 0.02)
        : at(hero:getPoint(), 100)
        : speed(0.03, 90)
        : life(1.5, 0.8)
        : show(function (player)
            return player == i_player
        end)

    local item = skill:getItem()
    if item then
        item:stack(item:stack() - 1)
        if item:stack() == 0 then
            item:remove()
        end
    end
end

local mt = ac.skill['治疗药水-大']

function mt:onCastShot()
    local skill = self
    --作用目标是玩家英雄
    local unit = skill:getOwner()
    local i_player = unit:getOwner()
    local hero = i_player:getHero()

    local heal = skill.heal
    local heal_rate = skill.heal_rate * hero:get('生命上限') / 100
    heal = heal + heal_rate
    heal = math.min(hero:get('生命上限') - hero:get('生命'), heal)
    hero:add('生命', heal)
    hero:particle([[Abilities\Spells\Undead\VampiricAura\VampiricAuraTarget.mdl]], 'origin', 0)
    local msg = '|cff00ff00+'..math.floor(heal)..'|n'
    ac.textTag()
        : text(msg, 0.02)
        : at(hero:getPoint(), 100)
        : speed(0.03, 90)
        : life(1.5, 0.8)
        : show(function (player)
            return player == i_player
        end)

    local item = skill:getItem()
    if item then
        item:stack(item:stack() - 1)
        if item:stack() == 0 then
            item:remove()
        end
    end
end
