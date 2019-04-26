--[[
影响伤害的英雄属性：
	战力 --> 百分比增伤
	减伤 --> 百分比减伤
	闪避 --> 闪避率
	命中 --> 抵消目标的闪避
	魔抗 --> 百分比魔法减伤
	物理穿透 --> 计算防御时减去一部分防御
	魔法穿透 --> 计算魔抗时减去一部分魔抗
	暴击 --> 一定概率使伤害根据'暴击伤害'翻倍
	暴击伤害 --> 触发暴击时额外造成的伤害百分比
	吸血 --> 造成伤害后恢复最终伤害数量的生命值
	
伤害类型：
	物理 --> 计算护甲、增伤、减伤
	魔法 --> 计算魔抗、增伤、减伤
	纯粹 --> 计算增伤、减伤
	真实 --> 不计算任何属性，但是依然可以通过damage:div_damage修改伤害
		
※普通攻击默认为物理伤害，需额外计算闪避、暴击、吸血

damage表内可定义的属性：
	attack = true --> 本次伤害判定为普攻
	crit = true --> 本次伤害计算暴击，默认为false，普攻则为true
	leech = true --> 本次伤害可吸血，默认为false，普攻则为true
	truestrike = true --> 本次伤害不计算闪避，默认为true，普攻则为false

'单位-即将造成/受到伤害'事件中damage可调用的api：
	damage:get_damage() --> 返回原始伤害(number)
	damage:get_currentdamage() --> 返回当前伤害(number)
	damage:set_type([string]) --> 设置damage_type为[string]，只能在'即将造成伤害'事件里使用
	damage:div_damage([number]) --> 设置当前伤害为[number]，只能在'即将造成伤害'事件里使用
]]--

local function avoid(damage)
	local target = damage.target
	local avo = target:get '闪避' - damage.source:get '命中'
	if damage.truestrike == false and sg.get_random(avo) then
		sg.text_tag({
			text = '|cffff0000miss|r',
			size = 30,
			point = target:getPoint(),
			height = 100,
		})
		return false
	else
		return true
	end
end

local function onDefence(damage)
	local source = damage.source
	local target = damage.target
	local now_damage = damage:get_currentdamage()
	if damage.damage_type == '物理' then			
		local penetrate = damage['物理穿透']
		if not penetrate then
			penetrate = source:get '物理穿透'
		end
		local def = target:get '护甲' - penetrate
		if def < 0 then
	        --每点负护甲相当于受到的伤害加深1%
	        damage:div_damage(now_damage * (1 - 0.01 * def))
	    elseif def > 0 then
	        --每点护甲相当于生命值增加1%，上限减免90%
	        local rate = math.min(10,1 + 0.01 * def)
	        damage:div_damage(now_damage / rate)
	    end
	elseif damage.damage_type == '魔法' then
	    local penetrate = damage['魔法穿透']
	    if not penetrate then
		   penetrate = source:get '魔法穿透'
	    end
	    local rate = (100 - target:get '魔抗' + penetrate)/100
	    if rate <= 0 then
		    damage:div_damage(0)
	    elseif rate < 100 then
		    damage:div_damage(now_damage * rate)
	    end
	end
end

local function onCrit(damage)
	if damage.crit == true then
		local source = damage.source
		local target = damage.target
		local cri = damage['暴击']
		if not cri then
			cri = source:get '暴击'
		end
		local cridamage = damage['暴击伤害']
		if not cridamage then
			cridamage = source:get '暴击伤害'
		end
		cri = cri - target:get '抗暴'
		if sg.get_random(cri) then
			local now_damage = damage:get_currentdamage() * (cridamage + 100)/100
			sg.text_tag({
				text = '|cffff0000' .. math.floor(now_damage) .. '!|r',
				size = 25,
				point = target:getPoint(),
				height = 100,
			})
			damage:div_damage(now_damage)
		end
	end
end

local function exDamage(damage)
	--真实伤害不计算增伤
	if damage.damage_type ~= '真实' then
		local rate = 100 + damage.source:get '战力' - damage.target:get '减伤'
		if rate < 0 then
			rate = 0
		else
			rate = rate/100
		end
		damage:div_damage(damage:get_currentdamage() * rate)
	end
end

local function costLife(damage)
	local target = damage.target
	target:add('生命', - damage:get_currentdamage())
	if target:get('生命') <= 0 then
		local result = target:eventDispatch('单位-即将死亡', target,damage)
		if result ~= false then		
			damage.source:kill(target)
		end
	end
end

local function notifyEvent(damage)
    damage.source:eventNotify('单位-造成伤害', damage.source, damage)
    damage.target:eventNotify('单位-受到伤害', damage.target, damage)
end

local function leech(damage)
	if	damage.leech == true then
		local source = damage.source
		local rate = damage['吸血']
		if not rate then
			rate = source:get '吸血'
		end
		if rate > 0 then
			source:particle([[Abilities\Spells\Undead\VampiricAura\VampiricAuraTarget.mdl]],'origin')()
			source:add('生命',damage:get_currentdamage() * rate/100)
		end
	end
end

local function createDamage(damage)
	damage.div_on = true
	damage.get_damage = function(self)
		return damage.damage
	end
	damage.get_currentdamage = function(self)
		return damage.currentDamage
	end
	damage.set_type = function(self,new)
		if self.div_on == true then
			self.damage_type = new
		end
	end
	damage.div_damage = function(self,new)
		if type(new) == 'number' then
			if self.div_on == true then
				self.currentDamage = new
			end
		else
			error('哎鸭给我填数字鸭')
		end
	end
	--若是非普攻伤害被定义为普攻，则触发一次'攻击出手'
	if damage.attack == true then
		if damage:isCommonAttack() ~= true then
			damage.source:eventNotify('单位-攻击出手', damage.source, damage.target, damage)
		end
		damage._commonAttack = true
	end
	--若伤害是普攻，则为物理伤害，需计算暴击，吸血，并移除克敌机先属性
	if damage:isCommonAttack() == true then
		damage.damage_type = '物理'
		--未定义是否可暴击则默认可暴击
		if not damage.crit then
			damage.crit = true
		end
		--未定义是否吸血则默认吸血
		if not damage.leech then
			damage.leech = true
		end
		--未定义是否无视闪避则移除克敌机先
		if not damage.truestrike then
			damage.truestrike = false
		end
	else
		damage.truestrike = true
	end
end

ac.game:event('游戏-造成伤害', function(_,damage)
	createDamage(damage)
	local result = damage.source:eventDispatch('单位-即将造成伤害', damage.source, damage)
    local result2 = damage.target:eventDispatch('单位-即将受到伤害', damage.target, damage)
    if result == false or result2 == false then
	    return false
    end
    --计算闪避，若闪避成功则直接跳过后续逻辑
    if avoid(damage) == false then
	    return false
    end
    --计算暴击
	onCrit(damage)
    --物理或魔法伤害需计算护甲
    onDefence(damage)	
	--计算增伤
	exDamage(damage)
	if damage:get_currentdamage() < 0 then
		damage:div_damage(0)
	end
	--错过即将造成伤害事件后，不可再修改伤害
    damage.div_on = false
	--实际伤害计算完毕，可返回return false阻止这次伤害
    local result = damage.target:eventDispatch('单位-即将扣除生命', damage.target, damage)
    if result == false then
	    return false
    end
	--计算吸血
    leech(damage)
    --扣除生命
    costLife(damage)
    notifyEvent(damage)
    return true
end)