local mt = ac.buff['致命一击']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNCriticalStrike.blp]]
mt.title = '致命一击'
mt.description = '该单位的普通攻击有一定概率暴击。'

mt.cri = 20

function mt:onAdd()
	local u = self:getOwner()
	u:add('暴击',self.cri)
end

function mt:onRemove()
	local u = self:getOwner()
	u:add('暴击',-self.cri)
end

local mt = ac.buff['重击']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNBash.blp]]
mt.title = '重击'
mt.description = '该单位的普通攻击有一定概率击晕目标。'

mt.cri = 20
mt.stun = 0.3

function mt:onAdd()
	local u = self:getOwner()
	self.trg = u:event('单位-造成伤害', function(_,_,damage)
		if damage:isCommonAttack() == true and sg.get_random(self.cri) then
			damage.target:addBuff '眩晕'
			{
				time = self.stun,
			}
		end
	end)
end

function mt:onRemove()
	self.trg:remove()
end

local mt = ac.buff['闪避']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNEvasion.blp]]
mt.title = '闪避'
mt.description = '该单位有一定概率闪避普通攻击。'

mt.avo = 70

function mt:onAdd()
	local u = self:getOwner()
	u:add('闪避',self.avo)
end

function mt:onRemove()
	local u = self:getOwner()
	u:add('闪避',-self.avo)
end

local mt = ac.buff['精灵之火']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNFaerieFire.blp]]
mt.title = '精灵之火'
mt.description = '该单位的普通攻击附加目标单位降低护甲的效果。'

mt.def = 50
mt.duration = 30

function mt:onAdd()
	local u = self:getOwner()
	self.trg = u:event('单位-造成伤害', function(_,_,damage)
		if damage:isCommonAttack() == true then
			damage.target:addBuff '精灵之火-效果'
			{
				time = self.duration,
				def = self.def,
			}
		end
	end)
end

function mt:onRemove()
	self.trg:remove()
end

local mt = ac.buff['减速']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNSlow.blp]]
mt.title = '减速'
mt.description = '该单位的普通攻击附加目标单位攻击/移动速度降低的效果。'

mt.attack = 50
mt.move = 50
mt.duration = 10

function mt:onAdd()
	local u = self:getOwner()
	self.trg = u:event('单位-造成伤害', function(_,_,damage)
		if damage:isCommonAttack() == true then
			damage.target:addBuff '减速-效果'
			{
				time = self.duration,
				attack = self.attack,
				move = self.move,
			}
		end
	end)
end

function mt:onRemove()
	self.trg:remove()
end

local mt = ac.buff['神圣护甲']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNDivineIntervention.blp]]
mt.title = '神圣护甲'
mt.description = '该单位被攻击时可以发动无敌一次。'

mt.duration = 5

function mt:onAdd()
	local u = self:getOwner()
	self.trg = u:event('单位-即将受到伤害', function(_)
		u:addBuff '无敌'
		{
			time = self.duration,
		}
		self:remove()
		return false		
	end)
end

function mt:onRemove()
	self.trg:remove()
end

local mt = ac.buff['浸毒武器']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNEnvenomedSpear.blp]]
mt.title = '浸毒武器'
mt.description = '该单位的普通攻击附加持续伤害。'

mt.duration = 10
mt.damage = 1
mt.damage_type = '物理'

function mt:onAdd()
	local u = self:getOwner()
	self.trg = u:event('单位-造成伤害', function(_,_,damage)
		if damage:isCommonAttack() == true then
			damage.target:addBuff '浸毒武器-效果'
			{
				time = self.duration,
				source = u,
				damage = u:get('攻击') * self.damage,
				damage_type = self.damage_type,
			}
		end
	end)
end

function mt:onRemove()
	self.trg:remove()
end

local mt = ac.buff['诱捕']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNEnsnare.blp]]
mt.title = '诱捕'
mt.description = '该单位的普通攻击附加一次定身效果。'

mt.duration = 3

function mt:onAdd()
	local u = self:getOwner()
	self.trg = u:event('单位-造成伤害', function(_,_,damage)
		if damage:isCommonAttack() == true then
			damage.target:addBuff '诱捕-效果'
			{
				time = self.duration,
			}
			self:remove()
		end
	end)
end

function mt:onRemove()
	self.trg:remove()
end

local mt = ac.buff['残废']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNCripple.blp]]
mt.title = '残废'
mt.description = '该单位的普通攻击附加目标单位攻击力和移动速度降低的效果。'

