-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- cl_hud.lua 
-- General HUD stuff.
-------------------------------

LocalPlayer( ).MyModel = "" -- Has to be blank for the initial value, so it will create a spawnicon in the first place.

surface.CreateFont( "ChatFont", 22, 100, true, false, "PlInfoFont" );

local function DrawTime( )

	draw.DrawText( GetGlobalString( "time" ), "PlInfoFont", 10, 10, Color( 255,255,255,255 ), 0 );
	
end

function DrawTargetInfo( )
	
	local tr = LocalPlayer( ):GetEyeTrace( )
	
	if( !tr.HitNonWorld ) then return; end
	
	if( tr.Entity:GetClass( ) == "item_prop" and tr.Entity:GetPos( ):Distance( LocalPlayer( ):GetPos( ) ) < 100 ) then
	
		local screenpos = tr.Entity:GetPos( ):ToScreen( )
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "ChatFont", screenpos.x + 2, screenpos.y + 2, Color( 0, 0, 0, 255 ), 1 );	
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "ChatFont", screenpos.x, screenpos.y, Color( 255, 255, 255, 255 ), 1 );
		draw.DrawText( tr.Entity:GetNWString( "Description" ), "ChatFont", screenpos.x + 2, screenpos.y + 22, Color( 0, 0, 0, 255 ), 1 );	
		draw.DrawText( tr.Entity:GetNWString( "Description" ), "ChatFont", screenpos.x, screenpos.y + 20, Color( 255, 255, 255, 255 ), 1 );

	end
	
end
		
function GM:HUDShouldDraw( name )

	if( LocalPlayer( ):GetNWInt( "charactercreate" ) == 1 or LocalPlayer( ):GetNWInt( "charactercreate" ) == nil ) then return false; end
	
	local nodraw = 
	{ 
	
		"CHudHealth",
		"CHudAmmo",
		"CHudSecondaryAmmo",
		"CHudBattery",
	
	 }
	
	for k, v in pairs( nodraw ) do
	
		if( name == v ) then return false; end
	
	end
	
	return true;

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

function DrawPlayerInfo( )
	
	local position
	local screenpos
	local trace
	local alpha
	local tracedata
	local dist
	local rendered = {}
	for k, v in pairs( player.GetAll( ) ) do	
		if( v != LocalPlayer( ) and !v:GetNWBool( "observe" )) then
			if( v:Alive( ) ) then
				alpha = 0
				tracedata = {}
				tracedata.start = LocalPlayer():GetShootPos()
				tracedata.endpos = v:GetPos()
				tracedata.filter = LocalPlayer()
				tracedata.mask = MASK_SOLID_BRUSHONLY
				trace = util.TraceLine( tracedata )
				position = v:GetPos()
				if v:GetBonePosition( v:LookupBone("ValveBiped.Bip01_Head1") ) then
					position = v:GetBonePosition( v:LookupBone("ValveBiped.Bip01_Head1") )
					position = Vector( position.x, position.y, position.z + 13 )
				else
					position = Vector( position.x, position.y, position.z + 100 )
				end
				screenpos = position:ToScreen( )
				dist = position:Distance( LocalPlayer( ):GetPos( ) )
				dist = dist / 2
				dist = math.floor( dist )
				
				if !trace.HitWorld then
					if( dist > 100 ) then
						alpha = 255 - ( dist - 100 )
					else
						alpha = 255
					end
				
					if( alpha > 255 ) then
						alpha = 255
					elseif( alpha < 0 ) then
						alpha = 0
					end
					draw.DrawText( v:Nick( ), "DefaultSmall", screenpos.x, screenpos.y, Color( 255, 255, 255, alpha ), 1 )
					draw.DrawText( v:GetNWString( "title", "Connecting.." ), "DefaultSmall", screenpos.x, screenpos.y + 10, Color( 255, 255, 255, alpha ), 1 )
					draw.DrawText( v:GetNWString( "title2", "Connecting.." ), "DefaultSmall", screenpos.x, screenpos.y + 20, Color( 255, 255, 255, alpha ), 1 )
				
					if( v:GetNWInt( "chatopen" ) == 1 ) then
						draw.DrawText( "Typing..", "ChatFont", screenpos.x, screenpos.y - 50, Color( 255, 255, 255, alpha ), 1 )
					end
					
					table.insert( rendered, v )
				end
			end
		end
	end
	
	local closeplayers = ents.FindInSphere( LocalPlayer():GetPos(), 120 )
	for k, v in pairs( closeplayers ) do
		if v:IsPlayer() and LocalPlayer() != v then
			if !table.HasValue( rendered, v ) then
					position = v:GetPos()
					if v:GetBonePosition( v:LookupBone("ValveBiped.Bip01_Head1") ) then
						position = v:GetBonePosition( v:LookupBone("ValveBiped.Bip01_Head1") )
						position = Vector( position.x, position.y, position.z + 13 )
					else
						position = Vector( position.x, position.y, position.z + 100 )
					end
					screenpos = position:ToScreen( )
					draw.DrawText( v:Nick( ), "DefaultSmall", screenpos.x, screenpos.y, Color( 255, 255, 255, 255 ), 1 )
					draw.DrawText( v:GetNWString( "title", "Connecting.." ), "DefaultSmall", screenpos.x, screenpos.y + 10, Color( 255, 255, 255, 255 ), 1 )
					draw.DrawText( v:GetNWString( "title2", "Connecting.." ), "DefaultSmall", screenpos.x, screenpos.y + 20, Color( 255, 255, 255, 255 ), 1 )
				
					if( v:GetNWInt( "chatopen" ) == 1 ) then
						draw.DrawText( "Typing..", "ChatFont", screenpos.x, screenpos.y - 50, Color( 255, 255, 255, 255 ), 1 )
					end
			
			end
		end
	end
	
