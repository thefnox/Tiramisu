--Everything chat related

CAKE.ChatCommands = {  };

function CAKE.SimpleChatCommand( prefix, range, form, channel )

	-- This is for simple chat commands like /me, /y, /w, etc
	-- This isn't useful for radio, broadcast, etc.

	-- Quite a new feature, you can specify a 'format' for the output.
	-- %1 - IC Name
	-- %2 - OOC Name
	-- %3 - Text Given
	--
	-- So, someone using Local OOC chat, would output this:
	-- Joe Bob | Bobby1337 [ LOCAL OOC ]: WAIT WHAT.
	-- The format would be: "%1 | %2 [ LOCAL OOC ]: %3"
	--
	-- Also, the range is a multiplier based upon the ConVar "TalkRange".
	--
	-- Genius, 'miryt?
	
	local cc = {  };
	cc.simple = true;
	cc.cmd = cmd;
	cc.range = range;
	cc.form = form;
	cc.channel = channel
	
	CAKE.ChatCommands[ prefix ] = cc;
	
end

function CAKE.ChatCommand( prefix, callback )

	local cc = {  }
	cc.simple = false;
	cc.cmd = prefix;
	cc.callback = callback;
	
	CAKE.ChatCommands[ prefix ] = cc;
	
end

hook.Add( "AcceptStream", "TiramisuAcceptChatStream", function( pl, handler, id )
	if handler == "TiramisuChatHandling" then
		return true
	end
end)

--NOTE: TIRAMISU NO LONGER USES THE NORMAL "SAY" COMMAND NOR THE REGULAR CHAT HOOKS.

--This means everything that you MUST use through chat commands must be hooked to this stream otherwise it won't work, period. There's no other way nor workaround.

datastream.Hook( "TiramisuChatHandling", function( ply, handler, id, encoded, decoded )

	local text = decoded.text or ""

	CAKE.DayLog("chat.txt", ply:SteamID() .. ": " .. text); -- we be spyins.
	
	if( string.sub( text, 1, 2) == "//" or string.sub( text, 1, 4) == "/ooc" ) then --OOC override, to add colors.
		CAKE.OOCAdd( ply, text )
		return
	end
	
	for prefix, cc in pairs( CAKE.ChatCommands ) do
	
		local cmd = prefix;
		local cmdlen = string.len( cmd );
		local cmdtxt = string.sub( text, 0, cmdlen );
		
		cmdtxt = string.lower( cmdtxt );
		cmd = string.lower( cmd );
		
		if( cmdtxt == cmd and (string.sub( text, cmdlen + 1, cmdlen + 1 ) == " " or string.len(text) == cmdlen) ) then -- This allows for multiple commands to start with the same thing 
			
			local args = string.sub( text, cmdlen + 2 );
			
			if( args == nil ) then
			
				args = "";
				
			end
			
			if( !cc.simple ) then
			
				return cc.callback( ply, args );
				
			end
			
			
			local range = CAKE.ConVars[ "TalkRange" ] * cc.range;
			
			local s = cc.form;
			local s = string.gsub( s, "$1", ply:Nick( ) ); -- IC Name
			local s = string.gsub( s, "$2", ply:Name( ) ); -- OOC Name
			local s = string.gsub( s, "$3", args ); -- Text
			
			for _, pl in pairs( player.GetAll( ) ) do
			
				if( pl:EyePos( ):Distance( ply:EyePos( ) ) <= range ) then
				
					CAKE.SendChat( pl, s, "ChatFont", cc.channel or "IC" );
				
				end
			
			end
			
			return
			
		end
		
	end
	
	if( string.sub( text, 1, 1 ) == "/" ) then
	
		CAKE.SendChat( ply, "That is not a valid command" );
		return
	
	else
	
		-- Hurr, IC Chat..

		CAKE.ICAdd( ply, ply:Nick() .. ": " .. text )
		
		return
		
	end
	
end)

--Adds a regular radio chat line.
function CAKE.AddRadioLine( ply, text )
	datastream.StreamToClients( ply, "TiramisuAddToRadio", {
		["text"] = text,
	})
end


--Concommand to handle OOC color changes. Takes 4 arguments, red, green, blue and alpha.
local function ccChangeOOCColor( ply, cmd, args )
	
	CAKE.SetPlayerField( ply, "ooccolor", Color( math.Clamp( tonumber( args[1] ), 0, 255 ), math.Clamp( tonumber( args[2] ), 0, 255 ), math.Clamp( tonumber( args[3] ), 0, 255 ), math.Clamp( tonumber( args[4] ), 0, 100 ) ) )

