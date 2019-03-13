local mt = ac.skill['决意奋起之盾']

function mt:onCastShot()
    local hero = self:getOwner()
    local point = hero:getPoint()
    local angle = point/self:getTarget()
    local distance = self.distance
    local speed = self.speed
	local time = distance/speed
	hero:addRestriction '定身'
	hero:speed(speed/500)
	hero:particle([[Abilities\Spells\NightElf\BattleRoar\RoarCaster.mdl]],'origin')()
	local eff = hero:particle([[effect\zhendangbo.mdx]],'origin')
	local mover = hero:moverLine
    {
		mover = hero,
		angle = angle,
		distance = distance,
		speed = self.speed,
		hitType = '敌方',
		hitArea = self.area,
	}
	local mark = {}
	function mover:onBlock()
		hero:setFacing(hero:getFacing() + 180)
		hero:stop()
	end
	local skill = self
	function mover:onHit(u)
		local damage = skill.damage * sg.get_allatr(hero)
		hero:damage
		{
		    target = u,
		    damage = damage,
		    damage_type = skill.damage_type,
		    skill = skill,
		}
		local p = u:getPoint()
		local a = hero:getPoint()/p
		local target = sg.on_block(p,p - {a,skill.disp})
		hero:moverLine
		{
			mover = u,
			start = p,
			target = target,
			speed = skill.disp/skill.air,
			parameter = true,
			middleHeight = skill.disp,
		}
		u:addBuff '眩晕'
		{
			time = skill.stun,
		}
	end
	local timer = ac.loop(0.05,function()
		mover:setOption('angle',hero:getFacing())
		sg.animationI(hero,5,true)
	end)
	function mover:onRemove()
		timer:remove()
		hero:removeRestriction '定身'
		eff()
		hero:speed(1)
		sg.animation(hero,'stand')
	end
end