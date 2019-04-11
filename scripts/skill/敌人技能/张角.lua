local mt = ac.skill['张角-雷鸣电闪']

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'spell channel',true)
	local time = self.castStartTime
	local point = hero:getPoint()
	local target = self:getTarget()
	self.load = sg.load_bar({target = point,time = time})
	ac.effect {
	    target = point,
	    model = [[Abilities\Spells\Orc\LightningShield\LightningShieldTarget.mdl]],
	    size = 2,
	    time = 0.6,
	}
end

function mt:onCastChannel()
	local hero = self:getOwner()
	local point = hero:getPoint()
	hero:speed(0.6/self.castChannelTime)
	sg.animation(hero,'spell slam')
	self.angle = {}
	for i = 1,self.direct do
		local angle = hero:getFacing() + 360/self.direct * i
		local distance = self.area * self.count
		local speed = distance/self.castChannelTime
		local dummy = hero:createUnit('张角-闪电预警',point,angle)
		local lighting = ac.lightning {
		    source = point,
		    target = dummy,
		    model = 'CLSB',
		    sourceHeight = 60,
		}
		local mover = hero:moverLine
		{
			mover = dummy,
			start = point,
			distance = distance,
			angle = angle,
			speed = speed,
		}
		function mover:onRemove()
			lighting:remove()
			dummy:remove()
		end
		self.angle[i] = angle
	end
end

function mt:onCastShot()
	local hero = self:getOwner()
	local point = hero:getPoint()
	local area = self.area
	hero:speed(1)
	sg.animation(hero,'attack spell')
	for i = 1,self.direct do
		local angle = self.angle[i]
		local distance = area * self.count + area
		for i = 1,self.count do
			ac.effect {
			    target = point - {angle,area * i},
			    model = [[effect\Purple Lightning.mdx]],
			    size = area/100,
			    speed = 0.4,
			    time = 3,
			}
		end
		ac.wait(self.wait,function()
			for _, u in ac.selector()
			    : inLine(point,distance,angle,area)
			    : isEnemy(hero)
			    : ofNot '建筑'
			    : ipairs()
			do
				local damage = self.damage/100 * u:get '生命上限'
				hero:damage
				{
				    target = u,
				    damage = damage,
				    damage_type = self.damage_type,
				    skill = self,
				}
				u:addBuff '麻痹'
				{
					time = self.stun,
				}
			end
		end)
	end
end

function mt:onCastStop()
	local hero = self:getOwner()
	hero:speed(1)
	if self.load then
		self.load:remove()
	end
end

function mt:onCastBreak()
    self:onCastStop()
end

local mt = ac.skill['张角-咆哮之火']

