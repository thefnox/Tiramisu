CAKE.OnIntro = false
CAKE.IntroReplay = false
CAKE.IntroSkippable = false

function CAKE.StartIntro( replay )
	CAKE.IntroReplay = replay
	CAKE.OnIntro = true
	derma.SkinHook( "Init", "Intro" )
end

function CAKE.SkipIntro()
	if CAKE.IntroSkippable then
		CAKE.EndIntro()
	end
end

function CAKE.EndIntro()
	derma.SkinHook( "Destroy", "Intro" )
	CAKE.OnIntro = false
	CAKE.IntroSkippable = false
	OpenCharacterMenu( !CAKE.IntroReplay )
	CAKE.IntroReplay = false
end

hook.Add( "PlayerBindPress", "TiramisuPlayerBindSkipIntro", function(ply, bind, press)
	if string.match(bind, "jump") and press then
		CAKE.SkipIntro()
	end
end)

hook.Add("Think", "TiramisuIntroThink", function()
	if CAKE.OnIntro then
		derma.SkinHook( "Think", "Intro" )
	end
end)

local alpha = 0
local onintro = false
local blackscreenalpha = 255
hook.Add("PostRenderVGUI", "TiramisuIntroDraw", function()
	if CAKE.OnIntro then
		onintro = true
		derma.SkinHook( "Paint", "Intro" )
		if CAKE.IntroSkippable then
			alpha = Lerp(RealFrameTime() * 5, alpha, 255 )
			draw.SimpleTextOutlined( "Press    SPACE    to    skip    intro", "Tiramisu24Font", ScrW()/2, ScrH() - 50, Color(255,255,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,math.max(alpha, 130)))
		end
	elseif !CAKE.OnIntro and onintro and blackscreenalpha != 0 then
		blackscreenalpha = Lerp( RealFrameTime() * 2, blackscreenalpha, 0 )
		surface.SetDrawColor( 0, 0, 0, blackscreenalpha )
		surface.DrawRect( -1, -1, ScrW() + 1, ScrH() + 1 )
	end	
end)