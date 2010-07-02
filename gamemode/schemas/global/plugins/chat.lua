PLUGIN.Name = "Chat Commands"; -- What is the plugin name
PLUGIN.Author = "LuaBanana"; -- Author of the plugin
PLUGIN.Description = "A set of default chat commands"; -- The description or purpose of the plugin

function Broadcast( ply, text )

	-- Check to see if the player's team allows broadcasting
	local team = ply:Team( );
	
	if( CAKE.Teams[ team ][ "broadcast" ] ) then
		
		for k, v in pairs( player.GetAll( ) ) do
		
			CAKE.SendChat( v, ply:Nick( ) .. " [BROADCAST]: " .. text );
			
		end
	
	end
	
	return "";
	
end

function Advertise( ply, text )

	if(CAKE.ConVars[ "AdvertiseEnabled" ] == "1") then
	
		if( tonumber( CAKE.GetCharField( ply, "money" ) ) >= CAKE.ConVars[ "AdvertisePrice" ] ) then
			
			CAKE.ChangeMoney( ply, 0 - CAKE.ConVars[ "AdvertisePrice" ] );
		
			for _, pl in pairs(player.GetAll()) do
			
				CAKE.SendChat(pl, "[AD] " .. ply:Nick() .. ": " .. text)
		
			end
			
		else
		
			CAKE.SendChat(ply, "You do not have enough credits! You need " .. CAKE.ConVars[ "AdvertisePrice" ] .. " to send an advertisement.");
			
		end	
		
	else
	
		CAKE.ChatPrint(ply, "Advertisements are not enabled");
		
	end
	
	return "";
	
end

function Radio( ply, text )

	local players = player.GetAll();
	local heardit = {};

	if(CAKE.Teams[ply:Team()] == nil) then return ""; end

	if(CAKE.Teams[ply:Team()]["radio_groups"] != {}) then
		for k, v in pairs(CAKE.Teams[ply:Team()]["radio_groups"]) do
			
			for k2, v2 in pairs(player.GetAll()) do
				if(CAKE.Teams[v2:Team()] != nil) then
					if(table.HasValue(CAKE.Teams[v2:Team()]["radio_groups"], v)) then
						CAKE.SendChat(v2, "[RADIO] " .. ply:Nick() .. ": " .. text);
						table.insert(heardit, v2);
					end
				end
			end
		end

	end

	for k, v in pairs(players) do
		
		if(!table.HasValue(heardit, v)) then
		
			local range = CAKE.ConVars[ "TalkRange" ]
			
			if( v:EyePos( ):Distance( ply:EyePos( ) ) <= range ) then
			
				CAKE.SendChat( v, ply:Nick() .. ": " .. text );
				
			end
			
		end
		
	end
	
	return "";

end

function Chat_ModPlayerVars(ply)

	ply.LastOOC = -100000; -- This is so people can talk for the first time without having to wait.
		
end

function PLUGIN.Init( ) -- We run this in init, because this is called after the entire gamemode has been loaded.

	CAKE.ConVars[ "AdvertiseEnabled" ] = "1"; -- Can players advertise
	CAKE.ConVars[ "AdvertisePrice" ] = 25; -- How much do advertisements cost
	CAKE.ConVars[ "OOCDelay" ] = 10; -- How long do you have to wait between OOC Chat
	
	CAKE.ConVars[ "YellRange" ] = 1.5; -- How much farther will yell chat go
	CAKE.ConVars[ "WhisperRange" ] = 0.2; -- How far will whisper chat go
	CAKE.ConVars[ "MeRange" ] = 1.0; -- How far will me chat go
	CAKE.ConVars[ "LOOCRange" ] = 1.0; -- How far will LOOC chat go
	
	CAKE.SimpleChatCommand( "/me", CAKE.ConVars[ "MeRange" ], "*** $1 $3" ); -- Me chat
	CAKE.SimpleChatCommand( "/it", CAKE.ConVars[ "MeRange" ], "*** $3" ); -- It chat
	CAKE.SimpleChatCommand( "/anon", CAKE.ConVars[ "MeRange" ], "???: $3" ); -- It chat
	CAKE.SimpleChatCommand( "/y", CAKE.ConVars[ "YellRange" ], "$1 [YELL]: $3" ); -- Yell chat
	CAKE.SimpleChatCommand( "/w", CAKE.ConVars[ "WhisperRange" ], "$1 [WHISPER]: $3" ); -- Whisper chat
	CAKE.SimpleChatCommand( ".//", CAKE.ConVars[ "LOOCRange" ], "$1 | $2 [LOOC]: $3" ); -- Local OOC Chat
	CAKE.SimpleChatCommand( "[[", CAKE.ConVars[ "LOOCRange" ], "$1 | $2 [LOOC]: $3" ); -- Local OOC Chat

	CAKE.ChatCommand( "/ad", Advertise ); -- Advertisements
	CAKE.ChatCommand( "/ooc", OOCChat ); -- OOC Chat
	CAKE.ChatCommand( "//", OOCChat ); -- OOC Chat
	CAKE.ChatCommand( "/bc", Broadcast ); -- Broadcast
	CAKE.ChatCommand( "/radio", Radio ); -- Radio
	
	CAKE.AddHook("Player_Preload", "chat_modplayervars", Chat_ModPlayerVars); -- Put in our OOCDelay variable
	
end

