CLPLUGIN.Name = "Post Process Effects"
CLPLUGIN.Author = "F-Nox/Big Bang"

function CLPLUGIN.Init()
	
end

function DrawDeathMeter( )

	local timeleft = LocalPlayer( ):GetNWInt( "deathmoderemaining" );
	local w = ( timeleft / 120 ) * 198

	draw.DrawText( "You have been mortally wounded. Type !acceptdeath to respawn ( You will lose your weapons )", "ChatFont", ScrW( ) / 2 - 250, 25 - 5, Color( 255,255,255,255 ), 0 );
	draw.DrawText( "Or wait " .. tostring( timeleft ) .. " seconds" , "ChatFont", ScrW( ) / 2 - 93, 50 - 5, Color( 255,255,255,255 ), 0 );
	
end

function UnconciousMeter( )

	local timeleft = 20 - LocalPlayer( ):GetNWInt( "unconciousmoderemaining" )

	draw.DrawText( "You have been knocked out.", "ChatFont", ScrW( ) / 2 - 250, 25 - 5, Color( 255,255,255,255 ), 0 );
	draw.DrawText( "Wait " .. tostring( timeleft ) .. " seconds" , "ChatFont", ScrW( ) / 2 - 93, 50 - 5, Color( 255,255,255,255 ), 0 );
	
end

local function DrawDeathMessages()

	if LocalPlayer():GetNWInt("deathmode", 0 ) == 1 then
		DrawDeathMeter( )
	end
	
	if LocalPlayer():GetNWInt("unconciousmode", 0 ) == 1 then
		UnconciousMeter( )
	end

end
hook.Add( "HUDPaint", "TiramisuDeathMessages", DrawDeathMessages )

local function DrawWhiteScreen()
	if CAKE.UseWhiteScreen:GetBool() then
		if LocalPlayer():GetNWInt("deathmode", 0 ) == 1 then
			local matWhite = CreateMaterial( "white", "UnlitGeneric", {
				[ "$basetexture" ] = "lights/white"
			} )
			render.SetMaterial( matWhite )
			render.DrawScreenQuad()
			render.ClearDepth()
			if ValidEntity( CAKE.ViewRagdoll ) then
				CAKE.ViewRagdoll:DrawModel()
				CAKE.ViewRagdoll:DrawShadow()
				for k, v in pairs (CAKE.ViewRagdoll.Clothing) do
					v:DrawModel()
					v:DrawShadow()
				end
			end
		else
			if CAKE.MenuOpen and CAKE.ActiveTab != "Character Editor" and LocalPlayer():GetNWInt("unconciousmode", 0 ) == 0 then
				local matWhite = CreateMaterial( "white", "UnlitGeneric", {
					[ "$basetexture" ] = "lights/white"
				} )
				render.SetMaterial( matWhite )
				render.DrawScreenQuad()
				render.ClearDepth()
				LocalPlayer():DrawModel()
				if CAKE.ClothingTbl then
					for k, v in pairs( CAKE.ClothingTbl ) do
						if ValidEntity( v ) then
							v:DrawModel()
						end
					end
				end
				if CAKE.Gear then
					for k, v in pairs( CAKE.Gear ) do
						if v["entity"] and ValidEntity( v["entity"] ) then
							v["entity"]:DrawModel()
						end
					end
				end
			elseif LocalPlayer():GetNWInt("unconciousmode", 0 ) == 1 then
				local matBlack = CreateMaterial( "black", "UnlitGeneric", {
					[ "$basetexture" ] = "vgui/black"
				} )
				render.SetMaterial( matBlack )
				render.DrawScreenQuad()
				render.ClearDepth()
				if ValidEntity( CAKE.ViewRagdoll ) then
					CAKE.ViewRagdoll:DrawModel()
					CAKE.ViewRagdoll:DrawShadow()
					if CAKE.ViewRagdoll.Clothing then
						for k, v in pairs (CAKE.ViewRagdoll.Clothing) do
							v:DrawModel()
							v:DrawShadow()
						end
					end
				end
			end
		end
	end
end
hook.Add( "PostDrawOpaqueRenderables", "DrawWhiteScreen", DrawWhiteScreen )

hook.Add( "RenderScreenspaceEffects", "Tiramisu: Turn Off PostProcess", function()
	
	if CAKE.MenuOpen then
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
		DrawColorModify( tab )
		DrawBloom( 0, 0, 5, 5, 14, 1, 1, 1, 1 )
		DrawSharpen( 0, 1)
		DrawMotionBlur( 0.4, 0, 0 )
	end
 
end)