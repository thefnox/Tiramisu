CAKE.ItemData = {  }
CAKE.UData = {  }

function CAKE.LoadItem( schema, filename )

	local path = "schemas/" .. schema .. "/items/" .. filename
	AddResource("lua", path)
	
	ITEM = {  }
	
	include( path )
	
	CAKE.ItemData[ ITEM.Class ] = ITEM
	
end

function CAKE.SaveUData( id )
	if !id then return end
	local savetable = glon.encode(CAKE.UData[id])
	file.Write( CAKE.Name .. "/udata/" .. CAKE.ConVars[ "Schema" ] .. "/" .. id .. ".txt" , savetable)
	CAKE.SendUData( ply, id )
end

function CAKE.LoadUData( id )
	if !id then return end
	CAKE.UData[id] = glon.decode(file.Read( CAKE.Name .. "/udata/" .. CAKE.ConVars[ "Schema" ] .. "/" .. id .. ".txt"))
end

function CAKE.SetUData( id, key, value )
	if !id then return nil end

	if !CAKE.UData[id] then
		CAKE.UData[id] = {}
	end
	CAKE.UData[id][key] = value
	CAKE.SaveUData(id)
end

function CAKE.GetUData(id, key)
	if !id or id == "none" then return nil end

	if !CAKE.UData[id] then
		CAKE.LoadUData( id )
	end
	
	if !CAKE.UData[id] or !CAKE.UData[id][key] then return nil end
	return CAKE.UData[id][key]
end

local lastostime = 0
local genned = {}
function CAKE.CreateItemID()
	if lastostime != os.time() then
		genned = {} 
		lastostime = os.time()
	end
	local repnum = 0
	local f = os.time() .. repnum
	while genned[f] do
		repnum = repnum + 1
		f = os.time() .. repnum
	end
	genned[f] = true
	return f
end

function CAKE.SendUData( ply, uid )
	if !CAKE.UData[uid] then
		CAKE.LoadUData( uid )
	end
	if CAKE.UData[uid] then
		net.Start( "Tiramisu.ReceiveUData" )
			net.WriteString( uid )
			net.WriteTable(CAKE.UData[uid])
		net.Send( ply )
	end
end

function CAKE.SendItemData( ply )
end

function CAKE.CreateItem( class, pos, ang, id )

	if !id then id = CAKE.CreateItemID() end
	
	if( CAKE.ItemData[ class ] == nil ) then return end
	
	local itemtable = CAKE.ItemData[ class ]
	
	local item = ents.Create( "item_prop" )
	item.uiid = id
	
	if string.match( class, "clothing" ) or string.match( class, "helmet" ) then
		item:SetModel( "models/props_c17/suitcase_passenger_physics.mdl" )
	else
		item:SetModel( CAKE.GetUData(id, "model") or itemtable.Model )
	end

	for k, v in pairs( itemtable ) do
		item[ k ] = v
	end

	item:SetAngles( ang )
	item:SetPos( pos )
	
	item:SetNWString("Name", CAKE.GetUData(id, "name") or itemtable.Name)
	item:SetNWString("Description", CAKE.GetUData(id, "description") or itemtable.Description)
	item:SetNWString("Class", itemtable.Class)
	item:SetNWString("id", id)
	
	item:Spawn( )
	item:Activate( )
	return item
	
end

function ccDropItem( ply, cmd, args )
	
	if !args[ 1 ] then return end

	if ply:HasItemID( args[ 1 ] ) then
		local class = ply:TakeItemID( args[ 1 ] )
		CAKE.CreateItem( class, ply:CalcDrop( ), Angle( 0,0,0 ), args[ 1 ] )
	end

end
concommand.Add( "rp_dropitem", ccDropItem )

function ccDropItemUnspecific( ply, cmd, args )

	if !args[ 1 ] then return end
	
	local inv =	ply:GetInventory()

	if inv:HasItem( args[ 1 ] ) then
		for _, tbl in pairs( inv.Items ) do
			for k, v in pairs(tbl) do
				CAKE.CreateItem( args[ 1 ], ply:CalcDrop( ), Angle( 0,0,0 ), v.itemid )
				ply:TakeItem( args[ 1 ] )
				return
			end
		end
	end

