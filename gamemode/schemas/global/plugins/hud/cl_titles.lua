
local position
local angle
local closeents
local tracedata = {}
local mlabel
local trace
local ent

--Locator for the 3D Titles

timer.Create( "LocalTiramisuTitleTimer", 0.2, 0, function()
	
	closeents = ents.FindInSphere( LocalPlayer():GetPos(), CAKE.TitleDrawDistance:GetInt() )

end)

--3D Titles

hook.Add( "PostDrawOpaqueRenderables", "Tiramisu3DTitles", function( )
	
	if closeents then
	    for k, v in pairs( closeents ) do
	    	if ValidEntity( v ) then
		        if v:IsPlayer() and LocalPlayer() != v and v:Alive() and !v:GetNWBool( "observe" ) and !v:GetNWBool( "unconciousmode", false ) then
		        	mlabel = markup.Parse( "<font=TiramisuTitlesFont>\n" .. v:GetNWString( "title", "Connecting..." ) .. "</font>", 570 )
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
		            
		            position = position - angle:Right() * 24
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

		        elseif CAKE.IsDoor( v ) and CAKE.GetDoorTitle( v ) != "" then
		      	  	position = v:LocalToWorld(v:OBBCenter())
				    angle = v:GetAngles()
				    angle:RotateAroundAxis( angle:Up(), 90 )
				    angle:RotateAroundAxis( angle:Forward() * -1, -90 )
				    cam.Start3D2D( position + ( angle:Up() * 4 ), angle , 0.12 )
				        draw.SimpleTextOutlined( CAKE.GetDoorTitle( v ), "TiramisuTitlesFont", 0, 0, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(10,10,10,200) )
				    cam.End3D2D()   
				                angle:RotateAroundAxis( angle:Forward(), 180 )
				            angle:RotateAroundAxis( angle:Up(), 180 )
				    cam.Start3D2D( position + ( angle:Up() * 4 ), angle , 0.12 )
				        draw.SimpleTextOutlined( CAKE.GetDoorTitle( v ), "TiramisuTitlesFont", 0, 0, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(10,10,10,200) )
				    cam.End3D2D()   
		        end
		   end
	    end
	end
end)
