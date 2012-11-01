--Broadcasts a message across the server, if group permissions for the faction allow it.
local function Broadcast( ply, text )

	-- Check to see if the player's team allows broadcasting
	local group = TIRA.GetCharField( ply, "activegroup" )
	
	if( TIRA.GroupExists( group )) then
		local group = TIRA.GetGroup( group )

		if group:GetField( "type" ) == "faction" and group:CharacterInGroup( ply ) and group:GetRankField( group:GetCharacterInfo( ply ).Rank, "canbroadcast" ) then
			for k, v in pairs( player.GetAll( ) ) do
			
				TIRA.SendChat( v, "[BROADCAST]: " .. text, "BudgetLabel", "IC" )
				
			end
		end
	
	end
	
	return ""
	
end

--Allows communication between group members.
local function GroupChat( ply, text )

	if !TIRA.ConVars[ "AllowGroupChat" ] then return "" end

	-- Check to see if the player's team allows broadcasting
	local exp = string.Explode( " ", text )
	local color = TIRA.GetPlayerField( ply, "ooccolor" )
	local group
	if exp[1] and TIRA.GroupExists( exp[1] or "none" ) then
		group = TIRA.GetGroup( exp[1] )
		table.remove( exp, 1 )
		text = table.concat( exp, " " )
	else
		group = TIRA.GetGroup(TIRA.GetCharField( ply, "activegroup" ))
	end
	
	if group and group:CharInGroup( ply ) then
		for k, v in pairs( group:GetOnlineChars() ) do
			net.Start("TiramisuAddToGroupChat")
				net.WriteTable({
					["text"] = text,
					["color"] = color,
					["name"] = ply:Nick(),
					["channel"] = "[" .. group:Name() .. "]",
					["handler"] = "/g " .. group.UniqueID .. " "
				})
			net.Send(v)
		end
	end
	
	return ""
	
end


function PLUGIN.Init( )

	TIRA.ChatCommand( "/bc", Broadcast ) -- Broadcast
	TIRA.ChatCommand( "/g", GroupChat )
	TIRA.ChatCommand( "/group", GroupChat )

end