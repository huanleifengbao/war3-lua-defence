local tbl = {'通用被动','常胜将军','合众统合','旷世奇才','乱世佳人','三国无双'}

for _,skill_name in ipairs(tbl) do
	local mt = ac.skill[skill_name]

	function mt:onAdd()
	    local hero = self:getOwner()
	    self.attr = {
			['减伤'] = self.div,
			['战力'] = self.dam,
			['抗性'] = self.mdf,
			['闪避'] = self.avo,
	    }
		for name,count in pairs(self.attr) do
			hero:add(name,count)
		end
	    local count = 0
	    self.trg = hero:event('单位-攻击出手', function (_, _, target, damage, mover)
	    	if sg.get_random(self.odds) then
		    	local p = target:getPoint()
		    	local area = self.area
		    	ac.effect {
				    target = p,
				    model = [[effect\DevilSlam.mdx]],
				    size = area/250,
				    time = 1,
				}
				ac.effect {
				    target = p,
				    model = [[effect\OrbitalRay.mdx]],
				    time = 1,
				}
	    		for _, u in ac.selector()
				    : inRange(p,area)
				    : isEnemy(hero)
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
				end
				local atr = self.atr
				if atr then
					sg.add_allatr(hero,atr)
				end
			end
			if self.odds3 and sg.get_random(self.odds) then
				sg.add_allatr(hero,self.atr3 * hero:get('威望'))
			end
			count = count + 1
			if count >= self.count then
				count = 0
				local damage = self.damage2 * sg.get_allatr(hero)
				hero:damage
				{
				    target = target,
				    damage = damage,
				    damage_type = self.damage_type,
				    skill = self,
				}
				ac.effect {
				    target = target:getPoint(),
				    model = [[effect\lightningwrath.mdx]],
				    time = 1,
				}
				local atr = self.atr2
				if atr then
					sg.add_allatr(hero,atr)
				end
			end
		end)
		if self.wod then
			hero:add('击杀木材', self.wod)
		end
	end

	function mt:onRemove()
		local hero = self:getOwner()
		for name,count in ipairs(self.attr) do
			hero:add(name,-count)
		end
	    self.trg:remove()
		if self.wod then
			hero:add('击杀木材', - self.wod)
		end
	end
end