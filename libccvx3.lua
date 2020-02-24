-- LIBCCVX3 version 2.0.0.0

do
	local FSX=_X(FS)
	local FSY=_Y(FS)
	local FSZ=_Z(FS)
	local RSX=_X(RS)
	local RSY=_Y(RS)
	local RSZ=_Z(RS)
	local LSX=_X(LS)
	local LSY=_Y(LS)
	local LSZ=_Z(LS)
	local TSX=_X(TS)
	local TSY=_Y(TS)
	local TSZ=_Z(TS)
	
	function MF(a)
		local FX=_X(FS)-FSX
		local FY=_Y(FS)-FSY
		local FZ=_Z(FS)-FSZ
		local RX=_X(RS)-RSX
		local RY=_Y(RS)-RSY
		local RZ=_Z(RS)-RSZ
		local LX=_X(LS)-LSX
		local LY=_Y(LS)-LSY
		local LZ=_Z(LS)-LSZ
		local TX=_X(TS)-TSX
		local TY=_Y(TS)-TSY
		local TZ=_Z(TS)-TSZ

		WX=(FX*_YX(FS)+FY*_YY(FS)+FZ*_YZ(FS))-(TX*_YX(TS)+TY*_YY(TS)+TZ*_YZ(TS))
		WY=(RX*_ZX(RS)+RY*_ZY(RS)+RZ*_ZZ(RS))-(LX*_ZX(LS)+LY*_ZY(LS)+LZ*_ZZ(LS))
		WZ=(RX*_YX(RS)+RY*_YY(RS)+RZ*_YZ(RS))-(LX*_YX(LS)+LY*_YY(LS)+LZ*_YZ(LS))
		VEL=(FX*_ZX(FS)+FY*_ZY(FS)+FZ*_ZZ(FS))*3.6
		VX=(FX*_XX(FS)+FY*_XY(FS)+FZ*_XZ(FS))*3.6

		VY=(FX*_YX(FS)+FY*_YY(FS)+FZ*_YZ(FS))*3.6

		FSX=_X(FS)
		FSY=_Y(FS)
		FSZ=_Z(FS)
		RSX=_X(RS)
		RSY=_Y(RS)
		RSZ=_Z(RS)
		LSX=_X(LS)
		LSY=_Y(LS)
		LSZ=_Z(LS)
		TSX=_X(TS)
		TSY=_Y(TS)
		TSZ=_Z(TS)
	end
end

math.limit = function (val,max,min)	return val>max and max or val<min and min or val	end

function _VEL(n)
	return _LEN3( _VX(n), _VY(n), _VZ(n))
end

function _LEN3(a,b,c)
	return math.sqrt(a * a + b * b + c * c)
end

function _LINER(v,t,s)
	local r=v
	if v<t then r=v+s end
	if v>t then r=v-s end
	if r>t and v<t then r=t end
	if r<t and v>t then r=t end
	return r
end

_md=0
_splash = 60

function _NPOS(n)
	math.randomseed(1519)
	local x = _PLAYERX(n)
	math.randomseed(1519)
	local y = _PLAYERY(n)
	math.randomseed(1519)
	local z = _PLAYERZ(n)
	
	local a = math.pow(_PLAYERCHIPS(n), 1.0 / 3.0) / 2.0
	
	local g_RandTime = _NTICKS()
	
	x = x - math.sin(g_RandTime / 150.0)*a + math.sin(g_RandTime / 350.0)*a
	y = y - math.sin(g_RandTime / 160.0)*a + math.sin(g_RandTime / 360.0)*a
	z = z - math.sin(g_RandTime / 140.0)*a + math.sin(g_RandTime / 340.0)*a
	
	return x,y,z
end

function _CROSS3D(x,y,z)
	_MOVE3D(x,y,z)
	_LINE3D(x+0.3,y,z)
	
	_MOVE3D(x,y,z)
	_LINE3D(x-0.3,y,z)
	
	_MOVE3D(x,y,z)
	_LINE3D(x,y+0.3,z)
	
	_MOVE3D(x,y,z)
	_LINE3D(x,y-0.3,z)
	
	_MOVE3D(x,y,z)
	_LINE3D(x,y,z+0.3)
	
	_MOVE3D(x,y,z)
	_LINE3D(x,y,z-0.3)
end

_vel=0
_ovel=0

_ab=0

_velrot=0

function Rotate2D(px,py,pr)
	return px * math.cos(pr) - py * math.sin(pr), px * math.sin(pr) + py * math.cos(pr)
end

function SetHUDMassage(sz)
	_fmsg = 30
	_msg = sz
end

function SetHUDMassageEx(sz,f)
	_fmsg = 30
	_msg = sz
end

function ShowSplash(name)
	if _TICKS() < 15 then
		SetHUDMassageEx("-WELCOME-",1)
	end
	
	if _TICKS() >= 15 and _TICKS() < 30 then
		SetHUDMassageEx(name,1)
	end
end

function CheckLimit()
	_md = math.mod(_md+_KEYDOWN(8)-_KEYDOWN(10),table.getn(_limitlist))
	if _md < 0 then _md = table.getn(_limitlist) - 1 end
	
	_slim=_limitlist[_md+1]
	
	if _VEL()*3.6 > _slim then P = (_slim-_VEL()*3.6)*2500 end
end

function XPID_new()
	local obj = {
		i = 0,
		d = 0,
		e_b = 0,

		PID = function (self,now,tgt,kp,ki,kd,lim)
			local e_n = now - tgt
			local e_d = e_n - self.e_b
			
			local p = e_n * kp
			
			local i = self.i + e_n * ki
			
			local d = e_d * kd
			
			i=math.min(lim,math.max(-lim,i))
			
			self.i = i
			
			self.e_b = e_n
			
			local pid = p+i+d
			
			pid = math.min(lim,math.max(-lim,pid))
			
			return pid
		end
	}
	
	return obj
end

R_PID = XPID_new()
V_PID = XPID_new()
J_PID = XPID_new()

function _NORMANALOG(n)
	local v = _ANALOG(n)
	if v < 150 and v > -150 then v = 0 end
	return v/1000
end

function GetPRVBAnalog(tbl,now)
	local ap = _NORMANALOG(2)
	if ap < 0 then ap = 0 end

	local p=_LINER(now.p,ap*tbl.p.limit,tbl.p.step)
	
	local r,v = 0,0
	
	--out(10,_ANALOG(0))
	
	local dr = math.rad(_NORMANALOG(0)*tbl.r.tgt/30)
	local dv = math.rad(-_NORMANALOG(1)*tbl.v.tgt/30)
	
	r = R_PID:PID(dr,WZ,tbl.r.kp,tbl.r.ki,tbl.r.kd,tbl.r.il)
	v = V_PID:PID(dv,WX,tbl.v.kp,tbl.v.ki,tbl.v.kd,tbl.v.il)
	
	local ab = _NORMANALOG(2)
	if ab > 0 then ab = 0 end
	
	local ab =_LINER(now.b,ab*60,30)
	
	return p,r,v,ab
end

function InitPRVTable()
	local _prvtbl = {}
	_prvtbl.p = {}
	_prvtbl.r = {}
	_prvtbl.v = {}
	
	return _prvtbl
end

function CCVXOnFrame()
	MF()
	
	if _splash > 0 then _splash = _splash - 1 end
	
	if Weapon then
		Weapon.Step()
	end
end

function CCVXOnInit(tbl)
	_ZOOM(_GETVIEWZOOM())
	
	if Weapon then
		Weapon.Init(tbl)
	end
end
