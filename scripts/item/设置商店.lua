
--新手装备
local shop = ac.player(16):createShop('刘备', ac.point(7044, -10529), 270)
shop:setBuyRange(1000000)
shop:setItem('新手武器-1', 9, 'Q')
shop:setItem('新手衣服-1', 10, 'W')
shop:setItem('新手鞋子-1', 11, 'E')
shop:setItem('新手饰品-1', 12, 'R')
shop:setItem('武器升级', 5, 'A')
shop:setItem('衣服升级', 6, 'S')
shop:setItem('鞋子升级', 7, 'D')
shop:setItem('饰品升级', 8, 'F')
shop:setItem('专属升级', 1, 'Z')

--挑战专武boss
local shop = ac.player(16):createShop('刘备', ac.point(7544, -10529), 270)
shop:setBuyRange(1000)
shop:setItem('挑战电', 9, 'Q')
shop:setItem('挑战雷', 10, 'W')
shop:setItem('挑战晓', 11, 'E')
shop:setItem('挑战响', 12, 'R')

local point = {
    {6593, 10301},   {9834, 10301},
    {6593, 7740},    {9834, 7740},
    {6593, 5547},    {9834, 5547},
}
--练功
for i = 1, 6 do
    local shop = ac.player(16):createShop('刘备', ac.point(point[i][1], point[i][2]), 270)
    shop:setBuyRange(1000)
end