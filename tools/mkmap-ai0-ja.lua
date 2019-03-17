#! /usr/bin/env texlua

-- Adobe-Identity0 なフォントのマップを作る．unicode 専用．
-- これは up(La)TeX + dvipdfmx (TeX Live 2017) が必須．
-- つまり，p(La)TeX は不可．dvips も不可．cid も不可．

-- ただし，TeX Live 2017 の dvipdfmx にはバグがあるので，
-- 同じフォントに異なる OpenType Layout を付けられない．
-- r44689, r44681 で直っているので，TeX Live 2018 では ok なはず．
-- 回避策として，TL2017 の間は
--   * (-TL17, +TL18) の行を disable
--   * (+TL17, -TL18) の行を enable
-- していた．TL2018 では逆に
--   * (-TL17, +TL18) の行を enable
--   * (+TL17, -TL18) の行を disable
-- とする．
local foundry = {
   ['sourcehan-otc']   = { -- Source Han Sans/Serif, "OTC"
      ml=':0:SourceHanSerif-Light.ttc',
      mr=':0:SourceHanSerif-Regular.ttc',
      mb=':0:SourceHanSerif-Bold.ttc',
      gr=':0:SourceHanSans-Regular.ttc',
      gru=':0:SourceHanSans-Medium.ttc',
      gb=':0:SourceHanSans-Bold.ttc',
      ge=':0:SourceHanSans-Heavy.ttc',
      mgr=':0:SourceHanSans-Medium.ttc',
      -- mrq=':2:SourceHanSerif-Regular.ttc', -- (+TL17, -TL18)
      -- gruq=':2:SourceHanSans-Medium.ttc', -- (+TL17, -TL18)
      {''},
   },
   ['sourcehan']   = { -- Source Han Sans/Serif, "Language-specific OTF"
      ml='SourceHanSerif-Light.otf',
      mr='SourceHanSerif-Regular.otf',
      mb='SourceHanSerif-Bold.otf',
      gr='SourceHanSans-Regular.otf',
      gru='SourceHanSans-Medium.otf',
      gb='SourceHanSans-Bold.otf',
      ge='SourceHanSans-Heavy.otf',
      mgr='SourceHanSans-Medium.otf',
      -- mrq='SourceHanSerifSC-Regular.otf', -- (+TL17, -TL18)
      -- gruq='SourceHanSansSC-Medium.otf', -- (+TL17, -TL18)
      {''},
   },
   ['noto-otc']   = { -- Noto Sans/Serif CJK, "OpenType/CFF Collection (OTC)"
      ml=':0:NotoSerifCJK-Light.ttc',
      mr=':0:NotoSerifCJK-Regular.ttc',
      mb=':0:NotoSerifCJK-Bold.ttc',
      gr=':0:NotoSansCJK-Regular.ttc',
      gru=':0:NotoSansCJK-Medium.ttc',
      gb=':0:NotoSansCJK-Bold.ttc',
      ge=':0:NotoSansCJK-Black.ttc',
      mgr=':0:NotoSansCJK-Medium.ttc',
      -- mrq=':2:NotoSerifCJK-Regular.ttc', -- (+TL17, -TL18)
      -- gruq=':2:NotoSansCJK-Medium.ttc', -- (+TL17, -TL18)
      {''},
   },
   ['noto']   = { -- Noto Sans/Serif CJK, "Language-specific OpenType/CFF (OTF)"
      ml='NotoSerifCJKjp-Light.otf',
      mr='NotoSerifCJKjp-Regular.otf',
      mb='NotoSerifCJKjp-Bold.otf',
      gr='NotoSansCJKjp-Regular.otf',
      gru='NotoSansCJKjp-Medium.otf',
      gb='NotoSansCJKjp-Bold.otf',
      ge='NotoSansCJKjp-Black.otf',
      mgr='NotoSansCJKjp-Medium.otf',
      -- mrq='NotoSerifCJKsc-Regular.otf', -- (+TL17, -TL18)
      -- gruq='NotoSansCJKsc-Medium.otf', -- (+TL17, -TL18)
      {''},
   },
}

-- Adobe-Identity0 なフォントは dvips で全く使えないので，
-- フォールバックとして noEmbed 相当の設定を追加する．
local foundry_fallback = {
   ['noEmbed']   = {
      fml='!Ryumin-Light',
      fmr='!Ryumin-Light',
      fmb='!Ryumin-Light,Bold',
      fgr='!GothicBBB-Medium',
      fgru='!GothicBBB-Medium',
      fgb='!GothicBBB-Medium,Bold',
      fge='!GothicBBB-Medium,Bold',
      fmgr='!GothicBBB-Medium',
      {'n'},
   },
}

