TIRA.AdminCommands = {  }
TIRA.AdminRanks = {  } 

--Sends an admin message to all players.
function TIRA.AnnounceAction( ply, action )

	local s
	if ply:IsTiraPlayer() then
		s = "[ ADMIN ] " .. ply:Name( ) .. " " .. action

		for k, v in pairs( player.GetAll( ) ) do

			TIRA.SendChat( v, s )
			
		end
	else
		s = "[ ADMIN ] Console " .. action

		for k, v in pairs( player.GetAll( ) ) do

			TIRA.SendChat( v, s )
			
		end
	end

end

-- This will create an admin function.
function TIRA.AdminCommand( ccName, func, description, CanRunFromConsole, CanRunFromAdmin, MinRank )

		local cmd = {  }
		cmd.func = func
		cmd.desc = description
		cmd.CanRunFromConsole = TIRA.NilFix(CanRunFromConsole, true)
		cmd.CanRunFromAdmin = TIRA.NilFix(CanRunFromAdmin, true)
		cmd.MinRank = TIRA.NilFix(MinRank, 0)

		TIRA.AdminCommands[ ccName ] = cmd
	
end

function TIRA.RemoveAdminCommand( ccName )
	if TIRA.AdminCommands[ ccName ] then
		TIRA.AdminCommands[ ccName ] = nil
	end
end

--Fetches a player's rank. Automatically compensates for administrators set outside of Tiramisu.
function TIRA.PlayerRank(ply)

	if ply:IsSuperAdmin() then
		return 5
	elseif ply:IsAdmin() then
		return 4
	end
		
	if TIRA.AdminRanks[TIRA.GetPlayerField( ply, "adrank" )] then
		return TIRA.AdminRanks[TIRA.GetPlayerField( ply, "adrank" )].rank
	else
		return 0
	end
end

function parseAdminArgs(words)
	curstring = ""
	instring = false
	out = {}
	for k,v in pairs(words) do
		first, a = string.find(v, "'", 1, true)
		if first then second, a = string.find(v, "'", first+1, true) end
		if second and string.find(v, "'", second + 1, true) then return 4 end
		if first and second then
			if !instring then
				fsplit = string.sub(v, 1, first-1)
				lsplit = string.sub(v, first+1, second-1)
				bsplit = string.sub(v, second+1)
				
				if fsplit == "'" or fsplit == " " or fsplit == "" then fsplit = nil end
				if lsplit == "'" or lsplit == " " or lsplit == "" then lsplit = nil end
				if bsplit == "'" or bsplit == " " or bsplit == "" then bsplit = nil end

				if fsplit then table.insert(out, fsplit) end
				if lsplit then table.insert(out, lsplit) end
				if bsplit then table.insert(out, bsplit) end
				print(bsplit)
			else
				fsplit = string.sub(v, 1, first-1)
				lsplit = string.sub(v, first+1, second -1)
				bsplit = string.sub(v, second+1)
				
				if fsplit == "'" or fsplit == " " or fsplit == "" then fsplit = nil end
				if lsplit == "'" or lsplit == " " or lsplit == "" then lsplit = nil end
				if bsplit == "'" or bsplit == " " or bsplit == "" then bsplit = nil end

				if fsplit then table.insert(out, curstring .. " " .. fsplit) end
				if lsplit then table.insert(out, lsplit) end
				curstring = bsplit or ""
			end
		elseif first then

			fsplit = string.sub(v, 1, first-1)
			lsplit = string.sub(v, first+1)

			if fsplit == "'" or fsplit == " " or fsplit == "" then fsplit = nil end
			if lsplit == "'" or lsplit == " " or lsplit == "" then lsplit = nil end

			if instring then
				if fsplit then table.insert(out, curstring .. " " .. fsplit) end
				if lsplit then table.insert(out, lsplit) end
				curstring = ""
				instring = false
			else
				if fsplit then table.insert(out, fsplit) end
				curstring = lsplit or ""
				instring = true
			end

		elseif instring then
			curstring = curstring .. " " .. v
		else
			table.insert(out, v)
		end
	end
	return out
end

-- Syntax is rp_admin command args
function ccAdmin( ply, cmd, args )

	local cmd = TIRA.NilFix( TIRA.AdminCommands[args[ 1 ]], 0)
	
	if( cmd == 0 ) then
	
		TIRA.SendChat( ply, "That is not a valid command!" )
		return
		
	end
	
	local func = cmd.func -- Retrieve the function
	local CanRunFromConsole = cmd.CanRunFromConsole -- Can it be run from the console
	local CanRunFromAdmin = cmd.CanRunFromAdmin -- Can it be run from a player's console
	local MinRank = cmd.MinRank
	local CMDName = args[1]
	
	table.remove( args, 1 ) -- Remove the admin command from the arguments
	args = parseAdminArgs(args)
	if( ply:EntIndex( ) == 0 ) then -- We're dealing with a console
		
		if( CanRunFromConsole ) then
		
			func( ply, cmd, args )
			
		else

			TIRA.PrintConsole( "You cannot run this command from server console!" )
			
		end
		
	else	
	
		if TIRA.PlayerRank(ply) >= 0 then -- We're dealing with an admin.
			
			if TIRA.PlayerRank(ply) >= cmd.MinRank then
			
				func( ply, cmd, args )
				
			else
			
				if !ply:IsSuperAdmin() then TIRA.SendChat( ply, "You are of insufficient rank!" ) end
				
			end
		
		else 
		
			if TIRA.PlayerRank(ply) == 0 then
				TIRA.SendChat( ply, "You are not an admin!")
			end
		
		end
	
	end
		
end
concommand.Add("rp_admin", ccAdmin) 

--Creates a new administrative rank. int refers to it's hirearchical level.
function TIRA.AddAdminRank(name, int, short)
	
	rank = {}
	rank.rank = int
	rank.name = name
	rank.short = short
	
	TIRA.AdminRanks[name] = rank
	
end

TIRA.AddAdminRank("Player", 0, "none")