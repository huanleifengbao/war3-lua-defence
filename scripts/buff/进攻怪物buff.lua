local mt = ac.buff['精灵之火-效果']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNFaerieFire.blp]]
mt.title = '精灵之火'
mt.description = '该单位的护甲被降低了。'

function mt:onAdd()
	local u = self:getOwner()
	self.eff = u:particle([[Abilities\Spells\NightElf\FaerieFire\FaerieFireTarget.mdl]],'head')
	u:add('护甲%',-self.def)
end

function mt:onRemove()
	local u = self:getOwner()
	self.eff()
	u:add('护甲%',self.def)
end

local mt = ac.buff['减速-效果']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNSlow.blp]]
mt.title = '减速'
mt.description = '该单位的攻击/移动速度被降低了。'

function mt:onAdd()
	local u = self:getOwner()
	self.eff = u:particle([[Abilities\Spells\Human\slow\slowtarget.mdl]],'origin')
	u:add('攻击速度%',-self.attack)
	u:add('移动速度%',-self.move)
end

function mt:onRemove()
	local u = self:getOwner()
	self.eff()
	u:add('攻击速度%',self.attack)
	u:add('移动速度%',self.move)
end

local mt = ac.buff['浸毒武器-效果']
mt.coverType = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNEnvenomedSpear.blp]]
mt.pulse = 1
mt.title = '浸毒武器'
mt.description = '该单位受到持续伤害。'

function mt:onAdd()
	local u = self:getOwner()
	self.eff = u:particle([[Abilities\Weapons\PoisonSting\PoisonStingTarget.mdl]],'origin')
end

function mt:onPulse()
	local u = self:getOwner()
	self.source:damage
	{
	    target = u,
	    damage = self.damage,
	    damage_type = self.damage_type,
	}
end

function mt:onRemove()
	self.eff()
end

local mt = ac.buff['诱捕-效果']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNEnsnare.blp]]
mt.title = '诱捕'
mt.description = '该单位不能移动。'

function mt:onAdd()
	local u = self:getOwner()
	u:addRestriction '定身'
	self.eff = u:particle([[Abilities\Spells\Orc\Ensnare\ensnareTarget.mdl]],'origin')
end

function mt:onCover(new)
    return new.time > self:remaining()
end

function mt:onRemove()
	local u = self:getOwner()
	u:removeRestriction '定身'
	self.eff()
end

local mt = ac.buff['残废-效果']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNCripple.blp]]
mt.title = '残废'
mt.description = '该单位的攻击力和移动速度被降低了。'

function mt:onAdd()
	local u = self:getOwner()
	self.eff = u:particle([[Abilities\Spells\Undead\Cripple\CrippleTarget.mdl]],'origin')
	u:add('攻击%',-self.attack)
	u:add('移动速度%',-self.move)
end

function mt:onRemove()
	local u = self:getOwner()
	self.eff()
	u:add('攻击%',self.attack)
	u:add('移动速度%',self.move)
end