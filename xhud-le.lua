XHUD = {}

local rader = 0
local raderbase = 500

local player_table = false

function XHUD.Draw(disable_rader)
	XGUI.SetDrawColorRGB(0,255,0)
	
	XHUD.DrawDigits(_WIDTH()-128,_HEIGHT()/2-16,32,_Y(0))
	
	XHUD.DrawDigits(128-(32/2+32/8)*4,_HEIGHT()/2-32,32,_VEL()*3.6)
	
	if _slim then XHUD.DrawDigits(128-(32/2+32/8)*4,_HEIGHT()/2+4,32,_slim) end
	
	out(5,_CHAT())
	
	out(6,string.format("%d Players",_PLAYERS()))
	
	rader = math.mod(rader+_KEYDOWN(11)*2000,10000)
	
	rader = rader + raderbase
	
	local r_r = 128
	local r_x = 16
	local r_s = r_r-8
	local r_y = _HEIGHT()-(16+256)
	
	XGUI.Move2D(r_x,r_y)
	XGUI.Line2D(r_r*2+r_x,r_y)
	XGUI.Line2D(r_r*2+r_x,r_r*2+r_y)
	XGUI.Line2D(r_x,r_r*2+r_y)
	XGUI.Line2D(r_x,r_y)
	
	XGUI.Move2D(_WIDTH()/2-16,_HEIGHT()/2)
	XGUI.Line2D(_WIDTH()/2+16,_HEIGHT()/2)
		
	XGUI.Move2D(_WIDTH()/2,_HEIGHT()/2)
	XGUI.Line2D(_WIDTH()/2,_HEIGHT()/2+16)
	
	if not player_table then player_table = {} end
	
	if not disable_rader then
		XGUI.Move2D(r_r+r_x,r_r+r_y)
		XGUI.Line2D(math.sin(math.rad(180+60/2))*r_s+r_r+r_x,r_y)
		XGUI.Move2D(r_r+r_x,r_r+r_y)
		XGUI.Line2D(math.sin(math.rad(180-60/2))*r_s+r_r+r_x,r_y)
	else
		XGUI.Move2D(r_x,r_y)
		XGUI.Line2D(r_r*2+r_x,r_r*2+r_y)
		
		XGUI.Move2D(r_r*2+r_x,r_y)
		XGUI.Line2D(r_x,r_r*2+r_y)
	end
	
	if not disable_rader then
		XHUD.DrawDigits(r_x+r_r*2+16,r_y+r_r*2-16,16,rader)
	end
	
	if not disable_rader then
		for i=1,_PLAYERS()-1 do
			local x,y,z = _NPOS(i)
			
			--Weapon.TargetBox(x,y,z,1)
			
			local x1,y1 = x-_X(0),z-_Z(0)
			
			if not player_table[_PLAYERID(i)] then
				player_table[_PLAYERID(i)] = {}
				player_table[_PLAYERID(i)].x = x
				player_table[_PLAYERID(i)].y = z
				player_table[_PLAYERID(i)].vx = 0
				player_table[_PLAYERID(i)].vy = 1
			end
			
			local vx = x - player_table[_PLAYERID(i)].x
			local vy = z - player_table[_PLAYERID(i)].y
			
			player_table[_PLAYERID(i)].x = x
			player_table[_PLAYERID(i)].y = z
			
			local vl = math.sqrt(vx ^ 2 + vy ^ 2)
			
			if vl == 0 then
				vx = player_table[_PLAYERID(i)].vx
				vy = player_table[_PLAYERID(i)].vy
			else
				vx = vx / vl
				vy = vy / vl
				
				player_table[_PLAYERID(i)].vx = vx
				player_table[_PLAYERID(i)].vy = vy
			end
			
			local x2 = x1 * math.cos(_EY(0)) - y1 * math.sin(_EY(0))
			local y2 = x1 * math.sin(_EY(0)) + y1 * math.cos(_EY(0))
			
			x2 = x2 / rader * -r_r + r_x + r_r
			y2 = y2 / rader *  r_r + r_y + r_r
			
			if Weapon then
				local tbl = Weapon.PositionTable()
				table.foreach(tbl, function(i,v)
					local xd,yd = v.x-_X(0),v.z-_Z(0)
					
					local xm = xd * math.cos(_EY(0)) - yd * math.sin(_EY(0))
					local ym = xd * math.sin(_EY(0)) + yd * math.cos(_EY(0))
					
					xm = xm / rader * -r_r + r_x + r_r
					ym = ym / rader *  r_r + r_y + r_r
					
					if xd < rader and xd >= -rader and yd < rader and yd >= -rader then
						XGUI.SetStringSize(6)
						
						XGUI.SetDrawColorRGB(255,255,255)
						
						XGUI.SetStringPosition(xm,ym)
						XGUI.DrawVectorStringCenter("¢")
					end
				end)
			end
			
			XGUI.SetStringSize(12)
			
			if x1 < rader and x1 >= -rader and y1 < rader and y1 >= -rader and _PLAYERID(i) ~= _PLAYERMYID() then
				if _PLAYERARMS(i) ~= 0 then XGUI.SetDrawColorRGB(255,0,0)
				else XGUI.SetDrawColorRGB(255,255,255) end
				local szL = ""
				local enL = false
				
				local k = 0
				
				if Weapon then
					for j=1, Weapon.Max do
						if Weapon.Target[j] == i then
							if k ~= 0 then szL = szL .. "," end
							szL = szL .. j
							enL = true
							k = k + 1
						end
					end
					
					if enL then
						XGUI.SetDrawColorRGB(255,255,0)
						XGUI.SetStringPosition(x2+8,y2+8)
						XGUI.DrawVectorString(string.format("LOCK %s",szL))
					end
				end
				
				local ptri = {{0,6},{-4,-6},{4,-6}}
				
				local pi = 0
				
				local yvm = math.min(1.5,math.max(0.5,(y - _Y(0))/12+1))
				
				for pi=1,3 do
					local pi1 = pi
					local pi2 = pi+1
					if pi2 > 3 then pi2 = 1 end
					
					local pix1,piy1 = ptri[pi1][2]*yvm,ptri[pi1][1]*yvm
					local pix2,piy2 = ptri[pi2][2]*yvm,ptri[pi2][1]*yvm
					
					local vx1 = vx * math.cos(_EY(0)) - vy * math.sin(_EY(0))
					local vy1 = vx * math.sin(_EY(0)) + vy * math.cos(_EY(0))
					
					local pvth = -math.atan2(-vy1,-vx1)
					
					local pfx1 = pix1 * math.cos(pvth) - piy1 * math.sin(pvth)
					local pfy1 = pix1 * math.sin(pvth) + piy1 * math.cos(pvth)
					
					local pfx2 = pix2 * math.cos(pvth) - piy2 * math.sin(pvth)
					local pfy2 = pix2 * math.sin(pvth) + piy2 * math.cos(pvth)
					
					XGUI.Move2D(pfx1+x2,pfy1+y2)
					XGUI.Line2D(pfx2+x2,pfy2+y2)
				end
			end
		end
	end
	
	rader = rader - raderbase
