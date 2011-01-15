CLPLUGIN.Name = "Post Process Effects"
CLPLUGIN.Author = "F-Nox/Big Bang"

function CLPLUGIN.Init()
	
end

function DrawDeathMeter( )

	local timeleft = LocalPlayer( ):GetNWInt( "deathmoderemaining" );

	/*
	draw.DrawText( "You have been mortally wounded. Type !acceptdeath to respawn ( You will lose your weapons )", "ChatFont", ScrW( ) / 2 - 250, 25 - 5, Color( 255,255,255,255 ), 0 );
	draw.DrawText( "Or wait " .. tostring( timeleft ) .. " seconds" , "ChatFont", ScrW( ) / 2 - 93, 50 - 5, Color( 255,255,255,255 ), 0 );*/
	draw.DrawText( "You have been mortally wounded. Wait " .. tostring( timeleft ) .. " seconds", "ChatFont", ScrW( ) / 2 - 250, 25 - 5, Color( 255,255,255,255 ), 0 )
	
	
	
end

function UnconciousMeter( )

	local timeleft = 10 - LocalPlayer( ):GetNWInt( "unconciousmoderemaining" )

	draw.DrawText( "You have been knocked out. Type 'rp_wakeup' on console.", "ChatFont", ScrW( ) / 2 - 250, 25 - 5, Color( 255,255,255,255 ), 0 );
	
end

local function DrawDeathMessages()

	if LocalPlayer():GetNWInt("deathmode", 0 ) == 1 then
		DrawDeathMeter( )
	end
	
	if LocalPlayer():GetNWBool("unconciousmode", false ) then
		UnconciousMeter( )
	end

end
hook.Add( "HUDPaint", "TiramisuDeathMessages", DrawDeathMessages )

hook.Add( "RenderScreenspaceEffects", "Tiramisu: Turn Off PostProcess", function()
	
	if CAKE.MenuOpen then
		/*
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
		--DrawColorModify( tab )*/
		DrawBloom( 0, 0, 5, 5, 14, 1, 1, 1, 1 )
		DrawSharpen( 0, 1)
		DrawMotionBlur( 0.4, 0, 0 )
	end
 
end)