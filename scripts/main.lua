sg = {}
sg.max_player = 6
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
require 'skill'
require 'war3_system'
require 'item'
require 'buff'
jass.FogEnable(false)
jass.FogMaskEnable(false)