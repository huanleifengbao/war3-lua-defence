local mt = ac.skill['含沙射影']

function mt:onCastShot()
    local hero = self:getOwner()
    local point = hero:getPoint()
    local target = self:getTarget():getPoint()
    local skill = self
    for _, u in ac.selector()
	    : inRange(target,self.area)
	    : isEnemy(hero)
	    : ipairs()
	do
		local mover = hero:moverTarget
		{
			model = [[effect\Magic Missile.mdx]],
			start = point,
			target = u,
			speed = 1500,
			startHeight = 60,
			finishHeight = 30,
		}
		function mover:onRemove()
			local damage = skill.damage * sg.get_allatr(hero)
			hero:damage
			{
			    target = u,
			    damage = damage,
			    damage_type = skill.damage_type,
			    skill = skill,
			    attack = true,
			}
			u:addBuff '麻痹'
			{
				time = skill.stun,
			}
		end
	end
end