
local mt = ac.skill['孟坦-折线雷矢']

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'spell throw',true)
	local time = self.castStartTime
	local point = hero:getPoint()
	self.load = sg.load_bar({target = point,time = time})
	ac.effect {
	    target = point,
	    size = 4,
	    model = [[Abilities\Spells\Orc\Purge\PurgeBuffTarget.mdl]],
	    time = 2,
	}
	hero:setFacing(point/self:getTarget(),0.1)
end

function mt:onCastChannel()
	local hero = self:getOwner()
	--sg.animationI(hero,7)
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local target = self:getTarget()
	local angle = point / target
    local area = self.area
    local count = self.count
    local skill = self
    local damage = skill.damage * hero:get('攻击')
    local int = math.random(2)

    for i = - count / 2, count / 2 do
        local angle2 = angle + 30 * i
        local mover = hero:moverLine
        {
            model = [[Abilities\Spells\Orc\LightningShield\LightningShieldTarget.mdl]],
            angle = angle2,
            speed = 2000,
            distance = 4000,
            hitArea = area,
            hitType = '敌方',
        }
        local mover_t1 = ac.loop(0.05, function()
            ac.effect {
                target = mover.mover:getPoint(),
                model = [[Abilities\Weapons\Bolt\BoltImpact.mdl]],
                size = 1,
                time = 0,
            }
        end)
        local int2 = int
        local mover_t2 = ac.loop(0.5, function()
            local angle_ex = 60
            if int2 == 2 then
                int2 = 1
                angle_ex = -60
            else
                int2 = 2
            end
            mover:pause()
            ac.wait(0.3, function()
                mover:resume()
            end)
            mover:setOption('angle', angle2 + angle_ex)
        end)
        mover_t2()
        function mover:onHit(u)
            for _ = 1, 3 do
                ac.effect {
                    target = u:getPoint(),
                    model = [[Abilities\Spells\Orc\LightningBolt\LightningBoltMissile.mdl]],
                    size = 1.3,
                    time = 0,
                }
            end
            if not u:isType '建筑' then
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
            mover_t1:remove()
            mover_t2:remove()
        end
	end
end

function mt:onCastStop()
	if self.load then
		self.load:remove()
	end
end

local mt = ac.skill['孟坦-雷云']

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'spell throw',true)
	local time = self.castStartTime
	local point = hero:getPoint()
	self.load = sg.load_bar({target = point,time = time})
	ac.effect {
	    target = point,
	    size = 4,
	    model = [[Abilities\Spells\Orc\Purge\PurgeBuffTarget.mdl]],
	    time = 2,
	}
	hero:setFacing(point/self:getTarget(),0.1)
end

function mt:onCastChannel()
	local hero = self:getOwner()
	--sg.animationI(hero,7)
end

function mt:onCastShot()
	local hero = self:getOwner()
	local target = self:getTarget()
    local area = self.area
    local skill = self
    local damage = skill.damage * hero:get('攻击')
end