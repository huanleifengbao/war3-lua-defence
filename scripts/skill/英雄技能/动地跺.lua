local mt = ac.skill['动地跺']

function mt:onCastShot()
	local skill = self
    local hero = skill:getOwner()
    local point = hero:getPoint()
    local area = skill.area
    ac.effect {
	    target = point,
	    model = [[Abilities\Spells\Orc\WarStomp\WarStompCaster.mdl]],
	    size = area/300,
	    time = 1,
	}
	ac.effect {
	    target = point,
	    model = [[effect\Firaga.mdx]],
	    size = area/250,
	    time = 1,
	}
	for _, u in ac.selector()
	    : inRange(point,area)
	    : isEnemy(hero)
	    : ipairs()
	do
		local p = u:getPoint()
		local mover = hero:moverLine
	    {
			mover = u,
			distance = 1,
			angle = point/p,
			speed = 1/skill.time,
			parameter = true,
			middleHeight = 500,
		}
		u:addRestriction '硬直'
		function mover:onRemove()
			u:removeRestriction '硬直'
		end
		local damage = skill.damage * sg.get_allatr(hero)
		hero:damage
		{
		    target = u,
		    damage = damage,
		    damage_type = skill.damage_type,
		    skill = skill,
		}
	end
end