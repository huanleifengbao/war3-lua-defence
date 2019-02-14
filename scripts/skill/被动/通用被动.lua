local mt = ac.skill['通用被动']

function mt:onAdd()
    local hero = self:getOwner()
    local count = 0
    self.trg = hero:event('单位-攻击出手', function (_, _, target, damage, mover)
    	if sg.get_random(self.odds) then
    		for _, u in ac.selector()
			    : inRange(hero:getPoint(),self.area)
			    : isEnemy(hero)
			    : isVisible(hero)
			    : ipairs()
			do
				local damage = self.damage1 * sg.get_allatr(hero)
				hero:damage
				{
				    target = u,
				    damage = damage,
				    damage_type = '魔法',
				    skill = self,
				}
			end
		end
		count = count + 1
		if count >= self.count then
			count = 0
			local damage = self.damage2 * sg.get_allatr(hero)
			hero:damage
			{
			    target = target,
			    damage = damage,
			    damage_type = '魔法',
			    skill = self,
			}
		end
	end)
end

function mt:onRemove()
    self.trg:remove()
end