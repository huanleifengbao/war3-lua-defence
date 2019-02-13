local mt = ac.skill['横扫千军']

function mt:onAdd()
    print('获得：', self)
    local hero = self:getOwner()
end

function mt:onRemove()
    print('失去：', self)
end