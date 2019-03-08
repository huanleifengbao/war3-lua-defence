local mt = ac.buff['眩晕']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNStun.blp]]
mt.title = '眩晕'
mt.description = '该单位被击晕了，所以不能移动，攻击和施放魔法。'

function mt:onAdd()
	local u = self:getOwner()
	self.eff = u:particle([[Abilities\Spells\Human\Thunderclap\ThunderclapTarget.mdl]],'overhead')
	u:addRestriction '硬直'
end

function mt:onCover(new)
    return new.time > self:remaining()
end

function mt:onRemove()
	local u = self:getOwner()
	self.eff()
	u:removeRestriction '硬直'
end

local mt = ac.buff['无敌']
mt.coverGlobal = 1
mt.show = 1
mt.icon = [[ReplaceableTextures\CommandButtons\BTNInvulnerable.blp]]
mt.title = '无敌'
mt.description = '该单位是无敌的，所以任何的攻击和魔法都对其无效。'

function mt:onAdd()
	local u = self:getOwner()
	jass.SetUnitInvulnerable(u._handle,true)
	self.eff = u:particle([[Abilities\Spells\Human\DivineShield\DivineShieldTarget.mdl]],'overhead')
end

function mt:onCover(new)
    return new.time > self:remaining()
end

function mt:onRemove()
	local u = self:getOwner()
	jass.SetUnitInvulnerable(u._handle,false)
	self.eff()
end