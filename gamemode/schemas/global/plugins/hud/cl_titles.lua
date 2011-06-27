
local position
local angle
local closeents
local tracedata = {}
local mlabel
local trace
local ent


--This function was made by Nori, not me, as many other parts of the gamemode. This one's special though, since it's from Cakescript G3 lol.
local function CalculateDoorTextPosition(door, reversed)
	local traceData = {};
	local obbCenter = door:OBBCenter();
	local obbMaxs = door:OBBMaxs();
	local obbMins = door:OBBMins();
		
	traceData.endpos = door:LocalToWorld(obbCenter);
	traceData.filter = ents.FindInSphere(traceData.endpos, 20);
		
	for k, v in pairs(traceData.filter) do
		if (v == door) then
			traceData.filter[k] = nil;
		end;
	end;
		
	local length = 0;
	local size = obbMins - obbMaxs;
		
	size.x = math.abs(size.x);
	size.y = math.abs(size.y);
	size.z = math.abs(size.z);
		
	if (size.z < size.x and size.z < size.y) then
		length = size.z;
		
		if (reverse) then
			traceData.start = traceData.endpos - (door:GetUp() * length);
		else
			traceData.start = traceData.endpos + (door:GetUp() * length);
		end;
	elseif (size.x < size.y) then
		length = size.x;
		width = size.y;
			
		if (reverse) then
			traceData.start = traceData.endpos - (door:GetForward() * length);
		else
			traceData.start = traceData.endpos + (door:GetForward() * length);
		end;
	elseif (size.y < size.x) then
		length = size.y;
		
		if (reverse) then
			traceData.start = traceData.endpos - (door:GetRight() * length);
		else
		
			traceData.start = traceData.endpos + (door:GetRight() * length);
		end;
	end;

	local trace = util.TraceLine(traceData);
	local angles = trace.HitNormal:Angle();
	
	if (trace.HitWorld and !reversed) then
		return CalculateDoorTextPosition(door, true);
	end;
		
	angles:RotateAroundAxis(angles:Forward(), 90);
	angles:RotateAroundAxis(angles:Right(), 90);
	
	local position = trace.HitPos - ( ( (traceData.endpos - trace.HitPos):Length() * 2) + 2 ) * trace.HitNormal;
	local anglesBack = trace.HitNormal:Angle();
	local positionBack = trace.HitPos + (trace.HitNormal * 2);
		
	anglesBack:RotateAroundAxis(anglesBack:Forward(), 90);
	anglesBack:RotateAroundAxis(anglesBack:Right(), -90);
	
	return {
		positionBack = positionBack,
		anglesBack = anglesBack,
		position = position,
		HitWorld = trace.HitWorld,
		angles = angles,
	};
end;

--Locator for the 3D Titles

timer.Create( "LocalTiramisuTitleTimer", 0.2, 0, function()
	
	closeents = ents.FindInSphere( LocalPlayer():GetPos(), CAKE.TitleDrawDistance:GetInt() )

end)

--3D Door Titles
local doordata
local alpha
local viewpos
hook.Add( "PostDrawOpaqueRenderables", "Tiramisu3DDoorTitles", function()
	if closeents then
		for _, door in pairs( closeents ) do
			if ValidEntity( door ) and CAKE.IsDoor( door ) and CAKE.GetDoorTitle( door ) != "" then
				doordata = CalculateDoorTextPosition( door )
				if !doordata.HitWorld then
					viewpos = LocalPlayer():GetShootPos()
					alpha = math.Clamp( viewpos:Distance( door:GetPos() ) * - 1 + 300, 0, 255 )
					cam.IgnoreZ(true)
					cam.Start3D2D(doordata.position, doordata.angles, 0.12 );
						draw.SimpleTextOutlined( CAKE.GetDoorTitle( door ), "TiramisuTitlesFont", 0, 0, Color( 255, 255, 255, alpha ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(10,10,10,alpha) )
					cam.End3D2D()
									
					cam.Start3D2D(doordata.positionBack, doordata.anglesBack, 0.12);
						draw.SimpleTextOutlined( CAKE.GetDoorTitle( door ), "TiramisuTitlesFont", 0, 0, Color( 255, 255, 255, alpha ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(10,10,10,alpha) )
					cam.End3D2D()
					cam.IgnoreZ(false)		
				end
			end
		end
	end

end)

--3D Titles drawing.

hook.Add( "PostDrawTranslucentRenderables", "Tiramisu3DPlayerTitles", function( )
	if closeents then
	    for k, v in pairs( closeents ) do
	    	if ValidEntity( v ) then
		        if v:IsPlayer() and LocalPlayer() != v and v:Alive() and !v:GetNWBool( "observe" ) and !v:GetNWBool( "unconciousmode", false ) then
		        	mlabel = markup.Parse( "<c><font=TiramisuTitlesFont>\n" .. v:GetNWString( "title", "Connecting..." ) .. "</font></c>", 570 )
		            position = v:GetPos()
		            if v:GetBonePosition( v:LookupBone("ValveBiped.Bip01_Head1") ) then
		                position = v:GetBonePosition( v:LookupBone("ValveBiped.Bip01_Head1") )
		            else
		            	position = position + Vector( 0, 0, 80 )
		            end
		            angle = v:GetAngles()
		            angle = Angle( 0, angle.y, 0 )
		            angle:RotateAroundAxis( angle:Up(), 90 )
		            angle:RotateAroundAxis( angle:Forward(), 90 )
		            
		            position = position - angle:Right() * 28
		            cam.Start3D2D( position, angle, 0.12 )
		            	if v:GetNWBool( "chatopen", false ) then
		            		draw.DrawText( "Typing...", "TiramisuTitlesFont", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		            	end
		            	draw.DrawText( v:Nick(), "TiramisuTitlesFont", 0, 40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		                mlabel:Draw( 0, 70, TEXT_ALIGN_CENTER )
		            cam.End3D2D()

		            angle:RotateAroundAxis( angle:Forward(), 180 )
		            angle:RotateAroundAxis( angle:Up(), 180 )
		            cam.Start3D2D( position, angle, 0.12 )
		            	if v:GetNWBool( "chatopen", false ) then
		            		draw.DrawText( "Typing...", "TiramisuTitlesFont", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		            	end
		            	draw.DrawText( v:Nick(), "TiramisuTitlesFont", 0, 40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		                mlabel:Draw( 0, 70, TEXT_ALIGN_CENTER )
		            cam.End3D2D()
		        end
		   end
	    end
	end
end)
