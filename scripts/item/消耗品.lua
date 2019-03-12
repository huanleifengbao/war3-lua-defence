
local mt = ac.item['经验之书']

function mt:onAdd()
    local item = self
    local unit = item:getOwner()
    local i_player = unit:getOwner()

    local exp = item.exp
    local msg_height = 60
    unit:addExp(exp, true)
    local msg = '|cff757575+'..math.floor(exp)..'exp|n'
    ac.textTag()
        : text(msg, 0.022)
        : at(unit:getPoint(), msg_height)
        : speed(0.025, 90)
        : life(1.5, 0.8)
        : show(function (player)
            return player == i_player
        end)
end

local mt = ac.item['作弊等级']

function mt:onAdd()
    local item = self
    local unit = item:getOwner()
    local i_player = unit:getOwner()

    local lv = item.lv
    local msg_height = 60
    unit:level(unit:level() + lv, true)
    local msg = '|cff00ddeeLevel Up'..math.floor(lv)..'|n'
    ac.textTag()
        : text(msg, 0.022)
        : at(unit:getPoint(), msg_height)
        : speed(0.025, 90)
        : life(1.5, 0.8)
        : show(function (player)
            return player == i_player
        end)
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

local mt = ac.skill['治疗药水-小']

function mt:onCastShot()
    local skill = self
    --作用目标是玩家英雄
    local unit = skill:getOwner()
    local i_player = unit:getOwner()
    local hero = i_player:getHero()

    local heal = skill.heal
    hero:add('生命', heal)
    hero:particle([[Abilities\Spells\Undead\VampiricAura\VampiricAuraTarget.mdl]], 'origin', 0)

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
    hero:add('生命', heal)
    hero:particle([[Abilities\Spells\Undead\VampiricAura\VampiricAuraTarget.mdl]], 'origin', 0)

    local item = skill:getItem()
    if item then
        item:stack(item:stack() - 1)
        if item:stack() == 0 then
            item:remove()
        end
    end
end