end
concommand.Add( "rp_dropitemunspecific", ccDropItemUnspecific )

function ccDropAllItem( ply, cmd, args )
	
	local inv =	ply:GetInventory()

	for _, tbl in pairs( inv.Items ) do
		for k, v in pairs(tbl) do
			if v.class == args[1]then
				CAKE.CreateItem( args[ 1 ], ply:CalcDrop( ), Angle( 0,0,0 ), v.itemid )
				ply:TakeItem( args[ 1 ] )
			end
		end
	end

end
concommand.Add( "rp_dropallitem", ccDropAllItem )

function ccPickupItem( ply, cmd, args )

	local item = ents.GetByIndex( tonumber( args[ 1 ] ) )
	local inv = ply:GetInventory()
	
	if inv:IsFull() then
		CAKE.SendError( ply, "Your inventory is full!" )
		return
	end

	if( item != nil and item:IsValid( ) and item:GetClass( ) == "item_prop" and item:GetPos( ):Distance( ply:GetShootPos( ) ) <= 200 ) then
		item:Pickup( ply )
		ply:GiveItem( item.Class, item:GetNWString("id") )
	end

end
concommand.Add( "rp_pickup", ccPickupItem )

function ccUseItem( ply, cmd, args )
	
	local item = ents.GetByIndex(tonumber( args[ 1 ] ))
	local funcrun = args [ 2 ]
	
	if item and IsValid(item) and item:GetClass( ) == "item_prop" and item:GetPos():Distance(ply:GetShootPos()) <= 200 then
		local class = item:GetNWString("Class", "")
		if class != "" then
			if funcrun and CAKE.ItemData[ class ][funcrun] then
				funcrun = CAKE.ItemData[ class ][funcrun]
				funcrun(item, ply )
			else
				item:UseItem( ply )
			end
		end
	end

end
concommand.Add( "rp_useitem", ccUseItem )

function ccUseOnInventoryID( ply, cmd, args )
	local id = args [ 1 ]
	local class = ply:HasItemID(id) 
	local funcrun = args [ 2 ]
	
	if class then
		local item = CAKE.CreateItem( class, ply:CalcDrop( ), Angle( 0,0,0 ), id )
		if IsValid(item) and item:GetClass( ) == "item_prop" then
			if funcrun and CAKE.ItemData[ class ][funcrun] then
				funcrun = CAKE.ItemData[ class ][funcrun]
				funcrun(item, ply )
			else
				item:UseItem( ply )
			end
			if item then
				item:Remove()
			end
			if !CAKE.ItemData[class].Unusable then
				ply:TakeItemID( id )
			end
		end
	end

end
concommand.Add( "rp_useinventoryid", ccUseOnInventoryID)

local meta = FindMetaTable( "Player" )

function meta:GiveItem( class, id )

	if !id then id = CAKE.CreateItemID() end
	CAKE.DayLog( "economy.txt", "Adding item '" .. class .. "' to " .. CAKE.FormatCharString( self ) .. " inventory" )
	local inv = self:GetInventory()

	if inv:IsFull() then
		return
	end

	inv:AddItem(class, id)
	
	if string.match( class, "weapon" ) then
		if !self:HasWeapon(CAKE.GetUData(id, "weaponclass") or class) then
			self:Give( CAKE.GetUData(id, "weaponclass") or class )
		end
	end
	CAKE.SendUData( self, id )

	inv:Save()

end

