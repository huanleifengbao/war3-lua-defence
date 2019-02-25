local mt = ac.skill['五月雨斩']

function mt:onCastShot()
    local skill = self
    local hero = skill:getOwner()
    local point = hero:getPoint()
    local target = skill:getTarget()
    local time = skill.time
    hero:addRestriction '硬直'
    sg.animationSpeed(hero,0.7)
    sg.animation(hero,'attack slam')
    sg.effectU(hero,'weapon',[[Abilities\Weapons\PhoenixMissile\Phoenix_Missile.mdl]],time)
    local mover = hero:moverLine
    {
		mover = hero,
		target = target,
		speed = (point * target)/ time,
		parameter = true,
		middleHeight = 100,
	}
	function mover:onFinish()
		sg.effect(target,[[Abilities\Spells\Human\Thunderclap\ThunderClapCaster.mdl]],0)
		for _, u in ac.selector()
		    : inRange(hero:getPoint(),skill.area)
		    : isEnemy(hero)
		    : ipairs()
		do
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
	function mover:onRemove()
		hero:removeRestriction '硬直'
		sg.animationSpeed(hero,1)
	end
end