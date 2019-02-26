local mt = ac.skill['五月雨斩']

function mt:jump(hero)
	sg.animationSpeed(hero,0.7)
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
    local target = sg.leap_block(point,skill:getTarget())
    local time = skill.time
    local area = skill.area
    hero:addRestriction '硬直'
    sg.effectU(hero,'weapon',[[Abilities\Weapons\PhoenixMissile\Phoenix_Missile.mdl]],time)
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
			}
		end
	end
	function mover:onRemove()
		hero:removeRestriction '硬直'
		sg.animationSpeed(hero,1)
	end
	--特效
	ac.timer(0.1,(time/0.1)/2,function()
		local dummy = hero:createUnit('关羽-分身',point,point/target)
		sg.set_color(dummy,{a = 125})
		local mover = self:jump(dummy)
		function mover:onRemove()
			dummy:remove()
		end
	end)
end