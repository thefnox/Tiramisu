PLUGIN.Name = "Containers"; -- What is the plugin name
PLUGIN.Author = "Ryaga/BadassMC"; -- Author of the plugin
PLUGIN.Description = "Containers,"; -- The description or purpose of the plugin

CAKE.Containers = {}

function CAKE.AddContainer( ent )

	ent.Size = CAKE.GetContainerSize( ent:GetModel() )
	ent.IsContainer = true
	ent:SetNWInt("iscont", 1)
	ent.Inv = {}

end

function CAKE.AddCType( model, size )

	if model and size then
	
		CAKE.Containers[model] = size
		
	end

end

function CAKE.GetContainerSize( model )

	return CAKE.Containers[model] or 8

end

function CAKE.AddContItem( ent, class )

	count = 0
	
	for k,v in pairs(ent.Inv) do
	
		print("+1")
		count = count + 1
		
	end
	
	if count != ent.Size then

		table.insert(ent.Inv, class)
		print("Adding " ..class.. " to " ..ent:EntIndex())
		
	end
		
end 

function CAKE.TakeContItem( ent, class )

	for k,v in pairs(ent.Inv) do
	
		if v == class then
		
			table.remove(ent.Inv, k)
			break
			
		end
	
	end

end

function CAKE.InitContainers(ply, model, ent)

	if CAKE.Containers[model] then
	
		CAKE.AddContainer(ent)
		
	end
	
end
hook.Add("PlayerSpawnedProp", "containerSpawn", CAKE.InitContainers)

function CAKE.PlayerGiveCont( ply, ent, item )

	ply:TakeItem(item)
	CAKE.AddContItem(ent, item)

end 

function CAKE.ContGivePlayer( ply, ent, item )

	ply:GiveItem(item)
	CAKE.TakeContItem(ent, item)

end 

function CAKE.InteractCont( ply, cmd, args )

	if args[1] == "give" then
		
		print("give" ..args[2])
	
		CAKE.PlayerGiveCont( ply, Entity( args[2] ), args[3])
		
	elseif args[1] == "take" then
	
		CAKE.ContGivePlayer( ply, Entity( args[2] ), args[3])
		
	end
	
end
concommand.Add( "rp_intcont", CAKE.InteractCont );	

function CAKE.GetContents( ply, cmd, args )

	print("Recieved")
	
	args[1] = Entity( args[1] )
	inv = args[1].Inv
	
	umsg.Start( "PopulateCont", ply)
	umsg.End()
	print("Popstart")
	
	for k,v in pairs(inv) do
	
		print("AddItem" ..v)
		umsg.Start( "AddItemCont", ply )
			umsg.String( v )
			umsg.String( CAKE.ItemData[v].Model )
			umsg.String( CAKE.ItemData[v].Description )
			umsg.String( CAKE.ItemData[v].Name )
		umsg.End()
	
	end

	umsg.Start( "EndPopulate", ply)
		umsg.Entity(args[1])
		umsg.Short(CAKE.GetContainerSize(args[1]))
	umsg.End()
	print("End pop")
	
end
concommand.Add( "rp_opencont", CAKE.GetContents );	

CAKE.AddCType("models/props_c17/FurnitureDrawer001a.mdl", 10)