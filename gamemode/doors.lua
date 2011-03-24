----------------------------
-- CakeScript (March 29, 2008)
-- by LuaBanana
--
-- Alpha Version
-- doors.lua
----------------------------

hook.Add( "InitPostEntity", "TiramisuLoadDoors", function()
	CAKE.LoadDoors()
end)

CAKE.Doors = {}

function CAKE.LoadDoors()

	if(file.Exists(CAKE.Name .. "/DoorData/" .. game.GetMap() .. ".txt")) then

		local rawdata = file.Read( CAKE.Name .. "/DoorData/" .. game.GetMap() .. ".txt");
		local tabledata = glon.decode( rawdata )
		
		CAKE.Doors = tabledata;
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

function CAKE.GetDoorGroup( entity )

	if ValidEntity( entity ) and entity.doorgroup then
		return entity.doorgroup
	end

	for k, v in pairs(CAKE.Doors) do
		
		if(v["class"] == entity:GetClass() and v["pos"] == entity:GetPos() and v["doorgroup"] != 0 ) then
			
			return v["doorgroup"]
				
		end
			
	end

	return false

end

function CAKE.GetDoorBuilding(entity)

	if entity.building then
		return entity.building
	end

	for k, v in pairs(CAKE.Doors) do
		
		if(v["class"] == entity:GetClass() and v["pos"] == entity:GetPos() and v["building"] != 0 ) then
			
			return v["building"]
				
		end
			
	end

	return false

end

function CAKE.SetDoorTitle( door, title )
	door:SetNWString( "doortitle", string.sub( title, 1, 33) )
end

function ccLockDoor( ply, cmd, args )
	
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( CAKE.IsDoor( door ) ) then
		if( door.owner != nil ) and door.owner == ply then
			door:Fire( "lock", "", 0 );
		else
			CAKE.SendChat( ply, "This is not your door!" );
		end
	end

end
concommand.Add( "rp_lockdoor", ccLockDoor );

function ccUnLockDoor( ply, cmd, args )
	
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( CAKE.IsDoor( door ) ) then
		if( door.owner != nil ) and door.owner == ply then
			door:Fire( "unlock", "", 0 );
		else
			CAKE.SendChat( ply, "This is not your door!" );
		end
	end

end
concommand.Add( "rp_unlockdoor", ccUnLockDoor );

function ccPurchaseDoor( ply, cmd, args )
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	local pos = door:GetPos( );
	
		
	if( CAKE.GetDoorGroup( entity ) and !door.purchaseable ) then
		
		CAKE.SendChat( ply, "This is not a purchaseable door!" );
		return;
			
	end

	
	if( CAKE.IsDoor( door ) ) then

		if( door.owner == nil ) then

			if CAKE.GetDoorBuilding(door) then
				local building = CAKE.GetDoorBuilding(door)
				for k, v in pairs( CAKE.Doors ) do
					if CAKE.GetDoorBuilding(v["entity"]) == building then
						CAKE.ChangeMoney( ply, -50 );
						v["entity"].owner = ply;
					end
				end
				CAKE.SendChat( ply, "Door Owned" );
			else
				if( tonumber( CAKE.GetCharField( ply, "money" ) ) >= 50 ) then
					
					-- Enough money to start off, let's start the rental.
					CAKE.ChangeMoney( ply, -50 );
					door.owner = ply;
					CAKE.SendChat( ply, "Door Owned" );

				end
			end
			
		elseif( door.owner == ply ) then
		
			door.owner = nil;
			CAKE.ChangeMoney( ply, 50 );
			CAKE.SetDoorTitle( door, "" )
			CAKE.SendChat( ply, "Door Unowned" );
			
		else
		
			CAKE.SendChat( ply, "This door is already rented by someone else!" );
			
		end
	
	end
	
end
concommand.Add( "rp_purchasedoor", ccPurchaseDoor );

local function ccDoorTitle( ply, cmd, args )

	local door = ply:GetEyeTrace( ).Entity
	if ValidEntity( door ) and CAKE.IsDoor( door ) and door.owner == ply then
		local title = table.concat( args, " " )
		CAKE.SetDoorTitle( door, title )
	end

end
concommand.Add( "rp_doortitle", ccDoorTitle )