-- rp_admin kick "name" "reason"
local function Admin_Kick( ply, cmd, args )

	if( #args != 2 ) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin kick \"name\" \"reason\" )" )
		return
		
	end
	
	local plyname = args[ 1 ]
	local reason = args[ 2 ]
	
	local pl = CAKE.FindPlayer( plyname )
	
	if ValidEntity( pl ) and pl:IsTiraPlayer( ) then
	
		local UniqueID = pl:UserID( )
		
		game.ConsoleCommand( "kickid " .. UniqueID .. " \"" .. reason .. "\"\n" )
		
		CAKE.AnnounceAction( ply, "kicked " .. pl:Nick( ) )
		
	else
	
		CAKE.SendChat( ply, "Cannot find " .. plyname .. "!" )
		
	end
	
end

-- rp_admin ban "name" "reason" minutes
local function Admin_Ban( ply, cmd, args )

	if( #args != 3 ) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin ban \"name\" \"reason\" minutes )" )
		return
		
	end
	
	local plyname = args[ 1 ]
	local reason = args[ 2 ]
	local mins = tonumber( args[ 3 ] )
	
	if(mins > CAKE.ConVars[ "MaxBan" ]) then
	
		CAKE.SendChat( ply, "Max minutes is " .. CAKE.ConVars[ "MaxBan" ] .. " for regular ban. Use superban.")
		return
	
	end
	
	local pl = CAKE.FindPlayer( plyname )
	
	if( pl and pl:IsValid( ) and pl:IsTiraPlayer( ) ) then
	
		local UniqueID = pl:UserID( )
		
		-- This bans, then kicks, then writes their ID to the file.
		game.ConsoleCommand( "banid " .. mins .. " " .. UniqueID .. "\n" )
		game.ConsoleCommand( "kickid " .. UniqueID .. " \"Banned for " .. mins .. " mins ( " .. reason .. " )\"\n" )
		game.ConsoleCommand( "writeid\n" )
		
		CAKE.AnnounceAction( ply, "banned " .. pl:Nick( ) )
		
	else
	
		CAKE.SendChat( ply, "Cannot find " .. plyname .. "!" )
		
	end
	
end

--rp_admin observe. No arguments.
local function Admin_Observe( ply, cmd, args )

	if( !ply:GetNWBool( "observe" ) and ply:GetMoveType() != MOVETYPE_NOCLIP ) then

		ply:GodEnable()
			if ply.Clothing then
			 for k, v in pairs( ply.Clothing ) do
					if ValidEntity( v ) then
						v:SetNoDraw( true )
					end
			 end
			end
		
			if( ply.Gear ) then
				for k, v in pairs( ply.Gear ) do
					if ValidEntity( v ) then
						v:SetNoDraw( true )
					end
				end
			end
		
		ply:DrawWorldModel(false)
		ply:DrawViewModel(false)
		
		ply:SetNotSolid( true )
		ply:SetMoveType( 8 )
		ply:SetNoDraw( true )
		
		ply:SetNWBool( "observe", true )
		
	else

		ply:GodDisable()
		for k, v in pairs( ply.Clothing ) do
			if type( v ) != "table" then --So it isn't gear.
				if ValidEntity( v ) then
					v:SetNoDraw( false )
				end
			end
		end
		
			if( ply.Gear ) then
				for k, v in pairs( ply.Gear ) do
					if ValidEntity( v ) then
						v:SetNoDraw( false )
					end
				end
			end
		
		ply:DrawWorldModel(true)
		ply:DrawViewModel(true)
		
		ply:SetNotSolid( false )
		ply:SetMoveType( 2 )
		 ply:SetNoDraw( false )
		ply:SetNWBool( "observe", false )
		
	end

end

--rp admin noclip. No arguments.
local function Admin_Noclip( ply, cmd, args )
		
	ply.Noclip = !ply.Noclip

	if !ply.Noclip then

		ply:GodEnable()
		ply:SetNotSolid( true )
		ply:SetMoveType( 8 )

	else

		ply:GodDisable()

		ply:SetNotSolid( false )
		ply:SetMoveType( 2 )

	end
end

-- rp_admin superban "name" "reason" minutes
local function Admin_SuperBan( ply, cmd, args )

	if( #args != 3 ) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin superban \"name\" \"reason\" minutes )" )
		return
		
	end
	
	local plyname = args[ 1 ]
	local reason = args[ 2 ]
	local mins = tonumber( args[ 3 ] )
	
	local pl = CAKE.FindPlayer( plyname )
	
	if( pl and pl:IsValid( ) and pl:IsTiraPlayer( ) ) then
	
		local UniqueID = pl:UserID( )
		
		-- This bans, then kicks, then writes their ID to the file.
		game.ConsoleCommand( "banid " .. mins .. " " .. UniqueID .. "\n" )
		
		if( mins == 0 ) then
		
			game.ConsoleCommand( "kickid " .. UniqueID .. " \"Permanently banned ( " .. reason .. " )\"\n" )
			CAKE.AnnounceAction( ply, "permabanned " .. pl:Nick( ) )
	
		else
		
			game.ConsoleCommand( "kickid " .. UniqueID .. " \"Banned for " .. mins .. " mins ( " .. reason .. " )\"\n" )
			CAKE.AnnounceAction( ply, "banned " .. pl:Nick( ) )
			
		end
		
		game.ConsoleCommand( "writeid\n" )
		
	else
	
		CAKE.SendChat( ply, "Cannot find " .. plyname .. "!" )
		
	end
	
end

--rp_admin setconvar var value
local function Admin_SetConVar( ply, cmd, args )

	if( #args != 2 ) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin setvar \"varname\" \"value\" )" )
		return
		
	end
	
	if( CAKE.ConVars[ args[ 1 ] ] ) then
	
		local vartype = type( CAKE.ConVars[ args [ 1 ] ] )
		
		if( vartype == "string" ) then
		
			CAKE.ConVars[ args[ 1 ] ] = tostring(args[ 2 ])
			
		elseif( vartype == "number" ) then
		
			CAKE.ConVars[ args[ 1 ] ] = CAKE.NilFix(tonumber(args[ 2 ]), 0) -- Don't set a fkn string for a number, dumbass! >:<
		
		elseif( vartype == "table" ) then
		
			CAKE.SendChat( ply, args[ 1 ] .. " cannot be changed, it is a table." ) -- This is kind of like.. impossible.. kinda. (Or I'm just a lazy fuck)
			return
			
		end
		
		CAKE.SendChat( ply, args[ 1 ] .. " set to " .. args[ 2 ] )
		
	else
	
		CAKE.SendChat( ply, args[ 1 ] .. " is not a valid convar! Use rp_admin listvars" )
		
	end
	
end

--rp_admin oocdelay number
local function Admin_SetOOCDelay( ply, cmd, args )

	CAKE.ConVars[ args[ 1 ] ] = tostring(args[ 1 ])
	CAKE.SendChat( ply, "OOC Delay set to " .. tostring(args[ 1 ]) )
	
end

--rp_admin listvars, no argument.
local function Admin_ListVars( ply, cmd, args )

	CAKE.SendChat( ply, "---List of Tiramisu ConVars---" )
	
	for k, v in pairs( CAKE.ConVars ) do
		
		CAKE.SendChat( ply, k .. " - " .. tostring(v) )
		
	end
	
end

--rp_admin help, no arguments.
local function Admin_Help( ply, cmd, args )

	CAKE.SendChat( ply, "---List of Tiramisu Admin Commands---" )
	
	for cmdname, cmd in pairs( CAKE.AdminCommands ) do
	
		local s = cmdname .. " \"" .. cmd.desc .. "\""
		
		if(cmd.CanRunFromConsole) then
		
			s = s .. " console"

		else
		
			s = s .. " noconsole"
			
		end
		
		if(cmd.CanRunFromAdmin) then
		
			s = s .. " admin"
			
		end
		
		if(cmd.SuperOnly) then
		
			s = s .. " superonly"
			
		end

		s = s .. "\n\n"
		
		CAKE.SendChat( ply, s )
		
	end
	
end

--rp_admin setmoney name money. This sets, not adds the money.
local function Admin_SetMoney( ply, cmd, args )

	local target = CAKE.FindPlayer(args[1])
	if ValidEntity(target) then
		CAKE.SetCharField( target, "money", tonumber( args[2] ) )
		ply:SetNWInt( "money", tonumber( args[2] ) )
	end
		
end

--rp_admin createitem item_class
local function Admin_CreateItem( ply, cmd, args ) -- Why the fuck wasn't this here on the first place...

	if args[1] then
		CAKE.CreateItem( args[ 1 ], ply:CalcDrop( ), Angle( 0,0,0 ) )
	else
		local tbl = {}
		for k, v in pairs( CAKE.ItemData ) do
			table.insert( tbl, v.Class .. " - " .. v.Name .. "\n" )
		end
		table.sortdesc( tbl )
		for k, v in ipairs( tbl ) do
			CAKE.SendConsole( ply, "\t" .. v )
		end
	end
	
end

--rp_admin listitems, no arguments.
local function Admin_ListItems( ply, cmd, args )
	
	for k, v in pairs( CAKE.ItemData ) do
	
		CAKE.SendConsole( ply, "\t" .. v.Class .. " - " .. v.Name .. "\n" )
	
	end

end

--rp_admin bring name. Brings a player to your position.
local function Admin_Bring( ply, cmd, args )
	
	local target = CAKE.FindPlayer( args[1] )
	
	if( target and target:IsValid() and target:IsTiraPlayer() ) then
	
		target:SetPos( ply:CalcDrop() + Vector( 0, 0, 6 ) )			
		CAKE.SendChat( ply, "Bringing " .. target:Nick() .. "." )
		CAKE.SendChat( target, "You are being brought to " .. ply:Nick() .. "." )
		
	else
	
		CAKE.SendChat( ply , "Cannot find target!")
		
	end
	
end

--rp_admin goto name. Teleports you to a player.
local function Admin_GoTo( ply, cmd, args )
	
	local target = CAKE.FindPlayer( args[1] )
	
	if( target and target:IsValid() and target:IsTiraPlayer() ) then
	
		ply:SetPos( target:CalcDrop() + Vector( 0, 0, 6 ) )
		CAKE.SendChat( ply, "Teleporting to " .. target:Nick() .. ".")
		CAKE.SendChat( target, ply:Nick() .. " is teleporting to you." )
		
	else
	
		CAKE.SendChat( ply , "Cannot find target!")
		
	end
	
end
	
--rp_admin slay name. Kills a player.
local function Admin_Slay( ply, cmd, args )

	local target = CAKE.FindPlayer( args[1] )
	
	if( target and target:IsValid( ) and target:IsTiraPlayer( ) ) then -- Target found, is player
	
		target:Kill()
		CAKE.SendChat( ply:Nick() .. "has slayed you. =)")
		CAKE.SendChat( ply, "You have slayed " .. target:Nick() .. ".")
		
	elseif( !pl ) then -- Target was not found
	
		CAKE.SendChat( ply , "Cannot find target!")
		
		return ""
		
	elseif( pl == "err") then -- More than one player of the same name
	
		CAKE.SendChat( ply , "Multiple targets selected!")
		
		return ""
		
	end
		
end

--rp_admin setrank name "rank". Sets a player to a particular admin rank.
local function Admin_SetRank( ply, cmd, args)
	print( args[1], args[2] )
	if #args != 2 then
		if ValidEntity( ply ) and ply:IsTiraPlayer() then
			CAKE.SendChat(ply, "Invalid number of arguments! ( rp_admin setrank \"name\" \"rank\" )")
		end
		return
	end
	
	args[1] = CAKE.FindPlayer(args[1])
	if !args[1] then
		if ValidEntity( ply ) and ply:IsTiraPlayer() then
			CAKE.SendChat(ply, "Target not found!")
		end
		return
	end

	for k, v in pairs(CAKE.AdminRanks) do
		if v.short == args[2] then
			args[2] = k
			break
		end
	end
	
	if !CAKE.AdminRanks[args[2]] then CAKE.SendChat(ply, "Invalid rank!") else
		CAKE.SetPlayerField( args[1], "adrank", args[2])
		CAKE.AnnounceAction( ply, "made " .. args[1]:Nick( ).. " a " ..args[2] )
	end

end

--rp_admin setmodel name model. Forces someone's model to the model specified ( DOES NOT WORK WITH CLOTHING )
local function Admin_SetModel( ply, cmd, args )

	local target = CAKE.FindPlayer(args[1])

	if !target then
		CAKE.SendChat(ply, "Target not found!")
	elseif ValidEntity( target ) then
		CAKE.RemoveClothing( target )
		CAKE.RemoveAllGear( target )
		target:SetSpecialModel( args[2] or "models/kleiner.mdl" )
		target:SetNWString( "model", args[2])
		ply:SetMaterial("")
	end

end

local function Admin_CreatePropItem( ply, cmd, args )
	if !(args[1] and args[2]) then CAKE.SendChat(ply, "Invalid number of arguments! ( rp_admin createpropitem \"name\" \"model\" )") return end
	id = CAKE.CreateItemID()
	CAKE.SetUData(id, "name", args[1])
	CAKE.SetUData(id, "model", args[2])
	CAKE.SetUData(id, "creator", ply:Nick() .. ":" .. ply:Name() .. " (" .. ply:SteamID() .. ")")
	CAKE.CreateItem( "propitem", ply:CalcDrop( ), Angle( 0,0,0 ), id )
end

local function Admin_CreateClothing( ply, cmd, args )
	if !(args[1] and args[2]) then CAKE.SendChat(ply, "Invalid number of arguments! ( rp_admin createclothing \"name\" \"type(body or head)\" \"model\" )") return end
	id = CAKE.CreateItemID()
	CAKE.SetUData(id, "name", args[1])
	CAKE.SetUData(id, "creator", ply:Nick() .. ":" .. ply:Name() .. " (" .. ply:SteamID() .. ")")
	CAKE.SetUData(id, "model", args[3])
	if args[2] == "body" then
		CAKE.CreateItem( "clothing_base", ply:CalcDrop( ), Angle( 0,0,0 ), id )
	elseif args[2] == "head" then
		CAKE.CreateItem( "helmet_base", ply:CalcDrop( ), Angle( 0,0,0 ), id )
	end
end

local function Admin_TurnIntoItem( ply, cmd, args )
	if !(args[1] and args[2]) then CAKE.SendChat(ply, "Invalid number of arguments! ( rp_admin converttoitem \"name\" \"model\" )") return end
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ))
	local name = args[2]
	local pickable = util.tobool( args[3] )
	local wearable = util.tobool( args[4] )
	local uniquename = util.tobool( args[5] )
	local bone = args[5] or "pelvis"
	if pickable then
		local id = CAKE.CreateItemID()
		CAKE.SetUData(id, "name", name)
		CAKE.SetUData(id, "model", entity:GetModel())
		if wearable then
			CAKE.SetUData(id, "wearable", true )
			CAKE.SetUData(id, "bone", bone)
		end
		CAKE.SetUData(id, "creator", ply:Nick() .. ":" .. ply:Name() .. " (" .. ply:SteamID() .. ")")
		CAKE.CreateItem( "propitem", entity:GetPos(), entity:GetAngles(), id )
		entity:Remove()
	else
		entity:SetNWString( "propdescription", name )
	end
end

local function Admin_TurnIntoClothing( ply, cmd, args )
	if !(args[1] and args[2]) then CAKE.SendChat(ply, "Invalid number of arguments! ( rp_admin converttoclothing \"entity\" \"name\" \"type\" )") return end
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ))
	local type = args[3]
	local name = args[2]
	local id = CAKE.CreateItemID()
	CAKE.SetUData(id, "name", name )
	CAKE.SetUData(id, "creator", ply:Nick() .. ":" .. ply:Name() .. " (" .. ply:SteamID() .. ")")
	CAKE.SetUData(id, "model", entity:GetModel())
	if type == "body" then
		print(util.tobool(args[4]))
		CAKE.SetUData(id, "nogloves", util.tobool(args[4]))
		CAKE.CreateItem( "clothing_base", entity:GetPos(), entity:GetAngles(), id )
		entity:Remove()
	elseif type == "head" then
		CAKE.CreateItem( "helmet_base", entity:GetPos(), entity:GetAngles(), id )
		entity:Remove()
	end
end

local function Admin_DuplicateItem( ply, cmd, args )
	if !(args[1] and args[2]) then CAKE.SendChat(ply, "Invalid number of arguments! ( rp_admin duplicate item \"entity\" \"amount\" )") return end
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ))
	local amount = math.Clamp( tonumber(args[2]), 1, 100 )
	timer.Create( ply:SteamID() .. "createitems" .. CurTime(), 0.1, amount, function()
		local origid = entity:GetNWString("id")
		local class = entity:GetNWString("Class")
		local id = CAKE.CreateItemID()
		CAKE.UData[id] = table.Copy( CAKE.UData[origid] )
		CAKE.SaveUData( id )
		CAKE.CreateItem( class, ply:CalcDrop( ), Angle( 0,0,0 ), id )
	end)