function mt:onCastStart()
	local hero = self:getOwner()
	sg.animation(hero,'spell channel',true)
	local time = self.castStartTime
	local point = hero:getPoint()
	local target = self:getTarget()
	local angle = point/target
	self.eff = {}
	self.eff[#self.eff + 1] = sg.load_bar({target = point,time = time})
	self.eff = {}
	self.eff[#self.eff + 1] = ac.effect {
	    target = point,
	    model = [[UI\Feedback\SelectionCircleEnemy\SelectionCircleEnemy.mdl]],
	    size = 5,
	    skipDeath = true,
	    time = time,
	}
	self.eff[#self.eff + 1] = ac.effect {
	    target = point,
	    model = [[effect\RaiseOfFire.mdx]],
	    size = 5,
	    time = 3,
	}
	local lnt = #self.eff
	for i = 1,4 do
		self.eff[#self.eff + 1] = ac.lightning {
		    source = point,
		    target = point - {angle + 90 * i,self.distance},
		    model = 'SPLK',
		    sourceHeight = 100,
		}
	end
	ac.wait(time + self.pulse,function()
		for i = 1,4 do
			self.eff[lnt + i]:remove()
		end
	end)
end

function mt:onCastChannel()
	local hero = self:getOwner()
	sg.animation(hero,'spell')
	local point = hero:getPoint()
	local target = self:getTarget()
	local angle = point/target
	local turn = self.turn
	local area = self.area
	local distance = self.distance
	local pulse = self.pulse
	ac.timer(pulse,180/turn,function()
		for i = 1,4 do
			ac.effect {
			    target = point,
			    model = [[effect\solarblast2.mdx]],
			    yScale = area/200,
			    xScale = distance/4000,
			    angle = angle + 90 * i,
			    speed = 1.5,
			    height = 60,
			    time = 0.4,
			}
		end
		local do_damage = {}
		for i = 1,2 do
			for _, u in ac.selector()
			    : inLine(point - {angle + 90 * i,-distance},distance * 2,angle + 90 * i,area)
			    : isEnemy(hero)
			    : ofNot '建筑'
			    : ipairs()
			do
				table.insert(do_damage,u)
			end
		end
		for _,u in ipairs(do_damage) do
			local damage = self.damage/100 * u:get '生命上限'
			hero:damage
			{
			    target = u,
			    damage = damage,
			    damage_type = self.damage_type,
			    skill = self,
			}
			local p = u:getPoint()
			local target = sg.on_block(p,p - {point/p,self.knock})
			u:addRestriction '硬直'
			local mover = hero:moverLine
			{
				mover = u,
				start = p,
				target = target,
				speed = self.knock/self.stun,
			}
			function mover:onRemove()
				u:removeRestriction '硬直'
			end
		end
		angle = angle - turn
	end)
	local dummy = hero:createUnit('张角-幻象',point,angle)
	sg.animation(dummy,'spell channel',true)
	sg.set_color(dummy,{a = 0.5})
	ac.wait(pulse * 180/turn + 1,function()
		dummy:remove()
	end)
end

function mt:onCastStop()
	for _,eff in ipairs(self.eff) do
		if eff then
			eff:remove()
		end
	end
end

function mt:onCastBreak()
    self:onCastStop()
end

local mt = ac.skill['张角-行尸走肉']

function mt:death()
	if self.load then
		self.load:remove()
	end
	if self.timer then
		self.timer:remove()
	end
	for i = 1,3 do
		if self.dummy[i] then
			self.dummy[i]:remove()
		end
	end
	if self.illusion then
		self.illusion:remove()
	end
end

function mt:start()
	local hero = self:getOwner()
	local point = ac.point(-3000,9300)
	local time = self.time
	hero:addRestriction '硬直'
	hero:stop()
	sg.message('|cffffff00张角：苍天已死...黄天当立！|r',5)
	hero:event('单位-死亡', function()
		self.is_finish = true
		self:death()
	end)
	self.is_start = true
	ac.wait(2,function()
		hero:addRestriction '隐藏'
		ac.effect {
		    target = hero:getPoint(),
		    model = [[Abilities\Spells\Human\MassTeleport\MassTeleportCaster.mdl]],
		    time = 2,
		}
		hero:blink(point)
		ac.effect {
		    target = point,
		    model = [[Abilities\Spells\Human\MassTeleport\MassTeleportTarget.mdl]],
		    time = 2,
		}
		self.illusion = hero:createUnit('张角-幻象',point,270)
		sg.animation(self.illusion,'spell channel',true)
		sg.set_color(self.illusion,{a = 0.75})
		hero:setFacing(270)
		sg.message('张角使用妖术成为不死之身！',5)
		ac.wait(2,function()
			sg.message('张角在地图中心开始咏唱湮灭！',5)
			self.load = sg.load_bar({target = point,time = time})
			sg.message('依照顺序击破张角的幻象，破除咒术！',5)
			local name = {'始动','起义','终焉'}
			local dummy = {}
			self.dummy = dummy
			self.illusion:particle([[Abilities\Spells\Other\Drain\DrainCaster.mdl]],'chest')
			for i = 1,3 do
				local p = point - {120 * i,600}
				local u = hero:createUnit('张角-' .. name[i],p,120 * i + 180)
				sg.animation(u,'spell channel',true)
				ac.effect {
				    target = p,
				    model = [[effect\BlackBlink.mdx]],
				    size = 3,
				    time = 1,
				}
				u:addBuff(name[i])
				{
					time = 0,
					skill = self,
				}
				u:particle([[Abilities\Spells\Other\Drain\DrainTarget.mdl]],'chest')
				local lnt = ac.lightning {
				    source = point,
				    target = p,
				    model = 'DRAL',
				    sourceHeight = 150,
				    targetHeight = 150,
				}
				dummy[i] = u
				u:event('单位-受到伤害', function(_,_,damage)
					for i = 1,3 do
						if u ~= dummy[i] then
							dummy[i]:add('生命',damage:get_currentdamage())
						end
					end
				end)			
				u:event('单位-死亡', function(_, _, killer)
					local finish = true
					lnt:remove()
					for i = 1,3 do
						if dummy[i]:isAlive() then
							finish = false
							break
						end
					end
					ac.effect
					{
						model = [[effect\BloodSlam.mdx]],
						target = u:getPoint(),
						size = 2,
						time = 1,
					}
					if finish == true and not self.is_finish then
						sg.message('|cffffff00张角：黄天...抛弃我了吗...|r',5)
						killer:kill(hero)
					end
				end)
			end
			self.timer = ac.wait(time,function()
				sg.message('|cffffff00张角：岁在甲子...天下大吉！|r',5)
				sg.animation(self.illusion,'spell attack')
				ac.effect
				{
					model = [[effect\BloodSlam.mdx]],
					target = point,
					size = 3,
					time = 1,
				}
				for _,u in ac.selector()
				    : inRange(point,3000)
				    : isEnemy(hero)
				    : ofNot '建筑'
				    : ipairs()
				do	
					hero:kill(u)
					ac.effect
					{
						model = [[effect\Blood Explosion.mdx]],
						target = u:getPoint(),
						size = 3,
						time = 1,
					}
				end
			end)
		end)
	end)
end

function mt:onAdd()
	local hero = self:getOwner()
	self.trg = hero:event('单位-即将死亡', function()
		if not self.is_start then
			self:start()
		end
		--self.trg:remove()
		return false
	end)
end

local mt = ac.buff['始动']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNRegenerationAura.blp]]
mt.title = '始动'
mt.description = '受到伤害时，恢复其余幻象的生命值。死亡时，对周围敌人造成当前生命60%的纯粹伤害'

