
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
                u:addBuff '眩晕'
                {
                    time = skill.stun,
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
	local target = self:getTarget()
	self.load = sg.load_bar({target = point,time = time})
	ac.effect {
	    target = point,
	    size = 4,
	    model = [[Abilities\Spells\Orc\Purge\PurgeBuffTarget.mdl]],
	    time = 2,
	}
    ac.effect {
	    target = target,
        model = [[Abilities\Spells\Human\CloudOfFog\CloudOfFog.mdl]],
        height = 700,
        time = 0.5,
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

    local angle = math.random(360)
    local speed = 60
    local mover = hero:moverLine
    {
        start = target,
        model = [[Abilities\Spells\Other\Drain\ManaDrainTarget.mdl]],
        angle = angle,
        distance = 10000,
        speed = 80,
        startHeight = 500,
        finishHeight = 500,
    }
    local int = 10
    local timer1
    local timer2 = ac.loop(0.1, function()
        speed = math.min(math.max(speed + math.random(-10, 10), 20), 100)
        angle = angle + math.random(-10, 10)
        mover:setOption('angle', angle)
    end)
    timer1 = ac.loop(2.5, function()
        int = int - 1
        local p = mover.mover:getPoint()
        ac.effect {
            target = p,
            model = [[Abilities\Spells\Human\CloudOfFog\CloudOfFog.mdl]],
            height = 700,
            time = 0.5,
        }
        ac.effect {
            target = p,
            model = [[Abilities\Weapons\FarseerMissile\FarseerMissile.mdl]],
            size = 5,
            height = 50,
            time = 0,
        }
        ac.effect {
            target = p,
            model = [[Abilities\Spells\Other\Monsoon\MonsoonBoltTarget.mdl]],
            size = 1.8,
            time = 0,
        }
        local lnt = ac.lightning {
            source = p,
            target = p,
            model = 'CHIM',
            sourceHeight = 2000,
            targetHeight = 0,
        }
        ac.wait(1, function()
            lnt:remove()
        end)
		for _, u in ac.selector()
		    : inRange(p,area)
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
            u:addBuff '眩晕'
            {
                time = skill.stun,
            }
		end
        if int == 0 then
            mover:remove()
            timer1:remove()
            timer2:remove()
        end
    end)
end

local mt = ac.skill['孟坦-雷神之怒']

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
	    time = 5,
    }
    self.timer = ac.loop(0.2, function()
        local p1 = hero:getPoint()
        local p2 = p1 - {math.random(360), math.random(1500)}
        local lnt = ac.lightning {
            source = hero,
            target = p2,
            model = 'CHIM',
            targetHeight = 2000,
        }
        ac.wait(1, function()
            lnt:remove()
        end)
        ac.effect {
            target = p1,
            size = 4,
            model = [[Abilities\Spells\Orc\Purge\PurgeBuffTarget.mdl]],
            time = 0.5,
        }
    end)
	hero:setFacing(point/self:getTarget(),0.1)
end

function mt:onCastChannel()
	local hero = self:getOwner()
	--sg.animationI(hero,7)
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
    local area = self.area
    local skill = self
    local damage = skill.damage * hero:get('攻击')

    --放烟花
    local size = 4
    ac.timer(0.15, 6, function()
        ac.effect {
            target = point,
            model = [[Abilities\Spells\Human\Thunderclap\ThunderClapCaster.mdl]],
            size = size,
            speed = 2,
            height = 50,
            time = 0,
        }
        ac.effect {
            target = point,
            model = [[Abilities\Weapons\FarseerMissile\FarseerMissile.mdl]],
            size = size,
            speed = 2,
            height = 50,
            time = 0,
        }
        size = size * 1.2 + 1
    end)
    for i = 1, 12 do
        local p2 = point - {360 / 12 * i, 500}
        ac.effect {
            target = p2,
            model = [[Abilities\Spells\Other\Monsoon\MonsoonBoltTarget.mdl]],
            size = 2.5,
            time = 0,
        }
    end
    for i = 1, 18 do
        local p2 = point - {360 / 18 * i, 800}
        ac.effect {
            target = p2,
            model = [[Abilities\Spells\Other\Monsoon\MonsoonBoltTarget.mdl]],
            size = 2.5,
            time = 0,
        }
    end

    --伤害判定
    ac.wait(0.3, function()
        for _, u in ac.selector()
            : inRange(point, area)
            : isEnemy(hero)
            : ofNot '建筑'
            : ipairs()
        do
            local p = u:getPoint()
            local lnt = ac.lightning {
                source = p,
                target = p,
                model = 'CHIM',
                sourceHeight = 2000,
                targetHeight = 0,
            }
            ac.wait(1, function()
                lnt:remove()
            end)
            ac.effect {
                target = p,
                model = [[Abilities\Weapons\ChimaeraLightningMissile\ChimaeraLightningMissile.mdl]],
                size = 3,
                height = 50,
                time = 0,
            }
            hero:damage
            {
                target = u,
                damage = damage,
                damage_type = skill.damage_type,
                skill = skill,
            }
            u:addBuff '眩晕'
            {
                time = skill.stun,
            }
        end
    end)
end

function mt:onCastStop()
	if self.load then
		self.load:remove()
    end
    if self.timer then
        self.timer:remove()
    end
end