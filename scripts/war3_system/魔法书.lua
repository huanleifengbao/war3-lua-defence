local mt = ac.skill['战魂魔法书']

local box = {
    {name = '横扫千军', icon_int = 9},
    {name = '铜墙铁壁', icon_int = 10},
    {name = '妙手回春', icon_int = 11},
    {name = '势如破竹', icon_int = 12},
    {name = '拨云见日', icon_int = 5},
    {name = '森罗万象', icon_int = 6},
    {name = '足智多谋', icon_int = 7},
    {name = '不动如山', icon_int = 8},
    {name = '天神下凡', icon_int = 1},
}

function mt:onAdd()
    local hero = self:getOwner()
    for i = 1, #box do
        local name = box[i].name
        local icon_int = box[i].icon_int
		local tbl = hero:userData('战魂技能')
		local skill = hero:addSkill(name,'技能', icon_int)
		skill:hide()
		skill:disable()
		table.insert(tbl, skill)
    end
end

function mt:onCastShot()
    local hero = self:getOwner()
    local box_skill = hero:findSkill('战魂魔法书-关闭')
    if not box_skill then
        box_skill = hero:addSkill('战魂魔法书-关闭', '技能', 4)
        local tbl = hero:userData('战魂技能')
        for _, skill in ipairs(tbl) do
            print(skill,'show')
            skill:show()
        end
        hero:iconLevel('技能', 50)
    end
end

local function closebox(hero)
    local box_skill = hero:findSkill('战魂魔法书-关闭')
    if box_skill then
        local tbl = hero:userData('战魂技能')
        for _, skill in ipairs(tbl) do
            print(skill,'hide')
            skill:hide()
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