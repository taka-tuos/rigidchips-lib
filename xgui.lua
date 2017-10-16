require("daretoku_taka/kst32b.lua")

XGUI = {}

__xgui_fy = 16
__xgui_fx = __xgui_fy / 2
__xgui_fm = __xgui_fy / 32

__xgui_windowsarray = {}
__xgui_windowmax = 24

__xgui_openwindowposx = 16
__xgui_openwindowposy = 16
__xgui_nowmove = nil

__xgui_x=0
__xgui_y=0
__xgui_vx=0
__xgui_vy=0

__xgui_moveorginx = 0
__xgui_moveorginy = 0

__xgui_mbx,__xgui_mby = _MX(),_MY()

function XGUI.GetRegularPoint(x,y)
	local rX,rY=0,0
	
	x=x-_HEIGHT()/2-(_WIDTH()-_HEIGHT())/2
	rX=x/_HEIGHT()*2
	
	y=_HEIGHT()/2-y
	rY=y/_HEIGHT()*2
	
	return rX,rY
end

function XGUI.GetMousePoint()
	return _MX(),_MY()
end

function XGUI.GetMouseClick()
	return _ML()
end

function XGUI.VectorStringWidth(stir)
	return string.len(stir) * __xgui_fx
end

__xgui_movex,__xgui_movey = 0,0

function XGUI.Move2D(x,y)
	--local rx,ry = XGUI.GetRegularPoint(math.floor(x+0.5) + __xgui_moveorginx,math.floor(y+0.5) + __xgui_moveorginy)
	local rx,ry = XGUI.GetRegularPoint(x + __xgui_moveorginx,y + __xgui_moveorginy)
	__xgui_movex,__xgui_movey = x,y
	_MOVE2D(rx,ry)
end

function XGUI.Line2D(x,y)
	--local rx,ry = XGUI.GetRegularPoint(math.floor(x+0.5) + __xgui_moveorginx,math.floor(y+0.5) + __xgui_moveorginy)
	local rx,ry = XGUI.GetRegularPoint(x + __xgui_moveorginx,y + __xgui_moveorginy)
	_LINE2D(rx,ry)
end

function XGUI.KST32BStroke(str)
	local i
	
	local __move = XGUI.Move2D
	local __line = XGUI.Line2D
	
	if not str then return end
	
	for i=1,string.len(str) do
		local a = string.byte(str,i)
		if a>32 and a<39 then
			__xgui_x=a-33
			__move(__xgui_x*__xgui_fm+__xgui_vx,__xgui_y*-__xgui_fm+__xgui_vy+__xgui_fy)
		elseif a>39 and a<64 then
			__xgui_x=a-34
			__move(__xgui_x*__xgui_fm+__xgui_vx,__xgui_y*-__xgui_fm+__xgui_vy+__xgui_fy)
		elseif a>63 and a<92 then
			__xgui_x=a-64
			__line(__xgui_x*__xgui_fm+__xgui_vx,__xgui_y*-__xgui_fm+__xgui_vy+__xgui_fy)
		elseif a>93 and a<96 then
			__xgui_x=a-65
			__line(__xgui_x*__xgui_fm+__xgui_vx,__xgui_y*-__xgui_fm+__xgui_vy+__xgui_fy)
		elseif a>95 and a<126 then
			__xgui_x=(a-96)
		elseif a==126 then
			__xgui_y=0
			__move(__xgui_x*__xgui_fm+__xgui_vx,__xgui_y*-__xgui_fm+__xgui_vy+__xgui_fy)
		elseif a>160 and a<192 then
			__xgui_y=a-160
			__move(__xgui_x*__xgui_fm+__xgui_vx,__xgui_y*-__xgui_fm+__xgui_vy+__xgui_fy)
		elseif a>191 and a<224 then
			__xgui_y=a-192
			__line(__xgui_x*__xgui_fm+__xgui_vx,__xgui_y*-__xgui_fm+__xgui_vy+__xgui_fy)
		elseif a==39 or a==92 or a==93 then
			__xgui_x=0
			__xgui_y=0
		end
	end
end

