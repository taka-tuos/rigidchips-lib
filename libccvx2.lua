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

_rate2=0.2
_rate1=1-_rate2

_md=0
_splash = 60

_pdisp = {}

function _RECT2D(x,y,s)
	--左の縦線
	_MOVE2D(x,y)
	_LINE2D(x,y-s)

	--右の縦線
	_MOVE2D(x+s,y)
	_LINE2D(x+s,y-s)

	--上の横線
	_MOVE2D(x,y)
	_LINE2D(x+s,y)

	--下の横線
	_MOVE2D(x,y-s)
	_LINE2D(x+s,y-s)
end

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

function OnInit()
	_ZOOM(_GETVIEWZOOM())
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
	_slim=1500
	
	if _md == 1 then
		_slim=1800
	end
	
	if _md == 2 then
		_slim=2000
	end
	
	if _md == 3 then
		_slim=2200
	end
	
	if _md == 4 then
		_slim=2500
	end
	
	if _md == 5 then
		_slim=64512
	end
	
	if _VEL()*3.6 > _slim then P = (_slim-_VEL()*3.6)*2500 end
	
	_md = _md+_KEYDOWN(8)-_KEYDOWN(10)
	if _md < 0 then _md = 5 end
	if _md > 5 then _md = 0 end
end

--<AAM>

function _NORMAL3(a,b,c,d,e,f)
	return a / _LEN3(a,b,c), b / _LEN3(a,b,c), c / _LEN3(a,b,c), d, e, f
end

_men = {}
_mfunc = {}
_moWx={}
_moWy={}
_moBp={} -- 1-3 : m/s	4-6 : m/s^2

_moPIDx={}
_moPIDy={}
_moPIDz={}

_pw = 0

-- lx, ly, lz : レイの始点
-- vx, vy, vz : レイの方向ベクトル
-- px, py, pz : 球の中心点の座標
-- r : 球の半径
-- q1x, q1y, q1z: 衝突開始点（戻り値）
-- q2x, q2y, q2z: 衝突終了点（戻り値）

function RaySphereAAM(lx, ly, lz, vx, vy, vz, px, py, pz, r)
	px = px - lx
	py = py - ly
	pz = pz - lz

	local A = vx * vx + vy * vy + vz * vz
	local B = vx * px + vy * py + vz * pz
	local C = px * px + py * py + pz * pz - r * r

	if A == 0 then
		return false -- レイの長さが0
	end

	local s = B * B - A * C

	if s < 0 then
		return false -- 衝突していない
	end

	s = math.sqrt(s);
	local a1 = ( B - s ) / A
	local a2 = ( B + s ) / A

	if a1 < 0 and a2 < 0 then
		return false -- レイの反対で衝突
	end

	local q1x = lx + a1 * vx
	local q1y = ly + a1 * vy
	local q1z = lz + a1 * vz
	local q2x = lx + a2 * vx
	local q2y = ly + a2 * vy
	local q2z = lz + a2 * vz

	return true,q1x,q1y,q1z,q2x,q2y,q2z
end

function InitAAM(func)
	local i
	
	for i=1,_mn do
		_mfunc[i] = func
		_moBp[i] = {}
		
		_moBp[i][1] = 0
		_moBp[i][2] = 0
		_moBp[i][3] = 0
		
		_moBp[i][4] = 0
		_moBp[i][5] = 0
		_moBp[i][6] = 0
		
		_moBp[i][7] = 0
		_moBp[i][8] = 0
		_moBp[i][9] = 0
	end
end

function EnableAAM()
	local i
	
	--_mn = n
	
	for i=1,_mn do
		_SPLIT(_G["MC"..i])
		_men[i] = true
		_moWx[i] = 0
		_moWy[i] = 0
		_moPIDx[i] = XPID_new()
		_moPIDy[i] = XPID_new()
		_moPIDz[i] = XPID_new()
	end
end