end
concommand.Add( "rp_ooccolor", ccChangeOOCColor )

--Sends a regular blue IC message.

function CAKE.ICAdd( ply, text )

	local range = CAKE.ConVars[ "TalkRange" ]
		
	for _, pl in pairs( player.GetAll( ) ) do
		
		if( pl:EyePos( ):Distance( ply:EyePos( ) ) <= range ) and pl:IsCharLoaded() then
			
			CAKE.SendChat( pl, text, "ChatFont", "IC" );
			
		end
		
	end

end

--Handles OOC messaging.

function CAKE.OOCAdd( ply, text )

	if( ply.LastOOC + CAKE.ConVars[ "OOCDelay" ] < CurTime() or CAKE.PlayerRank(ply) > 2 ) then
	
		local playername = ply:Name( ) 
		local color = CAKE.GetPlayerField( ply, "ooccolor" )
		if( string.sub( text, 1, 4 ) == "/ooc" ) then
			text = string.sub( text, 5 )
		else
			text = string.sub( text, 3 )
		end

		for _, target in pairs( player.GetAll( ) ) do
			if ValidEntity( target ) and target:IsCharLoaded() then
				datastream.StreamToClients( target, "TiramisuAddToOOC", {
					["text"] = text,
					["color"] = color,
					["name"] = playername 
				})
			end
		end
		
		ply.LastOOC = CurTime();
		
	else
	
		local TimeLeft = math.ceil(ply.LastOOC + CAKE.ConVars[ "OOCDelay" ] - CurTime());
		CAKE.SendChat( ply, "Please wait " .. TimeLeft .. " seconds before using OOC chat again!", "ChatFont", "OOC");
		
	end
end

--Sends the user a random number between the two limits established in the two arguments( Defaults to 0 and 100 )
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
			
				CAKE.SendChat( v, "[Roll] " .. ply:Nick() .. " rolled a " .. roll .. " out of " .. Min .. "-" .. Max .. ".", "ChatFont", "IC");
			
			end
		
		end
	
end
concommand.Add("rp_roll", ccRoll);

--Makes a player display the "Typing" title
function ccOpenChat( ply, cmd, args )

	ply:SetNWBool( "chatopen", true )
	
end
concommand.Add( "rp_openedchat", ccOpenChat );

--Hides the "Typing" title
function ccCloseChat( ply, cmd, args )

	ply:SetNWBool( "chatopen", false )
	
end
concommand.Add( "rp_closedchat", ccCloseChat );

--Reports a message directly to all online admins in the channel "Reports"
local function Report( ply, text )

	for k, v in pairs(player.GetAll()) do
		
		if( v:IsAdmin() or v:IsSuperAdmin() ) then
		
			CAKE.SendChat( v, ply:Nick() .. " | " .. ply:Name() .. " [" .. ply:SteamID()  .. "] [REPORT]:" .. text, "ChatFont", "Reports" );
			
		end
	
	end
	
	if( !ply:IsAdmin() and !ply:IsSuperAdmin() ) then 
	
		CAKE.SendChat( ply, ply:Nick() .. " [REPORT]:" .. text );
		
	end
	
	return ""
	
end

--Broadcasts a message across the server, if group permissions allow it.
local function Broadcast( ply, text )

	-- Check to see if the player's team allows broadcasting
	local group = CAKE.GetCharField( ply, "group" )
	
	if( CAKE.GetGroupFlag( group, "canbroadcast" ) ) then
		
		for k, v in pairs( player.GetAll( ) ) do
		
			CAKE.SendChat( v, "[BROADCAST]: " .. text, "BudgetLabel", "IC" );
			
		end
	
	end
	
	return "";
	
end

--Global message that only admins may send.
local function Event( ply, text )

	-- Check to see if the player's team allows broadcasting
	if( CAKE.PlayerRank(ply) > 0 ) then
		
		for k, v in pairs( player.GetAll( ) ) do
		
			CAKE.SendChat( v, "[EVENT]: " .. text, "ChatFont", "IC" );
			
		end
	
	end
	
	return "";
	
end

