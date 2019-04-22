local mt = ac.skill['五月雨斩']

function mt:jump(hero)
	hero:speed(0.7)
    sg.animation(hero,'attack slam')
    local mover = hero:moverLine
    {
		mover = hero,
		target = self.target,
		speed = (self.point * self.target)/self.time,
		parameter = true,
		middleHeight = 100,
	}
	return mover
end

function mt:onCastShot()
    local skill = self
    local hero = skill:getOwner()
    local point = hero:getPoint()
    local target = sg.on_block(point,skill:getTarget())
    if point * target < 1 then
	    target = target - {0,1}
	end
    local time = skill.time
    local area = skill.area
    hero:addRestriction '硬直'
    hero:addRestriction '无敌'
    local eff = hero:particle([[Abilities\Weapons\PhoenixMissile\Phoenix_Missile.mdl]],'weapon')
    self.point = point
    self.target = target
    local mover = self:jump(hero)
	function mover:onFinish()
		ac.effect {
		    target = target,
		    model = [[Abilities\Spells\Human\Thunderclap\ThunderClapCaster.mdl]],
		    size = area/300,
		    time = 1,
		}
		ac.effect {
		    target = target,
		    model = [[effect\lightningwrath.mdx]],
		    size = area/600,
		    time = 1,
		}
		for _, u in ac.selector()
		    : inRange(hero:getPoint(),area)
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
			    attack = true,
			}
		end
	end
	function mover:onRemove()
		eff()
		hero:removeRestriction '硬直'
		hero:removeRestriction '无敌'
		hero:speed(1)
	end
	--特效
	ac.timer(0.1,(time/0.1)/2,function()
		local dummy = hero:createUnit('关羽-分身',point,point/target)
		sg.set_color(dummy,{a = 0.5})
		local mover = self:jump(dummy)
		function mover:onRemove()
			dummy:remove()
		end
	end)
end