function MoveAAM()
	local i
	
	for i=1,_mn do
	local core = _G["MC"..i]
		local mx,my,mz = _NORMAL3(_ZX(core)*_mdl[i],_ZY(core)*_mdl[i],_ZZ(core)*_mdl[i])
		local ux,uy,uz = _mfunc[i](i)
		local px,py,pz = _X(core),_Y(core),_Z(core)
		local xx,xy,xz = _XX(core)*_mdl[i],_XY(core)*_mdl[i],_XZ(core)*_mdl[i]
		local yx,yy,yz = _YX(core),_YY(core),_YZ(core)
		local zx,zy,zz = _ZX(core),_ZY(core),_ZZ(core)
		
		-- 目標との距離
		local ul = _LEN3(ux-px,uy-py,uz-pz)
		
		-- 目標の1F前の座標
		local uxP = _moBp[i][1]
		local uyP = _moBp[i][2]
		local uzP = _moBp[i][3]
		
		-- 目標の1F前の速度
		local uxvP = _moBp[i][4]
		local uyvP = _moBp[i][5]
		local uzvP = _moBp[i][6]
		
		-- 目標の速度
		local uxv = (ux - uxP)
		local uyv = (uy - uyP)
		local uzv = (uz - uzP)
		
		-- 目標の加速度
		local uxvD = (uxv - uxvP)
		local uyvD = (uyv - uyvP)
		local uzvD = (uzv - uzvP)
		
		-- 目標の予測速度
		local uxvF = uxv + uxvD * (ul / 20)
		local uyvF = uyv + uxvD * (ul / 20)
		local uzvF = uzv + uxvD * (ul / 20)
		
		-- 目標の予測座標
		local uxF = ux + uxvF * (ul / 20)
		local uyF = uy + uyvF * (ul / 20)
		local uzF = uz + uzvF * (ul / 20)
		
		-- ミサイルの速度
		local vpx = _VX(core)
		local vpy = _VY(core)
		local vpz = _VZ(core)
		
		if _men[i] then
			local tx,ty,tz =  _NORMAL3(ux-px,uy-py,uz-pz)
			
			local uvx = uxv * 30
			local uvy = uyv * 30
			local uvz = uzv * 30
			
			local avx,avy,avz = _VX(core)*_mdl[i],_VY(core)*_mdl[i],_VZ(core)*_mdl[i]
			
			local vx = (-xx * avx + -yx * avy + -zx * avz)
			local vy = (-xy * avx + -yy * avy + -zy * avz)
			local vz = (-xz * avx + -yz * avy + -zz * avz)
			
			local nx = uvx - vx
			local ny = uvy - vy
			local nz = uvz - vz
			
			local nl = _LEN3(uxv,uyv,uzv) - _LEN3(vx,vy,vz)
			
			out(0,nx,ny,nz)
				
			_G["MP"..i] = math.limit(nl * 30000,200000,-200000)
			
			local dmp = _G["MP"..i]
			
			if ul > 10 then _G["MP"..i] = 200000 end
			if ul < 100 and _VEL(core) > 200 then _G["MP"..i] = dmp end
			if ul < 20 then _G["MP"..i] = dmp end
			
			_pw = 60
			if _VEL(core) > 150 then _pw = 30 end
			if _VEL(core) > 250 then _pw = 15 end
			if _VEL(core) > 350 then _pw = 10 end
			if _VEL(core) > 450 then _pw = 5 end
			
			--if _LEN3(_mfunc[i](i)) < _VEL(core)*2 then _G["MP"..i] = _VEL(core) * 2000 end
			
			if _VEL(core) > 500 then _G["MP"..i] = (500-_VEL(core))*7000 end
			
			_SETCOLOR(255)
			_MOVE3D(px,py,pz)
			_LINE3D(px+mx,py+my,pz+mz)
			
			_SETCOLOR(16777215)
			_MOVE3D(px,py,pz)
			_LINE3D(px+tx,py+ty,pz+tz)
			
			local dx,dy,dz = mx-tx,my-ty,mz-tz
			
			local jx = dx * _pw
			local jy = dy * _pw
			local jz = dz * _pw
			
			_SETCOLOR(255*65536)
			_MOVE3D(px,py,pz)
			_LINE3D(px+xx,py+xy,pz+xz)
			
			_SETCOLOR(255*256)
			_MOVE3D(px,py,pz)
			_LINE3D(px+yx,py+yy,pz+yz)
			
			local xa = -(xx * jx + xy * jy + xz * jz)
			local ya =	(yx * jx + yy * jy + yz * jz)
			
			_moWx[i] = _WX(core)
			_moWy[i] = _WY(core)
			
			_G["MX"..i] = xa
			_G["MY"..i] = ya
			
			local gip = _G["MG"..i]
			
			if _E(gip) == _OPTION(gip) then
				if ul < 1000 then
					local es,a,b,c = RaySphereAAM(px,py,pz,mx,my,mz,ux,uy,uz,0.6)
					
					if es then
						 _G["MA"..i] = 10000000000
					end
				end
			end
		end
		
		_moBp[i][1] = ux
		_moBp[i][2] = uy
		_moBp[i][3] = uz
		
		_moBp[i][4] = uxv
		_moBp[i][5] = uyv
		_moBp[i][6] = uzv
	end
