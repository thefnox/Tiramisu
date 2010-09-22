PLUGIN.Name = "Chat"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Handles chat commands"; -- The description or purpose of the plugin


local function ccChangeOOCColor( ply, cmd, args )
	
	CAKE.SetPlayerField( ply, "ooccolor", Color( math.Clamp( tonumber( args[1] ), 0, 255 ), math.Clamp( tonumber( args[2] ), 0, 255 ), math.Clamp( tonumber( args[3] ), 0, 255 ), math.Clamp( tonumber( args[4] ), 0, 100 ) ) )

end
concommand.Add( "rp_ooccolor", ccChangeOOCColor )

function CAKE.OOCAdd( ply, text )

	if( ply.LastOOC + CAKE.ConVars[ "OOCDelay" ] < CurTime() ) then
	
		local playername = ply:Name( ) 
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
		
		/*
		datastream.StreamToClients( player.GetAll( ), "AddOOCLine", {
			[ "text" ] = tostring( text ),
			[ "playername" ] = tostring( playername ),
			[ "color" ] = color
		});
		*/
		
		ply.LastOOC = CurTime();
		
	else
	
		local TimeLeft = math.ceil(ply.LastOOC + CAKE.ConVars[ "OOCDelay" ] - CurTime());
		CAKE.SendChat( ply, "Please wait " .. TimeLeft .. " seconds before using OOC chat again!");
		
	end
end

local function ccRoll( ply, cmd, args )

	local Min = args[1];
	local Max = args[2];

		if( tonumber(args[1]) == nil and tonumber(args[2]) == nil ) then
	
			Min = 1;
			Max = 100;
		
		end

		if( tonumber(args[2]) == nil and tonumber(args[1]) != nil) then

			Min = 1;
			Max = args[1];
		
		end
	
		if( tonumber(args[1]) != nil and tonumber(args[2]) != nil) then
		
			if(tonumber(args[1]) > tonumber(args[2]) )  then

			Min = args[2];
			Max = args[1];
		
			end
		
		end
	
	local roll = math.random( Min , Max );
	
		for k, v in pairs( player.GetAll( ) ) do
		
			if( v:EyePos():Distance( ply:EyePos() ) <= 300 ) then
			
				CAKE.SendChat( v, "[Roll] " .. ply:Nick() .. " rolled a " .. roll .. " out of " .. Min .. "-" .. Max .. ".");
			
			end
		
		end
	
end
concommand.Add("rp_roll", ccRoll);

function Report( ply, text )

	for k, v in pairs(player.GetAll()) do
		
		if( v:IsAdmin() or v:IsSuperAdmin() ) then
		
			CAKE.SendChat( v, ply:Nick() .. " | " .. ply:Name() .. " [" .. ply:SteamID()  .. "] [REPORT]:" .. text );
			
		end
	
	end
	
	if( !ply:IsAdmin() and !ply:IsSuperAdmin() ) then 
	
		CAKE.SendChat( ply, ply:Nick() .. " [REPORT]:" .. text );
		
	end
	
	return ""
	
end


function PLUGIN.Init()
	
	CAKE.ChatCommand( "/report", Report );
	CAKE.AddDataField( 1, "ooccolor", Color( 0, 255, 0, 100 ))
	
end