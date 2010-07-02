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
	
	draw.RoundedBox( 8, ScrW( ) / 2 - 100, 5, 200, 50, Color( GUIcolor_trans ) );
	draw.RoundedBox( 8, ScrW( ) / 2 - 98, 7, w, 46, Color( 255, 0, 0, 255 ) );
	
	draw.DrawText( "Time Left ( Type !acceptdeath to respawn )", "ChatFont", ScrW( ) / 2 - 93, 25 - 5, Color( 255,255,255,255 ), 0 );
	
end


function DrawPlayerInfo( )

	for k, v in pairs( player.GetAll( ) ) do	
	
		if( v != LocalPlayer( ) and !v:GetNWBool( "observe", false )) then
		
			if( v:Alive( ) ) then
			
				local alpha = 0
				local tracedata = {}
				tracedata.start = LocalPlayer():GetShootPos()
				tracedata.endpos = v:GetPos()
				tracedata.filter = LocalPlayer()
				local trace = util.TraceLine( tracedata )
				local position = v:GetPos( )
				local position = Vector( position.x, position.y, position.z + 75 )
				local screenpos = position:ToScreen( )
				local dist = position:Distance( LocalPlayer( ):GetPos( ) )
				local dist = dist / 2
				local dist = math.floor( dist )
				
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
					draw.DrawText( v:GetNWString( "title" ), "DefaultSmall", screenpos.x, screenpos.y + 10, Color( 255, 255, 255, alpha ), 1 )
					--draw.DrawText( v:GetNWString( "title2" ), "DefaultSmall", screenpos.x, screenpos.y + 20, Color( 255, 255, 255, alpha ), 1 )
				
					if( v:GetNWInt( "chatopen" ) == 1 ) then
					
						draw.DrawText( "Typing..", "ChatFont", screenpos.x, screenpos.y - 50, Color( 255, 255, 255, alpha ), 1 )
					
					end
				end
				
			end
			
		end
		
	end
	
end

function GM:HUDPaint( )
	
	--DrawTime( );
	DrawPlayerInfo( );
	DrawTargetInfo( );
end

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