end

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

function AAM_Callback(n)
	local core = _G["MC"..n]
	local x,y,z = _NPOS(_ntp[n])
	
	return x,y,z
end

function CalcNTP(n,inc,dec)
	_ntp[n] = math.mod(_ntp[n]+inc-dec,_PLAYERS())
	if _ntp[n] < 0 then _ntp[n] = _PLAYERS()-1 end
end

--</AAM>

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
			
			i=math.min(20,math.max(-20,i))
			
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

function GetPRV(pid,tbl)
	local p=_LINER(P,_KEY(4)*tbl.p.limit,tbl.p.step)
	
	local r,v = 0,0
	
	if pid then
		local dr = math.rad((_KEY(2)-_KEY(3))*tbl.r.tgt/30)
		local dv = math.rad((_KEY(1)-_KEY(0))*tbl.v.tgt/30)
		
		r = R_PID:PID(dr,WZ,tbl.r.kp,tbl.r.ki,tbl.r.kd,tbl.r.il)
		v = V_PID:PID(dv,WX,tbl.v.kp,tbl.v.ki,tbl.v.kd,tbl.v.il)
	else
		r=_LINER(R,_KEY(2)*tbl.r.limit+_KEY(3)*-tbl.r.limit,tbl.r.step)
		v=_LINER(V,_KEY(1)*tbl.v.limit+_KEY(0)*-tbl.v.limit,tbl.v.step)
		
		local _r,_v = 0,0
		if _KEY(2) == 0 and _KEY(3) == 0 then
			_r=WZ*tbl.r.kp
		end
		
		if _KEY(0) == 0 and _KEY(1) == 0 then
			_v=WX*tbl.v.kp
		end
		
		r=r*_rate1+_r*_rate2
		v=v*_rate1+_v*_rate2
	end
	
	return p,r,v
end

function _NORMANALOG(n)
	local v = _ANALOG(n)
	if v < 100 and v > -100 then v = 0 end
	return _ANALOG(n)/1000
end

function GetPRVAnalog(tbl)
	local ap = _NORMANALOG(5)
	if ap < 0 then ap = 0 end

	local p=_LINER(P,ap*tbl.p.limit,tbl.p.step)
	
	local r,v = 0,0
	
	local dr = math.rad(_NORMANALOG(0)*tbl.r.tgt/30)
	local dv = math.rad(-_NORMANALOG(1)*tbl.v.tgt/30)
	
	r = R_PID:PID(dr,WZ,tbl.r.kp,tbl.r.ki,tbl.r.kd,tbl.r.il)
	v = V_PID:PID(dv,WX,tbl.v.kp,tbl.v.ki,tbl.v.kd,tbl.v.il)
	
	return p,r,v
