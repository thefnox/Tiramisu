--Speed boost!
local surface = surface
local draw = draw
local Color = Color
local gradient = surface.GetTextureID("gui/gradient")
local matBlurScreen = Material( "pp/blurscreen" ) 
local gradientUp = surface.GetTextureID("gui/gradient_up")

local SKIN = derma.GetNamedSkin( "Tiramisu" )

function SKIN:PaintIntro()
	if TIRA.IntroStage1 then
		TIRA.IntroStage1Alpha = Lerp(1.5 * RealFrameTime(), TIRA.IntroStage1Alpha, 255 )
	end
	if TIRA.IntroStage2 then
		TIRA.IntroStage2Alpha = Lerp(1.5 * RealFrameTime(), TIRA.IntroStage2Alpha, 255 )
	end
	if TIRA.IntroStage3 then
		TIRA.IntroStage3Alpha = Lerp(1.5 * RealFrameTime(), TIRA.IntroStage3Alpha, 255 )
	end
	if TIRA.IntroStage4 then
		TIRA.IntroStage1Alpha = Lerp(2 * RealFrameTime(), TIRA.IntroStage1Alpha, 0 )
		TIRA.IntroStage2Alpha = Lerp(2 * RealFrameTime(), TIRA.IntroStage2Alpha, 0 )
		TIRA.IntroStage3Alpha = Lerp(2 * RealFrameTime(), TIRA.IntroStage3Alpha, 0 )
	end

	draw.SimpleTextOutlined( "Tiramisu", "Tiramisu64Font", ScrW()/2-20, ScrH() /2 - 50, Color(255,255,255,TIRA.IntroStage1Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,math.max(TIRA.IntroStage1Alpha, 130)))
	draw.SimpleTextOutlined( "                       2", "Tiramisu64Font", ScrW()/2, ScrH() /2 - 50, Color(255,0,0,TIRA.IntroStage2Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,math.max(TIRA.IntroStage2Alpha, 130)))
	draw.SimpleTextOutlined( "Freeform", "Tiramisu24Font", ScrW()/2, ScrH() / 2 + 10, Color(100,149,237,TIRA.IntroStage3Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,math.max(TIRA.IntroStage3Alpha, 130)))
end


function SKIN:PaintTiramisuClock()
	if TIRA.MenuOpen then
		draw.SimpleTextOutlined( LocalPlayer():Nick(), "TiramisuNamesFont", ScrW() - 10, 30, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT, 1, Color(0,0,0,180))
		draw.SimpleTextOutlined( LocalPlayer():Title(), "TiramisuNamesFont", ScrW() - 10, 50, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT, 1, Color(0,0,0,180))
	end
end

derma.DefineSkin( "TiramisuFreeform", "Custom skin for the freeform schema", SKIN )
TIRA.Skin = "TiramisuFreeform"