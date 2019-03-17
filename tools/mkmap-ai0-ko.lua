#! /usr/bin/env texlua

-- Adobe-Identity0 なフォントのマップを作る．unicode 専用．
-- これは up(La)TeX + dvipdfmx (TeX Live 2017) が必須．
-- つまり，p(La)TeX は不可．dvips も不可．cid も不可．
local foundry = {
   ['sourcehan-otc']   = { -- Source Han Sans/Serif, "OTC"
      mr=':1:SourceHanSerif-Regular.ttc',
      gr=':1:SourceHanSans-Medium.ttc',
      {''},
   },
   ['sourcehan']   = { -- Source Han Sans/Serif, "Language-specific OTF"
      mr='SourceHanSerifK-Regular.otf',
      gr='SourceHanSansK-Medium.otf',
      {''},
   },
   ['noto-otc']   = { -- Noto Sans/Serif CJK, "OpenType/CFF Collection (OTC)"
      mr=':1:NotoSerifCJK-Regular.ttc',
      gr=':1:NotoSansCJK-Medium.ttc',
      {''},
   },
   ['noto']   = { -- Noto Sans/Serif CJK, "Language-specific OpenType/CFF (OTF)"
      mr='NotoSerifCJKkr-Regular.otf',
      gr='NotoSansCJKkr-Medium.otf',
      {''},
   },
}

-- Adobe-Identity0 なフォントは dvips で全く使えないので，
-- フォールバックとして noEmbed 相当の設定を追加する．
local foundry_fallback = {
   ['noEmbed']   = {
      fmr='!HYSMyeongJo-Medium',
      fgr='!HYGoThic-Medium',
      fmgr='!HYRGoThic-Medium',
      {'n'},
   },
}

-- '#' は 'h', 'v' に置換される
-- '@' は koEmbed の値に置換される
-- テーブルサイズが 5 のとき，4/5 番目は fallback の AK1 フォント用
-- テーブルサイズが 3 のとき，全て fallback の AK1 フォント用
local maps = {
   ['uptex-ko-@'] = {
      {'uphysmjm-#', '#', 'mr', 'fmr', 'UniKS-UTF16-#'},
      {'uphygt-#',   '#', 'gr', 'fgr', 'UniKS-UTF16-#'},
   },
   ['otf-ko-@'] = {
      '% CID',
      {'otf-ckmr-#', 'Identity-#',     'fmr'},
      {'otf-ckgr-#', 'Identity-#',     'fgr'},
   -- {'otf-ckmgr-#','Identity-#',     'fmgr'},
      '% Unicode',
      {'otf-ukmr-#', '#', 'mr', 'fmr', 'UniKS-UCS2-#'},
      {'otf-ukgr-#', '#', 'gr', 'fgr', 'UniKS-UCS2-#'},
   -- {'otf-ukmgr-#','#', 'mgr','fmgr','UniKS-UCS2-#'},
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
          .. ' %!FB ' .. bn .. '-' .. gsub(o[5], '#', 'H') .. '\n'
          .. gsub(o[1], '#', 'v') .. '\t' .. "unicode" .. '\t' .. fn .. ' ' .. gsub(o[2], '#', '-w 1')
          .. ' %!FB ' .. bn .. '-' .. gsub(o[5], '#', 'V') .. '\n'
      else
         return o[1] .. '\t' .. "unicode" .. '\t' .. fn .. ' ' .. o[2]
          .. ' %!FB ' .. bn .. '-' .. o[5] .. '\n'
      end
   end end
end

for fd, v1 in pairs(foundry) do
   for _,s in pairs(v1[1]) do
      local dirname = fd
      print('koEmbed: ' .. dirname)
      -- Linux しか想定していない
      os.execute('mkdir ' .. dirname .. ' &>/dev/null')
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