end

function InitPRVTable()
	local _prvtbl = {}
	_prvtbl.p = {}
	_prvtbl.r = {}
	_prvtbl.v = {}
	
	return _prvtbl
end

if not _aop then _aop = 50000 end
if not _aan then _aan = 65 end
if not _amx then _amx = 4 end

_vx=(_aop+5000)/(5000*_amx)
_tn=_aan
_tv={0,_tn,_tn,_tn,_tn,_tn,_tn,_tn,_tn,_tn,_tn,_tn,_tn,_tn,_tn,_tn}
_v=0

function _RAMIEL3D(ex,ey,ez,size)
	local llen = 0.4
	if size then llen = size end
	_MOVE3D(ex, ey + llen * 2, ez)
	_LINE3D(ex + llen * 1.41421356, ey, ez - llen * 1.41421356)
	_MOVE3D(ex, ey + llen * 2, ez)
	_LINE3D(ex - llen * 1.41421356, ey, ez - llen * 1.41421356)
	_MOVE3D(ex, ey + llen * 2, ez)
	_LINE3D(ex + llen * 1.41421356, ey, ez + llen * 1.41421356)
	_MOVE3D(ex, ey + llen * 2, ez)
	_LINE3D(ex - llen * 1.41421356, ey, ez + llen * 1.41421356)
	
	_MOVE3D(ex, ey - llen * 2, ez)
	_LINE3D(ex + llen * 1.41421356, ey, ez - llen * 1.41421356)
	_MOVE3D(ex, ey - llen * 2, ez)
	_LINE3D(ex - llen * 1.41421356, ey, ez - llen * 1.41421356)
	_MOVE3D(ex, ey - llen * 2, ez)
	_LINE3D(ex + llen * 1.41421356, ey, ez + llen * 1.41421356)
	_MOVE3D(ex, ey - llen * 2, ez)
	_LINE3D(ex - llen * 1.41421356, ey, ez + llen * 1.41421356)
	
	_MOVE3D(ex - llen * 1.41421356, ey, ez + llen * 1.41421356)
	_LINE3D(ex - llen * 1.41421356, ey, ez - llen * 1.41421356)
	_MOVE3D(ex + llen * 1.41421356, ey, ez + llen * 1.41421356)
	_LINE3D(ex + llen * 1.41421356, ey, ez - llen * 1.41421356)
	_MOVE3D(ex - llen * 1.41421356, ey, ez - llen * 1.41421356)
	_LINE3D(ex + llen * 1.41421356, ey, ez - llen * 1.41421356)
	_MOVE3D(ex - llen * 1.41421356, ey, ez + llen * 1.41421356)
	_LINE3D(ex + llen * 1.41421356, ey, ez + llen * 1.41421356)
end

function CCVXOnFrame(gun)
	MF()
	
	if _splash > 0 then _splash = _splash - 1 end
	
	if gun then
		for i=0,_amx-1 do
			_G['G'..i]=0
		end
		
		if _KEY(2) == 1 and _E(_G['A'.._v]) == _OPTION(_G['A'.._v]) and _G['V'.._v] == 0 then
			_G['G'.._v]=_OPTION(_G['A'.._v])
			_v=math.mod(_v+1,_amx)
			_tv={_tn,_tn,_tn,_tn,_tn,_tn,_tn,_tn,_tn,_tn,_tn,_tn,_tn,_tn,_tn,_tn}
			_tv[_v+1]=0
		end
		
		for i=0,_amx-1 do
			_G['V'..i]=_LINER(_G['V'..i],_tv[i+1],math.abs(_tn/_vx))
			
		end
	end
end
