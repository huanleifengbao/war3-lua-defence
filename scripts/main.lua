sg = {}
--预设的最大玩家数量
sg.max_player = 6
--正在游戏的玩家数量,选英雄会加,退游戏会扣
sg.player_count = 0
--玩家颜色
sg.player_colour = {
    [1] = '|cFFF00000',
    [2] = '|c000000FF',
    [3] = '|c000EEEEE',
    [4] = '|c77700077',
    [5] = '|cFFFFFF00',
    [6] = '|cFFF77700',
    [7] = '|c000EEE00',
    [8] = '|cFFF222FF',
    [9] = '|c88888888',
    [10] = '|c777DDDFF',
    [11] = '|c00077766',
    [12] = '|c44400000',
}
jass = require 'jass.common'
require 'game'
require 'war3_system'
require 'skill'
require 'item'
require 'buff'
require 'shop'