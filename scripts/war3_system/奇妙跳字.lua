

local mt = ac.item['作弊金钱']

function mt:onAdd()
    local item = self
    local unit = item:getOwner()
    local i_player = unit:getOwner()

    local gold = item.gold
    local lumber = item.lumber
    local msg = ''
    local text = ac.textTag()
        : text(msg, 0.025)
        : at(unit:getPoint(), 250)
        : show(function (player)
            return player == i_player
        end)
    --[[if lumber > 0 then
        i_player:add('木材', lumber)
        local msg = '|cff25cc75+'..math.floor(lumber)..'|r|n'
    end]]
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
                text:life(4.5, 3)
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