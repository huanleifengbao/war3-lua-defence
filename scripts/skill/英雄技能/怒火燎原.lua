local mt = ac.skill['怒火燎原']

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local area = self.area
	ac.effect {
	    target = point,
	    model = [[Abilities\Spells\Other\Doom\DoomDeath.mdl]],
		size = area/250,
	    time = 1,
	}	
	for _, u in ac.selector()
		    : inRange(point,area)
		    : isEnemy(hero)
		    : ipairs()
	do
		hero:damage
		{
		    target = u,
		    damage = self.damage * sg.get_allatr(hero),
		    damage_type = self.damage_type,
		    attack = true,
		    skill = self,
		}
	end
	local angle = math.random(360)
	local distance = area * 0.6
	local pulse = self.pulse
	local j = 5
	local function do_effect()
		ac.effect {
		    target = point,
		    model = [[Abilities\Spells\Other\Incinerate\FireLordDeathExplode.mdl]],
		    time = 1,
		}
		angle = angle + 30
		for i = 1,j do
			local a = 360/j * i + angle
			local target = point - {a,distance}
			local mover = hero:moverLine
		    {
				model = [[Abilities\Weapons\PhoenixMissile\Phoenix_Missile.mdl]],
				start = point,
				target = target,
				finishHeight = 50,
				speed = distance/pulse,
		    }
		    function mover:onRemove()
			    ac.effect {
				    target = target,
				    model = [[Abilities\Spells\Other\Volcano\VolcanoDeath.mdl]],
				    time = 1,
				}
			  --  hero:moverLine
			  --  {					
					--model = [[Abilities\Weapons\PhoenixMissile\Phoenix_Missile_mini.mdl]],
					--start = target,
					--distance = distance,
					--finishHeight = 400,
					--angle = a + 180,
					--speed = distance * 2,
			  --  }
		    end
		end
	end
	do_effect()
	local count = 0
	local max_count = self.time/pulse
	local timer = ac.timer(pulse,max_count,function()
		count = count + 1
		if count < max_count then
			do_effect()
		end
		local damage = self.damage2 * sg.get_allatr(hero) * pulse
		for _, u in ac.selector()
		    : inRange(point,area)
		    : isEnemy(hero)
		    : ipairs()
		do
			hero:damage
			{
			    target = u,
			    damage = damage,
			    damage_type = self.damage_type,
			    skill = self,
			}
		end
	end)
end