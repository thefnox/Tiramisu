-- rp_admin superban "name" "reason" minutes
local function Admin_SuperBan( ply, cmd, args )

	if( #args != 3 ) then
	
		TIRA.SendChat( ply, "Invalid number of arguments! ( rp_admin superban \"name\" \"reason\" minutes )" )
		return
		
	end
	
	local plyname = args[ 1 ]
	local reason = args[ 2 ]
	local mins = tonumber( args[ 3 ] )
	
	local pl = TIRA.FindPlayer( plyname )
	
	if( pl and pl:IsValid( ) and pl:IsTiraPlayer( ) ) then
	
		local UniqueID = pl:UserID( )
		
		-- This bans, then kicks, then writes their ID to the file.
		game.ConsoleCommand( "banid " .. mins .. " " .. UniqueID .. "\n" )
		
		if( mins == 0 ) then
		
			game.ConsoleCommand( "kickid " .. UniqueID .. " \"Permanently banned ( " .. reason .. " )\"\n" )
			TIRA.AnnounceAction( ply, "permabanned " .. pl:Nick( ) )
	
		else
		
			game.ConsoleCommand( "kickid " .. UniqueID .. " \"Banned for " .. mins .. " mins ( " .. reason .. " )\"\n" )
			TIRA.AnnounceAction( ply, "banned " .. pl:Nick( ) )
			
		end
		
		game.ConsoleCommand( "writeid\n" )
		
	else
	
		TIRA.SendChat( ply, "Cannot find " .. plyname .. "!" )
		
	end
	
end

-- rp_admin ban "name" "reason" minutes
local function Admin_Ban( ply, cmd, args )

	if( #args != 3 ) then
	
		TIRA.SendChat( ply, "Invalid number of arguments! ( rp_admin ban \"name\" \"reason\" minutes )" )
		return
		
	end
	
	local plyname = args[ 1 ]
	local reason = args[ 2 ]
	local mins = tonumber( args[ 3 ] )
	
	if(mins > TIRA.ConVars[ "MaxBan" ]) then
	
		TIRA.SendChat( ply, "Max minutes is " .. TIRA.ConVars[ "MaxBan" ] .. " for regular ban. Use superban.")
		return
	
	end
	
	local pl = TIRA.FindPlayer( plyname )
	
	if( pl and pl:IsValid( ) and pl:IsTiraPlayer( ) ) then
	
		local UniqueID = pl:UserID( )
		
		-- This bans, then kicks, then writes their ID to the file.
		game.ConsoleCommand( "banid " .. mins .. " " .. UniqueID .. "\n" )
		game.ConsoleCommand( "kickid " .. UniqueID .. " \"Banned for " .. mins .. " mins ( " .. reason .. " )\"\n" )
		game.ConsoleCommand( "writeid\n" )
		
		TIRA.AnnounceAction( ply, "banned " .. pl:Nick( ) )
		
	else
	
		TIRA.SendChat( ply, "Cannot find " .. plyname .. "!" )
		
	end
	
end

-- Let's make some ADMIN COMMANDS!
function PLUGIN.Init( )

	TIRA.ConVars[ "MaxBan" ] = 300 -- What is the maximum ban limit for regular admins?
	
	TIRA.AdminCommand( "ban", Admin_Ban, "Ban someone on the server", true, true, 3 )
	TIRA.AdminCommand( "superban", Admin_SuperBan, "Ban someone on the server ( Permanent allowed )", true, true, 4 )
	
end