function XGUI.KST32BStroke3D(str,shader,shaderext)
	local i
	
	local __move = _MOVE3D
	local __line = _LINE3D
	
	for i=1,string.len(str) do
		local a = string.byte(str,i)
		if a>32 and a<39 then
			__xgui_x=a-33
			__move(shader(__xgui_x,__xgui_y,shaderext))
		elseif a>39 and a<64 then
			__xgui_x=a-34
			__move(shader(__xgui_x,__xgui_y,shaderext))
		elseif a>63 and a<92 then
			__xgui_x=a-64
			__line(shader(__xgui_x,__xgui_y,shaderext))
		elseif a>93 and a<96 then
			__xgui_x=a-65
			__line(shader(__xgui_x,__xgui_y,shaderext))
		elseif a>95 and a<126 then
			__xgui_x=(a-96)
		elseif a==126 then
			__xgui_y=0
			__move(shader(__xgui_x,__xgui_y,shaderext))
		elseif a>160 and a<192 then
			__xgui_y=a-160
			__move(shader(__xgui_x,__xgui_y,shaderext))
		elseif a>191 and a<224 then
			__xgui_y=a-192
			__line(shader(__xgui_x,__xgui_y,shaderext))
		elseif a==39 or a==92 or a==93 then
			__xgui_x=0
			__xgui_y=0
		end
	end
end

function XGUI.DrawVectorStringCenter(stir)
	__xgui_vx = __xgui_vx - XGUI.VectorStringWidth(stir) / 2
	__xgui_vy = __xgui_vy - __xgui_fy / 2
	
	XGUI.DrawVectorString(stir)
end

function XGUI.DrawVectorString(stir)
	local __stroke = XGUI.KST32BStroke
	local i
	local ji
	local tbl = __xgui_kst32b
	
	local lb = 0
	
	for i=1,string.len(stir) do
		ji = string.byte(stir,i)
		
		if lb == 0 then
			if (129 <= ji and ji <= 159) or (224 <= ji and ji <= 252) then
				lb = ji
			else
				__stroke(tbl[ji])
			end
		else
			local k,t = 0,0
			
			if 129 <= lb and lb <= 159 then
				k = (lb - 129) * 2
			else
				k = (lb - 224) * 2 + 62
			end
			
			if 64 <= ji and ji <= 126 then
				t = ji - 64
			elseif 128 <= ji and ji <= 158 then
				t = ji - 128 + 63
			else
				t = ji - 159
				k = k + 1
			end
			
			__xgui_vx = __xgui_vx - __xgui_fx
			
			__stroke(tbl[((k + 161) * 256 + (t + 161)) - 32896])
			
			lb = 0
			
			__xgui_vx = __xgui_vx + __xgui_fx
		end
		
		__xgui_vx = __xgui_vx + __xgui_fx
	end
end

function XGUI.CreateButton(w,h,x,y,t,win)
	local obj = {}
	obj.w = w
	obj.h = h
	obj.x = x
	obj.y = y
	obj.t = t
	obj.win = win
	
	return obj
end

function XGUI.CheckDrawButton(obj)
	XGUI.SetDrawColorRGB(255,255,255)
	
	XGUI.SetStringPosition(obj.x,obj.y)
	XGUI.DrawVectorStringCenter(obj.t)
	
	local ml = XGUI.GetMouseClick()
	local mx,my = XGUI.GetMousePoint()
	
	local bf = 0
	
	if
		(mx >= obj.x - obj.w / 2 + obj.win.x and mx < obj.x + obj.w / 2 + obj.win.x and my >= obj.y - obj.h / 2 + obj.win.y + 20 and my < obj.y + obj.h / 2 + obj.win.y + 20)
	then
		if ml == 1 then
			XGUI.SetDrawColorRGB(255,255,255)
			bf = 1
		else
			XGUI.SetDrawColorRGB(128,128,128)
		end
	else
		XGUI.SetDrawColorRGB(0,0,96)
	end
	
	XGUI.Move2D(obj.x-obj.w/2,obj.y-obj.h/2)
	XGUI.Line2D(obj.x+obj.w/2,obj.y-obj.h/2)
	
	XGUI.Move2D(obj.x-obj.w/2,obj.y+obj.h/2)
	XGUI.Line2D(obj.x+obj.w/2,obj.y+obj.h/2)
	
	XGUI.Move2D(obj.x-obj.w/2,obj.y-obj.h/2)
	XGUI.Line2D(obj.x-obj.w/2,obj.y+obj.h/2)
	
	XGUI.Move2D(obj.x+obj.w/2,obj.y-obj.h/2)
	XGUI.Line2D(obj.x+obj.w/2,obj.y+obj.h/2)
	
	XGUI.SetDrawColorRGB(255,255,255)
	
	return bf
end

function XGUI.CreateCheckBox(x,y,e,t,win)
	local obj = {}
	obj.e = e
	obj.f = 0
	obj.x = x
	obj.y = y
	obj.t = t
	obj.w = 16
	obj.win = win
	
	return obj
end

