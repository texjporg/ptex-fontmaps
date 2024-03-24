#! /usr/bin/env texlua

-- Adobe-Identity0 なフォントのマップを作る．unicode 専用．
-- これは up(La)TeX + dvipdfmx (TeX Live 2017) が必須．
-- つまり，p(La)TeX は不可．dvips も不可．cid も不可．
local foundry = {
   ['sourcehan-otc']   = { -- Source Han Sans/Serif, "OTC"
      ml=':3:SourceHanSerif-Light.ttc',
      mr=':3:SourceHanSerif-Regular.ttc',
      mb=':3:SourceHanSerif-Bold.ttc',
      gr=':3:SourceHanSans-Regular.ttc',
      gru=':3:SourceHanSans-Medium.ttc',
      gb=':3:SourceHanSans-Bold.ttc',
      ge=':3:SourceHanSans-Heavy.ttc',
      mgr=':3:SourceHanSans-Medium.ttc',
      {''},
   },
   ['sourcehan']   = { -- Source Han Sans/Serif, "Language-specific OTF"
      ml='SourceHanSerifTC-Light.otf',
      mr='SourceHanSerifTC-Regular.otf',
      mb='SourceHanSerifTC-Bold.otf',
      gr='SourceHanSansTC-Regular.otf',
      gru='SourceHanSansTC-Medium.otf',
      gb='SourceHanSansTC-Bold.otf',
      ge='SourceHanSansTC-Heavy.otf',
      mgr='SourceHanSansTC-Medium.otf',
      {''},
   },
   ['noto-otc']   = { -- Noto Sans/Serif CJK, "OpenType/CFF Collection (OTC)"
      ml=':3:NotoSerifCJK-Light.ttc',
      mr=':3:NotoSerifCJK-Regular.ttc',
      mb=':3:NotoSerifCJK-Bold.ttc',
      gr=':3:NotoSansCJK-Regular.ttc',
      gru=':3:NotoSansCJK-Medium.ttc',
      gb=':3:NotoSansCJK-Bold.ttc',
      ge=':3:NotoSansCJK-Black.ttc',
      mgr=':3:NotoSansCJK-Medium.ttc',
      {''},
   },
   ['noto']   = { -- Noto Sans/Serif CJK, "Language-specific OpenType/CFF (OTF)"
      ml='NotoSerifCJKtc-Light.otf',
      mr='NotoSerifCJKtc-Regular.otf',
      mb='NotoSerifCJKtc-Bold.otf',
      gr='NotoSansCJKtc-Regular.otf',
      gru='NotoSansCJKtc-Medium.otf',
      gb='NotoSansCJKtc-Bold.otf',
      ge='NotoSansCJKtc-Black.otf',
      mgr='NotoSansCJKtc-Medium.otf',
      {''},
   },
}

-- Adobe-Identity0 なフォントは dvips で全く使えないので，
-- フォールバックとして noEmbed 相当の設定を追加する．
local foundry_fallback = {
   ['noEmbed']   = {
      fml='!MSung-Light',
      fmr='!MSung-Light',
      fmb='!MSung-Light',
      fgr='!MHei-Medium',
      fgru='!MHei-Medium',
      fgb='!MHei-Medium',
      fge='!MHei-Medium',
      fmgr='!MHei-Medium',
      {'n'},
   },
}

-- '#' は 'h', 'v' に置換される
-- '@' は tcEmbed の値に置換される
-- テーブルサイズが 5 のとき，4/5 番目は fallback の AC1 フォント用
-- テーブルサイズが 3 のとき，全て fallback の AC1 フォント用
local maps = {
   ['uptex-tc-@'] = {
      {'upmsl-#', '#', 'mr' , 'fmr' , 'UniCNS-UTF16-#'},
      {'upmhm-#', '#', 'gru', 'fgru', 'UniCNS-UTF16-#'},
   },
   ['otf-tc-@'] = {
      '% CID',
      {'otf-ctml-#',  'Identity-#',     'fml'},
      {'otf-ctmr-#',  'Identity-#',     'fmr'},
      {'otf-ctmb-#',  'Identity-#',     'fmb'},
      {'otf-ctgr-#',  'Identity-#',     'fgr'},
      {'otf-ctgb-#',  'Identity-#',     'fgb'},
      {'otf-ctge-#',  'Identity-#',     'fge'},
      {'otf-ctmgr-#', 'Identity-#',     'fmgr'},
      '% Unicode',
      {'otf-utml-#',  '#', 'ml',  'fml',  'UniCNS-UCS2-#'},
      {'otf-utmr-#',  '#', 'mr',  'fmr',  'UniCNS-UCS2-#'},
      {'otf-utmb-#',  '#', 'mb',  'fmb',  'UniCNS-UCS2-#'},
      {'otf-utgr-#',  '#', 'gr',  'fgr',  'UniCNS-UCS2-#'},
      {'otf-utgb-#',  '#', 'gb',  'fgb',  'UniCNS-UCS2-#'},
      {'otf-utge-#',  '#', 'ge',  'fge',  'UniCNS-UCS2-#'},
      {'otf-utmgr-#', '#', 'mgr', 'fmgr', 'UniCNS-UCS2-#'},
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

local function make_one_line(o, fd, s)
   if type(o) == 'string' then
      return '\n' .. o .. '\n'
   else if #o == 3 then
      local bx = foundry_fallback['noEmbed']
      local bn = bx[o[3]]
      if string.match(o[1], '#') then -- 'H', 'V' 一括出力
         return gsub(o[1], '#', 'h') .. '\t' .. gsub(o[2], '#', 'H') .. '\t' .. bn .. '\n'
          .. gsub(o[1], '#', 'v') .. '\t' .. gsub(o[2], '#', 'V') .. '\t' .. bn .. '\n'
      else
         return o[1] .. '\t' .. o[2] .. '\t' .. bn .. '\n'
      end
   else
      local fx = foundry[fd]
      local fn = fx[o[3]]
      local bx = foundry_fallback['noEmbed']
      local bn = bx[o[4]]
      if string.match(o[1], '#') then -- 'H', 'V' 一括出力
         return gsub(o[1], '#', 'h') .. '\t' .. "unicode" .. '\t' .. fn .. gsub(o[2], '#', '')
          .. ' %!DVIPSFB ' .. bn .. '-' .. gsub(o[5], '#', 'H') .. '\n'
          .. gsub(o[1], '#', 'v') .. '\t' .. "unicode" .. '\t' .. fn .. ' ' .. gsub(o[2], '#', '-w 1')
          .. ' %!DVIPSFB ' .. bn .. '-' .. gsub(o[5], '#', 'V') .. '\n'
      else
         return o[1] .. '\t' .. "unicode" .. '\t' .. fn .. ' ' .. o[2]
          .. ' %!DVIPSFB ' .. bn .. '-' .. o[5] .. '\n'
      end
   end end
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
      local dirname = fd
      print('tcEmbed: ' .. dirname)
      mkdir(dirname)
      for mnx, mcont in pairs(maps) do
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
