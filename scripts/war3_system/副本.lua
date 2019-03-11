
local start_point = ac.point(6050, -9300)

local mt = ac.item['副本-大战黄巾贼']

function mt:onAdd()
    local mark = {}

    for i = 1, 6 do
        local player = ac.player(i)
        player:message('|cffff7500大战黄巾贼|r副本已激活,想去的自己坐|cffff7500飞机|r.jpg', 60)
    end
    --飞机特效
    local eff = ac.effect {
        target = start_point,
        model = [[units\creeps\GoblinZeppelin\GoblinZeppelin.mdl]],
        size = 3,
        speed = 1,
        time = 120,
    }

    local rect = ac.rect(start_point, 400, 400)
    local function bihi()
        print('8说了,开飞')
        eff:remove()
        rect:remove()
    end
    function rect:onEnter(u)
        local player = u:getOwner()
        local id = player:id()
        if u:isHero() and (id >= 1 and id <= 6) then
            mark[u] = true
            print(u,'已经上飞机了,现在人数',#mark)
            if #mark >= 1 then
                print('所有人都上飞机了')
                bihi()
            end
        end
    end
    function rect:onLeave(u)
        if mark[u] == true then
            mark[u] = false
            print(u,'又下飞机了')
        end
    end
end