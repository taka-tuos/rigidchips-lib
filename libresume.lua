-- LIBRESUME 1.0

Missile = {}

function _NORMAL3(a,b,c,d,e,f)
	return a / _LEN3(a,b,c), b / _LEN3(a,b,c), c / _LEN3(a,b,c), d, e, f
end

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

function Missile.Create(func,n,rawtable)
	local obj = {}
	
	obj.mfunc = func
	
	obj.mdl = rawtable.mdl[n]
	obj.n = n
	
	if not n then
		obj.n = ""
	end
	
	obj.moBp = {}
	
	obj.moBp[1] = 0
	obj.moBp[2] = 0
	obj.moBp[3] = 0
		
	obj.moBp[4] = 0
	obj.moBp[5] = 0
	obj.moBp[6] = 0
	
	obj.moBp[7] = 0
	obj.moBp[8] = 0
	obj.moBp[9] = 0
	
	obj.usetgt = true
	
	obj.Fire = function(self)
		_SPLIT(_G["MC"..self.n])
		self.men = true
		self.moWx = 0
		self.moWy = 0
		self.moPIDx = XPID_new()
		self.moPIDy = XPID_new()
		self.moPIDz = XPID_new()
		
		return self
	end
	
	obj.GetPosition = function(self)
		local core = _G["MC"..self.n]
		
		return _X(core),_Y(core),_Z(core)
	end
	
	obj.isEnabled = function(self)
		return self.men
	end
	
	obj.Step = function(self)
		local core = _G["MC"..self.n]
		local mx,my,mz = _NORMAL3(_ZX(core)*self.mdl,_ZY(core)*self.mdl,_ZZ(core)*self.mdl)
		local ux,uy,uz = self:mfunc()
		local px,py,pz = _X(core),_Y(core),_Z(core)
		local xx,xy,xz = _XX(core)*self.mdl,_XY(core)*self.mdl,_XZ(core)*self.mdl
		local yx,yy,yz = _YX(core),_YY(core),_YZ(core)
		local zx,zy,zz = _ZX(core),_ZY(core),_ZZ(core)
		
		-- 目標との距離
		local ul = _LEN3(ux-px,uy-py,uz-pz)
		
		-- 目標の1F前の座標
		local uxP = self.moBp[1]
		local uyP = self.moBp[2]
		local uzP = self.moBp[3]
		
		-- 目標の1F前の速度
		local uxvP = self.moBp[4]
		local uyvP = self.moBp[5]
		local uzvP = self.moBp[6]
		
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
		
		if self.men then
			local tx,ty,tz =  _NORMAL3(ux-px,uy-py,uz-pz)
			
			local uvx = uxv * 30
			local uvy = uyv * 30
			local uvz = uzv * 30
			
			local avx,avy,avz = _VX(core)*self.mdl,_VY(core)*self.mdl,_VZ(core)*self.mdl
			
			local vx = (-xx * avx + -yx * avy + -zx * avz)
			local vy = (-xy * avx + -yy * avy + -zy * avz)
			local vz = (-xz * avx + -yz * avy + -zz * avz)
			
			local nx = uvx - vx
			local ny = uvy - vy
			local nz = uvz - vz
			
			local nl = _LEN3(uxv,uyv,uzv) - _LEN3(vx,vy,vz)
			
			out(0,nx,ny,nz)
				
			_G["MP"..self.n] = math.limit(nl * 30000,200000,-200000)
			
			local dmp = _G["MP"..self.n]
			
			if ul > 10 then _G["MP"..self.n] = 200000 end
			if ul < 100 and _VEL(core) > 200 then _G["MP"..self.n] = dmp end
			if ul < 20 then _G["MP"..self.n] = dmp end
			
			_pw = 60
			if _VEL(core) > 150 then _pw = 30 end
			if _VEL(core) > 250 then _pw = 15 end
			if _VEL(core) > 350 then _pw = 10 end
			if _VEL(core) > 450 then _pw = 5 end
			
			--if _LEN3(self.mfunc(i)) < _VEL(core)*2 then _G["MP"..self.n] = _VEL(core) * 2000 end
			
			if _VEL(core) > 500 then _G["MP"..self.n] = (500-_VEL(core))*7000 end
			
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
			
			self.moWx = _WX(core)
			self.moWy = _WY(core)
			
			_G["MX"..self.n] = xa
			_G["MY"..self.n] = ya
			
			local gip = _G["MG"..self.n]
			
			if _E(gip) == _OPTION(gip) then
				if ul < 1000 then
					local es,a,b,c = RaySphereAAM(px,py,pz,mx,my,mz,ux,uy,uz,0.6)
					
					if es then
						 _G["MA"..self.n] = 10000000000
					end
				end
			end
		end
		
		self.moBp[1] = ux
		self.moBp[2] = uy
		self.moBp[3] = uz
		
		self.moBp[4] = uxv
		self.moBp[5] = uyv
		self.moBp[6] = uzv
		
		return self
	end
	
	return obj
end
