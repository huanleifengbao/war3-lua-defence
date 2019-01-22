
require 'war3_system.选择难度'
require 'war3_system.双击选择英雄'
require 'war3_system.英雄复活'
require 'war3_system.英雄统计'
require 'war3_system.计分板'
require 'war3_system.基地死亡'

for i = 1, 6 do
    ac.player(10):alliance(ac.player(i), '结盟', true)
    ac.player(i):alliance(ac.player(10), '结盟', true)
end