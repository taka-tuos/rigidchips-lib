XHUD = {}

function XHUD.Draw()
	XGUI.SetDrawColorRGB(0,255,0)
	
	XHUD.DrawDigits(_WIDTH()-128,_HEIGHT()/2-16,32,_Y(0))
	
	XHUD.DrawDigits(128-(32/2+32/8)*4,_HEIGHT()/2-32,32,_VEL()*3.6)
	
	if _slim then XHUD.DrawDigits(128-(32/2+32/8)*4,_HEIGHT()/2+4,32,_slim) end
	
	out(5,_CHAT())
end

function XHUD.DrawDigits(x,y,s,n)
	x = x + (s/2 + s/8)*4
	while math.floor(n) > 0 do
		local d = math.floor(math.mod(n,10))
		XHUD.DrawDigit[d](x,y,s)
		x = x - s/2 - s/8
		n = n / 10
	end
end

XHUD.DrawDigit={
[0]=function(x,y,s)
	--左の縦線
	XGUI.Move2D(x,y)
	XGUI.Line2D(x,y+s)

	--右の縦線
	XGUI.Move2D(x+s/2,y)
	XGUI.Line2D(x+s/2,y+s)

	--上の横線
	XGUI.Move2D(x,y)
	XGUI.Line2D(x+s/2,y)

	--下の横線
	XGUI.Move2D(x,y+s)
	XGUI.Line2D(x+s/2,y+s)
end,
[1]=function(x,y,s)
	--右の縦線
	XGUI.Move2D(x+s/2,y)
	XGUI.Line2D(x+s/2,y+s)
end,
[2]=function(x,y,s)
	--左の縦線
	XGUI.Move2D(x,y+s/2)
	XGUI.Line2D(x,y+s)

	--右の縦線
	XGUI.Move2D(x+s/2,y)
	XGUI.Line2D(x+s/2,y+s/2)

	--上の横線
	XGUI.Move2D(x,y)
	XGUI.Line2D(x+s/2,y)

	--真ん中の横線
	XGUI.Move2D(x,y+s/2)
	XGUI.Line2D(x+s/2,y+s/2)

	--下の横線
	XGUI.Move2D(x,y+s)
	XGUI.Line2D(x+s/2,y+s)
end,
[3]=function(x,y,s)
	--右の縦線
	XGUI.Move2D(x+s/2,y)
	XGUI.Line2D(x+s/2,y+s)

	--上の横線
	XGUI.Move2D(x,y)
	XGUI.Line2D(x+s/2,y)

	--真ん中の横線
	XGUI.Move2D(x,y+s/2)
	XGUI.Line2D(x+s/2,y+s/2)

	--下の横線
	XGUI.Move2D(x,y+s)
	XGUI.Line2D(x+s/2,y+s)
end,
[4]=function(x,y,s)
	--左の縦線
	XGUI.Move2D(x,y)
	XGUI.Line2D(x,y+s/2)

	--右の縦線
	XGUI.Move2D(x+s/2,y)
	XGUI.Line2D(x+s/2,y+s)

	--真ん中の横線
	XGUI.Move2D(x,y+s/2)
	XGUI.Line2D(x+s/2,y+s/2)
end,
[5]=function(x,y,s)
	--左の縦線
	XGUI.Move2D(x,y)
	XGUI.Line2D(x,y+s/2)

	--右の縦線
	XGUI.Move2D(x+s/2,y+s/2)
	XGUI.Line2D(x+s/2,y+s)

	--上の横線
	XGUI.Move2D(x,y)
	XGUI.Line2D(x+s/2,y)

	--真ん中の横線
	XGUI.Move2D(x,y+s/2)
	XGUI.Line2D(x+s/2,y+s/2)

	--下の横線
	XGUI.Move2D(x,y+s)
	XGUI.Line2D(x+s/2,y+s)
end,
[6]=function(x,y,s)
	--左の縦線
	XGUI.Move2D(x,y)
	XGUI.Line2D(x,y+s)

	--右の縦線
	XGUI.Move2D(x+s/2,y+s/2)
	XGUI.Line2D(x+s/2,y+s)

	--上の横線
	XGUI.Move2D(x,y)
	XGUI.Line2D(x+s/2,y)

	--真ん中の横線
	XGUI.Move2D(x,y+s/2)
	XGUI.Line2D(x+s/2,y+s/2)

	--下の横線
	XGUI.Move2D(x,y+s)
	XGUI.Line2D(x+s/2,y+s)
end,
[7]=function(x,y,s)
	--右の縦線
	XGUI.Move2D(x+s/2,y)
	XGUI.Line2D(x+s/2,y+s)

	--上の横線
	XGUI.Move2D(x,y)
	XGUI.Line2D(x+s/2,y)
end,
[8]=function(x,y,s)
	--左の縦線
	XGUI.Move2D(x,y)
	XGUI.Line2D(x,y+s)

	--右の縦線
	XGUI.Move2D(x+s/2,y)
	XGUI.Line2D(x+s/2,y+s)

	--上の横線
	XGUI.Move2D(x,y)
	XGUI.Line2D(x+s/2,y)

	--真ん中の横線
	XGUI.Move2D(x,y+s/2)
	XGUI.Line2D(x+s/2,y+s/2)

	--下の横線
	XGUI.Move2D(x,y+s)
	XGUI.Line2D(x+s/2,y+s)
end,
[9]=function(x,y,s)
	--左の縦線
	XGUI.Move2D(x,y)
	XGUI.Line2D(x,y+s/2)

	--右の縦線
	XGUI.Move2D(x+s/2,y)
	XGUI.Line2D(x+s/2,y+s)

	--上の横線
	XGUI.Move2D(x,y)
	XGUI.Line2D(x+s/2,y)

	--真ん中の横線
	XGUI.Move2D(x,y+s/2)
	XGUI.Line2D(x+s/2,y+s/2)

	--下の横線
	XGUI.Move2D(x,y+s)
	XGUI.Line2D(x+s/2,y+s)
end,
}
