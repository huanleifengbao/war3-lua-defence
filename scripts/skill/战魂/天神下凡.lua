local mt = ac.skill['天神下凡']

function mt:onAdd()
    local hero = self:getOwner()
    hero:add('抗性',self.mdf)
    hero:add('闪避',self.avo)
    hero:add('战力',self.dam)
    self.trg = hero:event('单位-攻击出手', function (_, _, target, damage, mover)
    	if sg.get_random(self.odds) then
    		sg.add_allatr(hero,self.atr)
		end
    	sg.recovery(hero,self.rec)
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
				    skill = self,
				}
			end
		end
	end)
	self.trg2 = ac.game:event('单位-死亡', function (_, dead, killer)
		if killer == hero then
			sg.add_allatr(hero,self.atr2)
		end
	end)
	self.trg3 = hero:event('单位-造成伤害', function (_, _, damage)
		local target = damage.target
		if sg.get_random(self.kill) then
			hero:kill(target)
		end
	end)
end

function mt:onRemove()
	hero:add('抗性',-self.mdf)
    hero:add('闪避',-self.avo)
	hero:add('战力',-self.dam)
    self.trg:remove()
    self.trg2:remove()
    self.trg3:remove()
end