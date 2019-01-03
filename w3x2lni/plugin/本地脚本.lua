local mt = {}

mt.info = {
    name = '本地脚本',
    version = 1.0,
    author = '最萌小汐',
    description = '让obj格式的地图使用本地的lua脚本。'
}

local currentpath = [[
package.path = package.path .. ';%s\scripts\?.lua;%s\scripts\?\init.lua'
]]

local function inject_jass(w2l, buf)
    if not buf then
        return nil
    end
    local _, pos = buf:find('function main takes nothing returns nothing', 1, true)
    local bufs = {}
    bufs[1] = buf:sub(1, pos)
    bufs[2] = '\r\n    call Cheat("exec-lua:scripts.currentpath")'
    bufs[3] = buf:sub(pos+1)
    return table.concat(bufs)
end

local function reduce_jass(w2l, name)
    local buf = w2l:file_load('map', name)
    if not buf then
        return
    end
    local a, b = buf:find('function main takes nothing returns nothing\r\n    call Cheat("exec-lua:scripts.currentpath")', 1, true)
    if not a or not b then
        return
    end
    local bufs = {}
    bufs[1] = buf:sub(1, a-1)
    bufs[2] = 'function main takes nothing returns nothing'
    bufs[3] = buf:sub(b+1)
    w2l:file_save('map', name, table.concat(bufs))
end

function mt:on_full(w2l)
    if w2l.setting.mode == 'lni' or w2l.setting.remove_we_only then
        w2l:file_remove('map', 'scripts\\currentpath.lua')
        reduce_jass(w2l, 'war3map.j')
        reduce_jass(w2l, 'scripts\\war3map.j')
    else
        local file_save = w2l.file_save
        function w2l:file_save(type, name, buf)
            if type == 'scripts' and name ~= 'blizzard.j' and name ~= 'common.j' then
                return
            end
            return file_save(self, type, name, buf)
        end

        if not w2l:file_load('map', 'scripts\\currentpath.lua') then
            w2l:file_save('map', 'scripts\\currentpath.lua', currentpath:format(w2l.setting.input:string(), w2l.setting.input:string()):gsub('\\', '\\\\'))
            local buf = inject_jass(w2l, w2l:file_load('map', 'war3map.j'))
            if buf then
                w2l:file_save('map', 'war3map.j', buf)
            end
            local buf = inject_jass(w2l, w2l:file_load('map', 'scripts\\war3map.j'))
            if buf then
                w2l:file_save('map', 'scripts\\war3map.j', buf)
            end
        end
    end
end

function mt:on_pack(w2l, output_ar)
    local buf = inject_jass(w2l, output_ar:get 'war3map.j')
    if buf then
        output_ar:set('war3map.j', buf)
    end
    local buf = inject_jass(w2l, output_ar:get 'scripts\\war3map.j')
    if buf then
        output_ar:set('scripts\\war3map.j', buf)
    end
end

return mt
