-- XHUD version 1.0.0.1

XHUD = {}

_rader = 0
_ovalstep = 10

function XHUD.Draw()
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
	
	XGUI.SetDrawColorRGB(0,255,0)
	
	local r_r = 128
	local r_s = r_r-8
	local r_t = r_r+8
	
	XGUI.Move2D(16,r_r+16)
	XGUI.Line2D(16,16)
	XGUI.Line2D(r_r+16,16)
	
	local i
	for i=180,-90,-_ovalstep do
		XGUI.Line2D(math.sin(math.rad(i))*r_r+r_r+16,math.cos(math.rad(i))*r_r+r_r+16)
	end
	
	i = 0
	XGUI.Move2D(math.sin(math.rad(i))*r_s+r_r+16,math.cos(math.rad(i))*r_s+r_r+16)
	
	for i=0,360,_ovalstep do
		XGUI.Line2D(math.sin(math.rad(i))*r_s+r_r+16,math.cos(math.rad(i))*r_s+r_r+16)
	end
	
	XGUI.Move2D(r_r+16,r_r+16)
	XGUI.Line2D(math.sin(math.rad(180+_GETVIEWZOOM()/2))*r_s+r_r+16,math.cos(math.rad(180+_GETVIEWZOOM()/2))*r_s+r_r+16)
	XGUI.Move2D(r_r+16,r_r+16)
	XGUI.Line2D(math.sin(math.rad(180-_GETVIEWZOOM()/2))*r_s+r_r+16,math.cos(math.rad(180-_GETVIEWZOOM()/2))*r_s+r_r+16)
	
	
	XGUI.Move2D(0,r_r+16)
	
	for i=-90,135,_ovalstep do
		XGUI.Line2D(math.sin(math.rad(i))*r_t+r_r+16,math.cos(math.rad(i))*r_t+r_r+16)
	end
	
	XGUI.Line2D(math.sin(math.rad(135))*r_t+r_r+16+64,math.cos(math.rad(135))*r_t+r_r+16-40)
	XGUI.Line2D(_WIDTH(),math.cos(math.rad(135))*r_t+r_r+16-40)
	
	
	local r_u = 16
	
	local r_s1 = 512
	
	XGUI.Move2D(0,_HEIGHT()-16)
	
	XGUI.Line2D(_WIDTH()-r_s1-r_u*2,_HEIGHT()-16)
	
	for i=0,90,_ovalstep do
		XGUI.Line2D(math.sin(math.rad(i))*r_u+_WIDTH()-r_s1,math.cos(math.rad(i))*r_u+_HEIGHT()-16-r_u)
	end
	
	for i=-90,-180,-_ovalstep do
		XGUI.Line2D(math.sin(math.rad(i))*r_u+_WIDTH()-r_s1+r_u*2,math.cos(math.rad(i))*r_u+_HEIGHT()-16-r_u-72)
	end
	
	XGUI.Line2D(_WIDTH(),_HEIGHT()-16-r_u*2-72)
	
	
	local r_v = 48
	
	XGUI.Move2D(math.sin(math.rad(0))*r_v+r_v+16,math.cos(math.rad(0))*r_v+_HEIGHT()/2)
	
	for i=0,360,_ovalstep do
		XGUI.Line2D(math.sin(math.rad(i))*r_v+r_v+16,math.cos(math.rad(i))*r_v+_HEIGHT()/2)
	end
	
	local r_w = 16
	
	XGUI.Move2D(math.sin(math.rad(0))*r_w+r_v+16,math.cos(math.rad(0))*r_w+_HEIGHT()/2)
	
	for i=0,360,_ovalstep do
		XGUI.Line2D(math.sin(math.rad(i))*r_w+r_v+16,math.cos(math.rad(i))*r_w+_HEIGHT()/2)
	end
	
	_vel = _VEL(0)
	--if _maxvel < _vel then _maxvel = _vel end
	
	_velrot = _velrot + (math.rad(90)*(_vel-_ovel)*30)
	
	_ovel = _vel
	
	
	for i=-20,20,40 do
		XGUI.Move2D(math.sin(math.rad(_velrot+i))*r_w+r_v+16,math.cos(math.rad(_velrot+i))*r_w+_HEIGHT()/2)
		XGUI.Line2D(math.sin(math.rad(_velrot+i))*r_v+r_v+16,math.cos(math.rad(_velrot+i))*r_v+_HEIGHT()/2)
	end
	
	for i=-200,-160,40 do
		XGUI.Move2D(math.sin(math.rad(_velrot+i))*r_w+r_v+16,math.cos(math.rad(_velrot+i))*r_w+_HEIGHT()/2)
		XGUI.Line2D(math.sin(math.rad(_velrot+i))*r_v+r_v+16,math.cos(math.rad(_velrot+i))*r_v+_HEIGHT()/2)
	end

	XGUI.Move2D(math.sin(math.rad(0))*r_v+r_v+16,math.cos(math.rad(0))*r_v+_HEIGHT()/2)
	XGUI.Line2D(128+r_v+16,math.cos(math.rad(0))*r_v+_HEIGHT()/2)
	
	XGUI.Move2D(math.sin(math.rad(90))*r_v+r_v+16,math.cos(math.rad(90))*r_v+_HEIGHT()/2)
	XGUI.Line2D(128+r_v+16,math.cos(math.rad(90))*r_v+_HEIGHT()/2)
	
	XGUI.Move2D(128+r_v+16,math.cos(math.rad(0))*r_v+_HEIGHT()/2)
	XGUI.Line2D(128+r_v+16,math.cos(math.rad(90))*r_v+_HEIGHT()/2)
	
	XGUI.SetStringPosition(math.sin(math.rad(90))*r_v+r_v+16,math.cos(math.rad(90))*r_v+_HEIGHT()/2+8)
	
	XGUI.SetStringSize(32)
	
	XGUI.DrawVectorString(string.format("% 4d",_vel*3.6))
	
	XGUI.SetStringPosition(math.sin(math.rad(90))*r_v+r_v+16,math.cos(math.rad(90))*r_v+_HEIGHT()/2+8+32+8)
	
	if _slim then XGUI.DrawVectorString(string.format("% 4d",_slim)) end
	
	
	local r_s2 = 96
	local r_s3 = 24
	
	XGUI.Move2D(_WIDTH()-r_s2-16-r_s3*2,_HEIGHT()/2-r_s3)
	XGUI.Line2D(_WIDTH()-16-r_s3*2,_HEIGHT()/2-r_s3)
	XGUI.Line2D(_WIDTH()-16-r_s3*2,_HEIGHT()/2+r_s3)
	XGUI.Line2D(_WIDTH()-r_s2-16-r_s3*2,_HEIGHT()/2+r_s3)
	XGUI.Line2D(_WIDTH()-r_s2-16-r_s3*2,_HEIGHT()/2-r_s3)
	
	XGUI.SetStringPosition(_WIDTH()-r_s2-16-r_s3*2+16,_HEIGHT()/2-r_s3+8)
	
	XGUI.DrawVectorString(string.format("% 4d",_Y(0)))
	
	XGUI.SetStringPosition(_WIDTH()-r_s2-16-r_s3*2+16,_HEIGHT()/2-r_s3+8+32+8)
	
	local _gy = _RANGE(0,-_YX(),-_YY(),-_YZ())
	if _gy == -100000 then _gy = _Y(0) end
	
	XGUI.DrawVectorString(string.format("% 4d",_gy))
	
	XGUI.Move2D(_WIDTH()-16-r_s3*2,_HEIGHT()/2-r_s3)
	XGUI.Line2D(_WIDTH()-16,_HEIGHT()/2-r_s3)
	XGUI.Line2D(_WIDTH()-16,_HEIGHT()/2-r_s3+r_s2)
	XGUI.Line2D(_WIDTH()-16-r_s3*2,_HEIGHT()/2-r_s3+r_s2)
	XGUI.Line2D(_WIDTH()-16-r_s3*2,_HEIGHT()/2-r_s3)
	
	
	for i=-10,10 do
		local j = i/11
		local k = 0.5
		
		if math.mod((_Y()-math.mod(_Y(),1))-i,5) == 0 then k=1 end
		
		XGUI.Move2D(_WIDTH()-16-r_s3*k,_HEIGHT()/2+r_s3+r_s2/2*j+math.mod(_Y(),1)*4)
		XGUI.Line2D(_WIDTH()-16,_HEIGHT()/2+r_s3+r_s2/2*j+math.mod(_Y(),1)*4)
	end
	
	local r_s5 = math.tan(math.rad(_GETVIEWZOOM()))*_HEIGHT()
	
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
	
	
	local ax1,ay1 = Rotate2D(-384-256,0,-_EZ())
	local ax2,ay2 = Rotate2D(-384	   ,0,-_EZ())
		
	local bx1,by1 = Rotate2D( 384+256,0,-_EZ())
	local bx2,by2 = Rotate2D( 384	   ,0,-_EZ())
		
	XGUI.Move2D(ax1+_WIDTH()/2,ay1+_HEIGHT()/2)
	XGUI.Line2D(ax2+_WIDTH()/2,ay2+_HEIGHT()/2)
		
	XGUI.Move2D(bx1+_WIDTH()/2,by1+_HEIGHT()/2)
	XGUI.Line2D(bx2+_WIDTH()/2,by2+_HEIGHT()/2)
	
	local cx1,cy1 = -256-128,0
	local cx2,cy2 =	 256+128,0
	
	XGUI.SetStringSize(16)
	
	XGUI.SetStringPosition(cx1+_WIDTH()/2,cy1+_HEIGHT()/2)
	XGUI.DrawVectorString(string.format("%d",math.abs(math.deg(_EX()))))
	
	XGUI.SetStringPosition(cx2+_WIDTH()/2,cy2+_HEIGHT()/2)
	XGUI.DrawVectorString(string.format("%d",math.abs(math.deg(_EX()))))
	
	_rader = _rader + _raderbase
	
	for i=1,_PLAYERS()-1 do
		local x,y,z = _NPOS(i)
		local _wsize_hlf = r_r+16
		
		local x1,y1 = x-_X(0),z-_Z(0)
		
		local x2 = x1 * math.cos(_EY(0)) - y1 * math.sin(_EY(0))
		local y2 = x1 * math.sin(_EY(0)) + y1 * math.cos(_EY(0))
		
		x2 = x2 / _rader * -r_r + _wsize_hlf
		y2 = y2 / _rader *	r_r + _wsize_hlf
		
		local j
		
		for j=1,_mn do
			if _men[i] then
				local core = _G["MC"..j]
				
				local xd,yd = _X(core)-_X(0),_Z(core)-_Z(0)
				
				local xm = xd * math.cos(_EY(0)) - yd * math.sin(_EY(0))
				local ym = xd * math.sin(_EY(0)) + yd * math.cos(_EY(0))
				
				xm = xm / _rader * -r_r + _wsize_hlf
				ym = ym / _rader *	r_r + _wsize_hlf
				
				if math.sqrt(xd * xd + yd * yd) < _rader then
					XGUI.SetStringSize(6)
					
					XGUI.SetDrawColorRGB(255,255,255)
					
					XGUI.SetStringPosition(xm,ym)
					XGUI.DrawVectorStringCenter("¢")
				end
			end
		end
		
		XGUI.SetStringSize(12)
		
		if math.sqrt(x1 * x1 + y1 * y1) < _rader and _PLAYERID(i) ~= _PLAYERMYID() then
			if _PLAYERARMS(i) ~= 0 then XGUI.SetDrawColorRGB(255,0,0)
			else XGUI.SetDrawColorRGB(255,255,255) end
			local szL = ""
			local enL = false
			
			local k = 0
			
			for j=1, _mn do
				if _ntp[j] == i then
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
			XGUI.SetStringPosition(x2,y2)
			XGUI.DrawVectorStringCenter("~")
		end
	end
	
	_rader = _rader - _raderbase
	
	XGUI.SetDrawColorRGB(0,255,0)
	
	XGUI.SetStringPosition(24,32)
	XGUI.DrawVectorString(string.format("% 4.4f",_FPS()))
	
	XGUI.SetStringSize(16)
	
	XGUI.SetStringPosition(128+12,256+32)
	XGUI.DrawVectorStringCenter(string.format("%d",_rader + _raderbase))
	
	XGUI.Move2D(_WIDTH()/2-16,_HEIGHT()/2)
	XGUI.Line2D(_WIDTH()/2+16,_HEIGHT()/2)
	
	XGUI.Move2D(_WIDTH()/2,_HEIGHT()/2)
	XGUI.Line2D(_WIDTH()/2,_HEIGHT()/2+16)
	
	XGUI.SetDrawColorRGB(255,128,0)
	
	local r_s4 = 256
	
	XGUI.Move2D(r_u+_WIDTH()/2-r_s4-r_u	  ,_HEIGHT()/2-r_s4-r_u)
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
	XGUI.Line2D(r_u+_WIDTH()/2-r_s4-r_u*2 ,_HEIGHT()/2+r_s4-16)
	
	
	
	for i=-90,-180,-_ovalstep do
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
	
	for i=1,_mn do
		XGUI.SetStringPosition(288,64-24+24*i)
		XGUI.DrawVectorString(string.format("%d %s %dm/s",_ntp[i],_PLAYERNAME(_ntp[i]),_VEL(_G["MC"..i])))
	end
	--</HUD>---------------------------------------------------------------
end
