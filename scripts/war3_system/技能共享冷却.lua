
ac.game:event('技能-施法引导', function (_, skill)
    if not skill.cool_type then
        return
    end
    local unit = skill:getOwner()
    for skill2 in unit:eachSkill() do
        if skill2.cool_type and skill.cool_type == skill2.cool_type then
            skill2:activeCd()
        end
    end
end)

ac.game:event('技能-获得', function (_, skill)
    if not skill.cool_type then
        return
    end
    local unit = skill:getOwner()
    for skill2 in unit:eachSkill() do
        if skill2.cool_type and skill.cool_type == skill2.cool_type then
            local cd = skill2:getCd()
            if cd > 0 then
                skill:activeCd()
                skill:setCd(cd)
            end
            break
        end
    end
end)