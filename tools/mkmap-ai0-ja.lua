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
-- している．TL2018 になる前に，これを
--   * (-TL17, +TL18) の行を enable
--   * (+TL17, -TL18) の行を disable
-- すること．
local foundry = {
   ['noto-otc']   = {
      ml=':0:NotoSerifCJK-Light.ttc',
      mr=':0:NotoSerifCJK-Regular.ttc',
      mb=':0:NotoSerifCJK-Bold.ttc',
      gr=':0:NotoSansCJK-Regular.ttc',
      gru=':0:NotoSansCJK-Medium.ttc',
      gb=':0:NotoSansCJK-Bold.ttc',
      ge=':0:NotoSansCJK-Black.ttc',
      mgr=':0:NotoSansCJK-Medium.ttc',
      mrq=':2:NotoSerifCJK-Regular.ttc', -- (+TL17, -TL18)
      gruq=':2:NotoSansCJK-Medium.ttc', -- (+TL17, -TL18)
      {''},
   },
}

-- '#' は 'h', 'v' に置換される
-- '@' は jaEmbed の値に置換される
local maps = {
   ['uptex-@'] = {   -- upTeX 90JIS
      {'urml',    '-l jp90',      'mr'},
      {'urmlv',   '-w 1 -l jp90', 'mr'},
      {'ugbm',    '-l jp90',      'gru'},
      {'ugbmv',   '-w 1 -l jp90', 'gru'},
      {'uprml-#', '# -l jp90',    'mr'},
      {'upgbm-#', '# -l jp90',    'gru'},
--      {'uprml-hq','-l fwid',      'mr'}, -- (-TL17, +TL18)
--      {'upgbm-hq','-l fwid',      'gru'}, -- (-TL17, +TL18)
      {'uprml-hq','',      'mrq'}, -- (+TL17, -TL18)
      {'upgbm-hq','',      'gruq'}, -- (+TL17, -TL18)
   },
   ['uptex-@-04'] = { -- upTeX JIS04
      {'urml',    '-l jp04',      'mrn'},
      {'urmlv',   '-w 1 -l jp04', 'mrn'},
      {'ugbm',    '-l jp04',      'grun'},
      {'ugbmv',   '-w 1 -l jp04', 'grun'},
      {'uprml-#', '# -l jp04',    'mrn'},
      {'upgbm-#', '# -l jp04',    'grun'},
--      {'uprml-hq','-l fwid',      'mrn'}, -- (-TL17, +TL18)
--      {'upgbm-hq','-l fwid',      'grun'}, -- (-TL17, +TL18)
      {'uprml-hq','',      'mrq'}, -- (+TL17, -TL18)
      {'upgbm-hq','',      'gruq'}, -- (+TL17, -TL18)
   },
   ['otf-@'] = {
      '% Unicode 90JIS',
      {'otf-ujml-#', '# -l jp90', 'ml'},
      {'otf-ujmr-#', '# -l jp90', 'mr'},
      {'otf-ujmb-#', '# -l jp90', 'mb'},
      {'otf-ujgr-#', '# -l jp90', 'gr'},
      {'otf-ujgb-#', '# -l jp90', 'gb'},
      {'otf-ujge-#', '# -l jp90', 'ge'},
      {'otf-ujmgr-#','# -l jp90', 'mgr'},
      '% Unicode JIS04',
      {'otf-ujmln-#', '# -l jp04', 'mln'},
      {'otf-ujmrn-#', '# -l jp04', 'mrn'},
      {'otf-ujmbn-#', '# -l jp04', 'mbn'},
      {'otf-ujgrn-#', '# -l jp04', 'grn'},
      {'otf-ujgbn-#', '# -l jp04', 'gbn'},
      {'otf-ujgen-#', '# -l jp04', 'gen'},
      {'otf-ujmgrn-#','# -l jp04', 'mgrn'},
   },
   ['otf-up-@'] = {
      '% TEXT, 90JIS',
      {'uphminl-#',  '# -l jp90', 'ml'},
      {'uphminr-#',  '# -l jp90', 'mr'},
      {'uphminb-#',  '# -l jp90', 'mb'},
      {'uphgothr-#', '# -l jp90', 'gr'},
      {'uphgothb-#', '# -l jp90', 'gb'},
      {'uphgotheb-#','# -l jp90', 'ge'},
      {'uphmgothr-#','# -l jp90', 'mgr'},
      '% TEXT, JIS04',
      {'uphminln-#',  '# -l jp04', 'mln'},
      {'uphminrn-#',  '# -l jp04', 'mrn'},
      {'uphminbn-#',  '# -l jp04', 'mbn'},
      {'uphgothrn-#', '# -l jp04', 'grn'},
      {'uphgothbn-#', '# -l jp04', 'gbn'},
      {'uphgothebn-#','# -l jp04', 'gen'},
      {'uphmgothrn-#','# -l jp04', 'mgrn'},
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
   else
      local fx = foundry[fd]
      local fn = fx[o[3]]
      if string.match(o[1], '#') then -- 'H', 'V' 一括出力
	 return gsub(o[1], '#', 'h') .. '\t' .. "unicode" .. '\t' .. fn .. ' ' .. gsub(o[2], '# ', '') .. '\n'
          .. gsub(o[1], '#', 'v') .. '\t' .. "unicode" .. '\t' .. fn .. ' ' .. gsub(o[2], '# ', '-w 1 ') .. '\n'
      else
	 return o[1] .. '\t' .. "unicode" .. '\t' .. fn .. ' ' .. o[2] .. '\n'
      end
   end
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
