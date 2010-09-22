PLUGIN.Name = "Chat Commands"; -- What is the plugin name
PLUGIN.Author = "LuaBanana"; -- Author of the plugin
PLUGIN.Description = "A set of default chat commands"; -- The description or purpose of the plugin

function CAKE.AddRadioLine( ply, text, color )
	umsg.Start( "AddRadioLine", ply )
		umsg.String( text )
		umsg.Short( color.r )
		umsg.Short( color.b )
		umsg.Short( color.g )
	umsg.End()
	CAKE.SendConsole( ply, text )
end

function Broadcast( ply, text )

	-- Check to see if the player's team allows broadcasting
	local team = CAKE.GetCharField( ply, "group" )
	
	if( CAKE.GetGroupFlag( team, "canbroadcast" ) ) then
		
		for k, v in pairs( player.GetAll( ) ) do
		
			CAKE.SendChat( v, "[BROADCAST]: " .. text );
			
		end
	
	end
	
	return "";
	
end

function Event( ply, text )

	-- Check to see if the player's team allows broadcasting
	if( CAKE.PlayerRank(ply) > 3 ) then
		
		for k, v in pairs( player.GetAll( ) ) do
		
			CAKE.SendChat( v, "[EVENT]: " .. text );
			
		end
	
	end
	
	return "";
	
end

function PersonalMessage( ply, text )

	-- Check to see if the player's team allows broadcasting
	local exp = string.Explode( " ", text )
	local target = CAKE.FindPlayer( exp[1] )
	table.remove( exp, 1)
	if target then
		CAKE.SendChat( target, "[FROM:" .. ply:Nick() .. "]" .. table.concat( exp, " " ) )
		CAKE.SendChat( ply, "[TO:" .. target:Nick() .. "]" .. table.concat( exp, " " ) )
	else
		CAKE.SendChat( ply, "Target not found!" )
	end
	
	return "";
	
end

function RemoveHelmet( ply, text )
	
	local gender = CAKE.GetCharField( ply, "gender" )
	local article = ""
	
	if gender == "Female" then
		article = "her"
	else
		article = "his"
	end
	
	for k, v in pairs(player.GetAll()) do
		
		local range = CAKE.ConVars[ "TalkRange" ]
			
		if( v:EyePos( ):Distance( ply:EyePos( ) ) <= range ) then
			
			CAKE.SendChat( v, "*** " .. ply:Nick() .. " removed " .. article .. " helmet." );
				
		end
			
	end
	
	ply:RemoveHelmet()
	
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
	local group = CAKE.GetCharField( ply, "group" )

	if(CAKE.Teams[ply:Team()] == nil) then return ""; end

	if(group != 0) then
		for k2, v2 in pairs(player.GetAll()) do
			if(CAKE.Teams[v2:Team()] != nil) then
				if( CAKE.GetCharField( v2, "group" ) == group or CAKE.GetGroupFlag( CAKE.GetCharField( v2, "group" ), "radiogroup" ) == CAKE.GetGroupFlag( group, "radiogroup" ) ) then
					/*
					if v2 != ply then
						CAKE.AddRadioLine( v2, "[RADIO] " .. ply:Nick() .. ": " .. text, CAKE.GetGroupFlag( group, "radiocolor" ) or Color( 255, 255, 255 ) );
					else
						CAKE.AddRadioLine( v2, "[RADIO] " .. ply:Nick() .. ": " .. text, Color( 255, 0, 0 ) );
						
					end*/
					CAKE.AddRadioLine( v2, "[RADIO] " .. ply:Nick() .. ": " .. text, CAKE.GetGroupFlag( group, "radiocolor" ) or Color( 255, 255, 255 ) );
					table.insert(heardit, v2);
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

function Title( ply, text )
	ply:ConCommand( "rp_title \"" .. text .. "\"" )
	return "";
end

function Title2( ply, text )
	ply:ConCommand( "rp_title2 \"" .. text .. "\"" )
	return "";
