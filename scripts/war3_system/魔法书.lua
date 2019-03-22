local mt = ac.skill['战魂魔法书']

function mt:onCastShot()
    local hero = self:getOwner()
    local box_skill = hero:findSkill('战魂魔法书-关闭')
    if not box_skill then
        box_skill = hero:addSkill('战魂魔法书-关闭', '技能', 4)
        local tbl = hero:userData('战魂技能')
        for _, skill in pairs(tbl) do
            skill:show()
        end
        hero:iconLevel('技能', 50)
    end
end

local function closebox(hero)
    local box_skill = hero:findSkill('战魂魔法书-关闭')
    if box_skill then
        local tbl = hero:userData('战魂技能')
        for _, skill in pairs(tbl) do
            skill:show()
        end
        hero:iconLevel('技能', 0)
        box_skill:remove()
    end
end

local mt = ac.skill['战魂魔法书-关闭']

function mt:onCastShot()
    local hero = self:getOwner()
    closebox(hero)
end

for i = 1,sg.max_player do
    local player = ac.player(i)
    player:event('玩家-取消选中', function (_, _, hero)
        if hero == player:getHero() then
            closebox(hero)
        end
    end)
end