-- '#' は 'h', 'v' に置換される
-- '@' は jaEmbed の値に置換される
-- テーブルサイズが 5 のとき，4/5 番目は fallback の AJ1 フォント用
-- テーブルサイズが 3 のとき，全て fallback の AJ1 フォント用
local maps = {
   ['ptex-@'] = {    -- pTeX 90JIS
      {'rml',  'H', 'fmr'},
      {'rmlv', 'V', 'fmr'},
      {'gbm',  'H', 'fgru'},
      {'gbmv', 'V', 'fgru'},
   },
   ['ptex-@-04'] = { -- pTeX JIS04
      {'rml',  '2004-H', 'fmr'},
      {'rmlv', '2004-V', 'fmr'},
      {'gbm',  '2004-H', 'fgru'},
      {'gbmv', '2004-V', 'fgru'},
   },
   ['uptex-@'] = {   -- upTeX 90JIS
      {'urml',    '-l jp90',      'mr',  'fmr',  'UniJIS-UTF16-H'},
      {'urmlv',   '-w 1 -l jp90', 'mr',  'fmr',  'UniJIS-UTF16-V'},
      {'ugbm',    '-l jp90',      'gru', 'fgru', 'UniJIS-UTF16-H'},
      {'ugbmv',   '-w 1 -l jp90', 'gru', 'fgru', 'UniJIS-UTF16-V'},
      {'uprml-#', '# -l jp90',    'mr',  'fmr',  'UniJIS-UTF16-#'},
      {'upgbm-#', '# -l jp90',    'gru', 'fgru', 'UniJIS-UTF16-#'},
      {'uprml-hq','-l fwid',      'mr',  'fmr',  'UniJIS-UCS2-H'}, -- (-TL17, +TL18)
      {'upgbm-hq','-l fwid',      'gru', 'fgru', 'UniJIS-UCS2-H'}, -- (-TL17, +TL18)
      --{'uprml-hq','',             'mrq', 'fmrq', 'UniJIS-UCS2-H'}, -- (+TL17, -TL18)
      --{'upgbm-hq','',             'gruq','fgruq','UniJIS-UCS2-H'}, -- (+TL17, -TL18)
   },
   ['uptex-@-04'] = { -- upTeX JIS04
      {'urml',    '-l jp04',      'mrn',  'fmr',  'UniJIS2004-UTF16-H'},
      {'urmlv',   '-w 1 -l jp04', 'mrn',  'fmr',  'UniJIS2004-UTF16-V'},
      {'ugbm',    '-l jp04',      'grun', 'fgru', 'UniJIS2004-UTF16-H'},
      {'ugbmv',   '-w 1 -l jp04', 'grun', 'fgru', 'UniJIS2004-UTF16-V'},
      {'uprml-#', '# -l jp04',    'mrn',  'fmr',  'UniJIS2004-UTF16-#'},
      {'upgbm-#', '# -l jp04',    'grun', 'fgru', 'UniJIS2004-UTF16-#'},
      {'uprml-hq','-l fwid',      'mrn',  'fmr',  'UniJIS-UCS2-H'}, -- (-TL17, +TL18)
      {'upgbm-hq','-l fwid',      'grun', 'fgru', 'UniJIS-UCS2-H'}, -- (-TL17, +TL18)
      --{'uprml-hq','',             'mrqn', 'fmrq', 'UniJIS-UCS2-H'}, -- (+TL17, -TL18)
      --{'upgbm-hq','',             'gruqn','fgruq','UniJIS-UCS2-H'}, -- (+TL17, -TL18)
   },
   ['otf-@'] = {
      '% TEXT, 90JIS',
      {'hminl-#',  '#', 'fml'},
      {'hminr-#',  '#', 'fmr'},
      {'hminb-#',  '#', 'fmb'},
      {'hgothr-#', '#', 'fgr'},
      {'hgothb-#', '#', 'fgb'},
      {'hgotheb-#','#', 'fge'},
      {'hmgothr-#','#', 'fmgr'},
      '% TEXT, JIS04',
      {'hminln-#',  '#', 'fml'},
      {'hminrn-#',  '#', 'fmr'},
      {'hminbn-#',  '#', 'fmb'},
      {'hgothrn-#', '#', 'fgr'},
      {'hgothbn-#', '#', 'fgb'},
      {'hgothebn-#','#', 'fge'},
      {'hmgothrn-#','#', 'fmgr'},
      '% CID',
      {'otf-cjml-#', 'Identity-#',     'fml'},
      {'otf-cjmr-#', 'Identity-#',     'fmr'},
      {'otf-cjmb-#', 'Identity-#',     'fmb'},
      {'otf-cjgr-#', 'Identity-#',     'fgr'},
      {'otf-cjgb-#', 'Identity-#',     'fgb'},
      {'otf-cjge-#', 'Identity-#',     'fge'},
      {'otf-cjmgr-#','Identity-#',     'fmgr'},
      '% Unicode 90JIS',
      {'otf-ujml-#', '# -l jp90', 'ml',  'fml', 'UniJIS-UTF16-#'},
      {'otf-ujmr-#', '# -l jp90', 'mr',  'fmr', 'UniJIS-UTF16-#'},
      {'otf-ujmb-#', '# -l jp90', 'mb',  'fmb', 'UniJIS-UTF16-#'},
      {'otf-ujgr-#', '# -l jp90', 'gr',  'fgr', 'UniJIS-UTF16-#'},
      {'otf-ujgb-#', '# -l jp90', 'gb',  'fgb', 'UniJIS-UTF16-#'},
      {'otf-ujge-#', '# -l jp90', 'ge',  'fge', 'UniJIS-UTF16-#'},
      {'otf-ujmgr-#','# -l jp90', 'mgr', 'fmgr','UniJIS-UTF16-#'},
      '% Unicode JIS04',
      {'otf-ujmln-#', '# -l jp04', 'mln',  'fml', 'UniJIS2004-UTF16-#'},
      {'otf-ujmrn-#', '# -l jp04', 'mrn',  'fmr', 'UniJIS2004-UTF16-#'},
      {'otf-ujmbn-#', '# -l jp04', 'mbn',  'fmb', 'UniJIS2004-UTF16-#'},
      {'otf-ujgrn-#', '# -l jp04', 'grn',  'fgr', 'UniJIS2004-UTF16-#'},
      {'otf-ujgbn-#', '# -l jp04', 'gbn',  'fgb', 'UniJIS2004-UTF16-#'},
      {'otf-ujgen-#', '# -l jp04', 'gen',  'fge', 'UniJIS2004-UTF16-#'},
      {'otf-ujmgrn-#','# -l jp04', 'mgrn', 'fmgr','UniJIS2004-UTF16-#'},
   },
   ['otf-up-@'] = {
      '% TEXT, 90JIS',
      {'uphminl-#',  '# -l jp90', 'ml',  'fml', 'UniJIS-UTF16-#'},
      {'uphminr-#',  '# -l jp90', 'mr',  'fmr', 'UniJIS-UTF16-#'},
      {'uphminb-#',  '# -l jp90', 'mb',  'fmb', 'UniJIS-UTF16-#'},
      {'uphgothr-#', '# -l jp90', 'gr',  'fgr', 'UniJIS-UTF16-#'},
      {'uphgothb-#', '# -l jp90', 'gb',  'fgb', 'UniJIS-UTF16-#'},
      {'uphgotheb-#','# -l jp90', 'ge',  'fge', 'UniJIS-UTF16-#'},
      {'uphmgothr-#','# -l jp90', 'mgr', 'fmgr','UniJIS-UTF16-#'},
      '% TEXT, JIS04',
      {'uphminln-#',  '# -l jp04', 'mln',  'fml', 'UniJIS2004-UTF16-#'},
      {'uphminrn-#',  '# -l jp04', 'mrn',  'fmr', 'UniJIS2004-UTF16-#'},
      {'uphminbn-#',  '# -l jp04', 'mbn',  'fmb', 'UniJIS2004-UTF16-#'},
      {'uphgothrn-#', '# -l jp04', 'grn',  'fgr', 'UniJIS2004-UTF16-#'},
      {'uphgothbn-#', '# -l jp04', 'gbn',  'fgb', 'UniJIS2004-UTF16-#'},
      {'uphgothebn-#','# -l jp04', 'gen',  'fge', 'UniJIS2004-UTF16-#'},
      {'uphmgothrn-#','# -l jp04', 'mgrn', 'fmgr','UniJIS2004-UTF16-#'},
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
         return gsub(o[1], '#', 'h') .. '\t' .. "unicode" .. '\t' .. fn .. ' ' .. gsub(o[2], '# ', '')
          .. ' %!FB ' .. bn .. '-' .. gsub(o[5], '#', 'H') .. '\n'
          .. gsub(o[1], '#', 'v') .. '\t' .. "unicode" .. '\t' .. fn .. ' ' .. gsub(o[2], '# ', '-w 1 ')
          .. ' %!FB ' .. bn .. '-' .. gsub(o[5], '#', 'V') .. '\n'
      else
         return o[1] .. '\t' .. "unicode" .. '\t' .. fn .. ' ' .. o[2]
          .. ' %!FB ' .. bn .. '-' .. o[5] .. '\n'
      end
   end end
end

for fd, v1 in pairs(foundry) do
   -- separate でないときは mln などのデータベースを省略してあるので ml などからコピー
   if not foundry[fd].separate then
      foundry[fd].mln = foundry[fd].ml
      foundry[fd].mrn = foundry[fd].mr
      foundry[fd].mbn = foundry[fd].mb
      foundry[fd].grn = foundry[fd].gr
      foundry[fd].grun = foundry[fd].gru
      foundry[fd].gbn = foundry[fd].gb
      foundry[fd].gen = foundry[fd].ge
      foundry[fd].mgrn = foundry[fd].mgr
   end
   for _,s in pairs(v1[1]) do
      local dirname = fd
      print('jaEmbed: ' .. dirname)
      -- Linux しか想定していない
      os.execute('mkdir ' .. dirname .. ' &>/dev/null')
      for mnx, mcont in pairs(maps) do
         if not string.match(mnx, '-04') or not foundry[fd].noncid or foundry[fd].separate then
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
