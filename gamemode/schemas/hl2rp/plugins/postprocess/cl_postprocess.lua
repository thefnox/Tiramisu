local perc
local bloommultiply
local blurmultiply
local tab = {}

local function HL2RPPostProcess()
	
	tab[ "$pp_colour_addr" ] = 0
	tab[ "$pp_colour_addg" ] = 0
	tab[ "$pp_colour_addb" ] = 0
	tab[ "$pp_colour_brightness" ] = 0
	tab[ "$pp_colour_contrast" ] = 1
	tab[ "$pp_colour_colour" ] = 1
	tab[ "$pp_colour_mulr" ] = 0
	tab[ "$pp_colour_mulg" ] = 0
	tab[ "$pp_colour_mulb" ] = 0
	blurmultiply = 0
	if LocalPlayer():Health() < 40 and LocalPlayer():GetNWInt("deathmode", 0 ) == 0 and LocalPlayer():Alive() then
		perc = ( LocalPlayer():Health() - 40 ) * -0.4
		blurmultiply = 1 - perc
		tab[ "$pp_colour_colour" ] = perc
	end

	DrawColorModify( tab )
	DrawSharpen( blurmultiply, 1)
	DrawMotionBlur( 0.4, blurmultiply, 0 )
 
end
--hook.Add( "RenderScreenspaceEffects", "HL2RPPostProcess", HL2RPPostProcess )