mt.attack = 50
mt.move = 20
mt.duration = 15

function mt:onAdd()
	local u = self:getOwner()
	self.trg = u:event('单位-造成伤害', function(_,_,damage)
		if damage:isCommonAttack() == true then
			damage.target:addBuff '残废-效果'
			{
				time = self.duration,
				attack = self.attack,
				move = self.move,
			}
		end
	end)
end

function mt:onRemove()
	self.trg:remove()
end

local mt = ac.buff['重生']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNReincarnation.blp]]
mt.title = '重生'
mt.description = '该单位被击杀时可以重生一次。'

function mt:onAdd()
	local u = self:getOwner()
	self.trg = u:event('单位-即将死亡', function(_)
		self:remove()
		u:animation('death',true)
		u:set('生命',u:get '生命上限')
		u:addRestriction '蝗虫'
		u:addRestriction '硬直'
		u:addRestriction '无敌'
		local eff = u:particle([[Abilities\Spells\Orc\Reincarnation\ReincarnationTarget.mdl]],'origin')
		ac.wait(3,function()
			u:addRestriction '隐藏'
			u:removeRestriction '隐藏'
			u:removeRestriction '蝗虫'
			u:removeRestriction '硬直'
			u:removeRestriction '无敌'
			eff()
			u:animation('stand',true)
		end)
		return false		
	end)
end

function mt:onRemove()
	self.trg:remove()
end

local mt = ac.buff['狂战士']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNBerserkForTrolls.blp]]
mt.title = '狂战士'
mt.description = '该单位造成的伤害和受到的伤害都被增加。'

mt.damage = 100
mt.hurt = 100

function mt:onAdd()
	local u = self:getOwner()
	u:add('战力',self.damage)
	u:add('减伤',-self.hurt)
end

function mt:onRemove()
	local u = self:getOwner()
	u:add('战力',-self.damage)
	u:add('减伤',self.hurt)
end

local mt = ac.buff['狂热']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNBloodLust.blp]]
mt.title = '狂热'
mt.description = '该单位的攻击速度增加了。'

mt.attack = 100

function mt:onAdd()
	local u = self:getOwner()
	u:add('攻击速度%',self.attack)
	self.eff = u:particle([[Abilities\Spells\Orc\Bloodlust\BloodlustTarget.mdl]],'left hand')
	self.eff2 = u:particle([[Abilities\Spells\Orc\Bloodlust\BloodlustSpecial.mdl]],'right hand')
end

function mt:onRemove()
	local u = self:getOwner()
	u:add('攻击速度%',-self.attack)
	self.eff()
	self.eff2()
end

local mt = ac.buff['耐久光环']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNCommand.blp]]
mt.title = '耐久光环'
mt.description = '该单位的攻击/移动速度增加了。'

mt.attack = 15
mt.move = 15

function mt:onAdd()
	local u = self:getOwner()
	u:add('攻击速度%',self.attack)
	u:add('攻击速度%',self.move)
	self.eff = u:particle([[Abilities\Spells\Orc\CommandAura\CommandAura.mdl]],'origin')
end

function mt:onRemove()
	local u = self:getOwner()
	u:add('攻击速度%',-self.attack)
	u:add('攻击速度%',-self.move)
	self.eff()
end

local mt = ac.buff['坚韧光环']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNDevotion.blp]]
mt.title = '坚韧光环'
mt.description = '该单位的减伤增加了。'

mt.def = 15

function mt:onAdd()
	local u = self:getOwner()
	u:add('减伤',self.def)
	self.eff = u:particle([[Abilities\Spells\Human\DevotionAura\DevotionAura.mdl]],'origin')
end

function mt:onRemove()
	local u = self:getOwner()
	u:add('减伤',-self.def)
	self.eff()
end

local mt = ac.buff['心灵之火']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNInnerFire.blp]]
mt.title = '心灵之火'
mt.description = '该单位的攻击力和减伤增加了。'

mt.attack = 50
mt.def = 20

function mt:onAdd()
	local u = self:getOwner()
	u:add('攻击%',self.attack)
	u:add('减伤',self.def)
	self.eff = u:particle([[Abilities\Spells\Human\InnerFire\InnerFireTarget.mdl]],'overhead')
end

function mt:onRemove()
	local u = self:getOwner()
	u:add('攻击%',-self.attack)
	u:add('减伤',-self.def)
	self.eff()
end