end

function Yell( ply, text )
	local players = ents.FindInSphere( ply:GetPos(), CAKE.ConVars[ "TalkRange" ] * CAKE.ConVars[ "YellRange" ] )
	for k, v in pairs( players ) do
		if v:IsPlayer() then
			CAKE.SendChat( v, "[Y]" .. ply:Nick() .. ": " .. text, "Trebuchet24" )
		end
	end
	return "";
end

function Whisper( ply, text )
	local players = ents.FindInSphere( ply:GetPos(), CAKE.ConVars[ "TalkRange" ] * CAKE.ConVars[ "WhisperRange" ] )
	for k, v in pairs( players ) do
		if v:IsPlayer() then
			CAKE.SendChat( v, "[W]" ..  ply:Nick() .. ": " .. text, "DefaultSmallDropShadow" )
		end
	end
	return "";
end


function PLUGIN.Init( ) -- We run this in init, because this is called after the entire gamemode has been loaded.

	CAKE.AddDataField( 2, "frequency", 0 )

	CAKE.ConVars[ "AdvertiseEnabled" ] = "1"; -- Can players advertise
	CAKE.ConVars[ "AdvertisePrice" ] = 25; -- How much do advertisements cost
	CAKE.ConVars[ "OOCDelay" ] = 10; -- How long do you have to wait between OOC Chat
	
	CAKE.ConVars[ "YellRange" ] = 1.5; -- How much farther will yell chat go
	CAKE.ConVars[ "WhisperRange" ] = 0.2; -- How far will whisper chat go
	CAKE.ConVars[ "MeRange" ] = 1.0; -- How far will me chat go
	CAKE.ConVars[ "LOOCRange" ] = 1.0; -- How far will LOOC chat go
	
	CAKE.SimpleChatCommand( "/?", CAKE.ConVars[ "MeRange" ], "??? : $3" ); -- Anon chat
	CAKE.SimpleChatCommand( "/me", CAKE.ConVars[ "MeRange" ], "*** $1 $3" ); -- Me chat
	CAKE.SimpleChatCommand( "/it", CAKE.ConVars[ "MeRange" ], "*** $3" ); -- It chat
	CAKE.SimpleChatCommand( "/anon", CAKE.ConVars[ "MeRange" ], "???: $3" ); -- It chat
	--CAKE.SimpleChatCommand( "/y", CAKE.ConVars[ "YellRange" ], "<font=DefaultLarge>$1 [YELL]: $3</font>" ); -- Yell chat
	--CAKE.SimpleChatCommand( "/w", CAKE.ConVars[ "WhisperRange" ], "<font=DefaultSmall>$1 [WHISPER]: $3</font>" ); -- Whisper chat
	CAKE.SimpleChatCommand( ".//", CAKE.ConVars[ "LOOCRange" ], "$1 | $2 [LOOC]: $3" ); -- Local OOC Chat
	CAKE.SimpleChatCommand( "[[", CAKE.ConVars[ "LOOCRange" ], "$1 | $2 [LOOC]: $3" ); -- Local OOC Chat

	CAKE.ChatCommand( "/ad", Advertise );
	CAKE.ChatCommand( "/y", Yell);
	CAKE.ChatCommand( "/w", Whisper);
	CAKE.ChatCommand( "/event", Event );	-- Advertisements
	CAKE.ChatCommand( "/bc", Broadcast ); -- Broadcast
	CAKE.ChatCommand( "/r", Radio ); -- Radio
	CAKE.ChatCommand( "/removehelmet", RemoveHelmet );
	CAKE.ChatCommand( "/pm", PersonalMessage );
	CAKE.ChatCommand( "/title", Title );
	CAKE.ChatCommand( "/title2", Title2 );
	
	CAKE.AddHook("Player_Preload", "chat_modplayervars", Chat_ModPlayerVars); -- Put in our OOCDelay variable
	
end