function XGUI.CheckDrawCheckBox(obj)
	XGUI.SetDrawColorRGB(255,255,255)
	
	XGUI.SetStringPosition(obj.x+obj.w/2+8,obj.y-__xgui_fy / 2)
	XGUI.DrawVectorString(obj.t)
	
	local ml = XGUI.GetMouseClick()
	local mx,my = XGUI.GetMousePoint()
	
	if
		(mx >= obj.x - obj.w / 2 + obj.win.x and mx < obj.x + obj.w / 2 + obj.win.x and my >= obj.y - obj.w / 2 + obj.win.y + 20 and my < obj.y + obj.w / 2 + obj.win.y + 20)
	then
		if ml == 1 then
			if obj.f == 0 then
				obj.e = math.abs(obj.e - 1)
				obj.f = 1
			end
		else
			obj.f = 0
		end
	end
	
	if obj.e == 1 then
		XGUI.Move2D(obj.x-obj.w/2,obj.y-obj.w/2)
		XGUI.Line2D(obj.x+obj.w/2,obj.y+obj.w/2)
		
		XGUI.Move2D(obj.x-obj.w/2,obj.y+obj.w/2)
		XGUI.Line2D(obj.x+obj.w/2,obj.y-obj.w/2)
	end
	
	XGUI.SetDrawColorRGB(0,0,96)
	
	XGUI.Move2D(obj.x-obj.w/2,obj.y-obj.w/2)
	XGUI.Line2D(obj.x+obj.w/2,obj.y-obj.w/2)
	
	XGUI.Move2D(obj.x-obj.w/2,obj.y+obj.w/2)
	XGUI.Line2D(obj.x+obj.w/2,obj.y+obj.w/2)
	
	XGUI.Move2D(obj.x-obj.w/2,obj.y-obj.w/2)
	XGUI.Line2D(obj.x-obj.w/2,obj.y+obj.w/2)
	
	XGUI.Move2D(obj.x+obj.w/2,obj.y-obj.w/2)
	XGUI.Line2D(obj.x+obj.w/2,obj.y+obj.w/2)
	
	XGUI.SetDrawColorRGB(255,255,255)
	
	return obj
end

function XGUI.CreateWindow(w,h,t,f,c)
	local obj = {}
	obj.w = w
	obj.h = h
	obj.x = __xgui_openwindowposx
	obj.y = __xgui_openwindowposy
	obj.t = t
	obj.f = f
	obj.c = c
	
	local n = XGUI.GetFreeWindowManager()
	
	__xgui_windowsarray[n] = obj
	
	__xgui_openwindowposx = __xgui_openwindowposx + 16
	__xgui_openwindowposy = __xgui_openwindowposy + 16
	
	if __xgui_openwindowposx > _WIDTH() - w then __xgui_openwindowposx = 0 end
	if __xgui_openwindowposy > _HEIGHT() - h then __xgui_openwindowposy = 0 end
	
	return obj
end

function XGUI.DeleteWindow(obj)
	local i
	
	for i=1,__xgui_windowmax do
		if __xgui_windowsarray[i] ~= nil then
			if __xgui_windowsarray[i] == obj then
				table.remove(__xgui_windowsarray,i)
			end
		end
	end
end

function XGUI.DrawWindowObj(obj)
	local i
	
	XGUI.SetDrawColorRGB(0,0,96)
	
	XGUI.Move2D(obj.x,obj.y)
	XGUI.Line2D(obj.x+obj.w+1,obj.y)
	
	XGUI.Move2D(obj.x,obj.y+obj.h+20)
	XGUI.Line2D(obj.x+obj.w+1,obj.y+obj.h+20)
	
	XGUI.Move2D(obj.x,obj.y)
	XGUI.Line2D(obj.x,obj.y+obj.h+20)
	
	XGUI.Move2D(obj.x+obj.w,obj.y)
	XGUI.Line2D(obj.x+obj.w,obj.y+obj.h+20)
	
	XGUI.SetDrawColorRGB(0,0,96)
	
	XGUI.Move2D(obj.x,obj.y+20)
	XGUI.Line2D(obj.x+obj.w+1,obj.y+20)
	
	for i=1,19 do
		local n = 32 * ((i-1)/18)
		XGUI.SetDrawColorRGB(128-n,128-n,128-n)
		XGUI.Move2D(obj.x+1,obj.y+i)
		XGUI.Line2D(obj.x+obj.w,obj.y+i)
	end
	
	XGUI.SetDrawColorRGB(255,255,255)
	
	XGUI.Move2D(obj.x+obj.w-20+4,obj.y+4)
	XGUI.Line2D(obj.x+obj.w-20+20-3,obj.y+20-3)
	
	XGUI.Move2D(obj.x+obj.w-20+20-4,obj.y+4)
	XGUI.Line2D(obj.x+obj.w-20+3,obj.y+20-3)
	
	XGUI.SetStringPosition(obj.x+4,obj.y+2)
	
	XGUI.DrawVectorString(obj.t)
	
	XGUI.SetDrawColorRGB(255,255,255)
end