end

function XHUD.DrawDigits(x,y,s,n)
	x = x + (s/2 + s/8)*4
	while math.floor(n) > 0 do
		local d = math.floor(math.mod(n,10))
		XHUD.DrawDigit[d](x,y,s)
		x = x - s/2 - s/8
		n = n / 10
	end
end

XHUD.DrawDigit={
[0]=function(x,y,s)
	--¶‚Ìcü
	XGUI.Move2D(x,y)
	XGUI.Line2D(x,y+s)

	--‰E‚Ìcü
	XGUI.Move2D(x+s/2,y)
	XGUI.Line2D(x+s/2,y+s)

	--ã‚Ì‰¡ü
	XGUI.Move2D(x,y)
	XGUI.Line2D(x+s/2,y)

	--‰º‚Ì‰¡ü
	XGUI.Move2D(x,y+s)
	XGUI.Line2D(x+s/2,y+s)
end,
[1]=function(x,y,s)
	--‰E‚Ìcü
	XGUI.Move2D(x+s/2,y)
	XGUI.Line2D(x+s/2,y+s)
end,
[2]=function(x,y,s)
	--¶‚Ìcü
	XGUI.Move2D(x,y+s/2)
	XGUI.Line2D(x,y+s)

	--‰E‚Ìcü
	XGUI.Move2D(x+s/2,y)
	XGUI.Line2D(x+s/2,y+s/2)

	--ã‚Ì‰¡ü
	XGUI.Move2D(x,y)
	XGUI.Line2D(x+s/2,y)

	--^‚ñ’†‚Ì‰¡ü
	XGUI.Move2D(x,y+s/2)
	XGUI.Line2D(x+s/2,y+s/2)

	--‰º‚Ì‰¡ü
	XGUI.Move2D(x,y+s)
	XGUI.Line2D(x+s/2,y+s)
end,
[3]=function(x,y,s)
	--‰E‚Ìcü
	XGUI.Move2D(x+s/2,y)
	XGUI.Line2D(x+s/2,y+s)

	--ã‚Ì‰¡ü
	XGUI.Move2D(x,y)
	XGUI.Line2D(x+s/2,y)

	--^‚ñ’†‚Ì‰¡ü
	XGUI.Move2D(x,y+s/2)
	XGUI.Line2D(x+s/2,y+s/2)

	--‰º‚Ì‰¡ü
	XGUI.Move2D(x,y+s)
	XGUI.Line2D(x+s/2,y+s)
end,
[4]=function(x,y,s)
	--¶‚Ìcü
	XGUI.Move2D(x,y)
	XGUI.Line2D(x,y+s/2)

	--‰E‚Ìcü
	XGUI.Move2D(x+s/2,y)
	XGUI.Line2D(x+s/2,y+s)

	--^‚ñ’†‚Ì‰¡ü
	XGUI.Move2D(x,y+s/2)
	XGUI.Line2D(x+s/2,y+s/2)
end,
[5]=function(x,y,s)
	--¶‚Ìcü
	XGUI.Move2D(x,y)
	XGUI.Line2D(x,y+s/2)

	--‰E‚Ìcü
	XGUI.Move2D(x+s/2,y+s/2)
	XGUI.Line2D(x+s/2,y+s)

	--ã‚Ì‰¡ü
	XGUI.Move2D(x,y)
	XGUI.Line2D(x+s/2,y)

	--^‚ñ’†‚Ì‰¡ü
	XGUI.Move2D(x,y+s/2)
	XGUI.Line2D(x+s/2,y+s/2)

	--‰º‚Ì‰¡ü
	XGUI.Move2D(x,y+s)
	XGUI.Line2D(x+s/2,y+s)
end,
[6]=function(x,y,s)
	--¶‚Ìcü
	XGUI.Move2D(x,y)
	XGUI.Line2D(x,y+s)

	--‰E‚Ìcü
	XGUI.Move2D(x+s/2,y+s/2)
	XGUI.Line2D(x+s/2,y+s)

	--ã‚Ì‰¡ü
	XGUI.Move2D(x,y)
	XGUI.Line2D(x+s/2,y)

	--^‚ñ’†‚Ì‰¡ü
	XGUI.Move2D(x,y+s/2)
	XGUI.Line2D(x+s/2,y+s/2)

	--‰º‚Ì‰¡ü
	XGUI.Move2D(x,y+s)
	XGUI.Line2D(x+s/2,y+s)
end,
[7]=function(x,y,s)
	--‰E‚Ìcü
	XGUI.Move2D(x+s/2,y)
	XGUI.Line2D(x+s/2,y+s)

	--ã‚Ì‰¡ü
	XGUI.Move2D(x,y)
	XGUI.Line2D(x+s/2,y)
end,
[8]=function(x,y,s)
	--¶‚Ìcü
	XGUI.Move2D(x,y)
	XGUI.Line2D(x,y+s)

	--‰E‚Ìcü
	XGUI.Move2D(x+s/2,y)
	XGUI.Line2D(x+s/2,y+s)

	--ã‚Ì‰¡ü
	XGUI.Move2D(x,y)
	XGUI.Line2D(x+s/2,y)

	--^‚ñ’†‚Ì‰¡ü
	XGUI.Move2D(x,y+s/2)
	XGUI.Line2D(x+s/2,y+s/2)

	--‰º‚Ì‰¡ü
	XGUI.Move2D(x,y+s)
	XGUI.Line2D(x+s/2,y+s)
end,
[9]=function(x,y,s)
	--¶‚Ìcü
	XGUI.Move2D(x,y)
	XGUI.Line2D(x,y+s/2)

	--‰E‚Ìcü
	XGUI.Move2D(x+s/2,y)
	XGUI.Line2D(x+s/2,y+s)

	--ã‚Ì‰¡ü
	XGUI.Move2D(x,y)
	XGUI.Line2D(x+s/2,y)

	--^‚ñ’†‚Ì‰¡ü
	XGUI.Move2D(x,y+s/2)
	XGUI.Line2D(x+s/2,y+s/2)

	--‰º‚Ì‰¡ü
	XGUI.Move2D(x,y+s)
	XGUI.Line2D(x+s/2,y+s)
end,
}
