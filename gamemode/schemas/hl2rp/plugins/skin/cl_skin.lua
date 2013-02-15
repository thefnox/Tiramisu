--Speed boost!
local surface = surface
local draw = draw
local Color = Color
local gradient = surface.GetTextureID("gui/gradient")
local matBlurScreen = Material( "pp/blurscreen" ) 
local gradientUp = surface.GetTextureID("gui/gradient_up")

local SKIN = derma.GetNamedSkin( "Tiramisu" )

surface.CreateFont( "TiramisuHL2RPFont1",
{

	font		= "Bebas Neue",
	size		= 128,
	antialias	= true,
	weight		= 500

} )

function SKIN:InitIntro()
	local introsound = Sound( "music/HL1_song11.mp3" )
	introsound = CreateSound(LocalPlayer(), introsound)
	introsound:Play()
	
	CAKE.IntroStage1 = false
	CAKE.IntroStage2 = false
	CAKE.IntroStage3 = false
	CAKE.IntroStage4 = false
	CAKE.IntroStage1Alpha = 0
	CAKE.IntroStage2Alpha = 0
	CAKE.IntroStage3Alpha = 0
	timer.Create( "IntroStage1", 1, 1, function()
		CAKE.IntroSkippable = true
		CAKE.IntroStage1 = true
		CAKE.IntroStage2 = true
	end)
	timer.Create( "IntroStage2", 3, 1, function()
	end)
	timer.Create( "IntroStage3", 5, 1, function()
		CAKE.IntroStage3 = true
	end)
	timer.Create( "IntroStage4", 9, 1, function()
		CAKE.IntroStage1 = false
		CAKE.IntroStage2 = false
		CAKE.IntroStage3 = false
		CAKE.IntroStage4 = true
		introsound:FadeOut(2)
	end)
	timer.Create( "IntroStage5", 12, 1, function()
		CAKE.EndIntro()
	end)
end

function SKIN:DestroyIntro()
	--You may be pondering why this one hook exists.
	--It's what allows you to make intro's skippable, this is where you destroy all remnants of the intro.
	if introsound then
		introsound:Stop()
	end
	timer.Destroy( "IntroStage1" )
	timer.Destroy( "IntroStage2" )
	timer.Destroy( "IntroStage3" )
	timer.Destroy( "IntroStage4" )
	timer.Destroy( "IntroStage5" )
end

function SKIN:PaintIntro()
	if CAKE.IntroStage1 then
		CAKE.IntroStage1Alpha = Lerp(0.1 * RealFrameTime(), CAKE.IntroStage1Alpha, 255 )
	end
	if CAKE.IntroStage2 then
		CAKE.IntroStage2Alpha = Lerp(0.1 * RealFrameTime(), CAKE.IntroStage2Alpha, 255 )
	end
	if CAKE.IntroStage3 then
		CAKE.IntroStage3Alpha = Lerp(1.5 * RealFrameTime(), CAKE.IntroStage3Alpha, 255 )
	end
	if CAKE.IntroStage4 then
		CAKE.IntroStage1Alpha = Lerp(3 * RealFrameTime(), CAKE.IntroStage1Alpha, 0 )
		CAKE.IntroStage2Alpha = Lerp(3 * RealFrameTime(), CAKE.IntroStage2Alpha, 0 )
		CAKE.IntroStage3Alpha = Lerp(2 * RealFrameTime(), CAKE.IntroStage3Alpha, 0 )
	end

	draw.SimpleTextOutlined( "Tiramisu 2", "Tiramisu64Font", ScrW()/2, ScrH() /2 - 50, Color(255,255,255,CAKE.IntroStage1Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,math.max(CAKE.IntroStage1Alpha, 130)))
	draw.SimpleTextOutlined( "HALF LIFE 2 RP", "TiramisuHL2RPFont1", ScrW()/2 + math.random(-10,10), ScrH() /2 + math.random(-10,10), Color(100,100,100,CAKE.IntroStage2Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,math.max(CAKE.IntroStage2Alpha, 130)))
	draw.SimpleTextOutlined( "HALF LIFE 2 RP", "TiramisuHL2RPFont1", ScrW()/2, ScrH() /2, Color(255,255,255,CAKE.IntroStage2Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,math.max(CAKE.IntroStage2Alpha, 130)))
	//draw.SimpleTextOutlined( "Freeform", "Tiramisu24Font", ScrW()/2, ScrH() / 2 + 10, Color(100,149,237,CAKE.IntroStage3Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,math.max(CAKE.IntroStage3Alpha, 130)))
end


function SKIN:PaintTiramisuClock()
	if CAKE.MenuOpen then
		draw.SimpleTextOutlined( LocalPlayer():Nick(), "TiramisuNamesFont", ScrW() - 10, 30, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT, 1, Color(0,0,0,180))
		draw.SimpleTextOutlined( LocalPlayer():Title(), "TiramisuNamesFont", ScrW() - 10, 50, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT, 1, Color(0,0,0,180))
	end
end

derma.DefineSkin( "TiramisuFreeform", "Custom skin for the freeform schema", SKIN )
CAKE.Skin = "TiramisuFreeform"