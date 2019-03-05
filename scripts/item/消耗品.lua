
local mt = ac.item['经验之书']

function mt:onAdd()
    local item = self
    local unit = item:getOwner()
    local i_player = unit:getOwner()
    
    local exp = item.exp
    unit:addExp(exp, true)
    local msg = '|cff757575+'..math.floor(exp)..'exp|n'
    ac.textTag()
        : text(msg, 0.022)
        : at(unit:getPoint(), 60)
        : speed(0.025, 90)
        : life(1.5, 0.8)
        : show(function (player)
            return player == i_player
        end)
end