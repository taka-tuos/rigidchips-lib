-- LIBWEAPON 1.0

Weapon = {}

Weapon.List = {}
Weapon.Target = {}
Weapon.Selected = 0
Weapon.Max = 0

function Weapon.TargetBox(ex,ey,ez,size)
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

function Weapon.Init(tbl)
	local xi=1
	if not tbl then return end
	table.foreach(tbl, function(i,v)
		if _G[i] then
			local wn = v.n
			if not wn then wn = 1 end
			local j
			for j=1,wn do
				local wd = {}
				wd.obj = _G[i].Create(Weapon.mFunc,j,v)
				wd.firebutton = v.fire
				wd.firefunc = v.func
				wd.fired = false
				wd.category = i
				if wd.obj.usetgt then
					wd.obj.xi = xi
					Weapon.Target[xi] = 0
					Weapon.Max = xi
					xi = xi + 1
				end
				table.insert(Weapon.List,wd)
			end
		end
	end)
end

function Weapon.Step()
	Weapon.Selected = math.mod(_KEY(11)*2+Weapon.Selected,Weapon.Max)
	table.foreach(Weapon.List, function(i,v)
		if v.firefunc(v.firebutton) == 1 then
			if v.obj.xi == nil or v.obj.xi == Weapon.Selected+1 or v.obj.xi == Weapon.Selected+2 then
				v.obj = v.obj:Fire()
			end
		else
			if (v.obj.xi == nil or v.obj.xi == Weapon.Selected+1 or v.obj.xi == Weapon.Selected+2) and v.obj.UnFire then
				v.obj = v.obj:UnFire()
			end
		end
		
		if v.obj.usetgt then
			if v.obj.xi == Weapon.Selected+1 then
				local now = Weapon.Target[v.obj.xi]
				now = math.mod(now+_KEYDOWN(6)*_KEY(0),_PLAYERS())
				Weapon.Target[v.obj.xi] = now
			end

			if v.obj.xi == Weapon.Selected+2 then
				local now = Weapon.Target[v.obj.xi]
				now = math.mod(now+_KEYDOWN(7)*_KEY(0),_PLAYERS())
				Weapon.Target[v.obj.xi] = now
			end
		end
		
		v.obj = v.obj:Step()
		
		Weapon.List[i] = v
	end)
end

function Weapon.Stat()
	table.foreach(Weapon.List, function(i,v)
		if v.obj.usetgt then
			XGUI.SetStringSize(24)
			XGUI.SetDrawColorRGB(255,255,0)
			if v.obj:isEnabled() then
				XGUI.SetDrawColorRGB(255,0,0)
			end
			XGUI.SetStringPosition(288,64-24+24*v.obj.xi)
			local s = "  "
			if v.obj.xi == Weapon.Selected+1 or v.obj.xi == Weapon.Selected+2 then
				s = "ÅÀ"
			end
			XGUI.DrawVectorString(string.format("%s %d:%s [%s]",s,Weapon.Target[v.obj.xi],_PLAYERNAME(Weapon.Target[v.obj.xi]),v.category))
		end
	end)
end

function Weapon.PositionTable()
	local tbl = {}
	table.foreach(Weapon.List, function(i,v)
		if v.obj.usetgt and v.obj:isEnabled() then
			local obj = {}
			local x,y,z = v.obj:GetPosition()
			obj.x = x
			obj.y = y
			obj.z = z
			table.insert(tbl,obj)
		end
	end)
	return tbl
end

function Weapon.mFunc(self)
	return _NPOS(Weapon.Target[self.xi])
end
