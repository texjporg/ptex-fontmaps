#! /usr/bin/env texlua

-- 90 字形と 04 字形が別ファイルに分かれているフォントセットの場合は
--   * ml, mr, ... に 90 字形フォント
--   * mln, mrn, ... に 04 字形フォント
-- を登録し，separate = true とする．それ以外のフォントは ml, mr, ... のほうに登録しておけばよい．
-- CID フォントでない場合は noncid = true とする．
-- '?' は 'Pro' 等に置換される
local foundry = {
   ['noEmbed']   = {
      ml='!Ryumin-Light',
      mr='!Ryumin-Light',
      mb='!Ryumin-Light,Bold',
      gr='!GothicBBB-Medium',
      gru='!GothicBBB-Medium',
      gb='!GothicBBB-Medium,Bold',
      ge='!GothicBBB-Medium,Bold',
      mgr='!GothicBBB-Medium',
      {'n'},
   },
   ['ms']   = {
      noncid = true,
      ml=':0:msmincho.ttc %!PS MS-Mincho',
      mr=':0:msmincho.ttc %!PS MS-Mincho',
      mb=':0:msmincho.ttc %!PS MS-Mincho',
      gr=':0:msgothic.ttc %!PS MS-Gothic',
      gru=':0:msgothic.ttc %!PS MS-Gothic',
      gb=':0:msgothic.ttc %!PS MS-Gothic',
      ge=':0:msgothic.ttc %!PS MS-Gothic',
      mgr=':0:msgothic.ttc %!PS MS-Gothic',
      {''},
   },
   ['ms-osx']   = {
      noncid = true,
      ml='MS-Mincho.ttf',
      mr='MS-Mincho.ttf',
      mb='MS-Mincho.ttf',
      gr='MS-Gothic.ttf',
      gru='MS-Gothic.ttf',
      gb='MS-Gothic.ttf',
      ge='MS-Gothic.ttf',
      mgr='MS-Gothic.ttf',
      {''},
   },
   ['yu-win']   = {
      noncid = true,
      ml='yuminl.ttf %!PS YuMincho-Light',
      mr='yumin.ttf %!PS YuMincho-Regular',
      mb='yumindb.ttf %!PS YuMincho-DemiBold',
      gr='yugothic.ttf %!PS YuGothic-Regular',
      gru='yugothic.ttf %!PS YuGothic-Regular',
      gb='yugothib.ttf %!PS YuGothic-Bold',
      ge='yugothib.ttf %!PS YuGothic-Bold',
      mgr='yugothib.ttf %!PS YuGothic-Bold',
      {''},
   },
   ['yu-win10']   = {
      noncid = true,
      ml='yuminl.ttf %!PS YuMincho-Light',
      mr='yumin.ttf %!PS YuMincho-Regular',
      mb='yumindb.ttf %!PS YuMincho-DemiBold',
      gr=':0:YuGothR.ttc %!PS YuGothic-Regular',
      gru=':0:YuGothM.ttc %!PS YuGothic-Medium',
      gb=':0:YuGothB.ttc %!PS YuGothic-Bold',
      ge=':0:YuGothB.ttc %!PS YuGothic-Bold',
      mgr=':0:YuGothB.ttc %!PS YuGothic-Bold',
      {''},
   },
   ['yu-osx']   = {
      noncid = false,
      ml='YuMin-Medium.otf',
      mr='YuMin-Medium.otf',
      mb='YuMin-Demibold.otf',
      gr='YuGo-Medium.otf',
      gru='YuGo-Medium.otf',
      gb='YuGo-Bold.otf',
      ge='YuGo-Bold.otf',
      mgr='YuGo-Bold.otf',
      {''},
   },
   ['ipa']   = {
      noncid = true,
      ml='ipam.ttf %!PS IPAMincho',
      mr='ipam.ttf %!PS IPAMincho',
      mb='ipam.ttf %!PS IPAMincho',
      gr='ipag.ttf %!PS IPAGothic',
      gru='ipag.ttf %!PS IPAGothic',
      gb='ipag.ttf %!PS IPAGothic',
      ge='ipag.ttf %!PS IPAGothic',
      mgr='ipag.ttf %!PS IPAGothic',
      {''},
   },
   ['ipaex']   = {
      noncid = true,
      ml='ipaexm.ttf %!PS IPAexMincho',
      mr='ipaexm.ttf %!PS IPAexMincho',
      mb='ipaexm.ttf %!PS IPAexMincho',
      gr='ipaexg.ttf %!PS IPAexGothic',
      gru='ipaexg.ttf %!PS IPAexGothic',
      gb='ipaexg.ttf %!PS IPAexGothic',
      ge='ipaexg.ttf %!PS IPAexGothic',
      mgr='ipaexg.ttf %!PS IPAexGothic',
      {''},
   },
   ['moga-mobo']   = {
      noncid = true,
      separate = true,
      ml=':3:mogam.ttc %!PS Moga90Mincho-Regular',
      mr=':3:mogam.ttc %!PS Moga90Mincho-Regular',
      mb=':2:mogamb.ttc %!PS Moga90Mincho-Bold',
      gr=':2:mogag.ttc %!PS Moga90Gothic-Regular',
      gru=':2:mogag.ttc %!PS Moga90Gothic-Regular',
      gb=':2:mogagb.ttc %!PS Moga90Gothic-Bold',
      ge=':2:mogagb.ttc %!PS Moga90Gothic-Bold',
      mgr=':2:mobog.ttc %!PS Mobo90Gothic-Regular',
      mln=':0:mogam.ttc %!PS MogaMincho-Regular',
      mrn=':0:mogam.ttc %!PS MogaMincho-Regular',
      mbn=':0:mogamb.ttc %!PS MogaMincho-Bold',
      grn=':0:mogag.ttc %!PS MogaGothic-Regular',
      grun=':0:mogag.ttc %!PS MogaGothic-Regular',
      gbn=':0:mogagb.ttc %!PS MogaGothic-Bold',
      gen=':0:mogagb.ttc %!PS MogaGothic-Bold',
      mgrn=':0:mobog.ttc %!PS MoboGothic-Regular',
      {''},
   },
   ['moga-mobo-ex']   = {
      noncid = true,
      separate = true,
      ml=':4:mogam.ttc %!PS MogaEx90Mincho-Regular',
      mr=':4:mogam.ttc %!PS MogaEx90Mincho-Regular',
      mb=':3:mogamb.ttc %!PS MogaEx90Mincho-Bold',
      gr=':3:mogag.ttc %!PS MogaEx90Gothic-Regular',
      gru=':3:mogag.ttc %!PS MogaEx90Gothic-Regular',
      gb=':3:mogagb.ttc %!PS MogaEx90Gothic-Bold',
      ge=':3:mogagb.ttc %!PS MogaEx90Gothic-Bold',
      mgr=':3:mobog.ttc %!PS MoboEx90Gothic-Regular',
      mln=':1:mogam.ttc %!PS MogaExMincho-Regular',
      mrn=':1:mogam.ttc %!PS MogaExMincho-Regular',
      mbn=':1:mogamb.ttc %!PS MogaExMincho-Bold',
      grn=':1:mogag.ttc %!PS MogaExGothic-Regular',
      grun=':1:mogag.ttc %!PS MogaExGothic-Regular',
      gbn=':1:mogagb.ttc %!PS MogaExGothic-Bold',
      gen=':1:mogagb.ttc %!PS MogaExGothic-Bold',
      mgrn=':1:mobog.ttc %!PS MoboExGothic-Regular',
      {''},
   },
   ['ume']   = {
      noncid = true,
      ml='ume-tmo3.ttf %!PS Ume-Mincho',
      mr='ume-tmo3.ttf %!PS Ume-Mincho',
      mb='ume-tmo3.ttf %!PS Ume-Mincho',
      gr='ume-tgo4.ttf %!PS Ume-Gothic',
      gru='ume-tgo5.ttf %!PS Ume-Gothic-O5',
      gb='ume-tgo5.ttf %!PS Ume-Gothic-O5',
      ge='ume-tgo5.ttf %!PS Ume-Gothic-O5',
      mgr='ume-tgo4.ttf %!PS Ume-Gothic',
      {''},
   },
   ['canon']   = {
      noncid = true,
      ml=':0:FGCCHMW3.TTC',
      mr=':0:FGCCHMW3.TTC',
      mb=':0:FGCCHMW5.TTC',
      gr=':0:FGCCHGW5.TTC',
      gru=':0:FGCCHGW7.TTC',
      gb=':0:FGCCHGW7.TTC',
      ge=':0:FGCCHGW9.TTC',
      mgr=':0:FGCCARGM.TTC',
      {''},
   },
   ['kozuka']   = {
      ml='KozMin?-Light.otf',
      mr='KozMin?-Regular.otf',
      mb='KozMin?-Bold.otf',
      gr='KozGo?-Regular.otf',
      gru='KozGo?-Medium.otf',
      gb='KozGo?-Bold.otf',
      ge='KozGo?-Heavy.otf',
      mgr='KozGo?-Heavy.otf',
      {'4','6','6n'}, -- Pro, Pr6 and  Pr6N
   },
   ['morisawa'] = {
      ml='A-OTF-Ryumin?-Light.otf %!PS Ryumin?-Light',
      mr='A-OTF-Ryumin?-Light.otf %!PS Ryumin?-Light',
      mb='A-OTF-FutoMinA101?-Bold.otf %!PS FutoMinA101?-Bold',
      gr='A-OTF-GothicBBB?-Medium.otf %!PS GothicBBB?-Medium',
      gru='A-OTF-GothicBBB?-Medium.otf %!PS GothicBBB?-Medium',
      gb='A-OTF-FutoGoB101?-Bold.otf %!PS FutoGoB101?-Bold',
      ge='A-OTF-MidashiGo?-MB31.otf %!PS MidashiGo?-MB31',
      mgr='A-OTF-Jun101?-Light.otf %!PS Jun101?-Light',
      {'4'}, -- Pro
   },
   ['morisawa-pr6n'] = {
      ml='A-OTF-Ryumin?-Light.otf %!PS Ryumin?-Light',
      mr='A-OTF-Ryumin?-Light.otf %!PS Ryumin?-Light',
      mb='A-OTF-FutoMinA101?-Bold.otf %!PS FutoMinA101?-Bold',
      gr='A-OTF-GothicBBB?-Medium.otf %!PS GothicBBB?-Medium',
      gru='A-OTF-GothicBBB?-Medium.otf %!PS GothicBBB?-Medium',
      gb='A-OTF-FutoGoB101?-Bold.otf %!PS FutoGoB101?-Bold',
      ge='A-OTF-MidashiGo?-MB31.otf %!PS MidashiGo?-MB31',
      mgr='A-OTF-ShinMGo?-Light.otf %!PS ShinMGo?-Light',
      {'6nm'}, -- Pr6N
   },
   ['hiragino'] = {
      ml='HiraMin?-W2.otf', -- OSX にはない
      mr='HiraMin?-W3.otf',
      mb='HiraMin?-W6.otf',
      gr='HiraKaku?-W3.otf',
      gru='HiraKaku?-W6.otf',
      gb='HiraKaku?-W6.otf',
      ge='HiraKaku?-W8.otf',
      mgr='HiraMaru?-W4.otf',
      {'X','Xn'},  -- Pro and ProN
   },
   ['hiragino-elcapitan'] = {
      ml= '#1-HiraginoSerif-W3.ttc %!PS HiraMin?-W3', -- ここは OTC を使おう
      mr= '#1-HiraginoSerif-W3.ttc %!PS HiraMin?-W3',
      mb= '#1-HiraginoSerif-W6.ttc %!PS HiraMin?-W6',
      gr= '#3-HiraginoSans-W3.ttc  %!PS HiraKaku?-W3',
      gru='#3-HiraginoSans-W6.ttc  %!PS HiraKaku?-W6',
      gb= '#3-HiraginoSans-W6.ttc  %!PS HiraKaku?-W6',
      ge= '#2+HiraginoSans-W8.ttc  %!PS HiraKaku?-W8',
      mgr='#0+HiraginoSansR-W4.ttc %!PS HiraMaru?-W4',
      {'X','Xn'},  -- Pro and ProN
   },
   ['toppanbunkyu-sierra'] = {
      ml= 'ToppanBunkyuMincho-Regular.otf %!PS ToppanBunkyuMinchoPr6N-Regular',
      mr= 'ToppanBunkyuMincho-Regular.otf %!PS ToppanBunkyuMinchoPr6N-Regular',
      mb= 'ToppanBunkyuMidashiMincho-ExtraBold.otf %!PS ToppanBunkyuMidashiMinchoStdN-ExtraBold',
      gr= ':1:ToppanBunkyuGothic.ttc %!PS ToppanBunkyuGothicPr6N-Regular',
      gru=':0:ToppanBunkyuGothic.ttc %!PS ToppanBunkyuGothicPr6N-DB',
      gb= ':0:ToppanBunkyuGothic.ttc %!PS ToppanBunkyuGothicPr6N-DB',
      ge= 'ToppanBunkyuMidashiGothic-ExtraBold.otf %!PS ToppanBunkyuMidashiGothicStdN-ExtraBold',
      mgr=':1:ToppanBunkyuGothic.ttc %!PS ToppanBunkyuGothicPr6N-Regular',
      {''},
   },
}

