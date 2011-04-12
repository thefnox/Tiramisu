--Override on GM:OnPlayerUse, in order to make it work wtih other kinds of doors
hook.Add( "KeyPress", "TiramisuHandleDoors", function( ply, key )
	if( key == IN_USE ) then
		local entity = ply:GetEyeTrace( ).Entity
		if(CAKE.IsDoor(entity)) then
			local doorgroup = CAKE.GetDoorGroup(entity) or 0
			local groupdoor = CAKE.GetGroupFlag( CAKE.GetCharField( ply, "group" ), "doorgroups" ) or 0
			if type( groupdoor ) == "table" then groupdoor = groupdoor[1] end
			if doorgroup == groupdoor then --lol
				entity:Fire( "open", "", 0 );
			end
		end
		if( entity:GetClass() == "item_prop" ) then
			ply:ConCommand( "rp_pickup " .. tostring( entity:EntIndex() ) )
		end
	end
end)

--rp_admin adddoor doorgroup [title] [number of building it belongs to] [purchaseable 1/0]. All arguments in brackets are optional.
--Setting two doors to have the same building number means that BOTH doors will be purchased when either of them is owned.
function Admin_AddDoor(ply, cmd, args)
	
	local tr = ply:GetEyeTrace()
	local trent = tr.Entity;
	
	if(!CAKE.IsDoor(trent)) then ply:PrintMessage(3, "You must be looking at a door!"); return; end

	if(table.getn(args) < 1) then ply:PrintMessage(3, "Specify a doorgroup!"); return; end
	
	local pos = trent:GetPos()
	local Door = {}
	Door["pos"] = trent:GetPos()
	Door["class"] = trent:GetClass()
	Door["title"] = args[2] or ""
	Door["doorgroup"] = tonumber(args[1])
	Door["building"] = tonumber(args[3])
	Door["purchaseable"] = util.tobool( args[4] )

	
	table.insert(CAKE.Doors, Door);
	
	CAKE.SendChat(ply, "Door added");

	trent.doorgroup = Door["doorgroup"]
	trent.building = Door["building"]
	trent.purchaseable = Door["purchaseable"]
	trent.title = Door["title"]
	CAKE.SetDoorTitle( trent, Door["title"] )
	
	local keys = glon.encode(CAKE.Doors);
	file.Write(CAKE.Name .. "/DoorData/" .. game.GetMap() .. ".txt", keys);
	
end

function PLUGIN.Init()

	CAKE.AdminCommand( "adddoor", Admin_AddDoor, "Add group permissions to a door", true, true, 4 );
	
end