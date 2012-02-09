--Broadcasts a message across the server, if group permissions for the faction allow it.
local function Broadcast( ply, text )

	-- Check to see if the player's team allows broadcasting
	local group = CAKE.GetCharField( ply, "activegroup" )
	
	if( CAKE.GroupExists( group )) then
		local group = CAKE.GetGroup( group )

		if group:GetField( "type" ) == "faction" and group:CharacterInGroup( ply ) and group:GetRankField( group:GetCharacterInfo( ply ).Rank, "canbroadcast" ) then
			for k, v in pairs( player.GetAll( ) ) do
			
				CAKE.SendChat( v, "[BROADCAST]: " .. text, "BudgetLabel", "IC" )
				
			end
		end
	
	end
	
	return ""
	
end

--Allows communication between group members.
local function GroupChat( ply, text )

	if !CAKE.ConVars[ "AllowGroupChat" ] then return "" end

	print( "whoop whoop!")

	-- Check to see if the player's team allows broadcasting
	local exp = string.Explode( " ", text )
	local color = CAKE.GetPlayerField( ply, "ooccolor" )
	local group
	if CAKE.GroupExists( exp[1] ) then
		group = CAKE.GetGroup( exp[1] )
		table.remove( exp, 1 )
		text = table.concat( exp, " " )
	else
		group = CAKE.GetGroup( "activegroup" )
	end

	print( "talking to group:", group.UniqueID)
	
	if group and group:CharInGroup( ply ) then
		for k, v in pairs( group:GetOnlineChars() ) do
			datastream.StreamToClients( v, "TiramisuAddToGroupChat", {
				["text"] = text,
				["color"] = color,
				["name"] = ply:Nick(),
				["channel"] = "[" .. group:Name() .. "]",
				["handler"] = "/g " .. group.UniqueID .. " "
			})
		end
	end
	
	return ""
	
end


function PLUGIN.Init( )

	CAKE.ChatCommand( "/bc", Broadcast ) -- Broadcast
	CAKE.ChatCommand( "/g", GroupChat )
	CAKE.ChatCommand( "/group", GroupChat )

end