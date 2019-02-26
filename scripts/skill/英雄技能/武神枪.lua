local mt = ac.skill['武神枪']

function mt:onCastShot()
    local skill = self
    local hero = skill:getOwner()
    local point = hero:getPoint()
	local target = skill:getTarget()
	local distance = skill.distance
	local area = skill.area
	local speed = skill.speed
	local angle = point/target
	local mover = hero:moverLine
	{
		model = [[effect\BladeShockwave.mdx]],
		angle = angle,
		speed = speed,
		distance = distance,
		hitArea = area,
		hitType = '敌方',
	}
	function mover:onHit(u)
	    local damage = skill.damage * sg.get_allatr(hero)
		hero:damage
		{
		    target = u,
		    damage = damage,
		    damage_type = skill.damage_type,
		    skill = skill,
		}
	end
	if distance > area*2 then
		local dis = area/2
		local pulse = dis/speed
		local count = 0
		ac.timer(pulse,distance/dis,function()
			local p = point - {angle,speed * count * pulse}
			count = count + 1
			ac.effect {
			    target = p,
			    model = [[Abilities\Spells\Human\Thunderclap\ThunderClapCaster.mdl]],
			    size = area/300,
			    time = 1,
			}
		end)
	end
end