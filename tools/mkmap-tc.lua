#! /usr/bin/env texlua

-- '?' は 'Pro' 等に置換される（今のところ tc では不使用）
local foundry = {
   ['noEmbed']   = {
      mr='!MSung-Light',
      gr='!MHei-Medium',
      {'n'},
   },
   ['adobe']   = {
      noncid = false,
      mr='AdobeMingStd-Light.otf',
      gr='AdobeFanHeitiStd-Bold.otf',
      {''},
   },
   ['arphic']   = {  -- gr がサンセリフになっていない
      noncid = true,
      mr='bsmi00lp.ttf %!PS ShanHeiSun-Light',
      gr='bkai00mp.ttf %!PS ZenKai-Medium',
      {''},
   },
   ['ms']   = {
      noncid = true,
      mr=':0:mingliu.ttc',  -- MingLiU
      gr='MSMHei.ttf',      -- MicrosoftMHei ほかに見当たらなかったので
      {''},
   },
   ['dynacomware']   = {
      noncid = true,
      mr='LiSongPro.ttf',
      gr='LiHeiPro.ttf',
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
      {'upmhm-#', 'UniCNS-UTF16-#', 'gr'},
   },
   ['otf-tc-@'] = {
      '% CID',
      {'otf-ctmr-#', 'Identity-#',     'mr'},
      {'otf-ctgr-#', 'Identity-#',     'gr'},
      '% Unicode',
      {'otf-utmr-#', 'UniCNS-UCS2-#', 'mr'},
      {'otf-utgr-#', 'UniCNS-UCS2-#', 'gr'},
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

for fd, v1 in pairs(foundry) do
   for _,s in pairs(v1[1]) do
      local dirname = fd .. suffix[s][2]
      print('tcEmbed: ' .. dirname)
      -- Linux しか想定していない
      os.execute('mkdir ' .. dirname .. ' &>/dev/null')
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
