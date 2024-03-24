#! /usr/bin/env texlua

-- Adobe-Identity0 なフォントのマップを作る．unicode 専用．
-- これは up(La)TeX + dvipdfmx (TeX Live 2017) が必須．
-- つまり，p(La)TeX は不可．dvips も不可．cid も不可．
local foundry = {
   ['sourcehan-otc']   = { -- Source Han Sans/Serif, "OTC"
      ml=':2:SourceHanSerif-Light.ttc',
      mr=':2:SourceHanSerif-Regular.ttc',
      mb=':2:SourceHanSerif-Bold.ttc',
      gr=':2:SourceHanSans-Regular.ttc',
      gru=':2:SourceHanSans-Medium.ttc',
      gb=':2:SourceHanSans-Bold.ttc',
      ge=':2:SourceHanSans-Heavy.ttc',
      mgr=':2:SourceHanSans-Medium.ttc',
      {''},
   },
   ['sourcehan']   = { -- Source Han Sans/Serif, "Language-specific OTF"
      ml='SourceHanSerifSC-Light.otf',
      mr='SourceHanSerifSC-Regular.otf',
      mb='SourceHanSerifSC-Bold.otf',
      gr='SourceHanSansSC-Regular.otf',
      gru='SourceHanSansSC-Medium.otf',
      gb='SourceHanSansSC-Bold.otf',
      ge='SourceHanSansSC-Heavy.otf',
      mgr='SourceHanSansSC-Medium.otf',
      {''},
   },
   ['noto-otc']   = { -- Noto Sans/Serif CJK, "OpenType/CFF Collection (OTC)"
      ml=':2:NotoSerifCJK-Light.ttc',
      mr=':2:NotoSerifCJK-Regular.ttc',
      mb=':2:NotoSerifCJK-Bold.ttc',
      gr=':2:NotoSansCJK-Regular.ttc',
      gru=':2:NotoSansCJK-Medium.ttc',
      gb=':2:NotoSansCJK-Bold.ttc',
      ge=':2:NotoSansCJK-Black.ttc',
      mgr=':2:NotoSansCJK-Medium.ttc',
      {''},
   },
   ['noto']   = { -- Noto Sans/Serif CJK, "Language-specific OpenType/CFF (OTF)"
      ml='NotoSerifCJKsc-Light.otf',
      mr='NotoSerifCJKsc-Regular.otf',
      mb='NotoSerifCJKsc-Bold.otf',
      gr='NotoSansCJKsc-Regular.otf',
      gru='NotoSansCJKsc-Medium.otf',
      gb='NotoSansCJKsc-Bold.otf',
      ge='NotoSansCJKsc-Black.otf',
      mgr='NotoSansCJKsc-Medium.otf',
      {''},
   },
}

-- Adobe-Identity0 なフォントは dvips で全く使えないので，
-- フォールバックとして noEmbed 相当の設定を追加する．
local foundry_fallback = {
   ['noEmbed']   = {
      fml='!STSong-Light',
      fmr='!STSong-Light',
      fmb='!STSong-Light',
      fgr='!STHeiti-Regular',
      fgru='!STHeiti-Regular',
      fgb='!STHeiti-Regular',
      fge='!STHeiti-Regular',
      fmgr='!STHeiti-Regular',
      {'n'},
   },
}

-- '#' は 'h', 'v' に置換される
-- '@' は scEmbed の値に置換される
-- テーブルサイズが 5 のとき，4/5 番目は fallback の AG1 フォント用
-- テーブルサイズが 3 のとき，全て fallback の AG1 フォント用
local maps = {
   ['uptex-sc-@'] = {
      {'upstsl-#', '#', 'mr',  'fmr',  'UniGB-UTF16-#'},
      {'upstht-#', '#', 'gru', 'fgru', 'UniGB-UTF16-#'},
   },
   ['otf-sc-@'] = {
      '% CID',
      {'otf-ccml-#',  'Identity-#',     'fml'},
      {'otf-ccmr-#',  'Identity-#',     'fmr'},
      {'otf-ccmb-#',  'Identity-#',     'fmb'},
      {'otf-ccgr-#',  'Identity-#',     'fgr'},
      {'otf-ccgb-#',  'Identity-#',     'fgb'},
      {'otf-ccge-#',  'Identity-#',     'fge'},
      {'otf-ccmgr-#', 'Identity-#',     'fmgr'},
      '% Unicode',
      {'otf-ucml-#',  '#', 'ml',  'fml',  'UniGB-UCS2-#'},
      {'otf-ucmr-#',  '#', 'mr',  'fmr',  'UniGB-UCS2-#'},
      {'otf-ucmb-#',  '#', 'mb',  'fmb',  'UniGB-UCS2-#'},
      {'otf-ucgr-#',  '#', 'gr',  'fgr',  'UniGB-UCS2-#'},
      {'otf-ucgb-#',  '#', 'gb',  'fgb',  'UniGB-UCS2-#'},
      {'otf-ucge-#',  '#', 'ge',  'fge',  'UniGB-UCS2-#'},
      {'otf-ucmgr-#', '#', 'mgr', 'fmgr', 'UniGB-UCS2-#'},
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
      print('scEmbed: ' .. dirname)
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