--Sends a private message to anyone who is online. Opens on a separate channel.
local function PersonalMessage( ply, text )

	-- Check to see if the player's team allows broadcasting
	local exp = string.Explode( " ", text )
	local target = CAKE.FindPlayer( exp[1] )
	table.remove( exp, 1)
	if target then
		CAKE.SendChat( target, "[FROM:" .. ply:Nick() .. "]" .. table.concat( exp, " " ), "ChatFont", ply:Name() )
		CAKE.SendChat( ply, "[TO:" .. target:Nick() .. "]" .. table.concat( exp, " " ), "ChatFont", target:Name() )
	else
		CAKE.SendChat( ply, "Target not found!" )
	end
	
	return "";
	
end

--Removes your currently wore helmet.
local function RemoveHelmet( ply, text )
	
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
			
			CAKE.SendChat( v, "*** " .. ply:Nick() .. " removed " .. article .. " helmet.", "ChatFont", "IC" );
				
		end
			
	end
	
	ply:RemoveHelmet()
	
	return "";

end

--Sends a global message if advertising is allowed. Costs money.
local function Advertise( ply, text )

	if(CAKE.ConVars[ "AdvertiseEnabled" ] == "1") then
	
		if( tonumber( CAKE.GetCharField( ply, "money" ) ) >= CAKE.ConVars[ "AdvertisePrice" ] ) then
			
			CAKE.ChangeMoney( ply, 0 - CAKE.ConVars[ "AdvertisePrice" ] );
		
			for _, pl in pairs(player.GetAll()) do
			
				CAKE.SendChat(pl, "[AD] " .. ply:Nick() .. ": " .. text, "ChatFont", "IC" )
		
			end
			
		else
		
			CAKE.SendChat(ply, "You do not have enough credits! You need " .. CAKE.ConVars[ "AdvertisePrice" ] .. " to send an advertisement.");
			
		end	
		
	else
	
		CAKE.ChatPrint(ply, "Advertisements are not enabled");
		
	end
	
	return "";
	
end

--Sends a group only message.
local function Radio( ply, text )

	local players = player.GetAll();
	local heardit = {};
	local group = CAKE.GetCharField( ply, "group" )
	local color = CAKE.GetGroupField( group, "radiocolor" ) or Color( 255, 255, 255 )

	if !ply:IsCharLoaded() then return ""; end
	if !CAKE.GroupExists( group ) then return ""; end

	for _, target in pairs(player.GetAll()) do
		if target:IsCharLoaded() then
			if( CAKE.GetCharField( target, "group" ) == group ) then
				/*
				if v2 != ply then
					CAKE.AddRadioLine( v2, "[RADIO] " .. ply:Nick() .. ": " .. text, CAKE.GetGroupFlag( group, "radiocolor" ) or Color( 255, 255, 255 ) );
					else
					CAKE.AddRadioLine( v2, "[RADIO] " .. ply:Nick() .. ": " .. text, Color( 255, 0, 0 ) );
						
					end*/
				datastream.StreamToClients( target, "TiramisuAddToRadio", {
					["text"] = "<color=white>[RADIO]</color><color=" .. tostring( color.r ) .. "," .. tostring( color.b ) .. "," .. tostring( color.g ) .. ">" .. ply:Nick() .. "</color><color=white>: " .. text .. "</color>" 
				})
				table.insert(heardit, target);
			end
		end
	end

	for k, v in pairs(players) do
		
		if(!table.HasValue(heardit, v)) then
		
			local range = CAKE.ConVars[ "TalkRange" ]
			
			if( v:EyePos( ):Distance( ply:EyePos( ) ) <= range ) then
			
				CAKE.SendChat( v, ply:Nick() .. ": " .. text, "ChatFont", "IC" );
				
			end
			
		end
		
	end
	
	return "";

end

--Sets your title.
local function Title( ply, text )
	ply:ConCommand( "rp_title " .. text )
	return "";
end

--Sets the title of the door you're facing.
local function DoorTitle( ply, text )
	ply:ConCommand( "rp_doortitle " .. text)
	return "";
end

--ICly yells a message.
local function Yell( ply, text )
	local players = ents.FindInSphere( ply:GetPos(), CAKE.ConVars[ "TalkRange" ] * CAKE.ConVars[ "YellRange" ] )
	for k, v in pairs( players ) do
		if v:IsPlayer() then
			CAKE.SendChat( v, "[YELL]" .. ply:Nick() .. ": " .. text, "TiramisuYellFont", "IC" )
		end
	end
	return "";
