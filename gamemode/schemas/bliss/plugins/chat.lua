PLUGIN.Name = "Chat"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Handles chat commands"; -- The description or purpose of the plugin


local function ccChangeOOCColor( ply, cmd, args )
	
	CAKE.SetPlayerField( ply, "ooccolor", Color( math.Clamp( tonumber( args[1] ), 0, 255 ), math.Clamp( tonumber( args[2] ), 0, 255 ), math.Clamp( tonumber( args[3] ), 0, 255 ), math.Clamp( tonumber( args[4] ), 0, 100 ) ) )

end
concommand.Add( "rp_ooccolor", ccChangeOOCColor )

function CAKE.OOCAdd( ply, text )

	if( ply.LastOOC + CAKE.ConVars[ "OOCDelay" ] < CurTime() ) then
	
		local playername = ply:Nick()
		local color = CAKE.GetPlayerField( ply, "ooccolor" )
		if( string.sub( text, 1, 4 ) == "/ooc" ) then
			text = string.sub( text, 5 )
		else
			text = string.sub( text, 3 )
		end
		
		umsg.Start("AddOOCLine")
			umsg.String( tostring( text ) )
			umsg.String( tostring( playername ) )
			umsg.Vector( Vector( color.r, color.b, color.g ) )
			umsg.Float( color.a )
		umsg.End()
		ply.LastOOC = CurTime();
		
	else
	
		local TimeLeft = math.ceil(ply.LastOOC + CAKE.ConVars[ "OOCDelay" ] - CurTime());
		CAKE.SendChat( ply, "Please wait " .. TimeLeft .. " seconds before using OOC chat again!");
		
	end
end


function PLUGIN.Init()
	
	CAKE.AddDataField( 1, "ooccolor", Color( 0, 255, 0, 100 ))
	
end