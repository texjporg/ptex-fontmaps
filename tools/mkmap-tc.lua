#! /usr/bin/env texlua

-- '?' は 'Pro' 等に置換される（今のところ tc では不使用）
local foundry = {
   ['noEmbed']   = {
      ml='!MSung-Light',
      mr='!MSung-Light',
      mb='!MSung-Medium',
      gr='!MHei-Medium',
      gru='!MHei-Medium',
      gb='!MHei-Medium',
      ge='!MHei-Medium',
      mgr='!MKai-Medium',
      {'n'},
   },
   ['adobe']   = {
      noncid = false,
      ml='AdobeMingStd-Light.otf',
      mr='AdobeMingStd-Light.otf',
      mb='AdobeMingStd-Light.otf',
      gr='AdobeFanHeitiStd-Bold.otf',
      gru='AdobeFanHeitiStd-Bold.otf',
      gb='AdobeFanHeitiStd-Bold.otf',
      ge='AdobeFanHeitiStd-Bold.otf',
      mgr='AdobeFanHeitiStd-Bold.otf',
      {''},
   },
   ['arphic']   = {  -- gr がサンセリフになっていない
      noncid = true,
      ml='bsmi00lp.ttf %!PS ShanHeiSun-Light',
      mr='bsmi00lp.ttf %!PS ShanHeiSun-Light',
      mb='bsmi00lp.ttf %!PS ShanHeiSun-Light',
      gr='bkai00mp.ttf %!PS ZenKai-Medium',
      gru='bkai00mp.ttf %!PS ZenKai-Medium',
      gb='bkai00mp.ttf %!PS ZenKai-Medium',
      ge='bkai00mp.ttf %!PS ZenKai-Medium',
      mgr='bkai00mp.ttf %!PS ZenKai-Medium',
      {''},
   },
   ['cjkunifonts']   = {  -- gr がサンセリフになっていない
      noncid = true,
      ml=':2:uming.ttc %!PS UMingTW',
      mr=':2:uming.ttc %!PS UMingTW',
      mb=':2:uming.ttc %!PS UMingTW',
      gr=':2:ukai.ttc %!PS UKaiTW',
      gru=':2:ukai.ttc %!PS UKaiTW',
      gb=':2:ukai.ttc %!PS UKaiTW',
      ge=':2:ukai.ttc %!PS UKaiTW',
      mgr=':2:ukai.ttc %!PS UKaiTW',
      {''},
   },
   ['cjkunifonts-ttf']   = {  -- gr がサンセリフになっていない
      noncid = true,
      ml='uming.ttf %!PS ShanHeiSun-Uni',
      mr='uming.ttf %!PS ShanHeiSun-Uni',
      mb='uming.ttf %!PS ShanHeiSun-Uni',
      gr='ukai.ttf %!PS ZenKai-Uni',
      gru='ukai.ttf %!PS ZenKai-Uni',
      gb='ukai.ttf %!PS ZenKai-Uni',
      ge='ukai.ttf %!PS ZenKai-Uni',
      mgr='ukai.ttf %!PS ZenKai-Uni',
      {''},
   },
   ['ms']   = { -- for windows vista, 7
      noncid = true,
      ml=':0:mingliu.ttc %!PS MingLiU',
      mr=':0:mingliu.ttc %!PS MingLiU',
      mb=':0:mingliu.ttc %!PS MingLiU',
      gr='msjh.ttf %!PS MicrosoftJhengHeiRegular',
      gru='msjh.ttf %!PS MicrosoftJhengHeiRegular',
      gb='msjh.ttf %!PS MicrosoftJhengHeiRegular',
      ge='msjh.ttf %!PS MicrosoftJhengHeiRegular',
      mgr='msjh.ttf %!PS MicrosoftJhengHeiRegular',
      {''},
   },
   ['ms-win10']   = { -- for windows 8, 8.1, 10
      noncid = true,
      ml=':0:mingliu.ttc %!PS MingLiU',
      mr=':0:mingliu.ttc %!PS MingLiU',
      mb=':0:mingliu.ttc %!PS MingLiU',
      gr=':0:msjh.ttc %!PS MicrosoftJhengHeiRegular',
      gru=':0:msjh.ttc %!PS MicrosoftJhengHeiRegular',
      gb=':0:msjh.ttc %!PS MicrosoftJhengHeiRegular',
      ge=':0:msjh.ttc %!PS MicrosoftJhengHeiRegular',
      mgr=':0:msjh.ttc %!PS MicrosoftJhengHeiRegular',
      {''},
   },
   ['dynacomware']   = {
      noncid = true,
      ml='LiSongPro.ttf',
      mr='LiSongPro.ttf',
      mb='LiSongPro.ttf',
      gr='LiHeiPro.ttf',
      gru='LiHeiPro.ttf',
      gb='LiHeiPro.ttf',
      ge='LiHeiPro.ttf',
      mgr='LiHeiPro.ttf',
      {''},
   },
   ['haranoaji']   = {
      ml='HaranoAjiMinchoTW-Light.otf',
      mr='HaranoAjiMinchoTW-Regular.otf',
      mb='HaranoAjiMinchoTW-Bold.otf',
      gr='HaranoAjiGothicTW-Regular.otf',
      gru='HaranoAjiGothicTW-Medium.otf',
      gb='HaranoAjiGothicTW-Bold.otf',
      ge='HaranoAjiGothicTW-Heavy.otf',
      mgr='HaranoAjiGothicTW-Medium.otf',
      {''},
   },
}

local suffix = {
   -- { '?' 置換, tcEmbed 接尾辞, (ttc index mov)}
   ['']   = {'', ''},          -- 非 CID フォント用ダミー
   ['n']  = {'!', ''},         -- 非埋め込みに使用
   ['4']  = {'Pro', ''},
   ['6']  = {'Pr6', '-pr6'},
}

-- '#' は 'h', 'v' に置換される
-- '@' は tcEmbed の値に置換される
local maps = {
   ['uptex-tc-@'] = {
      {'upmsl-#', 'UniCNS-UTF16-#', 'mr'},
      {'upmhm-#', 'UniCNS-UTF16-#', 'gru'},
   },
   ['otf-tc-@'] = {
      '% CID',
      {'otf-ctml-#',  'Identity-#',     'ml'},
      {'otf-ctmr-#',  'Identity-#',     'mr'},
      {'otf-ctmb-#',  'Identity-#',     'mb'},
      {'otf-ctgr-#',  'Identity-#',     'gr'},
      {'otf-ctgb-#',  'Identity-#',     'gb'},
      {'otf-ctge-#',  'Identity-#',     'ge'},
      {'otf-ctmgr-#', 'Identity-#',     'mgr'},
      '% Unicode',
      {'otf-utml-#',  'UniCNS-UCS2-#', 'ml'},
      {'otf-utmr-#',  'UniCNS-UCS2-#', 'mr'},
      {'otf-utmb-#',  'UniCNS-UCS2-#', 'mb'},
      {'otf-utgr-#',  'UniCNS-UCS2-#', 'gr'},
      {'otf-utgb-#',  'UniCNS-UCS2-#', 'gb'},
      {'otf-utge-#',  'UniCNS-UCS2-#', 'ge'},
      {'otf-utmgr-#', 'UniCNS-UCS2-#', 'mgr'},
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
            fn = gsub(fn, ' %%!PS', '/AC14 %%!PS')
         else
            fn = fn .. '/AC14'
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
      print('tcEmbed: ' .. dirname)
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
