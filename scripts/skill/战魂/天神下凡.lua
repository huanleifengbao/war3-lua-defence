local skill_name = '天神下凡'
local mt = ac.skill[skill_name]

function mt:onEnable()
	self.open = true
	self:setOption('description', ac.table.skill[skill_name].description)
    local hero = self:getOwner()
    hero:add('抗性',self.mdf)
    hero:add('闪避',self.avo)
    hero:add('战力',self.dam)
    self.trg = hero:event('单位-攻击出手', function (_, _, target, damage, mover)
    	if sg.get_random(self.odds) then
    		sg.add_allatr(hero,self.atr)
		end
		if sg.get_random(self.rec_odds) then
    		sg.recovery(hero,self.rec)
		end   	
		if not target:isHero() and sg.get_random(self.kill) then
			local p = target:getPoint()
			ac.effect {
			    target = p,
			    model = [[effect\Blood Explosion.mdx]],
			    size = 1.5,
			    angle = math.random(360),
			    time = 1,
			}
            local msg = '|cffff0000即|cffaa25ff死|r'
            ac.textTag()
                : text(msg, 0.025)
                : at(p, 100)
                : speed(0.02, 90)
                : life(2, 1)
			hero:kill(target)
		end
    	if sg.get_random(self.odds2) then
    		for _, u in ac.selector()
			    : inRange(hero:getPoint(),self.area)
			    : isEnemy(hero)
			    : isVisible(hero)
			    : ipairs()
			do
				local damage = self.damage * sg.get_allatr(hero)
				hero:damage
				{
				    target = u,
				    damage = damage,
				    damage_type = '魔法',
				    skill = self,
				}
				u:particle([[Abilities\Spells\Human\MarkOfChaos\MarkOfChaosDone.mdl]],'origin')				
			end
		end
	end)
	self.trg2 = ac.game:event('单位-死亡', function (_, dead, killer)
		if killer == hero then
			sg.add_allatr(hero,self.atr2)
		end
	end)
	ac.game:eventNotify('地图-获得战魂', hero)
end

function mt:onDisable()
	local msg = '|cffffcc00 未解锁|n|n|r'
	self:setOption('description', msg..ac.table.skill[skill_name].description)
	if self.open then
		self.open = false
	else
		return
	end
	local hero = self:getOwner()
	hero:add('抗性',-self.mdf)
    hero:add('闪避',-self.avo)
	hero:add('战力',-self.dam)
    self.trg:remove()
    self.trg2:remove()
    --self.trg3:remove()
    ac.game:eventNotify('地图-失去战魂', hero)
end