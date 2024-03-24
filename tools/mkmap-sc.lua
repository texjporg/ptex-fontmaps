#! /usr/bin/env texlua

-- '?' は 'Pro' 等に置換される（今のところ sc では不使用）
local foundry = {
   ['noEmbed']   = {
      ml='!STSong-Light',
      mr='!STSong-Light',
      mb='!STSong-Regular',
      gr='!STHeiti-Light',
      gru='!STHeiti-Regular',
      gb='!STHeiti-Regular',
      ge='!STHeiti-Regular',
      mgr='!STKaiti-Regular',
      {'n'},
   },
   ['adobe']   = {
      noncid = false,
      ml='AdobeSongStd-Light.otf',
      mr='AdobeSongStd-Light.otf',
      mb='AdobeSongStd-Light.otf',
      gr='AdobeHeitiStd-Regular.otf',
      gru='AdobeHeitiStd-Regular.otf',
      gb='AdobeHeitiStd-Regular.otf',
      ge='AdobeHeitiStd-Regular.otf',
      mgr='AdobeKaitiStd-Regular.otf',
      {''},
   },
   ['arphic']   = {  -- gr がサンセリフになっていない
      noncid = true,
      ml='gbsn00lp.ttf %!PS BousungEG-Light-GB',
      mr='gbsn00lp.ttf %!PS BousungEG-Light-GB',
      mb='gbsn00lp.ttf %!PS BousungEG-Light-GB',
      gr='gkai00mp.ttf %!PS GBZenKai-Medium',
      gru='gkai00mp.ttf %!PS GBZenKai-Medium',
      gb='gkai00mp.ttf %!PS GBZenKai-Medium',
      ge='gkai00mp.ttf %!PS GBZenKai-Medium',
      mgr='gkai00mp.ttf %!PS GBZenKai-Medium',
      {''},
   },
   ['cjkunifonts']   = {  -- gr がサンセリフになっていない
      noncid = true,
      ml=':0:uming.ttc %!PS UMingCN',
      mr=':0:uming.ttc %!PS UMingCN',
      mb=':0:uming.ttc %!PS UMingCN',
      gr=':0:ukai.ttc %!PS UKaiCN',
      gru=':0:ukai.ttc %!PS UKaiCN',
      gb=':0:ukai.ttc %!PS UKaiCN',
      ge=':0:ukai.ttc %!PS UKaiCN',
      mgr=':0:ukai.ttc %!PS UKaiCN',
      {''},
   },
   ['cjkunifonts-ttf']   = {  -- gr がサンセリフになっていない
      noncid = true,
      ml='uming.ttf %!PS ShanHeiSun-Uni',  -- (-Adobe-GB1)
      mr='uming.ttf %!PS ShanHeiSun-Uni',  -- (-Adobe-GB1)
      mb='uming.ttf %!PS ShanHeiSun-Uni',  -- (-Adobe-GB1)
      gr='ukai.ttf %!PS ZenKai-Uni',       -- (-Adobe-GB1)
      gru='ukai.ttf %!PS ZenKai-Uni',      -- (-Adobe-GB1)
      gb='ukai.ttf %!PS ZenKai-Uni',       -- (-Adobe-GB1)
      ge='ukai.ttf %!PS ZenKai-Uni',       -- (-Adobe-GB1)
      mgr='ukai.ttf %!PS ZenKai-Uni',      -- (-Adobe-GB1)
      {''},
   },
   ['fandol']   = {
      noncid = false,
      ml='FandolSong-Regular.otf',
      mr='FandolSong-Regular.otf',
      mb='FandolSong-Bold.otf',
      gr='FandolHei-Regular.otf',
      gru='FandolHei-Regular.otf',
      gb='FandolHei-Bold.otf',
      ge='FandolHei-Bold.otf',
      mgr='FandolKai-Regular.otf',
      {''},
   },
   ['founder']   = {
      noncid = true,
      ml='FZSSK.TTF %!PS FZSSK--GBK1-0',
      mr='FZSSK.TTF %!PS FZSSK--GBK1-0',
      mb='FZXBSK.TTF %!PS FZXBSK--GBK1-0',
      gr='FZXH1K.TTF %!PS FZXH1K--GBK1-0',
      gru='FZHTK.TTF %!PS FZHTK--GBK1-0',
      gb='FZHTK.TTF %!PS FZHTK--GBK1-0',
      ge='FZHTK.TTF %!PS FZHTK--GBK1-0',
      mgr='FZKTK.TTF %!PS FZKTK--GBK1-0',
      {''},
   },
   ['ms']   = {
      noncid = true,
      ml=':0:simsun.ttc %!PS SimSun',
      mr=':0:simsun.ttc %!PS SimSun',
      mb=':0:simsun.ttc %!PS SimSun',
      gr='simhei.ttf %!PS SimHei',
      gru='simhei.ttf %!PS SimHei',
      gb='simhei.ttf %!PS SimHei',
      ge='simhei.ttf %!PS SimHei',
      mgr='simkai.ttf %!PS KaiTi',
      {''},
   },
   ['ms-osx']   = {
      noncid = true,
      ml='simsun.ttf %!PS SimSun',
      mr='simsun.ttf %!PS SimSun',
      mb='simsun.ttf %!PS SimSun',
      gr='simhei.ttf %!PS SimHei',
      gru='simhei.ttf %!PS SimHei',
      gb='simhei.ttf %!PS SimHei',
      ge='simhei.ttf %!PS SimHei',
      mgr='simkai.ttf %!PS KaiTi',
      {''},
   },
--   ['sinotype']   = { -- Adobe-GB1 cmap unavailable
--      noncid = true,
--      ml='STSong.ttf',
--      mr='STSong.ttf',
--      mb='STSong.ttf',
--      gr='STHeiti.ttf',
--      gru='STHeiti.ttf',
--      gb='STHeiti.ttf',
--      ge='STHeiti.ttf',
--      mgr='STHeiti.ttf',
--      {''},
--   },
   ['haranoaji']   = {
      ml='HaranoAjiMinchoCN-Light.otf',
      mr='HaranoAjiMinchoCN-Regular.otf',
      mb='HaranoAjiMinchoCN-Bold.otf',
      gr='HaranoAjiGothicCN-Regular.otf',
      gru='HaranoAjiGothicCN-Medium.otf',
      gb='HaranoAjiGothicCN-Bold.otf',
      ge='HaranoAjiGothicCN-Heavy.otf',
      mgr='HaranoAjiGothicCN-Medium.otf',
      {''},
   },
}