end

local function Admin_SetPermaModel( ply, cmd, args )

	if( #args != 2 ) then
	
		CAKE.SendChat( ply, "Invalid number of arguments! ( rp_admin setpermamodel \"playername\" \"modelname\" (OPTIONAL:\"gender\" )" )
		return
		
	end

	local target = CAKE.FindPlayer(args[1])

	if !target then
		CAKE.SendChat(ply, "Target not found!")
	elseif ValidEntity( target ) then
		if args[3] then
			if args[3] == "Female" then
				CAKE.SetCharField( target, "gender", "Female" )
			else
				CAKE.SetCharField( target, "gender", "Male" )
			end
		end
		CAKE.SetCharField( target, "model", args[2] )
		ply:Spawn()
	end
end
	
-- Let's make some ADMIN COMMANDS!
function PLUGIN.Init( )

	CAKE.ConVars[ "MaxBan" ] = 300 -- What is the maximum ban limit for regular admins?
	
	--Default admin ranks. You can type on console either the full name of the rank or it's shortened version
	CAKE.AddAdminRank( "Event Coordinator", 2, "ec")
	CAKE.AddAdminRank( "Moderator", 3, "m")
	CAKE.AddAdminRank( "Administrator", 4, "a")
	CAKE.AddAdminRank( "Super Administrator", 5, "sa")
	
	CAKE.AdminCommand( "help", Admin_Help, "List of all admin commands", true, true, 1 )
	CAKE.AdminCommand( "listitems", Admin_ListItems, "List of all items", true, true, 1 )
	CAKE.AdminCommand( "oocdelay", Admin_SetOOCDelay, "Sets the OOC delay", true, true, 1 )
	CAKE.AdminCommand( "observe", Admin_Observe, "Enter admin only observe mode", true, true, 1 )
	CAKE.AdminCommand( "noclip", Admin_Noclip, "Enter admin only noclip mode", true, true, 1 )
	CAKE.AdminCommand( "kick", Admin_Kick, "Kick someone on the server", true, true, 2 )
	CAKE.AdminCommand( "setmodel", Admin_SetModel, "Set someone's model to something", true, true, 2 )
	CAKE.AdminCommand( "setpermamodel", Admin_SetPermaModel, "Set someone's model permanently to something", true, true, 2 )
	CAKE.AdminCommand( "ban", Admin_Ban, "Ban someone on the server", true, true, 3 )
	CAKE.AdminCommand( "superban", Admin_SuperBan, "Ban someone on the server ( Permanent allowed )", true, true, 4 )
	CAKE.AdminCommand( "setconvar", Admin_SetConVar, "Set a Convar", true, true, 4 )
	CAKE.AdminCommand( "listvars", Admin_ListVars, "List convars", true, true, 4 )
	CAKE.AdminCommand( "createitem", Admin_CreateItem, "Creates an item", true, true, 4 )
	CAKE.AdminCommand( "setmoney", Admin_SetMoney, "Set the money of another player", true, true, 4 )
	CAKE.AdminCommand( "bring", Admin_Bring, "Brings a player to you", true, true, 3)
	CAKE.AdminCommand( "goto", Admin_GoTo, "Takes you to a player", true, true, 3 )
	CAKE.AdminCommand( "slay", Admin_Slay, "Kills a player", true, true, 3 )
	CAKE.AdminCommand( "setrank", Admin_SetRank, "Set the rank of another player", true, true, 4 )
	CAKE.AdminCommand( "createpropitem", Admin_CreatePropItem, "Create an item from a prop.", true, true, 1 )
	CAKE.AdminCommand( "createclothing", Admin_CreateClothing, "Create a new set of clothing.", true, true, 1 )
	CAKE.AdminCommand( "converttoitem", Admin_TurnIntoItem, "Turns a prop into an item (Right click on prop)", true, true, 1 )
	CAKE.AdminCommand( "duplicateitem", Admin_DuplicateItem, "Duplicates an item", true, true, 3 )
	CAKE.AdminCommand( "converttoclothing", Admin_TurnIntoClothing, "Turns a ragdoll into clothing(Right click on prop)", true, true, 1 )
	
end