end

--IC whispers a message.
local function Whisper( ply, text )
	local players = ents.FindInSphere( ply:GetPos(), CAKE.ConVars[ "TalkRange" ] * CAKE.ConVars[ "WhisperRange" ] )
	for k, v in pairs( players ) do
		if v:IsPlayer() then
			CAKE.SendChat( v, "[WHISPER]" ..  ply:Nick() .. ": " .. text, "TiramisuWhisperFont", "IC" )
		end
	end
	return "";
end

--Allows you to perform an action.
local function Emote( ply, text )
	local players = ents.FindInSphere( ply:GetPos(), CAKE.ConVars[ "TalkRange" ] * CAKE.ConVars[ "MeRange" ] )
	for k, v in pairs( players ) do
		if v:IsPlayer() then
			CAKE.SendChat( v, "*** " ..  ply:Nick() .. " " .. text, "ChatFont", "IC" )
		end
	end
	return "";
end

hook.Add( "PlayerSpawn", "TiramisuStartChat", function( ply )
	if !ply.ChatInitialized then
		ply.ChatInitialized = true
		umsg.Start( "TiramisuInitChat", ply )
		umsg.End()
	end
end)

function GM:PlayerChat( ply, text )
	return "";
end

function PLUGIN.Init( ) -- We run this in init, because this is called after the entire gamemode has been loaded.

	CAKE.AddDataField( 1, "ooccolor", Color( 0, 255, 0, 100 ))

	CAKE.ConVars[ "AdvertiseEnabled" ] = "1"; -- Can players advertise
	CAKE.ConVars[ "AdvertisePrice" ] = 25; -- How much do advertisements cost
	CAKE.ConVars[ "OOCDelay" ] = 10; -- How long do you have to wait between OOC Chat
	
	CAKE.ConVars[ "YellRange" ] = 1.5; -- How much farther will yell chat go
	CAKE.ConVars[ "WhisperRange" ] = 0.2; -- How far will whisper chat go
	CAKE.ConVars[ "MeRange" ] = 1.0; -- How far will me chat go
	CAKE.ConVars[ "LOOCRange" ] = 1.0; -- How far will LOOC chat go
	
	CAKE.SimpleChatCommand( "/?", CAKE.ConVars[ "MeRange" ], "??? : $3" ); -- Anon chat
	--CAKE.SimpleChatCommand( "/me", CAKE.ConVars[ "MeRange" ], "*** $1 $3" ); -- Me chat
	CAKE.SimpleChatCommand( "/it", CAKE.ConVars[ "MeRange" ], "*** $3" ); -- It chat
	CAKE.SimpleChatCommand( "/anon", CAKE.ConVars[ "MeRange" ], "???: $3" ); -- It chat
	--CAKE.SimpleChatCommand( "/y", CAKE.ConVars[ "YellRange" ], "<font=DefaultLarge>$1 [YELL]: $3</font>" ); -- Yell chat
	--CAKE.SimpleChatCommand( "/w", CAKE.ConVars[ "WhisperRange" ], "<font=DefaultSmall>$1 [WHISPER]: $3</font>" ); -- Whisper chat
	CAKE.SimpleChatCommand( ".//", CAKE.ConVars[ "LOOCRange" ], "$1 | $2 [LOOC]: $3", "OOC" ); -- Local OOC Chat
	CAKE.SimpleChatCommand( "[[", CAKE.ConVars[ "LOOCRange" ], "$1 | $2 [LOOC]: $3", "OOC" ); -- Local OOC Chat

	CAKE.ChatCommand( "/ad", Advertise );
	CAKE.ChatCommand( "/y", Yell);
	CAKE.ChatCommand( "/me", Emote);
	CAKE.ChatCommand( "/w", Whisper);
	CAKE.ChatCommand( "/event", Event );	-- Advertisements
	CAKE.ChatCommand( "/bc", Broadcast ); -- Broadcast
	CAKE.ChatCommand( "/r", Radio ); -- Radio
	CAKE.ChatCommand( "/radio", Radio );
	CAKE.ChatCommand( "/removehelmet", RemoveHelmet );
	CAKE.ChatCommand( "/pm", PersonalMessage );
	CAKE.ChatCommand( "/title", Title );
	CAKE.ChatCommand( "/report", Report );
	
end

