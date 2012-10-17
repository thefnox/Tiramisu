hook.Add( "InitPostEntity", "TiramisuLoadDoors", function()
	TIRA.LoadDoors()
end)

TIRA.Doors = {}

--Loads all door information
function TIRA.LoadDoors()

	if(file.Exists(TIRA.Name .. "/DoorData/" .. game.GetMap() .. ".txt")) then

		local rawdata = file.Read( TIRA.Name .. "/DoorData/" .. game.GetMap() .. ".txt")
		local tabledata = TIRA.Deserialize( rawdata )
		
		TIRA.Doors = tabledata
		local entities

		for _, door in pairs( TIRA.Doors ) do
			entities = ents.FindByClass( door["class"] )
			for _, entity in pairs( entities ) do
				if ValidEntity( entity ) and entity:GetPos() == door["pos"] then
					entity.doorgroup = door["doorgroup"]
					entity.title = door["title"]
					entity.building = door["building"]
					entity.purchaseable = door["purchaseable"]
					TIRA.SetDoorTitle( entity, entity.title )
				end
			end
		end
		
	end 

end

function TIRA.SaveDoors()

	local keys = TIRA.Serialize(TIRA.Doors)
	file.Write(TIRA.Name .. "/DoorData/" .. game.GetMap() .. ".txt", keys)

end

--Fetches a door's group affinity.
function TIRA.GetDoorGroup( entity )

	if ValidEntity( entity ) then
		if entity.doorgroup then
			return entity.doorgroup
		end
		for k, v in pairs(TIRA.Doors) do
			if(v["class"] == entity:GetClass() and v["pos"] == entity:GetPos() and v["doorgroup"]) then
				return v["doorgroup"]
			end
		end
	end

	return 0

end

--Fetches on what group of doors does this entity belong to.
function TIRA.GetDoorBuilding(entity)

	if entity.building then
		return entity.building
	end

	for k, v in pairs(TIRA.Doors) do
		if v["class"] == entity:GetClass() and v["pos"] == entity:GetPos() then
			return v["building"]
		end
	end

	return 0

end

--Sets a door's title.
function TIRA.SetDoorTitle( door, title )
	door:SetNWString( "doortitle", string.sub( title, 1, 33) )
end

function ccLockDoor( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) )
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) )
	local doorgroup = TIRA.GetDoorGroup(entity) or 0
	local group = TIRA.GetGroup( TIRA.GetCharField( ply, "activegroup" ))
	local groupdoor = 0
	if group then
		groupdoor = group:GetField("doorgroup")
	end
	if( TIRA.IsDoor( door ) ) then
		if (door.owner and door.owner == ply) or ply:IsSuperAdmin() or ply:IsAdmin() or !TIRA.ConVars[ "DoorsPurchaseable" ] then
			door:Fire( "lock", "", 0 )
			TIRA.SendChat( ply, "Door locked!" )
		else
			if doorgroup == groupdoor then
				door:Fire( "lock", "", 0 )
				TIRA.SendChat( ply, "Door locked!" )
			else
				TIRA.SendChat( ply, "This is not your door!" )
			end
		end
	end

end
concommand.Add( "rp_lockdoor", ccLockDoor )

function ccUnLockDoor( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) )
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) )
	local doorgroup = TIRA.GetDoorGroup(entity) or 0
	local group = TIRA.GetGroup( TIRA.GetCharField( ply, "activegroup" ))
	local groupdoor = 0
	if group then
		groupdoor = group:GetField("doorgroup")
	end
	if( TIRA.IsDoor( door ) ) then
		if (door.owner and door.owner == ply) or ply:IsSuperAdmin() or ply:IsAdmin() or !TIRA.ConVars[ "DoorsPurchaseable" ] then
			door:Fire( "unlock", "", 0 )
			TIRA.SendChat( ply, "Door unlocked!" )
		else
			if doorgroup == groupdoor then
				door:Fire( "unlock", "", 0 )
				TIRA.SendChat( ply, "Door unlocked!" )
			else
				TIRA.SendChat( ply, "This is not your door!" )
			end
		end
	end


end
concommand.Add( "rp_unlockdoor", ccUnLockDoor )

function ccPurchaseDoor( ply, cmd, args )
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) )
	
	local pos = door:GetPos( )

	if !TIRA.ConVars[ "DoorsPurchaseable" ] then

		TIRA.SendChat( ply, "Purchasing doors is disabled." )
		return

	end
	
		
	if( TIRA.GetDoorGroup( door ) != 0 or !door.purchaseable ) then
		
		TIRA.SendChat( ply, "This is not a purchaseable door!" )
		return
			
	end

	
	if( TIRA.IsDoor( door ) ) then

		if( door.owner == nil ) then

			if TIRA.GetDoorBuilding(door) != 0 then
				local building = TIRA.GetDoorBuilding(door)
				local doors
				for _, targetdoor in pairs( TIRA.Doors ) do
					if targetdoor["building"] == building then
						doors = ents.FindByClass( targetdoor["class"] )
						for k, v in pairs( doors ) do
							if v:GetPos() == targetdoor["pos"] then
								TIRA.ChangeMoney( ply, -50 )
								v.owner = ply
							end
						end
					end
				end
				TIRA.SendChat( ply, "Building Owned" )
			else
				if( tonumber( TIRA.GetCharField( ply, "money" ) ) >= 50 ) then
					-- Enough money to start off, let's start the rental.
					TIRA.ChangeMoney( ply, -50 )
					door.owner = ply
					TIRA.SendChat( ply, "Door Owned" )
				end
			end
			
		elseif( door.owner == ply ) then
		
			door.owner = nil
			TIRA.ChangeMoney( ply, 50 )
			TIRA.SetDoorTitle( door, "" )
			for _, Door in pairs( TIRA.Doors ) do
				if Door[ "pos" ] == door:GetPos() then
					TIRA.SetDoorTitle( door, Door["title"] )
					break
				end
			end

			TIRA.SendChat( ply, "Door Unowned" )
			
		else
		
			TIRA.SendChat( ply, "This door is already rented by someone else!" )
			
		end
	
	end
	
end
concommand.Add( "rp_purchasedoor", ccPurchaseDoor )

local function ccDoorTitle( ply, cmd, args )

	local door = ply:GetEyeTrace( ).Entity

	if door.owner and door.owner != ply then
		TIRA.SendChat( ply, "You don't own this door!" )
		return
	end

	if (ValidEntity( door ) and TIRA.IsDoor( door ) and (door.owner and door.owner == ply)) or !TIRA.ConVars[ "DoorsPurchaseable" ] then
		local title = table.concat( args, " " )
		TIRA.SetDoorTitle( door, title )
	end

end
concommand.Add( "rp_doortitle", ccDoorTitle )