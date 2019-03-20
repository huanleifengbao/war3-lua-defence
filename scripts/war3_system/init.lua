require 'war3_system.选择难度'
require 'war3_system.双击选择英雄'
require 'war3_system.英雄复活'
require 'war3_system.击杀敌人'
require 'war3_system.计分板'
require 'war3_system.基地'
require 'war3_system.可刷新野外boss'
require 'war3_system.掉落道具'
require 'war3_system.快捷按钮'
require 'war3_system.信使'
require 'war3_system.技能共享冷却'

sg.max_player = 6
for i = 1, sg.max_player do
    ac.player(10):alliance(ac.player(i), '结盟', true)
    ac.player(i):alliance(ac.player(10), '结盟', true)
end
sg.enemy_player:alliance(sg.creeps_player, '结盟', true)
sg.creeps_player:alliance(sg.enemy_player, '结盟', true)