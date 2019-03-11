local mt = ac.skill['决意奋起之盾']

function mt:onCastShot()
    local hero = self:getOwner()
    local point = hero:getPoint()
    local angle = point/self:getTarget()
    local distance = self.distance
    local speed = self.speed
	local target = sg.on_block(point,point - {angle,distance})
	local time = distance/speed
	hero:addRestriction '硬直'
	sg.animationI(hero,5,true)
	hero:speed(speed/500)
	hero:particle([[Abilities\Spells\NightElf\BattleRoar\RoarCaster.mdl]],'origin')()
	local eff = hero:particle([[effect\zhendangbo.mdx]],'origin')
	local mover = hero:moverLine
    {
		mover = hero,
		target = target,
		speed = self.speed,
	}
	local mark = {}
	ac.timer(0.05,time/0.05,function()
		local p = hero:getPoint()
		ac.effect {
		    target = p,
		    model = [[Abilities\Weapons\AncientProtectorMissile\AncientProtectorMissile.mdl]],
		    time = 0,
		}
		for _, u in ac.selector()
		    : inRange(p,self.area)
		    : isEnemy(hero)
		    : filter(function(u)
			    return not mark[u]
			end)
		    : ipairs()
		do
			local damage = self.damage * sg.get_allatr(hero)
			hero:damage
			{
			    target = u,
			    damage = damage,
			    damage_type = self.damage_type,
			    skill = self,
			}
			local mover = hero:moverLine
		    {
				mover = u,
				distance = self.disp,
				angle = p/u:getPoint(),
				speed = self.disp/self.air,
				parameter = true,
				middleHeight = self.disp,
			}
			--sg.stun(u,self.stun)
			u:addBuff '眩晕'
			{
				time = self.stun,
			}
			mark[u] = true
		end
	end)
	ac.wait(time,function()
		hero:removeRestriction '硬直'
		eff()
		hero:speed(1)
		sg.animation(hero,'stand')
	end)
end