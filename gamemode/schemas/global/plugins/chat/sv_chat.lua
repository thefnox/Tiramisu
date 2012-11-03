--Everything chat related

util.AddNetworkString("TiramisuAddToChat")
util.AddNetworkString("TiramisuAddToOOC")
util.AddNetworkString("TiramisuChatHandling")

local meta = FindMetaTable( "Player" )

--Used instead of RunConsoleCOmmand
function meta:Say( text )

	gamemode.Call("PlayerSay", self, text )

end

TIRA.ChatCommands = {  }

function TIRA.SimpleChatCommand( prefix, range, form, font, channel )

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
	-- (paramenters channel, range and font allows them to behave like more complex chat commands too :D, they're all optional)
	
	local cc = {  }
	cc.simple = true
	cc.cmd = cmd
	cc.range = range
	cc.form = form
	cc.channel = channel
	cc.font = font
	
	TIRA.ChatCommands[ prefix ] = cc
	
end

function TIRA.ChatCommand( prefix, callback )

	local cc = {  }
	cc.simple = false
	cc.cmd = prefix
	cc.callback = callback
	
	TIRA.ChatCommands[ prefix ] = cc
	
end

hook.Add( "AcceptStream", "TiramisuAcceptChatStream", function( pl, handler, id )
	if handler == "TiramisuChatHandling" then
		return true
	end
end)

--NOTE: TIRAMISU IS NOW COMPATIBLE WITH REGULAR CHAT :D

function GM:PlayerSay( ply, text, team )

	TIRA.DayLog("chat.txt", ply:SteamID() .. ": " .. text) -- we be spyins.
	
	if( string.sub( text, 1, 2) == "//" or string.sub( text, 1, 4) == "/ooc" ) then --OOC override, to add colors.
		TIRA.OOCAdd( ply, text )
		return ""
	end
	
	for prefix, cc in pairs( TIRA.ChatCommands ) do
	
		local cmd = prefix
		local cmdlen = string.len( cmd )
		local cmdtxt = string.sub( text, 0, cmdlen )
		
		cmdtxt = string.lower( cmdtxt )
		cmd = string.lower( cmd )
		
		if( cmdtxt == cmd and (string.sub( text, cmdlen + 1, cmdlen + 1 ) == " " or string.len(text) == cmdlen) ) then -- This allows for multiple commands to start with the same thing 
			
			local args = string.sub( text, cmdlen + 2 )
			
			if( args == nil ) then
			
				args = ""
				
			end
			
			if( !cc.simple ) then
			
				return cc.callback( ply, args )
				
			end
			
			local s = cc.form
			local s = string.gsub( s, "$1", ply:Nick( ) ) -- IC Name
			local s = string.gsub( s, "$2", ply:Name( ) ) -- OOC Name
			local s = string.gsub( s, "$3", args ) -- Text
			
			TIRA.ICAdd( ply, s, cc.range, cc.font, cc.channel )

			return ""
			
		end
		
	end
	
	if( string.sub( text, 1, 1 ) == "/" ) then
	
		TIRA.SendChat( ply, "That is not a valid command" )
		return ""
	
	else
	
		-- Hurr, IC Chat..

		TIRA.ICAdd( ply, ply:Nick() .. ": " .. text )
		
		return ""
		
	end

end

net.Receive("TiramisuChatHandling", function(len, ply)
	local text = net.ReadString() or ""
	gamemode.Call("PlayerSay", ply, text )
end)


--Adds a regular radio chat line.
function TIRA.AddRadioLine( ply, text )
	net.Start("TiramisuAddToRadio")
		net.WriteString(text)
	net.Send(ply)
end


--Concommand to handle OOC color changes. Takes 4 arguments, red, green, blue and alpha.
local function ccChangeOOCColor( ply, cmd, args )
	
	TIRA.SetPlayerField( ply, "ooccolor", Color( math.Clamp( tonumber( args[1] ), 0, 255 ), math.Clamp( tonumber( args[2] ), 0, 255 ), math.Clamp( tonumber( args[3] ), 0, 255 ), math.Clamp( tonumber( args[4] ), 0, 100 ) ) )

end
concommand.Add( "rp_ooccolor", ccChangeOOCColor )

--Sends a regular blue IC message.

function TIRA.ICAdd( ply, text, range, font, channel )

	if ply:Alive() then
		range = range or TIRA.ConVars[ "TalkRange" ]

		for _, pl in pairs( ents.FindInSphere( ply:GetPos(), range * 2 ) ) do
			local tracedata = {}
			tracedata.start = pl:EyePos()
			tracedata.endpos = ply:EyePos()
			tracedata.filter = pl
			tracedata.mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER
			if( pl:IsTiraPlayer() and pl:IsPlayer() and (pl:EyePos( ):Distance( ply:EyePos( ) ) <= range or util.TraceLine(tracedata).Entity == ply )) then
			
				TIRA.SendChat( pl, text, font, channel or "IC" )
			
			end
		
		end
	end

end

--Handles OOC messaging.

function TIRA.OOCAdd( ply, text )

	if( ply.LastOOC + TIRA.ConVars[ "OOCDelay" ] < CurTime() or TIRA.PlayerRank(ply) > 2 ) then
	
		local playername = ply:Name( ) 
		local color = TIRA.GetPlayerField( ply, "ooccolor" )
		if( string.sub( text, 1, 4 ) == "/ooc" ) then
			text = string.sub( text, 5 )
		else
			text = string.sub( text, 3 )
		end

		for _, target in pairs( player.GetAll( ) ) do
			if ValidEntity( target ) and target:IsPlayer() and target:IsCharLoaded() then
				net.Start( "TiramisuAddToOOC")
					net.WriteTable({
						["text"] = text,
						["color"] = color,
						["name"] = playername,
						["font"] = "TiramisuOOCFont",
						["channel"] = channel or "OOC"
					})
				net.Send(target)
			end
		end
		
		ply.LastOOC = CurTime()
		
	else
	
		local TimeLeft = math.ceil(ply.LastOOC + TIRA.ConVars[ "OOCDelay" ] - CurTime())
		TIRA.SendChat( ply, "Please wait " .. TimeLeft .. " seconds before using OOC chat again!", false, "OOC")
		
	end
end

--Sends the user a random number between the two limits established in the two arguments( Defaults to 0 and 100 )
local function ccRoll( ply, cmd, args )

	local Min = args[1]
	local Max = args[2]

		if( tonumber(args[1]) == nil and tonumber(args[2]) == nil ) then
	
			Min = 1
			Max = 100
		
		end

		if( tonumber(args[2]) == nil and tonumber(args[1]) != nil) then

			Min = 1
			Max = args[1]
		
		end
	
		if( tonumber(args[1]) != nil and tonumber(args[2]) != nil) then
		
			if(tonumber(args[1]) > tonumber(args[2]) )  then

			Min = args[2]
			Max = args[1]
		
			end
		
		end
	
	local roll = math.random( Min , Max )
	
		for k, v in pairs( player.GetAll( ) ) do
		
			if( v:EyePos():Distance( ply:EyePos() ) <= 300 ) then
			
				TIRA.SendChat( v, "[Roll] " .. ply:Nick() .. " rolled a " .. roll .. " out of " .. Min .. "-" .. Max .. ".", false, "IC")
			
			end
		
		end
	
end
concommand.Add("rp_roll", ccRoll)

--Makes a player display the "Typing" title
function ccOpenChat( ply, cmd, args )

	ply:SetNWBool( "chatopen", true )
	
end
concommand.Add( "rp_openedchat", ccOpenChat )

--Hides the "Typing" title
function ccCloseChat( ply, cmd, args )

	ply:SetNWBool( "chatopen", false )
	
end
concommand.Add( "rp_closedchat", ccCloseChat )

--Reports a message directly to all online admins in the channel "Reports"
local function Report( ply, text )

	for k, v in pairs(player.GetAll()) do
		
		if( v:IsAdmin() or v:IsSuperAdmin() ) then
		
			TIRA.SendChat( v, ply:Nick() .. " | " .. ply:Name() .. " [" .. ply:SteamID()  .. "] [REPORT]:" .. text, false, "Reports" )
			
		end
	
	end
	
	if( !ply:IsAdmin() and !ply:IsSuperAdmin() ) then 
	
		TIRA.SendChat( ply, ply:Nick() .. " [REPORT]:" .. text )
		
	end
	
	return ""
	
end

--Global message that only admins may send.
local function Event( ply, text )

	-- Check to see if the player's team allows broadcasting
	if( TIRA.PlayerRank(ply) > 0 ) then
		
		for k, v in pairs( player.GetAll( ) ) do
		
			TIRA.SendChat( v, "[EVENT]: " .. text, false, "IC" )
			
		end
	
	end
	
	return ""
	
end

--Sends a private message to anyone who is online. Opens on a separate channel.
local function PersonalMessage( ply, text )

	-- Check to see if the player's team allows broadcasting
	local exp = string.Explode( " ", text )
	local target = TIRA.FindPlayer( exp[1] )
	table.remove( exp, 1)
	if target then
		TIRA.SendChat( target, "[FROM:" .. ply:Nick() .. "]" .. table.concat( exp, " " ), false, ply:Name(), "/pm " .. TIRA.FormatText(ply:SteamID()) .. " " )
		TIRA.SendChat( ply, "[TO:" .. target:Nick() .. "]" .. table.concat( exp, " " ), false, target:Name(),"/pm " .. TIRA.FormatText(target:SteamID()) .. " " )
	else
		TIRA.SendChat( ply, "Target not found!" )
	end
	
	return ""
	
end

--Removes your currently wore helmet.
local function RemoveHelmet( ply, text )
	
	local gender = TIRA.GetCharField( ply, "gender" )
	local article = ""
	
	if gender == "Female" then
		article = "her"
	else
		article = "his"
	end
	
	for k, v in pairs(player.GetAll()) do
		
		local range = TIRA.ConVars[ "TalkRange" ]
			
		if( v:EyePos( ):Distance( ply:EyePos( ) ) <= range ) then
			
			TIRA.SendChat( v, "*** " .. ply:Nick() .. " removed " .. article .. " helmet.", false, "IC" )
				
		end
			
	end
	
	TIRA.RemoveHelmet( ply )
	
	return ""

end

--Sends a global message if advertising is allowed. Costs money.
local function Advertise( ply, text )

	if(TIRA.ConVars[ "AdvertiseEnabled" ] == "1") then
	
		if( tonumber( TIRA.GetCharField( ply, "money" ) ) >= TIRA.ConVars[ "AdvertisePrice" ] ) then
			
			TIRA.ChangeMoney( ply, 0 - TIRA.ConVars[ "AdvertisePrice" ] )
		
			for _, pl in pairs(player.GetAll()) do
			
				TIRA.SendChat(pl, "[AD] " .. ply:Nick() .. ": " .. text, false, "IC" )
		
			end
			
		else
		
			TIRA.SendChat(ply, "You do not have enough credits! You need " .. TIRA.ConVars[ "AdvertisePrice" ] .. " to send an advertisement.")
			
		end	
		
	else
	
		TIRA.ChatPrint(ply, "Advertisements are not enabled")
		
	end
	
	return ""
	
end

--Sets your title.
local function Title( ply, text )
	ply:ConCommand( "rp_title " .. text )
	return ""
end

--Sets the title of the door you're facing.
local function DoorTitle( ply, text )
	ply:ConCommand( "rp_doortitle " .. text)
	return ""
end

hook.Add( "PlayerSpawn", "TiramisuStartChat", function( ply )
	if !ply.ChatInitialized then
		ply.ChatInitialized = true
		umsg.Start( "TiramisuInitChat", ply )
		umsg.End()
	end
end)

function GM:PlayerChat( ply, text )
	return ""
end

function PLUGIN.Init( ) -- We run this in init, because this is called after the entire gamemode has been loaded.

	TIRA.AddDataField( 1, "ooccolor", Color( 0, 255, 0, 100 ))

	TIRA.ConVars[ "AdvertiseEnabled" ] = "1" -- Can players advertise
	TIRA.ConVars[ "AdvertisePrice" ] = 25 -- How much do advertisements cost
	TIRA.ConVars[ "OOCDelay" ] = 10 -- How long do you have to wait between OOC Chat
	
	TIRA.ConVars[ "YellRange" ] = 1.5 * TIRA.ConVars[ "TalkRange" ] -- How much farther will yell chat go
	TIRA.ConVars[ "WhisperRange" ] = 0.2 * TIRA.ConVars[ "TalkRange" ]  -- How far will whisper chat go
	TIRA.ConVars[ "MeRange" ] = TIRA.ConVars[ "TalkRange" ]  -- How far will me chat go
	TIRA.ConVars[ "LOOCRange" ] = TIRA.ConVars[ "TalkRange" ]   -- How far will LOOC chat go
	
	TIRA.SimpleChatCommand( "/?", TIRA.ConVars[ "MeRange" ], "??? : $3", "TiramisuEmoteFont" ) -- Anon chat
	TIRA.SimpleChatCommand( "/me", TIRA.ConVars[ "MeRange" ], "*** $1 $3", "TiramisuEmoteFont" ) -- Me chat
	TIRA.SimpleChatCommand( "/it", TIRA.ConVars[ "MeRange" ], "*** $3", "TiramisuEmoteFont" ) -- It chat
	TIRA.SimpleChatCommand( "/anon", TIRA.ConVars[ "MeRange" ], "???: $3", "TiramisuEmoteFont" ) -- It chat
	TIRA.SimpleChatCommand( "/y", TIRA.ConVars[ "YellRange" ], "$1 [YELL]: $3", "TiramisuYellFont" ) -- Yell chat
	TIRA.SimpleChatCommand( "/w", TIRA.ConVars[ "WhisperRange" ], "$1 [WHISPER]: $3</font>", "TiramisuWhisperFont" ) -- Whisper chat
	TIRA.SimpleChatCommand( ".//", TIRA.ConVars[ "LOOCRange" ], "$1 | $2 [LOOC]: $3", "TiramisuOOCFont", "OOC" ) -- Local OOC Chat
	TIRA.SimpleChatCommand( "[[", TIRA.ConVars[ "LOOCRange" ], "$1 | $2 [LOOC]: $3", "TiramisuOOCFont", "OOC"  ) -- Local OOC Chat

	TIRA.ChatCommand( "/ad", Advertise )
	--TIRA.ChatCommand( "/y", Yell)
	--TIRA.ChatCommand( "/me", Emote)
	--TIRA.ChatCommand( "/w", Whisper)
	TIRA.ChatCommand( "/event", Event )	-- Advertisements
	TIRA.ChatCommand( "/removehelmet", RemoveHelmet )
	TIRA.ChatCommand( "/pm", PersonalMessage )
	TIRA.ChatCommand( "/title", Title )
	TIRA.ChatCommand( "/report", Report )
	
end

