-- XGL version 1.0.0.1

XGL={}

function XGL.GenHash(s)
	local i,j
	j = 0
	for i=1,string.len(s) do
		j = j + string.byte(s,i)
	end
	return string.format("H_%08x_mqo",j)
end

function XGL.Draw(m,f,e)
	if __jit ~= nil then __jit(f,e) return m.g_Polnum_a end
	
	local i, j, u, v, w
	local x, y, z
	w = 0
	
	local jit = "return function(f,e) "
	
	for i = 0,m.g_Polnum_a-1 do
		_SETCOLOR(m.g_Polcol[i+1])
		for j = 0,m.g_Polnum[i+1] do
			u = w + j
			v = w + math.mod((j + 1),m.g_Polnum[i+1])
			x = m.g_Vertex[m.g_Vindex[v+1]*3+0+1]
			y = m.g_Vertex[m.g_Vindex[v+1]*3+1+1]
			z = m.g_Vertex[m.g_Vindex[v+1]*3+2+1]
			--x,y,z=f(x,y,z,e)
			if j == 0 then jit = jit .. string.format("_MOVE3D(%f,%f,%f,e) ", x, y, z)
			else  jit = jit .. string.format("_LINE3D(%f,%f,%f,e) ", x, y, z) end
		end
		w = w + m.g_Polnum[i+1]
	end
	
	jit = jit .. "end"
	
	__jit = loadstring(jit)()
	
	__jit(f,e)
	
	return m.g_Polnum_a
end