end

function GM:HUDPaint( )
	
	--DrawTime( );
	DrawPlayerInfo( );
	DrawTargetInfo( );
	if LocalPlayer():GetNWInt("deathmode", 0 ) == 1 then
		DrawDeathMeter( )
	end
	
	if LocalPlayer():GetNWInt("unconciousmode", 0 ) == 1 then
		UnconciousMeter( )
	end
	
end

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
			if CAKE.MenuOpen and LocalPlayer():GetNWInt("unconciousmode", 0 ) == 0 then
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
					for k, v in pairs (CAKE.ViewRagdoll.Clothing) do
						v:DrawModel()
						v:DrawShadow()
					end
				end
			end
		end
	end
end
hook.Add( "PostDrawOpaqueRenderables", "DrawWhiteScreen", DrawWhiteScreen )

local function EditGear( handler, id, encoded, decoded )

	local ent = ents.GetByIndex( decoded.entity )

	--Dermadesigner!
	local PosZ
	local AngleR
	local AngleY
	local AngleP
	local PosY
	local PosX
	local GearFrame
	local originalpos = ent:GetDTVector( 4 )
	local originalang = ent:GetDTAngle( 3 )

	GearFrame = vgui.Create('DFrame')
	GearFrame:SetSize(179, 270)
	GearFrame:Center()
	GearFrame:SetTitle('Set Gear Offsets')
	GearFrame:SetSizable(true)
	GearFrame:SetDeleteOnClose(true)
	GearFrame:MakePopup()

	PosX = vgui.Create('DNumSlider')
	PosX:SetSize(154, 40)
	PosX:SetParent(GearFrame)
	PosX:SetPos(19, 25)
	PosX:SetDecimals(0)
	PosX.OnMouseReleased = function() end
	PosX.OnValueChanged = function() local pos = ent:GetDTVector( 4 ) ent:SetDTVector( 4, Vector( PosX:GetValue(), pos.y, pos.z ) ) end
	PosX:SetMinMax( -100, 100)

	PosY = vgui.Create('DNumSlider')
	PosY:SetSize(154, 40)
	PosY:SetParent(GearFrame)
	PosY:SetPos(19, 65)
	PosY:SetDecimals(0)
	PosY.OnMouseReleased = function() end
	PosY.OnValueChanged = function() local pos = ent:GetDTVector( 4 ) ent:SetDTVector( 4, Vector( pos.x, PosY:GetValue(), pos.z ) ) end
	PosY:SetMinMax( -100, 100)
	
	AngleP = vgui.Create('DNumSlider')
	AngleP:SetSize(154, 40)
	AngleP:SetParent(GearFrame)
	AngleP:SetPos(19, 145)
	AngleP:SetDecimals(0)
	AngleP.OnMouseReleased = function() end
	AngleP.OnValueChanged = function() local ang = ent:GetDTAngle( 3 ) ent:SetDTAngle( 3, Angle( AngleP:GetValue(), ang.y, ang.r ) ) end
	AngleP:SetMinMax( 0, 360)

	AngleY = vgui.Create('DNumSlider')
	AngleY:SetSize(154, 40)
	AngleY:SetParent(GearFrame)
	AngleY:SetPos(19, 185)
	AngleY:SetDecimals(0)
	AngleY.OnMouseReleased = function() end
	AngleY.OnValueChanged = function() local ang = ent:GetDTAngle( 3 ) ent:SetDTAngle( 3, Angle( ang.p, AngleY:GetValue(), ang.r ) ) end
	AngleY:SetMinMax( 0, 360)
	
	AngleR = vgui.Create('DNumSlider')
	AngleR:SetSize(154, 40)
	AngleR:SetParent(GearFrame)
	AngleR:SetPos(19, 225)
	AngleR:SetDecimals(0)
	AngleR.OnMouseReleased = function() end
	AngleR.OnValueChanged = function() local ang = ent:GetDTAngle( 3 ) ent:SetDTAngle( 3, Angle( ang.p, ang.y, AngleR:GetValue() ) ) end
	AngleR:SetMinMax( 0, 360)
	
	PosZ = vgui.Create('DNumSlider')
	PosZ:SetSize(154, 40)
	PosZ:SetParent(GearFrame)
	PosZ:SetPos(19, 105)
	PosZ:SetDecimals(0)
	PosZ.OnMouseReleased = function() end
	PosZ.OnValueChanged = function() local pos = ent:GetDTVector( 4 ) ent:SetDTVector( 4, Vector( pos.x, pos.y, PosZ:GetValue() ) ) end
	PosZ:SetMinMax( -100, 100)
	
	PosX:SetValue( originalpos.x )
	PosY:SetValue( originalpos.y )
	PosZ:SetValue( originalpos.z )
	AngleP:SetValue( originalang.p )
	AngleY:SetValue( originalang.y )
	AngleR:SetValue( originalang.r )

end
datastream.Hook( "EditGear", EditGear );

--YEAH 2D3D SHIT!

--Thank god for the gmod wiki
local function WorldToScreen(vWorldPos,vPos,vScale,aRot)
    local vWorldPos=vWorldPos-vPos;
    vWorldPos:Rotate(Angle(0,-aRot.y,0));
    vWorldPos:Rotate(Angle(-aRot.p,0,0));
    vWorldPos:Rotate(Angle(0,0,-aRot.r));
    return vWorldPos.x/vScale,(-vWorldPos.y)/vScale;
end

function CAKE.Label2d3d( pos, ang, text, font, color )
	
	cam.Start3D2D( pos, ang, 1 )
		draw.DrawText(text, font, 10, 10, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	cam.End3D2D()

end