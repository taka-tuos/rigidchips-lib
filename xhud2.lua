-- XHUD2 version 1.0.0.0

XHUD = {}

_rader = 0
_ovalstep = 10

_jit_func = {}

function XHUD.Draw(disable_rader)
	--<HUD>----------------------------------------------------------------
	
	_raderbase = 500
	_rader = math.mod(_rader+_KEYDOWN(11)*2000,10000)
	
	if not _opln then _opln = _PLAYERS() end
	if not _opll then
		local j
		_opll = {}
		_oplll = _PLAYERS()
		for j=0,_PLAYERS()-1 do
			_opll[j+1] = {}
			_opll[j+1].id = _PLAYERID(j)
			_opll[j+1].sz = _PLAYERNAME(j)
		end
	end
	
	if _opln ~= _PLAYERS() then
		local j
		if _oplll > _PLAYERS() then
			if _PLAYERS() == 0 then
				SetHUDMassage(string.format("LOG OUT",p))
			else
				for j=1,_oplll do
					local p = _opll[j].id
					local k
					local e = false
					for k=0,_PLAYERS()-1 do
						if _PLAYERID(k) == p then e = true end
					end
					if not e then
						SetHUDMassage(string.format("%s LOGOUT",_opll[j].sz))
					end
				end
			end
		else -- _oplll < _PLAYERS()
			if _oplll == 0 then
				SetHUDMassage(string.format("LOG IN",p))
			else
				for j=0,_PLAYERS()-1 do
					local p = _PLAYERID(j)
					local k
					local e = false
					for k=1,_oplll do
						if _opll[k].id == p then e = true end
					end
					if not e then
						SetHUDMassage(string.format("%s LOGIN", _PLAYERNAME(j)))
					end
				end
			end
		end
		_oplll = _PLAYERS()
		for j=0,_PLAYERS()-1 do
			_opll[j+1] = {}
			_opll[j+1].id = _PLAYERID(j)
			_opll[j+1].sz = _PLAYERNAME(j)
		end
	end
	
	_opln = _PLAYERS()
	
	local r_s2 = 96
	local r_s3 = 24
	
	local r_v = 48
	
	local cx1,cy1 = -256-128,0
	local cx2,cy2 =	 256+128,0
	
	local r_s5 = math.tan(math.rad(_GETVIEWZOOM()))*_HEIGHT()
	
	local r_r = 128
	local r_s = r_r-8
	local r_t = r_r+8
	
	local r_w = 16
	
	local jitid = _WIDTH()*1000+_HEIGHT()
	
	if _jit_func[jitid] then
		_jit_func[jitid]()
	else
		local jit = ""
		local scrgb = XGUI.SetDrawColorRGB
		local m2d = XGUI.Move2D
		local l2d = XGUI.Line2D
		
		XGUI.Move2D = function(x,y) jit = jit .. string.format("XGUI.Move2D(%f,%f)\n",x,y) end
		XGUI.Line2D = function(x,y) jit = jit .. string.format("XGUI.Line2D(%f,%f)\n",x,y) end
		XGUI.SetDrawColorRGB = function(r,g,b) jit = jit .. string.format("XGUI.SetDrawColorINT(%d)\n",math.floor(r)*65536+math.floor(g)*256+math.floor(b)) end
		
		XGUI.SetDrawColorRGB(0,255,0)
		
		--[[XGUI.Move2D(16,r_r+16)
		XGUI.Line2D(16,16)
		XGUI.Line2D(r_r+16,16)]]--
		
		XGUI.Move2D(16,16)
		XGUI.Line2D(r_r*2+16,16)
		XGUI.Line2D(r_r*2+16,r_r*2+16)
		XGUI.Line2D(16,r_r*2+16)
		XGUI.Line2D(16,16)
		
		local i
		--[[for i=180,-90,-_ovalstep do
			XGUI.Line2D(math.sin(math.rad(i))*r_r+r_r+16,math.cos(math.rad(i))*r_r+r_r+16)
		end]]--
		
		--[[i = 0
		XGUI.Move2D(math.sin(math.rad(i))*r_s+r_r+16,math.cos(math.rad(i))*r_s+r_r+16)
		
		for i=0,360,_ovalstep do
			XGUI.Line2D(math.sin(math.rad(i))*r_s+r_r+16,math.cos(math.rad(i))*r_s+r_r+16)
		end]]--
		
		if not disable_rader then
			XGUI.Move2D(r_r+16,r_r+16)
			XGUI.Line2D(math.sin(math.rad(180+60/2))*r_s+r_r+16,16)
			XGUI.Move2D(r_r+16,r_r+16)
			XGUI.Line2D(math.sin(math.rad(180-60/2))*r_s+r_r+16,16)
		else
			XGUI.Move2D(16,16)
			XGUI.Line2D(r_r*2+16,r_r*2+16)
			
			XGUI.Move2D(r_r*2+16,16)
			XGUI.Line2D(16,r_r*2+16)
		end
		
		
		--[[XGUI.Move2D(0,r_r+16)
		
		for i=-90,135,_ovalstep do
			XGUI.Line2D(math.sin(math.rad(i))*r_t+r_r+16,math.cos(math.rad(i))*r_t+r_r+16)
		end
		
		XGUI.Line2D(math.sin(math.rad(135))*r_t+r_r+16+64,math.cos(math.rad(135))*r_t+r_r+16-40)
		XGUI.Line2D(_WIDTH(),math.cos(math.rad(135))*r_t+r_r+16-40)]]--
		
		
		local r_u = 16
		
		local r_s1 = 512
		
		--XGUI.Move2D(0,_HEIGHT()-16)
		
		--XGUI.Line2D(_WIDTH()-r_s1-r_u*2,_HEIGHT()-16)
		
		--[[for i=0,90,_ovalstep do
			XGUI.Line2D(math.sin(math.rad(i))*r_u+_WIDTH()-r_s1,math.cos(math.rad(i))*r_u+_HEIGHT()-16-r_u)
		end
		
		for i=-90,-180,-_ovalstep do
			XGUI.Line2D(math.sin(math.rad(i))*r_u+_WIDTH()-r_s1+r_u*2,math.cos(math.rad(i))*r_u+_HEIGHT()-16-r_u-72)
		end
		
		XGUI.Line2D(_WIDTH(),_HEIGHT()-16-r_u*2-72)]]--
		
		--[[XGUI.Move2D(math.sin(math.rad(0))*r_v+r_v+16,math.cos(math.rad(0))*r_v+_HEIGHT()/2)
		
		for i=0,360,_ovalstep do
			XGUI.Line2D(math.sin(math.rad(i))*r_v+r_v+16,math.cos(math.rad(i))*r_v+_HEIGHT()/2)
		end
		
		XGUI.Move2D(math.sin(math.rad(0))*r_w+r_v+16,math.cos(math.rad(0))*r_w+_HEIGHT()/2)
		
		for i=0,360,_ovalstep do
			XGUI.Line2D(math.sin(math.rad(i))*r_w+r_v+16,math.cos(math.rad(i))*r_w+_HEIGHT()/2)
		end

		XGUI.Move2D(math.sin(math.rad(0))*r_v+r_v+16,math.cos(math.rad(0))*r_v+_HEIGHT()/2)
		XGUI.Line2D(128+r_v+16,math.cos(math.rad(0))*r_v+_HEIGHT()/2)
		
		XGUI.Move2D(math.sin(math.rad(90))*r_v+r_v+16,math.cos(math.rad(90))*r_v+_HEIGHT()/2)
		XGUI.Line2D(128+r_v+16,math.cos(math.rad(90))*r_v+_HEIGHT()/2)
		
		XGUI.Move2D(128+r_v+16,math.cos(math.rad(0))*r_v+_HEIGHT()/2)
		XGUI.Line2D(128+r_v+16,math.cos(math.rad(90))*r_v+_HEIGHT()/2)
		
		XGUI.Move2D(_WIDTH()-r_s2-16-r_s3*2,_HEIGHT()/2-r_s3)
		XGUI.Line2D(_WIDTH()-16-r_s3*2,_HEIGHT()/2-r_s3)
		XGUI.Line2D(_WIDTH()-16-r_s3*2,_HEIGHT()/2+r_s3)
		XGUI.Line2D(_WIDTH()-r_s2-16-r_s3*2,_HEIGHT()/2+r_s3)
		XGUI.Line2D(_WIDTH()-r_s2-16-r_s3*2,_HEIGHT()/2-r_s3)
		
		XGUI.Move2D(_WIDTH()-16-r_s3*2,_HEIGHT()/2-r_s3)
		XGUI.Line2D(_WIDTH()-16,_HEIGHT()/2-r_s3)
		XGUI.Line2D(_WIDTH()-16,_HEIGHT()/2-r_s3+r_s2)
		XGUI.Line2D(_WIDTH()-16-r_s3*2,_HEIGHT()/2-r_s3+r_s2)
		XGUI.Line2D(_WIDTH()-16-r_s3*2,_HEIGHT()/2-r_s3)]]--
		
		XGUI.Move2D(_WIDTH()/2-16,_HEIGHT()/2)
		XGUI.Line2D(_WIDTH()/2+16,_HEIGHT()/2)
		
		XGUI.Move2D(_WIDTH()/2,_HEIGHT()/2)
		XGUI.Line2D(_WIDTH()/2,_HEIGHT()/2+16)
		
		XGUI.SetDrawColorRGB(255,128,0)
		
		local r_s4 = 256
		
		--[[XGUI.Move2D(r_u+_WIDTH()/2-r_s4-r_u	  ,_HEIGHT()/2-r_s4-r_u)
		XGUI.Line2D(r_u+_WIDTH()/2-r_s4-r_u+16,_HEIGHT()/2-r_s4-r_u)
		
		XGUI.Move2D(r_u+_WIDTH()/2-r_s4-r_u*2 ,_HEIGHT()/2-r_s4)
		XGUI.Line2D(r_u+_WIDTH()/2-r_s4-r_u*2 ,_HEIGHT()/2-r_s4+16)
		
		
		
		XGUI.Move2D(r_u+_WIDTH()/2+r_s4+r_u	  ,_HEIGHT()/2+r_s4+r_u)
		XGUI.Line2D(r_u+_WIDTH()/2+r_s4+r_u-16,_HEIGHT()/2+r_s4+r_u)
		
		XGUI.Move2D(r_u+_WIDTH()/2+r_s4+r_u*2 ,_HEIGHT()/2+r_s4)
		XGUI.Line2D(r_u+_WIDTH()/2+r_s4+r_u*2 ,_HEIGHT()/2+r_s4-16)
		
		
		
		XGUI.Move2D(r_u+_WIDTH()/2+r_s4+r_u	  ,_HEIGHT()/2-r_s4-r_u)
		XGUI.Line2D(r_u+_WIDTH()/2+r_s4+r_u-16,_HEIGHT()/2-r_s4-r_u)
		
		XGUI.Move2D(r_u+_WIDTH()/2+r_s4+r_u*2 ,_HEIGHT()/2-r_s4)
		XGUI.Line2D(r_u+_WIDTH()/2+r_s4+r_u*2 ,_HEIGHT()/2-r_s4+16)
		
		
		
		XGUI.Move2D(r_u+_WIDTH()/2-r_s4-r_u	  ,_HEIGHT()/2+r_s4+r_u)
		XGUI.Line2D(r_u+_WIDTH()/2-r_s4-r_u+16,_HEIGHT()/2+r_s4+r_u)
		
		XGUI.Move2D(r_u+_WIDTH()/2-r_s4-r_u*2 ,_HEIGHT()/2+r_s4)
		XGUI.Line2D(r_u+_WIDTH()/2-r_s4-r_u*2 ,_HEIGHT()/2+r_s4-16)]]--
		
		
		
		--[[for i=-90,-180,-_ovalstep do
			XGUI.Move2D(math.sin(math.rad(i-5))*r_u+_WIDTH()/2-r_s4,math.cos(math.rad(i-5))*r_u+_HEIGHT()/2-r_s4)
			XGUI.Line2D(math.sin(math.rad(	i))*r_u+_WIDTH()/2-r_s4,math.cos(math.rad(	i))*r_u+_HEIGHT()/2-r_s4)
		end
		
		for i=-90,0,_ovalstep do
			XGUI.Move2D(math.sin(math.rad(i-5))*r_u+_WIDTH()/2-r_s4,math.cos(math.rad(i-5))*r_u+_HEIGHT()/2+r_s4)
			XGUI.Line2D(math.sin(math.rad(	i))*r_u+_WIDTH()/2-r_s4,math.cos(math.rad(	i))*r_u+_HEIGHT()/2+r_s4)
		end
		
		for i=90,180,_ovalstep do
			XGUI.Move2D(math.sin(math.rad(i-5))*r_u+_WIDTH()/2+r_s4+r_u*2,math.cos(math.rad(i-5))*r_u+_HEIGHT()/2-r_s4)
			XGUI.Line2D(math.sin(math.rad(	i))*r_u+_WIDTH()/2+r_s4+r_u*2,math.cos(math.rad(  i))*r_u+_HEIGHT()/2-r_s4)
		end
		
		for i=90,0,-_ovalstep do
			XGUI.Move2D(math.sin(math.rad(i-5))*r_u+_WIDTH()/2+r_s4+r_u*2,math.cos(math.rad(i-5))*r_u+_HEIGHT()/2+r_s4)
			XGUI.Line2D(math.sin(math.rad(	i))*r_u+_WIDTH()/2+r_s4+r_u*2,math.cos(math.rad(  i))*r_u+_HEIGHT()/2+r_s4)
		end]]--
		
		if string.len(jit) > 0 then
			local f = loadstring(jit)
			
			f()
			
			_jit_func[jitid] = f
		end
		
		XGUI.SetDrawColorRGB = scrgb
		XGUI.Move2D = m2d
		XGUI.Line2D = l2d
	end
	
	XGUI.SetStringSize(16)
	
	XGUI.SetDrawColorRGB(0,255,0)
	
	_vel = _VEL(0)
	--if _maxvel < _vel then _maxvel = _vel end
	
	_velrot = _velrot + (math.rad(90)*(_vel-_ovel)*30)
	
	_ovel = _vel
	
	
	local v11,v12 = math.sin(math.rad(_velrot-20))*r_w+r_v+16,math.cos(math.rad(_velrot-20))*r_w+_HEIGHT()/2
	local v13,v14 = math.sin(math.rad(_velrot+20))*r_w+r_v+16,math.cos(math.rad(_velrot+20))*r_w+_HEIGHT()/2
	
	local v21,v22 = math.sin(math.rad(_velrot-20))*r_v+r_v+16,math.cos(math.rad(_velrot-20))*r_v+_HEIGHT()/2
	local v23,v24 = math.sin(math.rad(_velrot+20))*r_v+r_v+16,math.cos(math.rad(_velrot+20))*r_v+_HEIGHT()/2
	
	XGUI.Move2D(v11,v12)
	XGUI.Line2D(v21,v22)
	
	XGUI.Move2D(v13,v14)
	XGUI.Line2D(v23,v24)
	
	XGUI.Move2D(v11,v12)
	XGUI.Line2D(v13,v14)
	
	XGUI.Move2D(v21,v22)
	XGUI.Line2D(v23,v24)
	
	local w11,w12 = math.sin(math.rad(_velrot-200))*r_w+r_v+16,math.cos(math.rad(_velrot-200))*r_w+_HEIGHT()/2
	local w13,w14 = math.sin(math.rad(_velrot-160))*r_w+r_v+16,math.cos(math.rad(_velrot-160))*r_w+_HEIGHT()/2
	
	local w21,w22 = math.sin(math.rad(_velrot-200))*r_v+r_v+16,math.cos(math.rad(_velrot-200))*r_v+_HEIGHT()/2
	local w23,w24 = math.sin(math.rad(_velrot-160))*r_v+r_v+16,math.cos(math.rad(_velrot-160))*r_v+_HEIGHT()/2
	
	XGUI.Move2D(w11,w12)
	XGUI.Line2D(w21,w22)
	
	XGUI.Move2D(w13,w14)
	XGUI.Line2D(w23,w24)
	
	XGUI.Move2D(w11,w12)
	XGUI.Line2D(w13,w14)
	
	XGUI.Move2D(w21,w22)
	XGUI.Line2D(w23,w24)
	
	--[[for i=-200,-160,40 do
		XGUI.Move2D(math.sin(math.rad(_velrot+i))*r_w+r_v+16,math.cos(math.rad(_velrot+i))*r_w+_HEIGHT()/2)
		XGUI.Line2D(math.sin(math.rad(_velrot+i))*r_v+r_v+16,math.cos(math.rad(_velrot+i))*r_v+_HEIGHT()/2)
	end]]--
	
	local ax1,ay1 = Rotate2D(-384-256,0,-_EZ())
	local ax2,ay2 = Rotate2D(-384	   ,0,-_EZ())
		
	local bx1,by1 = Rotate2D( 384+256,0,-_EZ())
	local bx2,by2 = Rotate2D( 384	   ,0,-_EZ())
		
	XGUI.Move2D(ax1+_WIDTH()/2,ay1+_HEIGHT()/2)
	XGUI.Line2D(ax2+_WIDTH()/2,ay2+_HEIGHT()/2)
		
	XGUI.Move2D(bx1+_WIDTH()/2,by1+_HEIGHT()/2)
	XGUI.Line2D(bx2+_WIDTH()/2,by2+_HEIGHT()/2)
	
	--[[for i=-10,10 do
		local j = i/11
		local k = 0.5
		
		if math.mod((_Y()-math.mod(_Y(),1))-i,5) == 0 then k=1 end
		
		XGUI.Move2D(_WIDTH()-16-r_s3*k,_HEIGHT()/2+r_s3+r_s2/2*j+math.mod(_Y(),1)*4)
		XGUI.Line2D(_WIDTH()-16,_HEIGHT()/2+r_s3+r_s2/2*j+math.mod(_Y(),1)*4)
	end]]--
	
	XGUI.SetStringPosition(cx1+_WIDTH()/2,cy1+_HEIGHT()/2)
	XGUI.DrawVectorString(string.format("%d",math.abs(math.deg(_EX()))))
	
	XGUI.SetStringPosition(cx2+_WIDTH()/2,cy2+_HEIGHT()/2)
	XGUI.DrawVectorString(string.format("%d",math.abs(math.deg(_EX()))))
	
	XGUI.SetStringPosition(_WIDTH()-r_s2-16-r_s3*2+16,_HEIGHT()/2-r_s3+8)
	
	XGUI.SetStringSize(32)
	
	XGUI.DrawVectorString(string.format("% 4d",_Y(0)))
	
	XGUI.SetStringPosition(_WIDTH()-r_s2-16-r_s3*2+16,_HEIGHT()/2-r_s3+8+32+8)
	
	local _gy = _RANGE(0,-_YX(),-_YY(),-_YZ())
	if _gy == -100000 then _gy = _Y(0) end
	
	XGUI.DrawVectorString(string.format("% 4d",_gy))
	
	XGUI.SetStringPosition(math.sin(math.rad(90))*r_v+r_v+16,math.cos(math.rad(90))*r_v+_HEIGHT()/2+8)
	
	for i=-360,360,20 do
		local k = 0.5
		
		if math.mod(i,40) == 0 then k = 1 end
		
		local ax1,ay1 = Rotate2D(-384-128*k,-r_s5*(_ZY()+(i/180)),-_EZ())
		local ax2,ay2 = Rotate2D(-384	   ,-r_s5*(_ZY()+(i/180)),-_EZ())
		
		local bx1,by1 = Rotate2D( 384+128*k,-r_s5*(_ZY()+(i/180)),-_EZ())
		local bx2,by2 = Rotate2D( 384	   ,-r_s5*(_ZY()+(i/180)),-_EZ())
		
		XGUI.Move2D(ax1+_WIDTH()/2,ay1+_HEIGHT()/2)
		XGUI.Line2D(ax2+_WIDTH()/2,ay2+_HEIGHT()/2)
		
		XGUI.Move2D(bx1+_WIDTH()/2,by1+_HEIGHT()/2)
		XGUI.Line2D(bx2+_WIDTH()/2,by2+_HEIGHT()/2)
	end
	
	XGUI.DrawVectorString(string.format("% 4d",_vel*3.6))
	
	XGUI.SetStringPosition(math.sin(math.rad(90))*r_v+r_v+16,math.cos(math.rad(90))*r_v+_HEIGHT()/2+8+32+8)
	
	if _slim then XGUI.DrawVectorString(string.format("% 4d",_slim)) end
	
	_rader = _rader + _raderbase
	
	if not _prdp then _prdp = {} end
	
	if not disable_rader then
		for i=1,_PLAYERS()-1 do
			local x,y,z = _NPOS(i)
			local _wsize_hlf = r_r+16
			
			--Weapon.TargetBox(x,y,z,1)
			
			local x1,y1 = x-_X(0),z-_Z(0)
			
			if not _prdp[_PLAYERID(i)] then
				_prdp[_PLAYERID(i)] = {}
				_prdp[_PLAYERID(i)].x = x
				_prdp[_PLAYERID(i)].y = z
				_prdp[_PLAYERID(i)].vx = 0
				_prdp[_PLAYERID(i)].vy = 1
			end
			
			local vx = x - _prdp[_PLAYERID(i)].x
			local vy = z - _prdp[_PLAYERID(i)].y
			
			_prdp[_PLAYERID(i)].x = x
			_prdp[_PLAYERID(i)].y = z
			
			local vl = math.sqrt(vx ^ 2 + vy ^ 2)
			
			if vl == 0 then
				vx = _prdp[_PLAYERID(i)].vx
				vy = _prdp[_PLAYERID(i)].vy
			else
				vx = vx / vl
				vy = vy / vl
				
				_prdp[_PLAYERID(i)].vx = vx
				_prdp[_PLAYERID(i)].vy = vy
			end
			
			local x2 = x1 * math.cos(_EY(0)) - y1 * math.sin(_EY(0))
			local y2 = x1 * math.sin(_EY(0)) + y1 * math.cos(_EY(0))
			
			x2 = x2 / _rader * -r_r + _wsize_hlf
			y2 = y2 / _rader *	r_r + _wsize_hlf
			
			if Weapon then
				local tbl = Weapon.PositionTable()
				table.foreach(tbl, function(i,v)
					local xd,yd = v.x-_X(0),v.z-_Z(0)
					
					local xm = xd * math.cos(_EY(0)) - yd * math.sin(_EY(0))
					local ym = xd * math.sin(_EY(0)) + yd * math.cos(_EY(0))
					
					xm = xm / _rader * -r_r + _wsize_hlf
					ym = ym / _rader *	r_r + _wsize_hlf
					
					if xd < _rader and xd >= -_rader and yd < _rader and yd >= -_rader then
						XGUI.SetStringSize(6)
						
						XGUI.SetDrawColorRGB(255,255,255)
						
						XGUI.SetStringPosition(xm,ym)
						XGUI.DrawVectorStringCenter("Å¢")
					end
				end)
			end
			
			--[[local j
			
			
			for j=1,_mn do
				if _men[i] then
					local core = _G["MC"..j]
					
					local xd,yd = _X(core)-_X(0),_Z(core)-_Z(0)
					
					local xm = xd * math.cos(_EY(0)) - yd * math.sin(_EY(0))
					local ym = xd * math.sin(_EY(0)) + yd * math.cos(_EY(0))
					
					xm = xm / _rader * -r_r + _wsize_hlf
					ym = ym / _rader *	r_r + _wsize_hlf
					
					if xd < _rader and xd >= -_rader and yd < _rader and yd >= -_rader then
						XGUI.SetStringSize(6)
						
						XGUI.SetDrawColorRGB(255,255,255)
						
						XGUI.SetStringPosition(xm,ym)
						XGUI.DrawVectorStringCenter("Å¢")
					end
				end
			end]]--
			
			XGUI.SetStringSize(12)
			
			if math.sqrt(x1 * x1 + y1 * y1) < _rader and _PLAYERID(i) ~= _PLAYERMYID() then
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
				
				--XGUI.SetStringPosition(x2,y2)
				
				--XGUI.SetStringPosition(x2,y2)
				--XGUI.DrawVectorStringCenter("Å~")
			end
		end
	end
	
	_rader = _rader - _raderbase
	
	XGUI.SetDrawColorRGB(0,255,0)
	
	--XGUI.SetStringPosition(24,32)
	--XGUI.DrawVectorString(string.format("% 4.4f",_FPS()))
	
	XGUI.SetStringSize(16)
	
	XGUI.SetStringPosition(128+12,256+32)
	
	if not disable_rader then
		XGUI.DrawVectorStringCenter(string.format("%d",_rader + _raderbase))
	else
		XGUI.DrawVectorStringCenter("DISABLE")
	end
	
	if not _fmsg then _fmsg = 0 end
	if not _msg then _msg = "" end
	
	local cs = _CHAT()
	
	if not _ocs then _ocs = _CHAT() end
	
	if _ocs ~= cs then
		SetHUDMassage("-NEW MESSAGE RECIEVED-")
	end
	
	_ocs = cs
	
	XGUI.SetStringSize(48)
	
	if _fmsg > 0 then
		local x = 0
		local y = 0
		for x=-1,1 do
			for y=-1,1 do
				if x ~= 0 or y ~= 0 then
					XGUI.SetDrawColorRGB(0,0,0)
					XGUI.SetStringPosition(_WIDTH()/2+x,_HEIGHT()/2+y)
					XGUI.DrawVectorStringCenter(_msg)
				end
			end
		end
		
		XGUI.SetDrawColorRGB(255,127,0)
		XGUI.SetStringPosition(_WIDTH()/2,_HEIGHT()/2)
		XGUI.DrawVectorStringCenter(_msg)
		_fmsg = _fmsg - 1
	end
	
	XGUI.SetStringSize(16)
	
	XGUI.SetDrawColorRGB(255,127,0)
	XGUI.SetStringPosition(_WIDTH()-string.len(cs)*8,_HEIGHT()-128-16)
	XGUI.DrawVectorString(cs)
	
	
	XGUI.SetStringSize(24)
	XGUI.SetDrawColorRGB(255,255,0)
	
	--[[for i=1,_mn do
		XGUI.SetStringPosition(288,64-24+24*i)
		XGUI.DrawVectorString(string.format("%d %s %dm/s",_ntp[i],_PLAYERNAME(_ntp[i]),_VEL(_G["MC"..i])))
	end]]--
	--</HUD>---------------------------------------------------------------
end
