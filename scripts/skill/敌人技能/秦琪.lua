local mt = ac.skill['秦琪-死亡脉冲']

function mt:onCastStart()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local time = self.castStartTime + self.castChannelTime
	sg.animation(hero,'stand channel',true)
	self.load = sg.load_bar({target = point,time = time})
	ac.effect {
	    target = point,
	    size = 2,
	    model = [[Abilities\Spells\Other\HowlOfTerror\HowlCaster.mdl]],
	    time = 1,
	}
end

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animation(hero,'attack spell')
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local target = self:getTarget()
	local count = self.count
	local skill = self

	--天黑
	--for a = -8, 8 do
	--	local p2 = point - {point / target + 15 * a + math.random(36), math.random(300, 1000)}
	--	local h = 1
	--	ac.timer(0.06, 1, function()
	--		ac.effect {
	--			target = p2,
	--			model = [[Doodads\LordaeronSummer\Props\SmokeSmudge\SmokeSmudge2.mdl]],
	--			size = 30,
	--			speed = 0.5,
	--			height = 15 * h,
	--			time = math.random(25, 45) / 10,
	--		}
	--		h = h + 1
	--	end)
	--end

	for i = 1,count do
		local a = 360/count * i
		local mover = hero:moverLine
		{
			model = [[effect\Shade Missile.mdx]],
			start = point,
			angle = a,
			speed = self.speed,
			distance = self.distance,
			hitType = '敌方',
			hitArea = self.area,
			startHeight = 80,
			finishHeight = 80,
		}
		function mover:onHit(u)
			if not u:isType '建筑' then
				local damage = skill.damage/100 * u:get '生命上限'
				hero:damage
				{
				    target = u,
				    damage = damage,
				    damage_type = skill.damage_type,
				    skill = skill,
				}
				self:remove()
				u:addBuff '死神镰刀'
				{
					source = hero,
					damage = skill.damage2,
					time = skill.stun,
					skill = skill,
				}
			end
		end
		local pulse = 0.15
		local index = 1
		local add = 0

		--local sx_mark = false
		--if i % 2 == 0 then
		--	ac.wait(1.2, function()
		--		a = point / target + math.random(-30, 30)
		--		sx_mark = true
		--		mover:setOption('distance',mover.distance + mover.mover:getPoint() * target)
		--	end)
		--end
		local timer = ac.loop(0.04,function()
			add = add + index * self.angle/(pulse/0.04)
			if math.abs(add) >= self.angle then
				index = -index
			end
			mover:setOption('angle',a + add)
			mover:setAngle(a + add)
			--if sx_mark == true then
			--	a = a + math.random(-5, 5)
			--end
		end)
		function mover:onRemove()
			timer:remove()
		end
	end
end

local mt = ac.buff['死神镰刀']

function mt:onAdd()
	local u = self:getOwner()
	u:addRestriction '硬直'
	ac.effect {
	    target = u:getPoint(),
	    size = 1.5,
	    model = [[effect\Death Spell.mdx]],
	    angle = u:getFacing(),
	    time = 0.8,
	}
	self.eff = u:particle([[effect\Hell Roots Buff.mdx]],'origin')
end

function mt:onCover()
	return false
end

function mt:onRemove()
	local u = self:getOwner()
	u:removeRestriction '硬直'
	local skill = self.skill
	local damage = (u:get('生命上限') - u:get('生命')) * self.damage
	self.source:damage
	{
	    target = u,
	    damage = damage,
	    damage_type = skill.damage_type,
	    skill = skill,
	}
	self.eff()
end

local mt = ac.skill['秦琪-影压']

function mt:onCastStart()
	local hero = self:getOwner()
	local point = hero:getPoint()
	hero:setFacing(point/self:getTarget(),0.1)
end

function mt:onCastChannel()
	local hero = self:getOwner()
	local time = self.castChannelTime
	local point = hero:getPoint()
	sg.animation(hero,'stand victory',true)
	self.load = sg.load_bar({target = point,time = time})
	local target = self:getTarget()
	local point = target:getPoint()
	self.rd_target = point - {target:getFacing() + math.random(-30, 30), math.random(150, 300)}
	ac.effect {
	    target = self.rd_target,
	    model = [[Abilities\Spells\Undead\DarkRitual\DarkRitualTarget.mdl]],
		size = 2.2,
		zScale = 0.3,
		speed = 2,
	    time = 0,
    }
end

function mt:onCastShot()
	local hero = self:getOwner()
    local area = self.area
    local skill = self
    local damage = self.damage/100 * u:get '生命上限'
    sg.animation(hero,'spell attack')
	local function cast(point)
		--放烟花
		--local size = 4
		--ac.timer(0.05, 5, function()
		--	ac.effect {
		--		target = point,
		--		model = [[Abilities\Spells\Undead\OrbOfDeath\OrbOfDeathMissile.mdl]],
		--		size = size,
		--		time = 0,
		--	}
		--end)
		--for i = 1, 20 do
		--	local p2 = point - {360 / 20 * i, area - 25}
		--	ac.effect {
		--		target = p2,
		--		model = [[Abilities\Spells\Undead\OrbOfDeath\AnnihilationMissile.mdl]],
		--		size = 0.6,
		--		time = 0,
		--	}
		--end
		ac.effect{
			target = point,
			model = [[Abilities\Spells\Undead\DeathCoil\DeathCoilSpecialArt.mdl]],
			size = 2,
			time = 0,
		}
		ac.effect{
			target = point,
			model = [[Abilities\Spells\Other\HowlOfTerror\HowlCaster.mdl]],
			size = 1,
			time = 0,
		}
		ac.effect{
			target = point,
			model = [[Objects\Spawnmodels\Undead\UndeadDissipate\UndeadDissipate.mdl]],
			size = 1,
			time = 0,
		}
		for _, u in ac.selector()
			: inRange(point, area)
			: isEnemy(hero)
			: ofNot '建筑'
			: ipairs()
		do
			hero:damage
			{
				target = u,
				damage = damage,
				damage_type = skill.damage_type,
				skill = skill,
			}
		end
	end

	cast(self.rd_target)
	local rd_angle = math.random(360)
	ac.wait(0.5, function()
		for i = 1, 3 do
			local p2 = self.rd_target - {rd_angle + 360 / 3 * i, 450}
			ac.effect {
				target = p2,
				model = [[Abilities\Spells\Undead\DarkRitual\DarkRitualTarget.mdl]],
				size = 2.2,
				zScale = 0.3,
				speed = 2,
				time = 0,
			}
			ac.wait(1.5, function()
				cast(p2)
			end)
		end
	end)
end

function mt:onCastStop()
	local hero = self:getOwner()
	hero:speed(1)
	if self.load then
		self.load:remove()
    end
    if self.timer then
        self.timer:remove()
    end
end

function mt:onCastBreak()
    self:onCastStop()
end