function mt:onRemove()
	local hero = self:getOwner()
	for _,u in ac.selector()
	    : inRange(hero:getPoint(),3000)
	    : isEnemy(hero)
	    : ofNot '建筑'
	    : ipairs()
	do	
		hero:damage
		{
		    target = u,
		    damage = u:get('生命') * 0.6,
		    damage_type = '纯粹',
		    skill = self.skill,
		}
		u:particle([[effect\Blood Explosion.mdx]],'origin',1)
	end
	hero:remove()
end

local mt = ac.buff['起义']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNRegenerationAura.blp]]
mt.title = '起义'
mt.description = '受到伤害时，恢复其余幻象的生命值。死亡时，使周围敌人在15秒内受到的伤害增加100%'

function mt:onRemove()
	local hero = self:getOwner()
	for _,u in ac.selector()
	    : inRange(hero:getPoint(),3000)
	    : isEnemy(hero)
	    : ofNot '建筑'
	    : ipairs()
	do	
		u:addBuff '伤害加深'
		{
			time = 15,
			add = 100,
		}
	end
	hero:remove()
end

local mt = ac.buff['终焉']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNRegenerationAura.blp]]
mt.title = '始动'
mt.description = '受到伤害时，恢复其余幻象的生命值。死亡时，使周围友军增加99%减伤'

function mt:onRemove()
	local hero = self:getOwner()
	for _,u in ac.selector()
	    : inRange(hero:getPoint(),3000)
	    : isAlly(hero)
	    : ofNot '建筑'
	    : ipairs()
	do	
		u:add('减伤',99)
		u:particle([[effect\Cure.mdx]],'origin')
	end
	hero:remove()
end