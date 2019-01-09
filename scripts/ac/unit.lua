local jass = require 'jass.common'
local japi = require 'jass.japi'
local slk = require 'jass.slk'
local dbg = require 'jass.debug'
local attribute = require 'ac.attribute'
local attack = require 'ac.attack'
local mover = require 'ac.mover'

local All = {}
local IdMap

local function getIdMap()
    if IdMap then
        return IdMap
    end
    IdMap = {}
    for name, data in pairs(ac.table.unit) do
        local id = ('>I4'):unpack(data.id)
        local obj = slk.unit[id]
        if not obj then
            log.error(('单位[%s]的id[%s]无效'):format(name, id))
            goto CONTINUE
        end
        IdMap[id] = name
        ::CONTINUE::
    end
    return IdMap
end

local function update(delta)
    for _, u in pairs(All) do
        if u.class == '生物' then
            local life = delta / 1000 * u:get '生命恢复'
            if life > 0 then
                u:add('生命', life)
            end
            local mana = delta / 1000 * u:get '魔法恢复'
            if mana > 0 then
                u:add('魔法', mana)
            end
        end
    end
end

local function createDestructor(unit, callback)
    if not unit._destructor then
        unit._destructor = { sort = 0 }
    end
    local function destructor()
        unit._destructor[destructor] = nil
        callback()
    end
    local sort = unit._destructor.sort + 1
    unit._destructor[destructor] = sort
    unit._destructor.sort = sort
    return destructor
end

local function onRemove(unit)
    local destructors = unit._destructor
    if destructors then
        -- 保证所有人都按固定的顺序执行
        local list = {}
        for f in pairs(destructors) do
            list[#list+1] = f
        end
        table.sort(list, function (a, b)
            return destructors[a] < destructors[b]
        end)
        for _, f in ipairs(list) do
            f()
        end
    end
end

local function create(player, name, point, face)
    local data = ac.table.unit[name]
    if not data then
        log.error(('单位[%s]不存在'):format(name))
        return nil
    end
    local x, y = point:getXY()
    local handle = jass.CreateUnit(player._handle, data.id, x, y, face)
    local unit = ac.unit(handle)
    return unit
end

local mt = {}
function ac.unit(handle)
    if handle == 0 then
        return nil
    end
    if All[handle] then
        return All[handle]
    end

    local idMap = getIdMap()

    local id = jass.GetUnitTypeId(handle)
    local name = idMap[id]
    if not name then
        log.error(('ID[%s]对应的单位不存在'):format(id))
        return nil
    end
    local data = ac.table.unit[name]
    if not data then
        log.error(('名字[%s]对应的单位不存在'):format(name))
        return nil
    end
    local class = data.class
    if class ~= '弹道' and class ~= '生物' then
        log.error(('[%s]的class无效'):format(name))
        return nil
    end

    local u = setmetatable({
        class = class,
        _gchash = handle,
        _handle = handle,
        _id = id,
        _data = data,
        _slk = slk.unit[id],
        _owner = ac.player(1+jass.GetPlayerId(jass.GetOwningPlayer(handle))),
    }, mt)
    dbg.gchash(u, handle)
    u._gchash = handle

    All[handle] = u

    if class == '生物' then
        -- 初始化单位属性
        u.attribute = attribute(u, u._data.attribute)

        ac.game:eventNotify('单位-初始化', u)

        -- 初始化攻击
        u.attack = attack(u, u._data.attack)

        ac.game:eventNotify('单位-创建', u)
    elseif class == '弹道' then
        jass.UnitAddAbility(handle, ac.id.Aloc)
    end

    return u
end

mt.__index = mt

mt.type = 'unit'

function mt:getName()
    return self._slk.Propernames or self._slk.Name
end

function mt:set(k, v)
    self.attribute:set(k, v)
end

function mt:get(k)
    return self.attribute:get(k)
end

function mt:add(k, v)
    self.attribute:add(k, v)
end

function mt:kill(target)
    if target == nil then
        target = self
    end
    if not ac.isUnit(target) then
        return
    end
    jass.KillUnit(target._handle)
    target:eventNotify('单位-死亡', self)
end

function mt:getPoint()
    return ac.point(jass.GetUnitX(self._handle), jass.GetUnitY(self._handle))
end

function mt:setPoint(point)
    local x, y = point:getXY()
    jass.SetUnitX(self._handle, x)
    jass.SetUnitY(self._handle, y)
end

function mt:getOwner()
    return self._owner
end

function mt:particle(model, socket)
    local handle = jass.AddSpecialEffectTarget(model, self._handle, socket)
    if handle == 0 then
        return nil
    else
        return createDestructor(self, function ()
            jass.DestroyEffect(handle)
            -- 这里不做引用计数保护，因此删除一次后将局部变量释放掉，保证不会再次访问
            handle = nil
        end)
    end
end

--注册单位事件
function mt:event(name)
    return ac.event_register(self, name)
end

--发起事件
function mt:eventDispatch(name, ...)
    local res = ac.eventDispatch(self, name, ...)
    if res ~= nil then
        return res
    end
    local player = self:getOwner()
    if player then
        local res = ac.eventDispatch(player, name, ...)
        if res ~= nil then
            return res
        end
    end
    local res = ac.eventDispatch(ac.game, name, ...)
    if res ~= nil then
        return res
    end
    return nil
end

function mt:eventNotify(name, ...)
    ac.eventNotify(self, name, ...)
    local player = self:getOwner()
    if player then
        ac.eventNotify(player, name, ...)
    end
    ac.eventNotify(ac.game, name, ...)
end

function mt:moverTarget(data)
    data.source = self
    data.moverType = 'target'
    return mover.create(data)
end

function mt:moverLine(data)
    data.source = self
    data.moverType = 'line'
    return mover.create(data)
end

return {
    all = All,
    update = update,
    create = create,
}