local suffix = {
   -- { '?' 置換, scEmbed 接尾辞, (ttc index mov)}
   ['']   = {'', ''},          -- 非 CID フォント用ダミー
   ['n']  = {'!', ''},         -- 非埋め込みに使用
   ['4']  = {'Pro', ''},
   ['6']  = {'Pr6', '-pr6'},
}

-- '#' は 'h', 'v' に置換される
-- '@' は scEmbed の値に置換される
local maps = {
   ['uptex-sc-@'] = {
      {'upstsl-#', 'UniGB-UTF16-#', 'mr'},
      {'upstht-#', 'UniGB-UTF16-#', 'gru'},
   },
   ['otf-sc-@'] = {
      '% CID',
      {'otf-ccml-#',  'Identity-#',    'ml'},
      {'otf-ccmr-#',  'Identity-#',    'mr'},
      {'otf-ccmb-#',  'Identity-#',    'mb'},
      {'otf-ccgr-#',  'Identity-#',    'gr'},
      {'otf-ccgb-#',  'Identity-#',    'gb'},
      {'otf-ccge-#',  'Identity-#',    'ge'},
      {'otf-ccmgr-#', 'Identity-#',    'mgr'},
      '% Unicode',
      {'otf-ucml-#',  'UniGB-UCS2-#', 'ml'},
      {'otf-ucmr-#',  'UniGB-UCS2-#', 'mr'},
      {'otf-ucmb-#',  'UniGB-UCS2-#', 'mb'},
      {'otf-ucgr-#',  'UniGB-UCS2-#', 'gr'},
      {'otf-ucgb-#',  'UniGB-UCS2-#', 'gb'},
      {'otf-ucge-#',  'UniGB-UCS2-#', 'ge'},
      {'otf-ucmgr-#', 'UniGB-UCS2-#', 'mgr'},
   },
}

local jis2004_flag = 'n'
local gsub = string.gsub

function string.explode(s, sep)
   local t = {}
   sep = sep or '\n'
   string.gsub(s, "([^"..sep.."]*)"..sep, function(c) t[#t+1]=c end)
   return t
end

local function ret_suffix(fd, s, fa)
      return suffix[s][1]
end

local function replace_index(line, s)
   local ttc_mov = suffix[s][3]
   if ttc_mov then
      local ttc_index, ttc_dir = line:match('#(%d)(.)')
      if tonumber(ttc_index) then
         return line:gsub('#..', ':' .. tostring(tonumber(ttc_index)+tonumber(ttc_dir .. ttc_mov)) .. ':')
      end
   end
   return line
end

local function make_one_line(o, fd, s)
   if type(o) == 'string' then
      return '\n' .. o .. '\n'
   else
      local fx = foundry[fd]
      local fn = replace_index(gsub(fx[o[3]], '?', ret_suffix(fd,s,o[3])), s)
      if fx.noncid and string.match(o[2],'Identity') then
         if string.match(fn, '%!PS') then
            fn = gsub(fn, ' %%!PS', '/AG14 %%!PS')
         else
            fn = fn .. '/AG14'
         end
      end
      if string.match(o[1], '#') then -- 'H', 'V' 一括出力
         return gsub(o[1], '#', 'h') .. '\t' .. gsub(o[2], '#', 'H') .. '\t' .. fn .. '\n'
          .. gsub(o[1], '#', 'v') .. '\t' .. gsub(o[2], '#', 'V') .. '\t' .. fn .. '\n'
      else
         return o[1] .. '\t' .. o[2] .. '\t' .. fn .. '\n'
      end
   end
end

local function mkdir(dirname)
  if os.type == "windows" then
    dirname = string.gsub(dirname, '/', '\\')
    return os.execute('IF NOT EXIST ' .. dirname .. ' MKDIR ' .. dirname)
  else
    return os.execute('mkdir -p ' .. dirname)
  end
end

for fd, v1 in pairs(foundry) do
   for _,s in pairs(v1[1]) do
      local dirname = fd .. suffix[s][2]
      print('scEmbed: ' .. dirname)
      mkdir(dirname)
      for mnx, mcont in pairs(maps) do
         --if not string.match(mnx, '-04') or string.match(s, jis2004_flag) then
         if not string.match(mnx, '-04') or not foundry[fd].noncid then
            local mapbase = gsub(mnx, '@', dirname)
            local f = io.open(dirname .. '/' .. mapbase .. '.map', 'w+')
            for _,x in ipairs(mcont) do
               f:write(make_one_line(x, fd, s))
            end
            f:close()
         end
      end
   end
end
