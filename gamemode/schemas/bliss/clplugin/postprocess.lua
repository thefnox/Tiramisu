CLPLUGIN.Name = "Post Process Effects"
CLPLUGIN.Author = "F-Nox/Big Bang"

function CLPLUGIN.Init()
	
end

local perc
local bloommultiply
local blurmultiply

local function TiramisuPostProcess()
	
	local tab = {}
	tab[ "$pp_colour_addr" ] = 0
	tab[ "$pp_colour_addg" ] = 0
	tab[ "$pp_colour_addb" ] = 0
	tab[ "$pp_colour_brightness" ] = 0
	tab[ "$pp_colour_contrast" ] = 1
	tab[ "$pp_colour_colour" ] = 1
	tab[ "$pp_colour_mulr" ] = 0
	tab[ "$pp_colour_mulg" ] = 0
	tab[ "$pp_colour_mulb" ] = 0
	bloommultiply = 0
	blurmultiply = 0
	if LocalPlayer():Health() < 61 and LocalPlayer():GetNWInt("deathmode", 0 ) != 1 and LocalPlayer():Alive()  then
		perc = LocalPlayer():Health() / 60 
		bloommultiply = ( ( 1 - perc ) * 1 ) + 0.11
		blurmultiply = 1 - perc
		tab[ "$pp_colour_colour" ] = perc
	end
	DrawColorModify( tab )
	DrawBloom( 0.34, bloommultiply, 5, 5, 14, 1, 1, 1, 1 )
	DrawSharpen( blurmultiply, 1)
	DrawMotionBlur( 0.4, blurmultiply, 0 )
 
end
hook.Add( "RenderScreenspaceEffects", "TiramisuPostProcess", TiramisuPostProcess )