local suffix = {
   -- { '?' 置換, kanjiEmbed 接尾辞, (ttc index mov)}
   ['']   = {'', ''},          -- 非 CID フォント用ダミー
   ['n']  = {'!', ''},         -- 非埋め込みに使用
   ['4']  = {'Pro', ''},
   ['6']  = {'Pr6', '-pr6'},
   ['X']  = {'Pro', '', '0'},       -- ヒラギノ
   ['Xn'] = {'ProN', '-pron', '1'}, -- ヒラギノ
   ['6n'] = {'Pr6N','-pr6n'},
   ['6nm'] = {'Pr6N',''},      -- モリサワ Pr6N
}

-- '#' は 'h', 'v' に置換される
-- '@' は kanjiEmbed の値に置換される
local maps = {
   ['ptex-@'] = {    -- pTeX 90JIS
      {'rml',  'H', 'mr'},
      {'rmlv', 'V', 'mr'},
      {'gbm',  'H', 'gru'},
      {'gbmv', 'V', 'gru'},
   },
   ['ptex-@-04'] = { -- pTeX JIS04
      {'rml',  '2004-H', 'mrn'},
      {'rmlv', '2004-V', 'mrn'},
      {'gbm',  '2004-H', 'grun'},
      {'gbmv', '2004-V', 'grun'},
   },
   ['uptex-@'] = {   -- upTeX 90JIS
      {'urml',    'UniJIS-UTF16-H', 'mr'},
      {'urmlv',   'UniJIS-UTF16-V', 'mr'},
      {'ugbm',    'UniJIS-UTF16-H', 'gru'},
      {'ugbmv',   'UniJIS-UTF16-V', 'gru'},
      {'uprml-#', 'UniJIS-UTF16-#', 'mr'},
      {'upgbm-#', 'UniJIS-UTF16-#', 'gru'},
      {'uprml-hq','UniJIS-UCS2-H',  'mr'},
      {'upgbm-hq','UniJIS-UCS2-H',  'gru'},
   },
   ['uptex-@-04'] = { -- upTeX JIS04
      {'urml',    'UniJIS2004-UTF16-H', 'mrn'},
      {'urmlv',   'UniJIS2004-UTF16-V', 'mrn'},
      {'ugbm',    'UniJIS2004-UTF16-H', 'grun'},
      {'ugbmv',   'UniJIS2004-UTF16-V', 'grun'},
      {'uprml-#', 'UniJIS2004-UTF16-#', 'mrn'},
      {'upgbm-#', 'UniJIS2004-UTF16-#', 'grun'},
      {'uprml-hq','UniJIS-UCS2-H',  'mrn'},
      {'upgbm-hq','UniJIS-UCS2-H',  'grun'},
   },
   ['otf-@'] = {
      '% TEXT, 90JIS',
      {'hminl-#',  '#', 'ml'},
      {'hminr-#',  '#', 'mr'},
      {'hminb-#',  '#', 'mb'},
      {'hgothr-#', '#', 'gr'},
      {'hgothb-#', '#', 'gb'},
      {'hgotheb-#','#', 'ge'},
      {'hmgothr-#','#', 'mgr'},
      '% TEXT, JIS04',
      {'hminln-#',  '#', 'mln'},
      {'hminrn-#',  '#', 'mrn'},
      {'hminbn-#',  '#', 'mbn'},
      {'hgothrn-#', '#', 'grn'},
      {'hgothbn-#', '#', 'gbn'},
      {'hgothebn-#','#', 'gen'},
      {'hmgothrn-#','#', 'mgrn'},
      '% CID',
      {'otf-cjml-#', 'Identity-#',     'mln'},
      {'otf-cjmr-#', 'Identity-#',     'mrn'},
      {'otf-cjmb-#', 'Identity-#',     'mbn'},
      {'otf-cjgr-#', 'Identity-#',     'grn'},
      {'otf-cjgb-#', 'Identity-#',     'gbn'},
      {'otf-cjge-#', 'Identity-#',     'gen'},
      {'otf-cjmgr-#','Identity-#',     'mgrn'},
      '% Unicode 90JIS',
      {'otf-ujml-#', 'UniJIS-UTF16-#', 'ml'},
      {'otf-ujmr-#', 'UniJIS-UTF16-#', 'mr'},
      {'otf-ujmb-#', 'UniJIS-UTF16-#', 'mb'},
      {'otf-ujgr-#', 'UniJIS-UTF16-#', 'gr'},
      {'otf-ujgb-#', 'UniJIS-UTF16-#', 'gb'},
      {'otf-ujge-#', 'UniJIS-UTF16-#', 'ge'},
      {'otf-ujmgr-#','UniJIS-UTF16-#', 'mgr'},
      '% Unicode JIS04',
      {'otf-ujmln-#', 'UniJIS2004-UTF16-#', 'mln'},
      {'otf-ujmrn-#', 'UniJIS2004-UTF16-#', 'mrn'},
      {'otf-ujmbn-#', 'UniJIS2004-UTF16-#', 'mbn'},
      {'otf-ujgrn-#', 'UniJIS2004-UTF16-#', 'grn'},
      {'otf-ujgbn-#', 'UniJIS2004-UTF16-#', 'gbn'},
      {'otf-ujgen-#', 'UniJIS2004-UTF16-#', 'gen'},
      {'otf-ujmgrn-#','UniJIS2004-UTF16-#', 'mgrn'},
   },
   ['otf-up-@'] = {
      '% TEXT, 90JIS',
      {'uphminl-#',  'UniJIS-UTF16-#', 'ml'},
      {'uphminr-#',  'UniJIS-UTF16-#', 'mr'},
      {'uphminb-#',  'UniJIS-UTF16-#', 'mb'},
      {'uphgothr-#', 'UniJIS-UTF16-#', 'gr'},
      {'uphgothb-#', 'UniJIS-UTF16-#', 'gb'},
      {'uphgotheb-#','UniJIS-UTF16-#', 'ge'},
      {'uphmgothr-#','UniJIS-UTF16-#', 'mgr'},
      '% TEXT, JIS04',
      {'uphminln-#',  'UniJIS2004-UTF16-#', 'mln'},
      {'uphminrn-#',  'UniJIS2004-UTF16-#', 'mrn'},
      {'uphminbn-#',  'UniJIS2004-UTF16-#', 'mbn'},
      {'uphgothrn-#', 'UniJIS2004-UTF16-#', 'grn'},
      {'uphgothbn-#', 'UniJIS2004-UTF16-#', 'gbn'},
      {'uphgothebn-#','UniJIS2004-UTF16-#', 'gen'},
      {'uphmgothrn-#','UniJIS2004-UTF16-#', 'mgrn'},
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
   if fd=='kozuka' and s=='6'  then
      return 'ProVI' -- 小塚だけ特別
   elseif fd:match('hiragino') then
      if string.match(s, jis2004_flag) then
	 return (fa=='ge' or fa=='gen') and 'StdN' or suffix[s][1]
      else
	 return (fa=='ge' or fa=='gen') and 'Std'  or suffix[s][1]
      end
      -- ヒラギノ角ゴ W8 は StdN/Std しかない
   else
      return suffix[s][1]
   end
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
	    fn = gsub(fn, ' %%!PS', '/AJ16 %%!PS')
	 else
	    fn = fn .. '/AJ16'
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
      local dirname = fd .. suffix[s][2]
      print('kanjiEmbed: ' .. dirname)
      -- Linux しか想定していない
      os.execute('mkdir ' .. dirname .. ' &>/dev/null')
      for mnx, mcont in pairs(maps) do
	 --if not string.match(mnx, '-04') or string.match(s, jis2004_flag) then
	 -- フォントが OpenType (CID) の場合は、すべての map を作る
	 -- フォントが TrueType の場合は、基本的に -04 以外の map を作る
	 -- ただし TrueType でも separate なときは -04 も作る
	 if not string.match(mnx, '-04') or not foundry[fd].noncid or foundry[fd].separate then
	    local mapbase = gsub(mnx, '@', dirname)
	    local f = io.open(dirname .. '/' .. mapbase .. '.map', 'w+')
	    for _,x in ipairs(mcont) do
	       f:write(make_one_line(x, fd, s))
	    end
	    if string.match(mapbase,'otf%-hiragino') then
	       print('  hiraprop: ' .. mapbase)
	       local v2 = string.explode([[

% hiraprop
hiramin-w3-h Identity-H $mr
hiramin-w6-h Identity-H $mb
hirakaku-w3-h Identity-H $gr
hirakaku-w6-h Identity-H $gb
hiramaru-w4-h Identity-H $mgr
hiramin-w3-v Identity-V $mr
hiramin-w6-v Identity-V $mb
hirakaku-w3-v Identity-V $gr
hirakaku-w6-v Identity-V $gb
hiramaru-w4-v Identity-V $mgr

]])
	       for i,v in pairs(v2) do
		  v = (v:gsub ('$(%w+)', foundry[fd])):gsub('?', ret_suffix(fd,s,''))
		  v2[i] = replace_index(v, s)
	       end
	       f:write(table.concat(v2, '\n'))
	    end
	    f:close()
	 end
      end
   end
end