function meta:TakeItem( class )
	local inv = self:GetInventory()

	if string.match( class, "weapon" ) and class != "weapon_base" then
		self:StripWeapon( class )
	end

	for i=1, inv.Height do
		for j=1, inv.Width do
			if !inv:IsSlotEmpty(j,i) and inv.Items[i][j].class == class then 
				umsg.Start("c_Take", CAKE.GetPlyTrackingContainer( inv.UniqueID ))
					umsg.String(inv.UniqueID)
					umsg.String(inv.Items[i][j].itemid)
				umsg.End()
				inv:Save()
				inv:ClearSlot( j, i )
				if CAKE.GetUData( inv.Items[i][j].itemid, "weaponclass" ) then
					for _, tbl in pairs( inv.Items ) do
						for k, v in pairs(tbl) do
							if CAKE.GetUData( inv.Items[i][j].itemid, "weaponclass" ) == CAKE.GetUData(v.itemid, "weaponclass") then
								count = true
								break
							end
						end
						if count then
							break
						end
					end

					if !count then
						self:StripWeapon(CAKE.GetUData(id, "weaponclass") or "nothing")
					end
				elseif string.match(class, "weapon_") and class != "weapon_base" then
					for _, tbl in pairs( inv.Items ) do
						for k, v in pairs(tbl) do
							if v.class == class then
								count = true
								break
							end
						end
						if count then
							break
						end
					end

					if !count then
						self:StripWeapon(class)
					end
				end
				inv:Save()
				return
			end
		end
	end

end

function meta:TakeItemID( id )
	local inv = self:GetInventory()
	CAKE.RemoveClothingID( self, id )
	CAKE.RemoveGearItemID( self, id )

	local class = inv:TakeItemID( id )
	CAKE.DayLog( "economy.txt", "Removing item '" .. id .. "' from " .. CAKE.FormatCharString( self ) .. " inventory" )

	local count = false

	if CAKE.GetUData( id, "weaponclass" ) then
		for _, tbl in pairs( self:GetInventory().Items ) do
			for k, v in pairs(tbl) do
				if CAKE.GetUData( v.itemid, "weaponclass" ) == CAKE.GetUData(id, "weaponclass") then
					count = true
					break
				end
			end
			if count then
				break
			end
		end

		if !count then
			self:StripWeapon(CAKE.GetUData(id, "weaponclass") or "nothing")
		end
	elseif string.match(class, "weapon_") and class != "weapon_base" then
		for _, tbl in pairs( self:GetInventory().Items ) do
			for k, v in pairs(tbl) do
				if v.class == class then
					count = true
					break
				end
			end
			if count then
				break
			end
		end

		if !count then
			self:StripWeapon(class)
		end
	end

	CAKE.SendClothingToClient( self )
	CAKE.SaveGear( self )
	CAKE.SendGearToClient( self )

	inv:Save()
	return class
	
end

function meta:ItemHasFlag( item, flag )
	
	if !CAKE.ItemData[ item ] then
		return false
	end

	if !CAKE.ItemData[ item ].Flags then
		CAKE.ItemData[ item ].Flags = {}
		return false
	end
	
	for k, v in pairs( CAKE.ItemData[ item ].Flags ) do
		if type( v ) == "table" then
			for k2, v2 in pairs( v ) do
				if string.match( v2, flag ) then
					return true
				end
			end
		end
		if string.match( v, flag ) then
			return true
		end
	end
	
	return false

end

function meta:GetFlagValue( item, flag )

	if !CAKE.ItemData[ item ].Flags then
		CAKE.ItemData[ item ].Flags = {}
		return false
	end
	
	for k, v in pairs( CAKE.ItemData[ item ].Flags ) do
		if type( v ) == "table" then
			for k2, v2 in pairs( v ) do
				if string.match( v2, flag ) then
					local exp = string.Explode( "", v2 )
					return exp[2] or true
				end
			end
		end
		if string.match( v, flag ) then
			local exp = string.Explode( "", v )
			return exp[2] or true
		end
	end
	
	return false

end

function meta:HasItem( class )
	local inv = self:GetInventory()
	return inv:HasItem( class )
end

function meta:HasItemID( ID )
	if !ID or ID == "none" then return false end
	local inv = self:GetInventory()
	return inv:HasItemID( ID )
end

function meta:SetUData( item, key, value )
	id = item:GetNWString("id")
	CAKE.SetUData( id, key, value )
end

function meta:GetUData( item, key )
	id = item:GetNWString("id")
	return CAKE.GetUData( id, key )
end