__xgui_mbx,__xgui_mby,__xgui_mbl = 0,0,0

function XGUI.RefreshWindowManager()
	local i
	
	local ml = XGUI.GetMouseClick()
	local mx,my = XGUI.GetMousePoint()
	
	local mbx,mby = __xgui_mbx,__xgui_mby
	
	local ismove = 0
	
	for i=1,__xgui_windowmax do
		if __xgui_windowsarray[i] ~= nil then
			local obj = __xgui_windowsarray[i]
			if ml == 1 then
				if
					((mx >= obj.x and mx < obj.x + obj.w - 20 and my >= obj.y and my < obj.y + 20)
					or
					(mbx >= obj.x and mbx < obj.x + obj.w - 20 and mby >= obj.y and mby < obj.y + 20))
					and
					((__xgui_nowmove == nil or __xgui_nowmove == i)
					and
					(__xgui_mbl == 0 or __xgui_nowmove == i))
				then
					__xgui_windowsarray[i] = obj
					obj.x = obj.x + (mx - mbx)
					obj.y = obj.y + (my - mby)
					if __xgui_nowmove == nil then
						table.remove(__xgui_windowsarray,i)
						table.insert(__xgui_windowsarray,obj)
					end
					ismove = 1
					__xgui_nowmove = table.getn(__xgui_windowsarray)
					i = __xgui_windowmax
				end
				
				if
					(mx >= obj.x + obj.w - 20 and mx < obj.x + obj.w and my >= obj.y and my < obj.y + 20)
					and
					obj.c == true
				then
					XGUI.DeleteWindow(obj)
				end
			end
		end
	end
	
	for i=1,__xgui_windowmax do
		if __xgui_windowsarray[i] ~= nil then
			local obj = __xgui_windowsarray[i]
			XGUI.DrawWindowObj(obj)
			obj.f(obj)
		end
	end
	
	if ismove == 0 then
		__xgui_nowmove = nil
	end
	
	__xgui_mbx,__xgui_mby = XGUI.GetMousePoint()
	__xgui_mbl = XGUI.GetMouseClick()
end

function XGUI.GetFreeWindowManager()
	local i
	for i=1,__xgui_windowmax do
		if __xgui_windowsarray[i] == nil then
			return i
		end
	end
	return 0
end

function XGUI.WindowDrawBegin(obj)
	__xgui_moveorginx = obj.x
	__xgui_moveorginy = obj.y + 20
end

function XGUI.WindowDrawEnd()
	__xgui_moveorginx = 0
	__xgui_moveorginy = 0
	
	XGUI.SetStringSize(16)
end

function XGUI.SetStringPosition(x,y)
	__xgui_vx=x
	__xgui_vy=y
end

function XGUI.GetStringPosition()
	return __xgui_vx,__xgui_vy
end

function XGUI.SetWindowPosition(obj,x,y)
	obj.x=x
	obj.y=y
end

function XGUI.SetStringSize(d)
	__xgui_fy = d
	__xgui_fx = __xgui_fy / 2
	__xgui_fm = __xgui_fy / 32
end

function XGUI.GetStringSize()
	return __xgui_fy
end

function XGUI.GetWindowPosition(obj)
	return obj.x,_obj.y
end

function XGUI.SetDrawColorRGB(r,g,b)
	_SETCOLOR(math.floor(r)*65536+math.floor(g)*256+math.floor(b))
end

function XGUI.SetDrawColorINT(rgb)
	_SETCOLOR(math.floor(rgb))
end

function XGUI.DrawVectorString3D(stir,shader,shaderext)
	local __stroke = XGUI.KST32BStroke3D
	local i
	local ji
	local tbl = __xgui_kst32b
	
	local lb = 0
	
	for i=1,string.len(stir) do
		ji = string.byte(stir,i)
		
		if lb == 0 then
			if (129 <= ji and ji <= 159) or (224 <= ji and ji <= 252) then
				lb = ji
			else
				__stroke(tbl[ji],shader,shaderext)
			end
		else
			local k,t = 0,0
			
			if 129 <= lb and lb <= 159 then
				k = (lb - 129) * 2
			else
				k = (lb - 224) * 2 + 62
			end
			
			if 64 <= ji and ji <= 126 then
				t = ji - 64
			elseif 128 <= ji and ji <= 158 then
				t = ji - 128 + 63
			else
				t = ji - 159
				k = k + 1
			end
			
			__xgui_vx = __xgui_vx - __xgui_fx
			
			__stroke(tbl[((k + 161) * 256 + (t + 161)) - 32896],shader,shaderext)
			
			lb = 0
			
			__xgui_vx = __xgui_vx + __xgui_fx
		end
		
		__xgui_vx = __xgui_vx + __xgui_fx
	end
end