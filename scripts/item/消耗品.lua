
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

local mt = ac.skill['治疗药水-小']

function mt:onCastShot()
    local skill = self
    local hero = skill:getOwner()

    local heal = skill.heal
    hero:add('生命', heal)
    hero:particle([[Abilities\Spells\Undead\VampiricAura\VampiricAuraTarget.mdl]], 'origin')
end

local mt = ac.skill['治疗药水-大']

function mt:onCastShot()
    local skill = self
    local hero = skill:getOwner()

    local heal = skill.heal
    hero:add('生命', heal)
    hero:particle([[Abilities\Spells\Undead\VampiricAura\VampiricAuraTarget.mdl]], 'origin')
end
