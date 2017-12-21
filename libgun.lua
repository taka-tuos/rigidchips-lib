-- LIBGUN 1.0

Gun = {}

function Gun.Create(func,n,rawtable)
	local obj = {}
	
	obj.op = rawtable.op
	obj.mx = rawtable.an
	obj.an = rawtable.ang
	
	obj.raw = rawtable
	
	obj.en = false
	
	obj.tv = {}
	obj.v = 0
	obj.vx=(rawtable.op+5000)/(5000*rawtable.an)
	
	
	local i
	
	for i=1,rawtable.an do
		obj.tv[i] = rawtable.ang
	end
	
	obj.tv[1] = 0
	
	obj.Fire = function(self)
		self.en = true
		return self
	end
	
	obj.UnFire = function(self)
		self.en = false
		return self
	end
	
	obj.isEnabled = function(self)
		return self.en
	end
	
	obj.Step = function(self)
		local i
		
		for i=0,obj.mx-1 do
			_G['G'..i]=0
		end
		
		if obj.raw.func(obj.raw.fire) == 1 and _E(_G['A'..self.v]) == _OPTION(_G['A'..self.v]) and _G['V'..self.v] == 0 then
			_G['G'..self.v]=_OPTION(_G['A'..self.v])
			self.v=math.mod(self.v+1,obj.mx)
			for i=1,self.mx do
				self.tv[i] = self.an
			end
			self.tv[self.v+1]=0
		end
		
		for i=0,self.mx-1 do
			_G['V'..i]=_LINER(_G['V'..i],self.tv[i+1],math.abs(self.an/self.vx))
		end
		return self
	end
	
	return obj
end
