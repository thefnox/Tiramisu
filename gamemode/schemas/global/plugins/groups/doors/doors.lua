hook.Add( "InitPostEntity", "TiramisuLoadDoors", function()
	CAKE.LoadDoors()
end)

CAKE.Doors = {}

--Loads all door information
function CAKE.LoadDoors()

	if(file.Exists(CAKE.Name .. "/DoorData/" .. game.GetMap() .. ".txt")) then

		local rawdata = file.Read( CAKE.Name .. "/DoorData/" .. game.GetMap() .. ".txt")
		local tabledata = von.deserialize( rawdata )
		
		CAKE.Doors = tabledata
		local entities

		for _, door in pairs( CAKE.Doors ) do
			entities = ents.FindByClass( door["class"] )
			for _, entity in pairs( entities ) do
				if ValidEntity( entity ) and entity:GetPos() == door["pos"] then
					entity.doorgroup = door["doorgroup"]
					entity.title = door["title"]
					entity.building = door["building"]
					entity.purchaseable = door["purchaseable"]
					CAKE.SetDoorTitle( entity, entity.title )
				end
			end
		end
		
	end 

end

function CAKE.SaveDoors()

	local keys = von.serialize(CAKE.Doors)
	file.Write(CAKE.Name .. "/DoorData/" .. game.GetMap() .. ".txt", keys)

end

--Fetches a door's group affinity.
function CAKE.GetDoorGroup( entity )

	if ValidEntity( entity ) then
		if entity.doorgroup then
			return entity.doorgroup
		end
		for k, v in pairs(CAKE.Doors) do
			if(v["class"] == entity:GetClass() and v["pos"] == entity:GetPos() and v["doorgroup"]) then
				return v["doorgroup"]
			end
		end
	end

	return 0

end

--Fetches on what group of doors does this entity belong to.
function CAKE.GetDoorBuilding(entity)

	if entity.building then
		return entity.building
	end

	for k, v in pairs(CAKE.Doors) do
		if v["class"] == entity:GetClass() and v["pos"] == entity:GetPos() then
			return v["building"]
		end
	end

	return 0

end

--Sets a door's title.
function CAKE.SetDoorTitle( door, title )
	door:SetNWString( "doortitle", string.sub( title, 1, 33) )
end

function ccLockDoor( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) )
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) )
	local doorgroup = CAKE.GetDoorGroup(entity) or 0
	local group = CAKE.GetGroup( CAKE.GetCharField( ply, "activegroup" ))
	local groupdoor = 0
	if group then
		groupdoor = group:GetField("doorgroup")
	end
	if( CAKE.IsDoor( door ) ) then
		if (door.owner and door.owner == ply) or ply:IsSuperAdmin() or ply:IsAdmin() or !CAKE.ConVars[ "DoorsPurchaseable" ] then
			door:Fire( "lock", "", 0 )
			CAKE.SendChat( ply, "Door locked!" )
		else
			if doorgroup == groupdoor then
				door:Fire( "lock", "", 0 )
				CAKE.SendChat( ply, "Door locked!" )
			else
				CAKE.SendChat( ply, "This is not your door!" )
			end
		end
	end

end
concommand.Add( "rp_lockdoor", ccLockDoor )

function ccUnLockDoor( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) )
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) )
	local doorgroup = CAKE.GetDoorGroup(entity) or 0
	local group = CAKE.GetGroup( CAKE.GetCharField( ply, "activegroup" ))
	local groupdoor = 0
	if group then
		groupdoor = group:GetField("doorgroup")
	end
	if( CAKE.IsDoor( door ) ) then
		if (door.owner and door.owner == ply) or ply:IsSuperAdmin() or ply:IsAdmin() or !CAKE.ConVars[ "DoorsPurchaseable" ] then
			door:Fire( "unlock", "", 0 )
			CAKE.SendChat( ply, "Door unlocked!" )
		else
			if doorgroup == groupdoor then
				door:Fire( "unlock", "", 0 )
				CAKE.SendChat( ply, "Door unlocked!" )
			else
				CAKE.SendChat( ply, "This is not your door!" )
			end
		end
	end


end
concommand.Add( "rp_unlockdoor", ccUnLockDoor )

function ccPurchaseDoor( ply, cmd, args )
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) )
	
	local pos = door:GetPos( )

	if !CAKE.ConVars[ "DoorsPurchaseable" ] then

		CAKE.SendChat( ply, "Purchasing doors is disabled." )
		return

	end
	
		
	if( CAKE.GetDoorGroup( door ) != 0 or !door.purchaseable ) then
		
		CAKE.SendChat( ply, "This is not a purchaseable door!" )
		return
			
	end

	
	if( CAKE.IsDoor( door ) ) then

		if( door.owner == nil ) then

			if CAKE.GetDoorBuilding(door) != 0 then
				local building = CAKE.GetDoorBuilding(door)
				local doors
				for _, targetdoor in pairs( CAKE.Doors ) do
					if targetdoor["building"] == building then
						doors = ents.FindByClass( targetdoor["class"] )
						for k, v in pairs( doors ) do
							if v:GetPos() == targetdoor["pos"] then
								CAKE.ChangeMoney( ply, -50 )
								v.owner = ply
							end
						end
					end
				end
				CAKE.SendChat( ply, "Building Owned" )
			else
				if( tonumber( CAKE.GetCharField( ply, "money" ) ) >= 50 ) then
					-- Enough money to start off, let's start the rental.
					CAKE.ChangeMoney( ply, -50 )
					door.owner = ply
					CAKE.SendChat( ply, "Door Owned" )
				end
			end
			
		elseif( door.owner == ply ) then
		
			door.owner = nil
			CAKE.ChangeMoney( ply, 50 )
			CAKE.SetDoorTitle( door, "" )
			for _, Door in pairs( CAKE.Doors ) do
				if Door[ "pos" ] == door:GetPos() then
					CAKE.SetDoorTitle( door, Door["title"] )
					break
				end
			end

			CAKE.SendChat( ply, "Door Unowned" )
			
		else
		
			CAKE.SendChat( ply, "This door is already rented by someone else!" )
			
		end
	
	end
	
end
concommand.Add( "rp_purchasedoor", ccPurchaseDoor )

local function ccDoorTitle( ply, cmd, args )

	local door = ply:GetEyeTrace( ).Entity

	if door.owner and door.owner != ply then
		CAKE.SendChat( ply, "You don't own this door!" )
		return
	end

	if (ValidEntity( door ) and CAKE.IsDoor( door ) and (door.owner and door.owner == ply)) or !CAKE.ConVars[ "DoorsPurchaseable" ] then
		local title = table.concat( args, " " )
		CAKE.SetDoorTitle( door, title )
	end

end
concommand.Add( "rp_doortitle", ccDoorTitle )