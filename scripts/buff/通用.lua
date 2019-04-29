local mt = ac.buff['眩晕']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNStun.blp]]
mt.title = '眩晕'
mt.description = '该单位被击晕了，所以不能移动，攻击和施放魔法。'

function mt:onAdd()
	local u = self:getOwner()
	self.eff = u:particle([[Abilities\Spells\Human\Thunderclap\ThunderclapTarget.mdl]],'overhead')
	u:addRestriction '晕眩'
	u:stop()
end

function mt:onCover(new)
    return new.time > self:remaining()
end

function mt:onRemove()
	local u = self:getOwner()
	self.eff()
	u:removeRestriction '晕眩'
end

local mt = ac.buff['冰冻']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNFreezingBreath.blp]]
mt.title = '冰冻'
mt.description = '该单位被冰冻了，所以不能移动，攻击和施放魔法。'

function mt:onAdd()
	local u = self:getOwner()
	self.eff = u:particle([[Abilities\Spells\Undead\FreezingBreath\FreezingBreathTargetArt.mdl]],'origin')
	u:addRestriction '晕眩'
	u:stop()
end

function mt:onCover(new)
    return new.time > self:remaining()
end

function mt:onRemove()
	local u = self:getOwner()
	self.eff()
	u:removeRestriction '晕眩'
end

local mt = ac.buff['无敌']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNInvulnerable.blp]]
mt.title = '无敌'
mt.description = '该单位是无敌的，所以任何的攻击和魔法都对其无效。'

function mt:onAdd()
	local u = self:getOwner()
	u:addRestriction '无敌'
	self.eff = u:particle([[Abilities\Spells\Human\DivineShield\DivineShieldTarget.mdl]],'origin')
end

function mt:onCover(new)
    return new.time > self:remaining()
end

function mt:onRemove()
	local u = self:getOwner()
	u:removeRestriction '无敌'
	self.eff()
end

local mt = ac.buff['即将石化']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNResistantSkin.blp]]
mt.title = '即将石化'
mt.description = '该单位直视了魔眼，即将被石化。'

function mt:onAdd()
	local u = self:getOwner()
	local hero = self.source
	local p = u:getPoint()
	local dummy = hero:createUnit('远吕智-石化预警',p,p/hero:getPoint())
	ac.wait(1,function()
		dummy:remove()
	end)
end

function mt:onCover(new)
    return true
end

local mt = ac.buff['石化']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNHardenedSkin.blp]]
mt.title = '石化'
mt.description = '该被石化了，无法行动，生命恢复速度降低，但是获得少许减伤。'

function mt:onAdd()
	local u = self:getOwner()
	u:addRestriction '晕眩'
	u:speed(0)
	u:add('减伤',25)
	self.rec = u:get('生命恢复')
	u:add('生命恢复',-self.rec)
	sg.set_color(u,{r = 0.2,g = 0.2,b = 0.2})
end

function mt:onCover(new)
    return new.time > self:remaining()
end

function mt:onRemove()
	local u = self:getOwner()
	u:removeRestriction '晕眩'
	u:speed(1)
	u:add('减伤',-25)
	u:add('生命恢复',self.rec)
	sg.set_color(u)
end

local mt = ac.buff['冻结']
mt.coverGlobal = 1
mt.show = 0

function mt:onAdd()
	local u = self:getOwner()
	u:addRestriction '晕眩'
	u:addRestriction '无敌'
	u:addRestriction '幽灵'
    u:speed(0)
    u:color(1, 1, 1, 0.5)
end

function mt:onCover()
    return false
end

function mt:onRemove()
	local u = self:getOwner()
	u:removeRestriction '晕眩'
    u:removeRestriction '无敌'
	u:removeRestriction '幽灵'
    u:speed(1)
    u:color(1, 1, 1, 1)
end

local mt = ac.buff['假死']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNAnkh.blp]]
mt.title = '死亡'
mt.description = '你死了,祈祷队友获胜吧...'

function mt:onAdd()
	local u = self:getOwner()
	u:addRestriction '晕眩'
	u:addRestriction '无敌'
	u:addRestriction '幽灵'
	u:animation('death')
	self.hps = u:get('生命恢复')
	u:add('生命恢复', - self.hps)
end

function mt:onCover()
    return false
end

function mt:onRemove()
	local u = self:getOwner()
	u:removeRestriction '晕眩'
	u:removeRestriction '无敌'
	u:removeRestriction '幽灵'
	if u:isAlive() then
		u:animation('stand')
	else
		u:speed(0)
		--[=[ac.effect {
			target = u:getPoint(),
			model = [[Objects\Spawnmodels\Undead\UndeadDissipate\UndeadDissipate.mdl]],
			speed = 1,
			time = 0,
		}]=]--
		ac.wait(2.5, function()
			u:speed(1)
		end)
	end
	u:add('生命恢复', self.hps)
end

local mt = ac.buff['纯化']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNOrbOfDeath.blp]]
mt.title = '纯化'
mt.description = '该单位的普通攻击造成无视护甲的纯粹伤害。'

function mt:onAdd()
	local u = self:getOwner()
	self.trg = u:event('单位-即将造成伤害', function(_,_,damage)
		if damage:isCommonAttack() == true then
			damage:set_type '纯粹'
		end
	end)
end

function mt:onRemove()
	self.trg:remove()
end

local mt = ac.buff['魔化']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNFeedBack.blp]]
mt.title = '魔化'
mt.description = '该单位的普通攻击造成魔法伤害。'

function mt:onAdd()
	local u = self:getOwner()
	self.trg = u:event('单位-即将造成伤害', function(_,_,damage)
		if damage:isCommonAttack() == true then
			damage:set_type '魔法'
		end
	end)
end

function mt:onRemove()
	self.trg:remove()
end

local mt = ac.buff['麻痹']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNPurge.blp]]
mt.title = '麻痹'
mt.description = '该单位被麻痹了，每2秒都有概率陷入无法行动的状态。'
mt.pulse = 2
mt.odds = 50
mt.stun = 1

function mt:torpor()
	local u = self:getOwner()
	u:particle([[Abilities\Spells\Orc\Purge\PurgeBuffTarget.mdl]],'origin',1.2)
	u:addRestriction '晕眩'
	u:stop()
	ac.wait(self.stun,function()
		u:removeRestriction '晕眩'
	end)
end

function mt:onAdd()
	local u = self:getOwner()
	self:torpor()
end

function mt:onCover(new)
    return new.time > self:remaining()
end

function mt:onPulse()
	if sg.get_random(self.odds) then
		self:torpor()
	end
end

local mt = ac.buff['伤害加深']
mt.coverGlobal = 1
mt.coverType = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNIncinerate.blp]]
mt.title = '伤害加深'
mt.description = '该单位受到攻击时会产生额外伤害。'

function mt:onAdd()
	local u = self:getOwner()
	u:add('减伤',-self.add)
end

function mt:onRemove()
	local u = self:getOwner()
	u:add('减伤',self.add)
end

local mt = ac.buff['击飞']
mt.coverGlobal = 1
mt.coverType = 1

function mt:onAdd()
	local u = self:getOwner()
	u:addRestriction '晕眩'
	u:moverLine
	{
		mover = u,
		distance = 1,
		angle = 0,
		speed = 1/self.time,
		middleHeight = self.height,
	}
end

function mt:onRemove()
	local u = self:getOwner()
	u:removeRestriction '晕眩'
end