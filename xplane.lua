-- XPLANE version 1.0.0.0

local ReadySKA = pcall(require,"shared/SharedKeyAssign.lua")

if not ReadySKA then
	SharedKeyAssign = {};
	SharedKeyAssign.PitchUp = 1;
	SharedKeyAssign.PitchDown = 0;
	SharedKeyAssign.RollLeft = 2;
	SharedKeyAssign.RollRight = 3;
	SharedKeyAssign.YawLeft = 4;
	SharedKeyAssign.YawRight = 6;
	SharedKeyAssign.PowerUp = 8;
	SharedKeyAssign.PowerDown = 5;
	SharedKeyAssign.Gear = 10;
	SharedKeyAssign.ModeChange = 12;
	SharedKeyAssign.Fire = 7;
	SharedKeyAssign.Shift = 9;
	SharedKeyAssign.Option2 = 14;

	SharedKeyAssign.PitchFunc = function()
		return -_ANALOG(1)/1000;
	end
	SharedKeyAssign.RollFunc = function()
		return _ANALOG(0)/1000;
	end
	SharedKeyAssign.YawFunc = function()
		return _ANALOG(2)/1000;
	end
	SharedKeyAssign.PowerFunc = function()
		return 0 ;
	end

	SKA = SharedKeyAssign;
end

function _VEL(n)
	return _LEN3( _VX(n), _VY(n), _VZ(n))
end

function _LEN3(a,b,c)
	return math.sqrt(a * a + b * b + c * c)
end

--------------------------------------------------------------------------------

function xpLimit(val,min,max)
	return val>max and max or val<min and min or val
end

function xpStepVal(v,t,s)
	local r=v
	if v<t then r=v+s end
	if v>t then r=v-s end
	if r>t and v<t then r=t end
	if r<t and v>t then r=t end
	return r
end

function xpConvWL(dx,dy,dz, cn, flag)
	if flag then
		return dx*_XX(cn)+dy*_XY(cn)+dz*_XZ(cn),dx*_YX(cn)+dy*_YY(cn)+dz*_YZ(cn),dx*_ZX(cn)+dy*_ZY(cn)+dz*_ZZ(cn)
	else
		return _X(cn)+dx*_XX(cn)+dy*_YX(cn)+dz*_ZX(cn),_Y(cn)+dx*_XY(cn)+dy*_YY(cn)+dz*_ZY(cn),_Z(cn)+dx*_XZ(cn)+dy*_YZ(cn)+dz*_ZZ(cn)
	end
end

function xpNewPID()
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

-- 劣化角速度 多分実用レベル 1Fに1回呼び出し
local Base = {}
function xpPhysic(cn)
	if not cn then cn = 0 end
	Base[cn] = Base[cn] or {_YX(cn),_YY(cn),_YZ(cn),_ZX(cn),_ZY(cn),_ZZ(cn),_TICKS()}
	local yx,yy,yz = xpConvWL(Base[cn][1],Base[cn][2],Base[cn][3],cn,true)
	local zx,zy,zz = xpConvWL(Base[cn][4],Base[cn][5],Base[cn][6],cn,true)
	if Base[cn][7]~=_TICKS() then
		Base[cn] = {_YX(cn),_YY(cn),_YZ(cn),_ZX(cn),_ZY(cn),_ZZ(cn),_TICKS()}
	end
	return -(math.atan2(zz,zy)-math.pi/2)*30,(math.atan2(zz,zx)-math.pi/2)*30,(math.atan2(yx,yy))*30
end

function xpInitPID()
	local tbl = {}
	tbl.pow = {}
	tbl.rol = {}
	tbl.pit = {}
	tbl.yaw = {}
	tbl.brk = {}
	
	tbl.pow.now = 0
	tbl.rol.now = 0
	tbl.pit.now = 0
	tbl.yaw.now = 0
	tbl.brk.now = 0
	
	return tbl
end

function xpOnInit()
	-- やることなし(将来に備えて)
end

local analogMode=true
local digitalEngine=false

function xpOnFrame()
	if _KEYDOWN(SharedKeyAssign.ModeChange) == 1 then
		analogMode = not analogMode
	end
	
	if _KEYDOWN(SharedKeyAssign.Option2) == 1 then
		digitalEngine = not digitalEngine
	end
	
	return analogMode,digitalEngine
end

local rolPID = xpNewPID()
local pitPID = xpNewPID()
local yawPID = xpNewPID()

function xpDoControl(tbl)
	local outPow,outRol,outPit,outYaw
	
	if analogMode then
		outPow = math.max(0,SharedKeyAssign.PowerFunc())
		outRol = SharedKeyAssign.RollFunc()
		outPit = SharedKeyAssign.PitchFunc()
		outYaw = SharedKeyAssign.YawFunc()
	else
		outPow = _KEY(SharedKeyAssign.PowerUp)
		outRol = _KEY(SharedKeyAssign.RollLeft) - _KEY(SharedKeyAssign.RollRight)
		outPit = _KEY(SharedKeyAssign.PitchUp) - _KEY(SharedKeyAssign.PitchDown)
		outYaw = _KEY(SharedKeyAssign.YawLeft) - _KEY(SharedKeyAssign.YawRight)
	end
	
	local finPow,finRol,finPit,finYaw,finBrk
	
	if digitalEngine then
		finPow = tbl.pow.now + _KEY(SharedKeyAssign.PowerUp)*tbl.pow.stp - _KEY(SharedKeyAssign.PowerDown)*tbl.pow.stp
		finPow = xpLimit(finPow,0,tbl.pow.tgt)
	else
		finPow = xpStepVal(tbl.pow.now,tbl.pow.tgt*outPow,tbl.pow.stp)
	end
	
	finBrk = 0
	
	if _KEY(SharedKeyAssign.Shift) == 1 then
		finBrk = xpStepVal(tbl.brk.now,tbl.brk.tgt,tbl.brk.stp)
	end
	
	local wx,wy,wz = xpPhysic(PC)
	
	finRol = rolPID:PID(0,-wz - outRol * tbl.rol.tgt,tbl.rol.kp,tbl.rol.ki,tbl.rol.kd,tbl.rol.il)
	finPit = pitPID:PID(0, wx - outPit * tbl.pit.tgt,tbl.pit.kp,tbl.pit.ki,tbl.pit.kd,tbl.pit.il)
	finYaw = yawPID:PID(0, wy + outYaw * tbl.yaw.tgt,tbl.yaw.kp,tbl.yaw.ki,tbl.yaw.kd,tbl.yaw.il)
	
	tbl.pow.now = finPow
	tbl.rol.now = finRol
	tbl.pit.now = finPit
	tbl.yaw.now = finYaw
	tbl.brk.now = finBrk
	
	return finPow,finRol,finPit,finYaw,finBrk
end
